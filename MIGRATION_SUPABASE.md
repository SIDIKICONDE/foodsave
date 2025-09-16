# Migration vers Supabase - FoodSave
## Standards NYTH - Zero Compromise

Ce guide vous accompagne dans la migration complète de FoodSave vers Supabase, remplaçant l'architecture backend actuelle par une solution moderne et évolutive.

## 🎯 **État actuel de la migration**

### ✅ **Terminé**
- [x] Configuration des variables d'environnement (.env)
- [x] Mise à jour du pubspec.yaml avec les dépendances Supabase
- [x] Initialisation Supabase dans main.dart  
- [x] Création du SupabaseService complet
- [x] Providers Riverpod pour l'intégration Supabase
- [x] Mise à jour du LoginScreen
- [x] Schéma de base de données complet
- [x] Configuration Supabase (config.toml)
- [x] Edge Functions pour gestion automatisée

### 🔄 **En cours**
- [ ] Test de la nouvelle authentification
- [ ] Migration des autres écrans (SignUp, Profile, etc.)
- [ ] Test des fonctionnalités métier

### 📋 **À faire**
- [ ] Déploiement en local pour tests
- [ ] Configuration du projet Supabase distant
- [ ] Tests d'intégration complets

## 🚀 **Commandes de déploiement**

### **1. Installation des dépendances**
```bash
# Se positionner dans le projet FoodSave
cd /Users/m1/Desktop/FoodSave

# Nettoyer et récupérer les dépendances
flutter clean
flutter pub get
```

### **2. Configuration de Supabase local**
```bash
# Installer Supabase CLI (si pas déjà fait)
npm install -g supabase
# ou avec Homebrew
brew install supabase/tap/supabase

# Initialiser Supabase dans le projet
supabase init

# Démarrer l'environnement local
supabase start

# Vérifier l'état des services
supabase status
```

**Résultat attendu:**
```
API URL: http://localhost:54321
Studio URL: http://localhost:54323
Database URL: postgresql://postgres:postgres@localhost:54322/postgres
```

### **3. Application du schéma de base de données**
```bash
# Appliquer le schéma complet
supabase db reset --debug

# Ou appliquer manuellement le fichier schema.sql
psql "postgresql://postgres:postgres@localhost:54322/postgres" -f supabase/schema.sql
```

### **4. Configuration des buckets de stockage**
```bash
# Se connecter à Studio pour configurer les buckets
open http://localhost:54323

# Ou via SQL (dans Studio > SQL Editor):
```
```sql
-- Créer les buckets de stockage
INSERT INTO storage.buckets (id, name, public) VALUES 
    ('meal-images', 'meal-images', true),
    ('restaurant-images', 'restaurant-images', true),
    ('user-avatars', 'user-avatars', true),
    ('documents', 'documents', false);

-- Politiques de sécurité pour les buckets
CREATE POLICY "Utilisateurs peuvent uploader leurs avatars" ON storage.objects
    FOR INSERT WITH CHECK (bucket_id = 'user-avatars' AND auth.uid()::text = (storage.foldername(name))[1]);

CREATE POLICY "Images publiques lisibles par tous" ON storage.objects
    FOR SELECT USING (bucket_id IN ('meal-images', 'restaurant-images', 'user-avatars'));
```

### **5. Configuration des variables d'environnement**

**Récupérer les clés locales:**
```bash
# Afficher les URLs et clés locales
supabase status

# Copier les valeurs dans .env
```

**Mettre à jour `.env` avec les vraies valeurs:**
```env
# Remplacer dans .env
SUPABASE_URL_LOCAL=http://localhost:54321
SUPABASE_ANON_KEY_LOCAL=eyJhbG... (valeur du supabase status)
SUPABASE_SERVICE_ROLE_KEY_LOCAL=eyJhbG... (valeur du supabase status)
```

### **6. Déploiement des Edge Functions**
```bash
# Déployer la fonction de vérification d'expiration
supabase functions deploy meal-expiry-check

# Vérifier le déploiement
supabase functions list
```

### **7. Test de l'application**
```bash
# Lancer l'application Flutter
flutter run

# Ou pour le mode debug avec logs
flutter run --dart-define=DEBUG_MODE=true
```

## 🧪 **Tests de validation**

