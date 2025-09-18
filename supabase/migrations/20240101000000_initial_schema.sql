-- Migration initiale pour l'application FoodSave
-- Création des tables principales et configuration de la sécurité

-- Extension pour la génération d'UUID
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- Extension pour les fonctions de géolocalisation (optionnel)
-- CREATE EXTENSION IF NOT EXISTS "postgis";

-- =============================================================================
-- TABLE DES MAGASINS
-- =============================================================================

CREATE TABLE IF NOT EXISTS public.shops (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    address TEXT NOT NULL,
    phone VARCHAR(20),
    email VARCHAR(255),
    rating DECIMAL(2,1) CHECK (rating >= 0 AND rating <= 5),
    total_reviews INTEGER DEFAULT 0 CHECK (total_reviews >= 0),
    opening_hours JSONB,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Index pour améliorer les performances de recherche
CREATE INDEX IF NOT EXISTS idx_shops_name ON public.shops USING gin(to_tsvector('french', name));
CREATE INDEX IF NOT EXISTS idx_shops_rating ON public.shops (rating DESC);
CREATE INDEX IF NOT EXISTS idx_shops_created_at ON public.shops (created_at DESC);

-- =============================================================================
-- TABLE DES PANIERS ANTI-GASPI
-- =============================================================================

CREATE TABLE IF NOT EXISTS public.baskets_map (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    shop_id UUID REFERENCES public.shops(id) ON DELETE CASCADE,
    title VARCHAR(255) NOT NULL,
    description TEXT,
    price DECIMAL(10,2) NOT NULL CHECK (price >= 0),
    original_price DECIMAL(10,2) CHECK (original_price IS NULL OR original_price >= price),
    latitude DECIMAL(10,8) NOT NULL CHECK (latitude >= -90 AND latitude <= 90),
    longitude DECIMAL(11,8) NOT NULL CHECK (longitude >= -180 AND longitude <= 180),
    type VARCHAR(50) NOT NULL,
    quantity INTEGER DEFAULT 1 CHECK (quantity >= 0),
    available_from TIMESTAMP WITH TIME ZONE,
    available_until TIMESTAMP WITH TIME ZONE NOT NULL,
    image_url TEXT,
    is_active BOOLEAN DEFAULT true,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    
    -- Contrainte pour s'assurer que available_until est après available_from
    CONSTRAINT check_availability_dates CHECK (
        available_from IS NULL OR available_until > available_from
    )
);

-- Index pour améliorer les performances de recherche géographique et temporelle
CREATE INDEX IF NOT EXISTS idx_baskets_map_location ON public.baskets_map (latitude, longitude);
CREATE INDEX IF NOT EXISTS idx_baskets_map_active ON public.baskets_map (is_active) WHERE is_active = true;
CREATE INDEX IF NOT EXISTS idx_baskets_map_availability ON public.baskets_map (available_until) WHERE is_active = true;
CREATE INDEX IF NOT EXISTS idx_baskets_map_type ON public.baskets_map (type);
CREATE INDEX IF NOT EXISTS idx_baskets_map_price ON public.baskets_map (price);
CREATE INDEX IF NOT EXISTS idx_baskets_map_shop_id ON public.baskets_map (shop_id);
CREATE INDEX IF NOT EXISTS idx_baskets_map_created_at ON public.baskets_map (created_at DESC);

-- Index composé pour les requêtes fréquentes
CREATE INDEX IF NOT EXISTS idx_baskets_map_active_available ON public.baskets_map (is_active, available_until) 
    WHERE is_active = true;

-- =============================================================================
-- TABLE DES FAVORIS UTILISATEUR
-- =============================================================================

CREATE TABLE IF NOT EXISTS public.user_favorites (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    user_id UUID NOT NULL,
    basket_id UUID REFERENCES public.baskets_map(id) ON DELETE CASCADE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    
    -- Contrainte d'unicité pour éviter les doublons
    UNIQUE(user_id, basket_id)
);

-- Index pour améliorer les performances
CREATE INDEX IF NOT EXISTS idx_user_favorites_user_id ON public.user_favorites (user_id);
CREATE INDEX IF NOT EXISTS idx_user_favorites_basket_id ON public.user_favorites (basket_id);
CREATE INDEX IF NOT EXISTS idx_user_favorites_created_at ON public.user_favorites (created_at DESC);

-- =============================================================================
-- TABLE DES NOTIFICATIONS DE PROXIMITÉ
-- =============================================================================

CREATE TABLE IF NOT EXISTS public.proximity_notifications (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    user_id UUID NOT NULL,
    basket_id UUID REFERENCES public.baskets_map(id) ON DELETE CASCADE,
    distance_km DECIMAL(5,2) CHECK (distance_km >= 0),
    notified_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    clicked BOOLEAN DEFAULT false,
    
    -- Contrainte d'unicité pour éviter les notifications en double
    CONSTRAINT unique_notification UNIQUE(user_id, basket_id)
);

-- Index pour améliorer les performances
CREATE INDEX IF NOT EXISTS idx_proximity_notifications_user_id ON public.proximity_notifications (user_id);
CREATE INDEX IF NOT EXISTS idx_proximity_notifications_notified_at ON public.proximity_notifications (notified_at DESC);
CREATE INDEX IF NOT EXISTS idx_proximity_notifications_clicked ON public.proximity_notifications (clicked);

-- =============================================================================
-- TABLE DE L'HISTORIQUE DE RECHERCHE
-- =============================================================================

CREATE TABLE IF NOT EXISTS public.search_history (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    user_id UUID NOT NULL,
    search_query VARCHAR(255) NOT NULL,
    results_count INTEGER CHECK (results_count >= 0),
    searched_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Index pour améliorer les performances
CREATE INDEX IF NOT EXISTS idx_search_history_user_id ON public.search_history (user_id);
CREATE INDEX IF NOT EXISTS idx_search_history_searched_at ON public.search_history (searched_at DESC);
CREATE INDEX IF NOT EXISTS idx_search_history_query ON public.search_history USING gin(to_tsvector('french', search_query));

-- =============================================================================
-- FONCTIONS ET TRIGGERS
-- =============================================================================

-- Fonction pour mettre à jour automatiquement updated_at
CREATE OR REPLACE FUNCTION public.update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ language 'plpgsql';

-- Triggers pour mettre à jour updated_at automatiquement
CREATE TRIGGER update_shops_updated_at 
    BEFORE UPDATE ON public.shops 
    FOR EACH ROW 
    EXECUTE FUNCTION public.update_updated_at_column();

CREATE TRIGGER update_baskets_map_updated_at 
    BEFORE UPDATE ON public.baskets_map 
    FOR EACH ROW 
    EXECUTE FUNCTION public.update_updated_at_column();

-- Fonction pour nettoyer les paniers expirés
CREATE OR REPLACE FUNCTION public.cleanup_expired_baskets()
RETURNS INTEGER
LANGUAGE plpgsql
SET search_path = public
AS $$
DECLARE
    deleted_count INTEGER;
BEGIN
    UPDATE public.baskets_map 
    SET is_active = false 
    WHERE is_active = true 
    AND available_until < NOW();
    
    GET DIAGNOSTICS deleted_count = ROW_COUNT;
    RETURN deleted_count;
END;
$$;

-- Fonction pour calculer la distance entre deux points (Haversine)
CREATE OR REPLACE FUNCTION public.calculate_distance(
    lat1 DECIMAL, lon1 DECIMAL, lat2 DECIMAL, lon2 DECIMAL
)
RETURNS DECIMAL AS $$
DECLARE
    earth_radius DECIMAL := 6371; -- Rayon de la Terre en kilomètres
    lat_diff DECIMAL;
    lon_diff DECIMAL;
    a DECIMAL;
    c DECIMAL;
BEGIN
    lat_diff := radians(lat2 - lat1);
    lon_diff := radians(lon2 - lon1);
    
    a := sin(lat_diff/2)^2 + cos(radians(lat1)) * cos(radians(lat2)) * sin(lon_diff/2)^2;
    c := 2 * atan2(sqrt(a), sqrt(1-a));
    
    RETURN earth_radius * c;
END;
$$ language 'plpgsql';

-- =============================================================================
-- POLITIQUES DE SÉCURITÉ (RLS)
-- =============================================================================

-- Activer RLS sur toutes les tables
ALTER TABLE public.shops ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.baskets_map ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.user_favorites ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.proximity_notifications ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.search_history ENABLE ROW LEVEL SECURITY;

-- Politiques pour la table shops
CREATE POLICY "Shops are viewable by everyone" 
    ON public.shops FOR SELECT 
    USING (true);

CREATE POLICY "Authenticated users can insert shops" 
    ON public.shops FOR INSERT 
    TO authenticated 
    WITH CHECK (true);

CREATE POLICY "Users can update their own shops" 
    ON public.shops FOR UPDATE 
    TO authenticated 
    USING (true); -- À adapter selon votre logique métier

-- Politiques pour la table baskets_map
CREATE POLICY "Active baskets are viewable by everyone" 
    ON public.baskets_map FOR SELECT 
    USING (is_active = true);

CREATE POLICY "Authenticated users can insert baskets" 
    ON public.baskets_map FOR INSERT 
    TO authenticated 
    WITH CHECK (true);

CREATE POLICY "Users can update their own baskets" 
    ON public.baskets_map FOR UPDATE 
    TO authenticated 
    USING (true); -- À adapter selon votre logique métier

-- Politiques pour la table user_favorites
CREATE POLICY "Users can view their own favorites" 
    ON public.user_favorites FOR SELECT 
    TO authenticated 
    USING (auth.uid() = user_id);

CREATE POLICY "Users can insert their own favorites" 
    ON public.user_favorites FOR INSERT 
    TO authenticated 
    WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can delete their own favorites" 
    ON public.user_favorites FOR DELETE 
    TO authenticated 
    USING (auth.uid() = user_id);

-- Politiques pour la table proximity_notifications
CREATE POLICY "Users can view their own notifications" 
    ON public.proximity_notifications FOR SELECT 
    TO authenticated 
    USING (auth.uid() = user_id);

CREATE POLICY "System can insert notifications" 
    ON public.proximity_notifications FOR INSERT 
    TO service_role 
    WITH CHECK (true);

CREATE POLICY "Users can update their own notifications" 
    ON public.proximity_notifications FOR UPDATE 
    TO authenticated 
    USING (auth.uid() = user_id);

-- Politiques pour la table search_history
CREATE POLICY "Users can view their own search history" 
    ON public.search_history FOR SELECT 
    TO authenticated 
    USING (auth.uid() = user_id);

CREATE POLICY "Users can insert their own search history" 
    ON public.search_history FOR INSERT 
    TO authenticated 
    WITH CHECK (auth.uid() = user_id);

-- =============================================================================
-- DONNÉES DE TEST (OPTIONNEL)
-- =============================================================================

-- Insertion de quelques magasins de test
INSERT INTO public.shops (name, address, phone, email, rating, total_reviews, opening_hours) VALUES
('Boulangerie du Coin', '123 Rue de la Paix, 75001 Paris', '01.23.45.67.89', 'contact@boulangerie-coin.fr', 4.5, 150, 
 '{"lundi": {"open": "07:00", "close": "19:30"}, "mardi": {"open": "07:00", "close": "19:30"}, "mercredi": {"open": "07:00", "close": "19:30"}, "jeudi": {"open": "07:00", "close": "19:30"}, "vendredi": {"open": "07:00", "close": "19:30"}, "samedi": {"open": "07:30", "close": "18:00"}, "dimanche": null}'::jsonb),
 
('Restaurant Bio & Local', '456 Avenue Verte, 75002 Paris', '01.34.56.78.90', 'hello@bio-local.fr', 4.2, 89, 
 '{"lundi": {"open": "12:00", "close": "14:30"}, "mardi": {"open": "12:00", "close": "14:30"}, "mercredi": {"open": "12:00", "close": "14:30"}, "jeudi": {"open": "12:00", "close": "14:30"}, "vendredi": {"open": "12:00", "close": "14:30"}, "samedi": {"open": "12:00", "close": "15:00"}, "dimanche": {"open": "12:00", "close": "15:00"}}'::jsonb),

('Épicerie Fine Moderne', '789 Boulevard Central, 75003 Paris', '01.45.67.89.01', 'info@epicerie-moderne.fr', 4.7, 203, 
 '{"lundi": {"open": "09:00", "close": "20:00"}, "mardi": {"open": "09:00", "close": "20:00"}, "mercredi": {"open": "09:00", "close": "20:00"}, "jeudi": {"open": "09:00", "close": "20:00"}, "vendredi": {"open": "09:00", "close": "21:00"}, "samedi": {"open": "09:00", "close": "21:00"}, "dimanche": {"open": "10:00", "close": "19:00"}}'::jsonb);

-- Insertion de quelques paniers de test
INSERT INTO public.baskets_map (shop_id, title, description, price, original_price, latitude, longitude, type, quantity, available_from, available_until, image_url) 
SELECT 
    s.id,
    'Panier Pain & Viennoiseries',
    'Assortiment de pains et viennoiseries de la journée : croissants, pains au chocolat, baguettes tradition.',
    8.50,
    15.00,
    48.8566 + (random() - 0.5) * 0.01, -- Coordonnées autour de Paris
    2.3522 + (random() - 0.5) * 0.01,
    'boulangerie',
    FLOOR(random() * 5 + 1)::INTEGER,
    NOW(),
    NOW() + INTERVAL '2 hours',
    'https://images.unsplash.com/photo-1509440159596-0249088772ff?w=400'
FROM public.shops s 
WHERE s.name = 'Boulangerie du Coin';

INSERT INTO public.baskets_map (shop_id, title, description, price, original_price, latitude, longitude, type, quantity, available_from, available_until, image_url) 
SELECT 
    s.id,
    'Menu Complet Bio',
    'Menu complet avec entrée, plat et dessert préparés avec des ingrédients biologiques et locaux.',
    12.90,
    24.50,
    48.8566 + (random() - 0.5) * 0.01,
    2.3522 + (random() - 0.5) * 0.01,
    'restaurant',
    FLOOR(random() * 3 + 1)::INTEGER,
    NOW(),
    NOW() + INTERVAL '4 hours',
    'https://images.unsplash.com/photo-1546069901-ba9599a7e63c?w=400'
FROM public.shops s 
WHERE s.name = 'Restaurant Bio & Local';

INSERT INTO public.baskets_map (shop_id, title, description, price, original_price, latitude, longitude, type, quantity, available_from, available_until, image_url) 
SELECT 
    s.id,
    'Panier Fruits & Légumes',
    'Sélection de fruits et légumes frais de saison, légèrement abîmés mais parfaitement consommables.',
    6.80,
    12.30,
    48.8566 + (random() - 0.5) * 0.01,
    2.3522 + (random() - 0.5) * 0.01,
    'épicerie',
    FLOOR(random() * 4 + 1)::INTEGER,
    NOW(),
    NOW() + INTERVAL '6 hours',
    'https://images.unsplash.com/photo-1542838132-92c53300491e?w=400'
FROM public.shops s 
WHERE s.name = 'Épicerie Fine Moderne';

-- =============================================================================
-- COMMENTAIRES FINAUX
-- =============================================================================

-- Cette migration crée toute la structure nécessaire pour l'application FoodSave :
-- 1. Tables principales avec contraintes et validation
-- 2. Index optimisés pour les performances
-- 3. Fonctions utilitaires (distance, nettoyage)
-- 4. Triggers pour la maintenance automatique
-- 5. Politiques de sécurité RLS
-- 6. Données de test pour le développement

-- Pour déployer cette migration :
-- 1. Assurez-vous d'avoir configuré vos clés Supabase
-- 2. Utilisez `supabase db push` ou copiez-collez ce SQL dans l'éditeur Supabase
-- 3. Vérifiez que toutes les tables sont créées correctement
-- 4. Testez les politiques de sécurité avec un utilisateur authentifié