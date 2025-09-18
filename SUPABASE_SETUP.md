# Configuration Supabase pour FoodSave

## 🎯 Installation Terminée

✅ **Supabase a été configuré avec succès dans votre application FoodSave !**

## 📁 Fichiers Créés/Modifiés

### Fichiers de Configuration
- `lib/config/supabase_config.dart` - Configuration centralisée
- `lib/services/supabase_service.dart` - Service principal avec gestion d'erreurs

### Modèles de Données
- `lib/models/basket.dart` - Modèle pour les paniers anti-gaspi
- `lib/models/shop.dart` - Modèle pour les magasins/commerçants

### Exemples
- `lib/examples/supabase_usage_example.dart` - Exemples d'utilisation complète

### Fichiers Modifiés
- `pubspec.yaml` - Dépendance supabase_flutter activée
- `lib/main.dart` - Initialisation Supabase au démarrage

## 🔧 Prochaines Étapes Obligatoires

### 1. Configurer vos Clés Supabase

**IMPORTANT :** Remplacez les valeurs placeholder dans `lib/config/supabase_config.dart`:

```dart
static const String supabaseUrl = 'https://your-project.supabase.co';
static const String supabaseAnonKey = 'your-anon-key-here';
```

Par vos vraies clés Supabase :
1. Connectez-vous à [supabase.com](https://supabase.com)
2. Créez un nouveau projet ou ouvrez le vôtre
3. Allez dans `Settings > API`
4. Copiez l'URL et la clé anonyme

### 2. Créer les Tables dans Supabase

Exécutez les requêtes SQL suivantes dans l'éditeur SQL de Supabase :

```sql
-- Table des magasins
CREATE TABLE shops (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  name VARCHAR(255) NOT NULL,
  address TEXT NOT NULL,
  phone VARCHAR(20),
  email VARCHAR(255),
  rating DECIMAL(2,1),
  total_reviews INTEGER DEFAULT 0,
  opening_hours JSONB,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Table des paniers anti-gaspi
CREATE TABLE baskets_map (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  shop_id UUID REFERENCES shops(id),
  title VARCHAR(255) NOT NULL,
  description TEXT,
  price DECIMAL(10,2) NOT NULL,
  original_price DECIMAL(10,2),
  latitude DECIMAL(10,8) NOT NULL,
  longitude DECIMAL(11,8) NOT NULL,
  type VARCHAR(50) NOT NULL,
  quantity INTEGER DEFAULT 1,
  available_from TIMESTAMP WITH TIME ZONE,
  available_until TIMESTAMP WITH TIME ZONE NOT NULL,
  image_url TEXT,
  is_active BOOLEAN DEFAULT true,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Table des favoris utilisateur
CREATE TABLE user_favorites (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  user_id UUID NOT NULL,
  basket_id UUID REFERENCES baskets_map(id),
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  UNIQUE(user_id, basket_id)
);

-- Table des notifications de proximité
CREATE TABLE proximity_notifications (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  user_id UUID NOT NULL,
  basket_id UUID REFERENCES baskets_map(id),
  distance_km DECIMAL(5,2),
  notified_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  clicked BOOLEAN DEFAULT false
);

-- Table de l'historique de recherche
CREATE TABLE search_history (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  user_id UUID NOT NULL,
  search_query VARCHAR(255) NOT NULL,
  results_count INTEGER,
  searched_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Trigger pour mettre à jour updated_at automatiquement
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ language 'plpgsql';

CREATE TRIGGER update_baskets_map_updated_at 
    BEFORE UPDATE ON baskets_map 
    FOR EACH ROW 
    EXECUTE FUNCTION update_updated_at_column();
```

### 3. Configurer les Politiques de Sécurité (RLS)

```sql
-- Activer RLS sur toutes les tables
ALTER TABLE shops ENABLE ROW LEVEL SECURITY;
ALTER TABLE baskets_map ENABLE ROW LEVEL SECURITY;
ALTER TABLE user_favorites ENABLE ROW LEVEL SECURITY;
ALTER TABLE proximity_notifications ENABLE ROW LEVEL SECURITY;
ALTER TABLE search_history ENABLE ROW LEVEL SECURITY;

-- Politiques de base (à adapter selon vos besoins)
-- Lecture publique des magasins et paniers actifs
CREATE POLICY "Public shops are viewable by everyone" 
    ON shops FOR SELECT 
    USING (true);

CREATE POLICY "Active baskets are viewable by everyone" 
    ON baskets_map FOR SELECT 
    USING (is_active = true);

-- Les favoris sont privés à chaque utilisateur
CREATE POLICY "Users can view their own favorites" 
    ON user_favorites FOR SELECT 
    USING (auth.uid() = user_id);

CREATE POLICY "Users can insert their own favorites" 
    ON user_favorites FOR INSERT 
    WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can delete their own favorites" 
    ON user_favorites FOR DELETE 
    USING (auth.uid() = user_id);
```

## 💡 Comment Utiliser Supabase

### Authentification

```dart
import 'package:foodsave_app/services/supabase_service.dart';

// Inscription
final result = await SupabaseService.signUp(
  email: 'user@example.com',
  password: 'password123',
);

// Connexion
final result = await SupabaseService.signIn(
  email: 'user@example.com',
  password: 'password123',
);

// Vérifier l'état de connexion
if (SupabaseService.isAuthenticated) {
  print('Utilisateur connecté: ${SupabaseService.currentUser?.email}');
}
```

### Opérations sur les Données

```dart
// Récupérer les paniers disponibles
final result = await SupabaseService.select(
  tableName: SupabaseConfig.tableBasketsMap,
  filters: {'is_active': true},
  orderBy: 'created_at',
  ascending: false,
  limit: 20,
);

result.fold(
  (error) => print('Erreur: ${error.message}'),
  (data) {
    final baskets = data.map((json) => Basket.fromJson(json)).toList();
    print('${baskets.length} paniers trouvés');
  },
);

// Ajouter un panier aux favoris
await SupabaseService.insert(
  tableName: SupabaseConfig.tableFavorites,
  data: {
    'user_id': SupabaseService.currentUser!.id,
    'basket_id': basketId,
  },
);
```

### Temps Réel

```dart
// S'abonner aux changements des paniers
final channel = SupabaseService.subscribeToTable(
  tableName: SupabaseConfig.tableBasketsMap,
  callback: (payload) {
    print('Changement détecté: ${payload.eventType}');
    // Mettre à jour votre interface utilisateur
  },
);

// Arrêter l'écoute
channel.unsubscribe();
```

## 🛠️ Fonctionnalités Disponibles

### ✅ Authentification
- Inscription/connexion par email/mot de passe
- Réinitialisation de mot de passe
- Gestion des sessions
- Metadata utilisateur

### ✅ Base de Données
- CRUD operations avec gestion d'erreurs
- Filtrage et tri des données
- Pagination
- Relations entre tables

### ✅ Temps Réel
- Écoute des changements en temps réel
- Notifications push
- Synchronisation automatique

### ✅ Sécurité
- Row Level Security (RLS)
- Authentification JWT
- Politiques d'accès granulaires

### ✅ Types et Modèles
- Modèles Dart typés
- Sérialisation JSON automatique
- Validation des données
- Documentation complète

## 📚 Ressources Utiles

- [Documentation Supabase](https://supabase.com/docs)
- [Package supabase_flutter](https://pub.dev/packages/supabase_flutter)
- [Exemples complets dans `lib/examples/`](./lib/examples/supabase_usage_example.dart)

## 🔍 Dépannage

### Erreurs Courantes

1. **Erreur de connexion** : Vérifiez vos clés dans `supabase_config.dart`
2. **Erreur de permissions** : Vérifiez les politiques RLS dans Supabase
3. **Erreur de table** : Assurez-vous que les tables existent dans votre base

### Vérification

```bash
# Vérifier que tout compile
flutter analyze

# Installer les dépendances
flutter pub get

# Générer les fichiers JSON
flutter packages pub run build_runner build
```

---

🎉 **Votre application FoodSave est maintenant prête à utiliser Supabase !**

N'hésitez pas à explorer les exemples dans `lib/examples/supabase_usage_example.dart` pour découvrir toutes les fonctionnalités disponibles.