### **Test 1: Connexion à Supabase**
```bash
# Tester l'API REST
curl "http://localhost:54321/rest/v1/users" \
  -H "apikey: YOUR_ANON_KEY" \
  -H "Authorization: Bearer YOUR_ANON_KEY"
```

### **Test 2: Créer un utilisateur de test**
```sql
-- Dans Supabase Studio > SQL Editor
INSERT INTO auth.users (id, email, encrypted_password, email_confirmed_at, created_at, updated_at)
VALUES (
    gen_random_uuid(),
    'test@foodsave.fr',
    crypt('password123', gen_salt('bf')),
    NOW(),
    NOW(),
    NOW()
);
```

### **Test 3: Edge Function**
```bash
curl -X POST "http://localhost:54321/functions/v1/meal-expiry-check" \
  -H "Authorization: Bearer YOUR_ANON_KEY" \
  -H "Content-Type: application/json"
```

## 🔧 **Configuration pour la production**

### **1. Créer un projet Supabase**
1. Aller sur [supabase.com](https://supabase.com)
2. Créer un nouveau projet "FoodSave"
3. Noter l'URL et les clés du projet

### **2. Configurer les variables de production**
```env
# Mettre à jour dans .env
ENVIRONMENT=production
SUPABASE_URL=https://your-project-id.supabase.co
SUPABASE_ANON_KEY=eyJhbG... (vraie clé du projet)
SUPABASE_SERVICE_ROLE_KEY=eyJhbG... (vraie clé service)
```

### **3. Déployer en production**
```bash
# Connecter au projet distant
supabase login
supabase link --project-ref YOUR_PROJECT_ID

# Appliquer les migrations
supabase db push

# Déployer les Edge Functions
supabase functions deploy meal-expiry-check
```

## 📱 **Changements dans l'application**

### **Authentification**
- ✅ `LoginScreen` mis à jour avec providers Supabase
- ⏳ `SignUpScreen` à migrer
- ⏳ `ProfileScreen` à migrer

### **Services**
- ✅ `SupabaseService` remplace `AuthService`
- ✅ Providers Riverpod configurés
- ⏳ Tests des méthodes métier

### **Modèles**
- ✅ `User` model compatible
- ⏳ Nouveaux modèles (Meal, Order, Restaurant)

## 🚨 **Points d'attention**

### **Sécurité**
- RLS (Row Level Security) activé sur toutes les tables
- Chiffrement des données sensibles
- Tokens JWT avec expiration automatique

### **Performance**
- Index optimisés pour les requêtes fréquentes
- Cache local avec synchronisation
- Gestion offline native

### **Évolutivité**
- Architecture modulaire et extensible
- Edge Functions pour la logique métier
- Storage séparé pour les médias

## 🔄 **Rollback (en cas de problème)**

Si vous devez revenir à l'ancienne version:

```bash
# Arrêter Supabase local
supabase stop

# Revenir aux anciens providers dans le code
git checkout HEAD~1 lib/providers/supabase_providers.dart
git checkout HEAD~1 lib/screens/auth/login_screen.dart
git checkout HEAD~1 lib/main.dart

# Rebuilder l'app
flutter clean && flutter pub get
```

## 📞 **Support et debug**

### **Logs Supabase**
```bash
# Voir les logs en temps réel
supabase logs

# Logs spécifiques à l'auth
supabase logs --type auth

# Logs des Edge Functions
supabase logs --type functions
```

### **Debug Flutter**
```bash
# Mode verbose
flutter run -v

# Avec variables d'environnement
flutter run --dart-define=DEBUG_MODE=true --dart-define=VERBOSE_LOGGING=true
```

### **Problèmes courants**

1. **Erreur "Supabase not initialized"**
   - Vérifier que `supabase start` est lancé
   - Contrôler les variables d'environnement dans `.env`

2. **Erreur d'authentification**
   - Vérifier les clés dans `.env`
   - Contrôler les politiques RLS

3. **Edge Functions qui ne répondent pas**
   - Redéployer: `supabase functions deploy meal-expiry-check`
   - Vérifier les logs: `supabase logs --type functions`

---

## 📈 **Prochaines étapes**

1. **Terminer la migration des écrans d'auth**
2. **Implémenter les écrans métier** (feed, commandes, etc.)
3. **Tester l'upload d'images**
4. **Configurer les notifications push**
5. **Optimiser les performances**
6. **Préparer le déploiement en production**

---

*Migration réalisée selon les standards NYTH - Zero Compromise pour FoodSave*