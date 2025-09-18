-- Schema de base de données Supabase pour FoodSave
-- Respecte les standards NYTH - Zero Compromise

-- Extensions nécessaires
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";
CREATE EXTENSION IF NOT EXISTS "postgis";

-- =================== TYPES ENUM ===================

CREATE TYPE user_type AS ENUM ('student', 'merchant');
CREATE TYPE meal_category AS ENUM (
    'main_course', 'appetizer', 'dessert', 
    'beverage', 'snack', 'bakery', 'other'
);
CREATE TYPE meal_status AS ENUM (
    'available', 'sold_out', 'expired', 'suspended'
);
CREATE TYPE order_status AS ENUM (
    'pending', 'confirmed', 'preparing', 'ready', 
    'completed', 'cancelled'
);
CREATE TYPE restaurant_type AS ENUM (
    'restaurant', 'bakery', 'cafe', 'fast_food',
    'caterer', 'food_truck', 'supermarket', 
    'grocery_store', 'other'
);

-- =================== TABLES PRINCIPALES ===================

-- Table des utilisateurs (complète les auth.users)
CREATE TABLE public.users (
    id UUID PRIMARY KEY REFERENCES auth.users(id) ON DELETE CASCADE,
    email TEXT NOT NULL UNIQUE,
    username TEXT NOT NULL UNIQUE,
    user_type user_type NOT NULL,
    first_name TEXT,
    last_name TEXT,
    phone_number TEXT,
    avatar_url TEXT,
    address TEXT,
    city TEXT,
    postal_code TEXT,
    coordinates GEOGRAPHY(POINT),
    is_verified BOOLEAN DEFAULT FALSE,
    is_active BOOLEAN DEFAULT TRUE,
    preferences JSONB DEFAULT '{}',
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Table des restaurants/commerçants
CREATE TABLE public.restaurants (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    owner_id UUID NOT NULL REFERENCES public.users(id) ON DELETE CASCADE,
    name TEXT NOT NULL,
    description TEXT NOT NULL,
    type restaurant_type NOT NULL DEFAULT 'restaurant',
    cover_image_url TEXT,
    logo_url TEXT,
    image_urls TEXT[] DEFAULT '{}',
    
    -- Adresse et localisation
    address TEXT NOT NULL,
    city TEXT NOT NULL,
    postal_code TEXT NOT NULL,
    coordinates GEOGRAPHY(POINT) NOT NULL,
    
    -- Contact
    phone_number TEXT,
    email TEXT,
    website TEXT,
    
    -- Horaires d'ouverture (JSON)
    opening_hours JSONB DEFAULT '{}',
    
    -- Statistiques
    average_rating DECIMAL(3,2) DEFAULT 0.0,
    total_reviews INTEGER DEFAULT 0,
    total_meals_sold INTEGER DEFAULT 0,
    total_savings_generated DECIMAL(10,2) DEFAULT 0.0,
    
    -- Spécialités et certifications
    specialties TEXT[] DEFAULT '{}',
    certifications TEXT[] DEFAULT '{}',
    
    -- Paramètres opérationnels
    delivery_radius DECIMAL(5,2) DEFAULT 5.0,
    average_preparation_time INTEGER DEFAULT 15,
    
    -- Statuts
    is_open BOOLEAN DEFAULT TRUE,
    is_active BOOLEAN DEFAULT TRUE,
    is_verified BOOLEAN DEFAULT FALSE,
    offers_delivery BOOLEAN DEFAULT FALSE,
    
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Table des repas
CREATE TABLE public.meals (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    merchant_id UUID NOT NULL REFERENCES public.users(id) ON DELETE CASCADE,
    restaurant_id UUID REFERENCES public.restaurants(id) ON DELETE SET NULL,
    
    -- Informations de base
    title TEXT NOT NULL,
    description TEXT NOT NULL,
    category meal_category NOT NULL,
    image_urls TEXT[] DEFAULT '{}',
    
    -- Prix et quantité
    original_price DECIMAL(8,2) NOT NULL CHECK (original_price >= 0),
    discounted_price DECIMAL(8,2) NOT NULL CHECK (discounted_price >= 0),
    quantity INTEGER NOT NULL CHECK (quantity >= 0),
    remaining_quantity INTEGER NOT NULL CHECK (remaining_quantity >= 0),
    
    -- Allergènes et ingrédients
    allergens TEXT[] DEFAULT '{}',
    ingredients TEXT[] DEFAULT '{}',
    
    -- Informations nutritionnelles (JSON)
    nutritional_info JSONB,
    
    -- Disponibilité
    available_from TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    available_until TIMESTAMP WITH TIME ZONE NOT NULL,
    
    -- Statut
    status meal_status DEFAULT 'available',
    
    -- Évaluations
    average_rating DECIMAL(3,2) DEFAULT 0.0,
    rating_count INTEGER DEFAULT 0,
    
    -- Spécificités alimentaires
    is_vegetarian BOOLEAN DEFAULT FALSE,
    is_vegan BOOLEAN DEFAULT FALSE,
    is_gluten_free BOOLEAN DEFAULT FALSE,
    is_halal BOOLEAN DEFAULT FALSE,
    
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    
    -- Contraintes
    CHECK (discounted_price <= original_price),
    CHECK (remaining_quantity <= quantity),
    CHECK (available_until > available_from)
);

-- Table des commandes
CREATE TABLE public.orders (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    order_number TEXT UNIQUE NOT NULL,
    
    -- Acteurs
    customer_id UUID NOT NULL REFERENCES public.users(id) ON DELETE CASCADE,
    merchant_id UUID NOT NULL REFERENCES public.users(id) ON DELETE CASCADE,
    meal_id UUID NOT NULL REFERENCES public.meals(id) ON DELETE CASCADE,
    
    -- Détails de la commande
    quantity INTEGER NOT NULL CHECK (quantity > 0),
    unit_price DECIMAL(8,2) NOT NULL CHECK (unit_price >= 0),
    total_price DECIMAL(8,2) NOT NULL CHECK (total_price >= 0),
    notes TEXT,
    
    -- Statut et timing
    status order_status DEFAULT 'pending',
    estimated_ready_at TIMESTAMP WITH TIME ZONE,
    ready_at TIMESTAMP WITH TIME ZONE,
    completed_at TIMESTAMP WITH TIME ZONE,
    cancelled_at TIMESTAMP WITH TIME ZONE,
    cancellation_reason TEXT,
    
    -- Évaluation
    customer_rating INTEGER CHECK (customer_rating >= 1 AND customer_rating <= 5),
    customer_review TEXT,
    merchant_feedback TEXT,
    
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    
    -- Contraintes
    CHECK (total_price = unit_price * quantity)
);

-- Table des avis/évaluations
CREATE TABLE public.reviews (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    
    -- Relations
    customer_id UUID NOT NULL REFERENCES public.users(id) ON DELETE CASCADE,
    order_id UUID NOT NULL REFERENCES public.orders(id) ON DELETE CASCADE,
    meal_id UUID NOT NULL REFERENCES public.meals(id) ON DELETE CASCADE,
    merchant_id UUID NOT NULL REFERENCES public.users(id) ON DELETE CASCADE,
    
    -- Évaluation
    rating INTEGER NOT NULL CHECK (rating >= 1 AND rating <= 5),
    title TEXT,
    comment TEXT,
    
    -- Images des avis
    image_urls TEXT[] DEFAULT '{}',
    
    -- Modération
    is_approved BOOLEAN DEFAULT TRUE,
    is_flagged BOOLEAN DEFAULT FALSE,
    moderator_notes TEXT,
    
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    
    -- Un seul avis par commande
    UNIQUE(customer_id, order_id)
);

-- Table des favoris
CREATE TABLE public.favorites (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID NOT NULL REFERENCES public.users(id) ON DELETE CASCADE,
    meal_id UUID NOT NULL REFERENCES public.meals(id) ON DELETE CASCADE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    
    -- Un favori unique par utilisateur/repas
    UNIQUE(user_id, meal_id)
);

-- Table des notifications
CREATE TABLE public.notifications (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID NOT NULL REFERENCES public.users(id) ON DELETE CASCADE,
    
    -- Contenu
    title TEXT NOT NULL,
    message TEXT NOT NULL,
    type TEXT NOT NULL, -- 'order', 'meal', 'promotion', 'system'
    
    -- Métadonnées
    data JSONB DEFAULT '{}',
    
    -- Statuts
    is_read BOOLEAN DEFAULT FALSE,
    is_sent BOOLEAN DEFAULT FALSE,
    
    -- Timing
    scheduled_for TIMESTAMP WITH TIME ZONE,
    sent_at TIMESTAMP WITH TIME ZONE,
    read_at TIMESTAMP WITH TIME ZONE,
    
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- =================== INDEX ===================

-- Index pour les performances des requêtes fréquentes

-- Users
CREATE INDEX idx_users_user_type ON public.users(user_type);
CREATE INDEX idx_users_email ON public.users(email);
CREATE INDEX idx_users_username ON public.users(username);
CREATE INDEX idx_users_location ON public.users USING GIST(coordinates);

-- Restaurants
CREATE INDEX idx_restaurants_owner_id ON public.restaurants(owner_id);
CREATE INDEX idx_restaurants_location ON public.restaurants USING GIST(coordinates);
CREATE INDEX idx_restaurants_type ON public.restaurants(type);
CREATE INDEX idx_restaurants_active ON public.restaurants(is_active, is_open);

-- Meals
CREATE INDEX idx_meals_merchant_id ON public.meals(merchant_id);
CREATE INDEX idx_meals_restaurant_id ON public.meals(restaurant_id);
CREATE INDEX idx_meals_status ON public.meals(status);
CREATE INDEX idx_meals_category ON public.meals(category);
CREATE INDEX idx_meals_availability ON public.meals(available_until, remaining_quantity, status);
CREATE INDEX idx_meals_price ON public.meals(discounted_price);
CREATE INDEX idx_meals_dietary ON public.meals(is_vegetarian, is_vegan, is_gluten_free, is_halal);
CREATE INDEX idx_meals_created_at ON public.meals(created_at);

-- Orders
CREATE INDEX idx_orders_customer_id ON public.orders(customer_id);
CREATE INDEX idx_orders_merchant_id ON public.orders(merchant_id);
CREATE INDEX idx_orders_meal_id ON public.orders(meal_id);
CREATE INDEX idx_orders_status ON public.orders(status);
CREATE INDEX idx_orders_created_at ON public.orders(created_at);
CREATE INDEX idx_orders_number ON public.orders(order_number);

-- Reviews
CREATE INDEX idx_reviews_customer_id ON public.reviews(customer_id);
CREATE INDEX idx_reviews_merchant_id ON public.reviews(merchant_id);
CREATE INDEX idx_reviews_meal_id ON public.reviews(meal_id);
CREATE INDEX idx_reviews_rating ON public.reviews(rating);

-- Favorites
CREATE INDEX idx_favorites_user_id ON public.favorites(user_id);
CREATE INDEX idx_favorites_meal_id ON public.favorites(meal_id);

-- Notifications
CREATE INDEX idx_notifications_user_id ON public.notifications(user_id);
CREATE INDEX idx_notifications_unread ON public.notifications(user_id, is_read);
CREATE INDEX idx_notifications_scheduled ON public.notifications(scheduled_for, is_sent);

-- =================== RLS (ROW LEVEL SECURITY) ===================

-- Activer RLS sur toutes les tables
ALTER TABLE public.users ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.restaurants ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.meals ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.orders ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.reviews ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.favorites ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.notifications ENABLE ROW LEVEL SECURITY;

-- Politiques RLS pour users
CREATE POLICY "Users can view own profile" ON public.users
    FOR SELECT USING (auth.uid() = id);

CREATE POLICY "Users can update own profile" ON public.users
    FOR UPDATE USING (auth.uid() = id);

CREATE POLICY "Public profiles are viewable" ON public.users
    FOR SELECT USING (true); -- Pour les profils publics des commerçants

-- Politiques RLS pour restaurants
CREATE POLICY "Anyone can view active restaurants" ON public.restaurants
    FOR SELECT USING (is_active = true);

CREATE POLICY "Owners can manage their restaurants" ON public.restaurants
    FOR ALL USING (auth.uid() = owner_id);

-- Politiques RLS pour meals
CREATE POLICY "Anyone can view available meals" ON public.meals
    FOR SELECT USING (
        status = 'available' 
        AND remaining_quantity > 0 
        AND available_until > NOW()
    );

CREATE POLICY "Merchants can manage their meals" ON public.meals
    FOR ALL USING (auth.uid() = merchant_id);

-- Politiques RLS pour orders
CREATE POLICY "Users can view their orders" ON public.orders
    FOR SELECT USING (auth.uid() = customer_id OR auth.uid() = merchant_id);

CREATE POLICY "Customers can create orders" ON public.orders
    FOR INSERT WITH CHECK (auth.uid() = customer_id);

CREATE POLICY "Merchants can update order status" ON public.orders
    FOR UPDATE USING (auth.uid() = merchant_id);

-- Politiques RLS pour reviews
CREATE POLICY "Anyone can read approved reviews" ON public.reviews
    FOR SELECT USING (is_approved = true);

CREATE POLICY "Customers can manage their reviews" ON public.reviews
    FOR ALL USING (auth.uid() = customer_id);

-- Politiques RLS pour favorites
CREATE POLICY "Users can manage their favorites" ON public.favorites
    FOR ALL USING (auth.uid() = user_id);

-- Politiques RLS pour notifications
CREATE POLICY "Users can view their notifications" ON public.notifications
    FOR SELECT USING (auth.uid() = user_id);

CREATE POLICY "Users can update their notifications" ON public.notifications
    FOR UPDATE USING (auth.uid() = user_id);

-- =================== FONCTIONS ET TRIGGERS ===================

-- Fonction pour mettre à jour updated_at
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ language 'plpgsql';

-- Triggers pour updated_at
CREATE TRIGGER update_users_updated_at BEFORE UPDATE ON public.users
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_restaurants_updated_at BEFORE UPDATE ON public.restaurants
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_meals_updated_at BEFORE UPDATE ON public.meals
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_orders_updated_at BEFORE UPDATE ON public.orders
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

-- Fonction pour générer un numéro de commande unique
CREATE OR REPLACE FUNCTION generate_order_number()
RETURNS TRIGGER AS $$
BEGIN
    NEW.order_number := 'FS' || TO_CHAR(NOW(), 'YYYYMMDD') || '-' || LPAD(EXTRACT(EPOCH FROM NOW())::TEXT, 10, '0');
    RETURN NEW;
END;
$$ language 'plpgsql';

-- Trigger pour générer le numéro de commande
CREATE TRIGGER generate_order_number_trigger
    BEFORE INSERT ON public.orders
    FOR EACH ROW EXECUTE FUNCTION generate_order_number();

-- Fonction pour créer une commande avec mise à jour du stock
CREATE OR REPLACE FUNCTION create_order_with_stock_update(
    meal_id UUID,
    customer_id UUID,
    quantity INTEGER,
    total_price DECIMAL,
    notes TEXT DEFAULT NULL
)
RETURNS UUID AS $$
DECLARE
    order_id UUID;
    meal_record RECORD;
BEGIN
    -- Vérifier et bloquer le repas
    SELECT * INTO meal_record 
    FROM public.meals 
    WHERE id = meal_id 
    FOR UPDATE;
    
    -- Vérifier la disponibilité
    IF meal_record.remaining_quantity < quantity THEN
        RAISE EXCEPTION 'Quantité insuffisante disponible';
    END IF;
    
    IF meal_record.status != 'available' THEN
        RAISE EXCEPTION 'Repas non disponible';
    END IF;
    
    -- Créer la commande
    INSERT INTO public.orders (
        customer_id, 
        merchant_id, 
        meal_id, 
        quantity, 
        unit_price, 
        total_price, 
        notes
    ) VALUES (
        customer_id,
        meal_record.merchant_id,
        meal_id,
        quantity,
        meal_record.discounted_price,
        total_price,
        notes
    ) RETURNING id INTO order_id;
    
    -- Mettre à jour le stock
    UPDATE public.meals 
    SET remaining_quantity = remaining_quantity - quantity,
        updated_at = NOW()
    WHERE id = meal_id;
    
    -- Marquer comme épuisé si nécessaire
    IF (meal_record.remaining_quantity - quantity) = 0 THEN
        UPDATE public.meals 
        SET status = 'sold_out',
            updated_at = NOW()
        WHERE id = meal_id;
    END IF;
    
    RETURN order_id;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Fonction pour calculer la distance entre deux points
CREATE OR REPLACE FUNCTION calculate_distance(
    lat1 DOUBLE PRECISION, 
    lon1 DOUBLE PRECISION, 
    lat2 DOUBLE PRECISION, 
    lon2 DOUBLE PRECISION
)
RETURNS DOUBLE PRECISION AS $$
BEGIN
    RETURN ST_Distance(
        ST_GeogFromText('POINT(' || lon1 || ' ' || lat1 || ')'),
        ST_GeogFromText('POINT(' || lon2 || ' ' || lat2 || ')')
    ) / 1000; -- Retourner en kilomètres
END;
$$ LANGUAGE plpgsql;

-- =================== DONNÉES INITIALES (SEED) ===================

-- Insérer quelques données de test (optionnel)
-- Ceci sera fait via l'application ou des scripts séparés

-- =================== VUES UTILES ===================

-- Vue des repas avec informations du restaurant
CREATE VIEW meals_with_restaurant AS
SELECT 
    m.*,
    r.name as restaurant_name,
    r.address as restaurant_address,
    r.coordinates as restaurant_coordinates,
    r.average_rating as restaurant_rating
FROM public.meals m
LEFT JOIN public.restaurants r ON m.restaurant_id = r.id;

-- Vue des commandes avec détails
CREATE VIEW orders_with_details AS
SELECT 
    o.*,
    cu.username as customer_username,
    cu.first_name as customer_first_name,
    cu.last_name as customer_last_name,
    m.title as meal_title,
    m.description as meal_description,
    me.username as merchant_username,
    r.name as restaurant_name
FROM public.orders o
JOIN public.users cu ON o.customer_id = cu.id
JOIN public.meals m ON o.meal_id = m.id
JOIN public.users me ON o.merchant_id = me.id
LEFT JOIN public.restaurants r ON m.restaurant_id = r.id;

-- Vue des statistiques commerçant
CREATE VIEW merchant_stats AS
SELECT 
    u.id,
    u.username,
    COUNT(DISTINCT m.id) as total_meals,
    COUNT(DISTINCT o.id) as total_orders,
    COALESCE(SUM(o.total_price), 0) as total_revenue,
    COALESCE(AVG(o.customer_rating), 0) as average_rating
FROM public.users u
LEFT JOIN public.meals m ON u.id = m.merchant_id
LEFT JOIN public.orders o ON m.id = o.meal_id
WHERE u.user_type = 'merchant'
GROUP BY u.id, u.username;

-- =================== COMMENTAIRES ===================

COMMENT ON TABLE public.users IS 'Table des utilisateurs étendant auth.users';
COMMENT ON TABLE public.restaurants IS 'Table des restaurants/commerçants';
COMMENT ON TABLE public.meals IS 'Table des repas/invendus proposés';
COMMENT ON TABLE public.orders IS 'Table des commandes';
COMMENT ON TABLE public.reviews IS 'Table des avis clients';
COMMENT ON TABLE public.favorites IS 'Table des favoris utilisateurs';
COMMENT ON TABLE public.notifications IS 'Table des notifications push';

COMMENT ON FUNCTION create_order_with_stock_update IS 'Crée une commande avec mise à jour atomique du stock';
COMMENT ON FUNCTION calculate_distance IS 'Calcule la distance entre deux coordonnées géographiques';