# 🚀 Déploiement des Tables Supabase - FoodSave

## ⚡ Déploiement Rapide (Recommandé)

### Option 1 : Script Automatique

Exécutez le script PowerShell qui va tout configurer pour vous :

```powershell
.\deploy_supabase.ps1
```

Le script va :
1. ✅ Installer Scoop (si nécessaire)
2. ✅ Installer Supabase CLI (si nécessaire)
3. ✅ Vérifier la configuration
4. ✅ Vous proposer 3 options de déploiement

---

## 📋 Options de Déploiement

### Option 1 : Vers Supabase Cloud (Production)

```bash
# 1. Se connecter à Supabase
supabase login

# 2. Lier votre projet
supabase link

# 3. Appliquer les migrations
supabase db push
```

**Prérequis :**
- Compte Supabase créé sur [supabase.com](https://supabase.com)
- Projet Supabase créé
- Project Reference et Database Password

### Option 2 : Environnement Local (Développement)

```bash
# Démarrer l'environnement local
supabase start

# Voir le statut
supabase status
```

**Prérequis :**
- Docker installé et en cours d'exécution

### Option 3 : Copie Manuelle (Simple)

1. 📋 Copiez le contenu du fichier `supabase/migrations/20240101000000_initial_schema.sql`
2. 🌐 Connectez-vous à [supabase.com/dashboard](https://supabase.com/dashboard)
3. 📂 Ouvrez votre projet
4. 💾 Allez dans **SQL Editor**
5. 📝 Collez le SQL et cliquez sur **RUN**

---

## 🔧 Configuration des Clés

**IMPORTANT :** Avant de déployer, configurez vos vraies clés Supabase dans :

`lib/config/supabase_config.dart`

```dart
static const String supabaseUrl = 'https://VOTRE-PROJECT.supabase.co';
static const String supabaseAnonKey = 'VOTRE-ANON-KEY';
```

### Comment obtenir vos clés :

1. Allez sur [supabase.com/dashboard](https://supabase.com/dashboard)
2. Sélectionnez votre projet
3. Cliquez sur **Settings** > **API**
4. Copiez :
   - **Project URL** → `supabaseUrl`
   - **anon public** → `supabaseAnonKey`

---

## 📊 Tables Créées

Le déploiement va créer automatiquement :

### 🏪 **shops** - Magasins/Commerçants
- `id`, `name`, `address`, `phone`, `email`
- `rating`, `total_reviews`, `opening_hours`
- `created_at`, `updated_at`

### 🧺 **baskets_map** - Paniers Anti-Gaspi
- `id`, `shop_id`, `title`, `description`
- `price`, `original_price`, `latitude`, `longitude`
- `type`, `quantity`, `available_from`, `available_until`
- `image_url`, `is_active`, `created_at`, `updated_at`

### ❤️ **user_favorites** - Favoris Utilisateur
- `id`, `user_id`, `basket_id`, `created_at`

### 🔔 **proximity_notifications** - Notifications de Proximité
- `id`, `user_id`, `basket_id`, `distance_km`
- `notified_at`, `clicked`

### 🔍 **search_history** - Historique de Recherche
- `id`, `user_id`, `search_query`, `results_count`, `searched_at`

---

## 🛡️ Sécurité (RLS)

Le déploiement active automatiquement **Row Level Security** avec :

- 👀 **Lecture publique** : Magasins et paniers actifs
- 🔐 **Données privées** : Favoris, notifications, historique par utilisateur
- ✅ **Authentification requise** : Pour les actions de modification

---

## 🔍 Vérification du Déploiement

### Via Dashboard Supabase
1. Connectez-vous au [Dashboard](https://supabase.com/dashboard)
2. Ouvrez votre projet
3. Cliquez sur **Table Editor**
4. Vérifiez que les 5 tables sont présentes

### Via Flutter
```dart
// Test rapide dans votre app
import 'package:foodsave_app/services/supabase_service.dart';

// Vérifier la connexion
if (SupabaseService.isAuthenticated) {
  print('✅ Connexion OK');
} else {
  print('❌ Pas de connexion');
}

// Test de lecture des magasins
final result = await SupabaseService.select(
  tableName: 'shops',
  limit: 5,
);
```

---

## 🚨 Résolution de Problèmes

### ❌ "Échec de l'installation de Supabase CLI"
- Vérifiez votre connexion internet
- Essayez de redémarrer le terminal en tant qu'administrateur
- Installation manuelle : https://supabase.com/docs/guides/cli

### ❌ "Échec de la liaison du projet"
- Vérifiez vos identifiants Supabase
- Assurez-vous que le projet existe
- Vérifiez la Project Reference (format : `abcdefghijklmnop`)

### ❌ "Échec de l'application des migrations"
- Vérifiez vos permissions sur le projet
- Assurez-vous que la base de données est accessible
- Regardez les logs d'erreur détaillés

### ❌ "Erreur de connexion dans Flutter"
- Vérifiez les clés dans `supabase_config.dart`
- Assurez-vous que l'URL est correcte
- Testez les clés dans l'éditeur SQL Supabase

---

## 📱 Données de Test

Le déploiement inclut des données de test :

- 🏪 **3 magasins** : Boulangerie, Restaurant, Épicerie
- 🧺 **3 paniers** : Un par type de magasin
- 📍 **Localisation** : Autour de Paris (pour les tests)

### Supprimer les données de test

```sql
-- Dans l'éditeur SQL Supabase
DELETE FROM baskets_map WHERE title LIKE 'Panier%';
DELETE FROM shops WHERE name LIKE '%Coin%' OR name LIKE '%Bio%' OR name LIKE '%Moderne%';
```

---

## 🎯 Prochaines Étapes

Une fois le déploiement terminé :

1. ✅ **Testez l'authentification** avec votre app Flutter
2. ✅ **Ajoutez vos propres données** de magasins et paniers
3. ✅ **Configurez les notifications push** (optionnel)
4. ✅ **Optimisez les politiques RLS** selon vos besoins
5. ✅ **Configurez les sauvegardes** automatiques

---

## 📞 Support

- 📚 [Documentation Supabase](https://supabase.com/docs)
- 💬 [Discord Supabase](https://discord.supabase.com)
- 🐛 [Issues GitHub](https://github.com/supabase/supabase)
- 📱 [Guide Flutter + Supabase](https://supabase.com/docs/guides/getting-started/tutorials/with-flutter)

---

🎉 **Votre base de données FoodSave est maintenant prête !**