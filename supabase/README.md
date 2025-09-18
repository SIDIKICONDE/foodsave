# Configuration Supabase pour FoodSave
## Standards NYTH - Zero Compromise

Ce dossier contient tous les fichiers nécessaires pour configurer et déployer l'infrastructure backend Supabase pour l'application FoodSave.

## 📋 Structure des fichiers

```
supabase/
├── README.md                          # Ce guide d'installation
├── config.toml                        # Configuration Supabase complète
├── schema.sql                          # Schéma de base de données complet
├── functions/
│   └── meal-expiry-check/
│       └── index.ts                   # Edge Function pour vérification d'expiration
├── migrations/                        # Migrations de base de données (auto-généré)
├── storage/                          # Configuration du stockage
└── seed/                            # Données de test initiales
```

## 🚀 Installation et Configuration

### Prérequis

1. **Installation de Supabase CLI**
```bash
npm install -g supabase
# ou
brew install supabase/tap/supabase
```

2. **Compte Supabase**
- Créer un compte sur [supabase.com](https://supabase.com)
- Créer un nouveau projet pour FoodSave

### Étape 1: Initialisation du projet

```bash
# Se positionner dans le dossier FoodSave
cd /Users/m1/Desktop/FoodSave

# Initialiser Supabase (si pas déjà fait)
supabase init

# Connecter au projet distant
supabase login
supabase link --project-ref YOUR_PROJECT_ID
```

### Étape 2: Configuration locale

```bash
# Démarrer l'environnement local
supabase start

# Vérifier que tous les services sont actifs
supabase status
```

Les services suivants doivent être actifs:
- **API**: `http://localhost:54321`
- **Studio**: `http://localhost:54323` 
- **Database**: `postgresql://postgres:postgres@localhost:54322/postgres`
- **Storage**: `http://localhost:54325`

### Étape 3: Application du schéma

```bash
# Appliquer le schéma complet
supabase db reset --debug

# Ou appliquer manuellement
psql "postgresql://postgres:postgres@localhost:54322/postgres" -f supabase/schema.sql
```

### Étape 4: Configuration des buckets de stockage

Exécuter ces commandes SQL dans Supabase Studio ou via CLI:

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

CREATE POLICY "Commerçants peuvent uploader images de repas" ON storage.objects
    FOR INSERT WITH CHECK (bucket_id = 'meal-images');

CREATE POLICY "Images publiques lisibles par tous" ON storage.objects
    FOR SELECT USING (bucket_id IN ('meal-images', 'restaurant-images', 'user-avatars'));
```

### Étape 5: Déploiement des Edge Functions

```bash
# Déployer la fonction de vérification d'expiration
supabase functions deploy meal-expiry-check

# Configurer la planification automatique (Cron)
# Dans l'interface Supabase, aller dans Database > Extensions
# Activer pg_cron et configurer:
SELECT cron.schedule('meal-expiry-check', '*/10 * * * *', 'SELECT net.http_post(url:=''https://YOUR_PROJECT_ID.supabase.co/functions/v1/meal-expiry-check'', headers:=''{"Authorization": "Bearer YOUR_ANON_KEY", "Content-Type": "application/json"}''::jsonb);');
```

## 🔐 Variables d'environnement

### Pour l'application Flutter

Ajouter dans votre fichier `.env` ou configuration:

```env
# URLs Supabase
SUPABASE_URL=https://YOUR_PROJECT_ID.supabase.co
SUPABASE_ANON_KEY=your_anon_key_here
SUPABASE_SERVICE_ROLE_KEY=your_service_key_here

# Configuration locale (développement)
SUPABASE_URL_LOCAL=http://localhost:54321
SUPABASE_ANON_KEY_LOCAL=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...
```

### Pour les Edge Functions

```env
SUPABASE_URL=https://YOUR_PROJECT_ID.supabase.co
SUPABASE_SERVICE_ROLE_KEY=your_service_key_here
```

## 🧪 Test de l'installation

### 1. Tester la connexion

```bash
# Tester l'API REST
curl "http://localhost:54321/rest/v1/users" \
  -H "apikey: YOUR_ANON_KEY" \
  -H "Authorization: Bearer YOUR_ANON_KEY"
```

### 2. Créer un utilisateur de test

```sql
-- Depuis Supabase Studio ou CLI
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

### 3. Tester l'Edge Function

```bash
curl -X POST "http://localhost:54321/functions/v1/meal-expiry-check" \
  -H "Authorization: Bearer YOUR_ANON_KEY" \
  -H "Content-Type: application/json"
```

## 📊 Monitoring et Performance

### Métriques importantes à surveiller:

1. **Performance des requêtes**
```sql
-- Requêtes les plus lentes
SELECT query, mean_exec_time, calls 
FROM pg_stat_statements 
ORDER BY mean_exec_time DESC 
LIMIT 10;
```

2. **Usage du stockage**
```sql
-- Taille des tables principales
SELECT 
    schemaname,
    tablename,
    pg_size_pretty(pg_total_relation_size(schemaname||'.'||tablename)) as size
FROM pg_tables 
WHERE schemaname = 'public'
ORDER BY pg_total_relation_size(schemaname||'.'||tablename) DESC;
```

3. **Statistiques des repas**
```sql
-- Vue d'ensemble des repas actifs
SELECT 
    status,
    COUNT(*) as count,
    SUM(remaining_quantity) as total_quantity
FROM meals 
GROUP BY status;
```

## 🔧 Maintenance

### Sauvegardes automatiques

```bash
# Configurer les sauvegardes quotidiennes
supabase db dump --data-only --file=backup_$(date +%Y%m%d).sql

# Script de sauvegarde automatique
#!/bin/bash
BACKUP_DIR="/path/to/backups"
DATE=$(date +%Y%m%d_%H%M%S)
supabase db dump --file="${BACKUP_DIR}/foodsave_backup_${DATE}.sql"
```

### Nettoyage des données

```sql
-- Nettoyer les anciennes notifications (mensuel)
DELETE FROM notifications 
WHERE created_at < NOW() - INTERVAL '30 days' 
AND is_read = true;

-- Archiver les anciennes commandes (annuel)
-- Créer une table d'archive si nécessaire
```

## 🚨 Sécurité et Conformité

### Politique RLS (Row Level Security)

Toutes les tables ont des politiques RLS activées. Vérifier régulièrement:

```sql
-- Lister toutes les politiques RLS
SELECT schemaname, tablename, policyname, permissive, roles, cmd, qual 
FROM pg_policies 
WHERE schemaname = 'public';
```

### Audit et logs

```sql
-- Activer l'audit des connexions (si nécessaire)
ALTER SYSTEM SET log_connections = 'on';
ALTER SYSTEM SET log_disconnections = 'on';
ALTER SYSTEM SET log_statement = 'all';
```

## 📱 Intégration avec l'application Flutter

Le service `SupabaseService` dans l'application Flutter utilise cette configuration. Points d'attention:

1. **Authentification**: Utilise `supabase_flutter` pour la gestion automatique des tokens
2. **Stockage**: Upload d'images avec redimensionnement automatique
3. **Temps réel**: Subscriptions pour les mises à jour en temps réel
4. **Offline**: Cache local avec synchronisation automatique

## 🎯 Prochaines étapes

1. **Configuration SSL** pour la production
2. **CDN** pour les images (CloudFlare/AWS CloudFront)
3. **Monitoring avancé** avec Grafana
4. **Tests d'intégration** automatisés
5. **CI/CD** pour les déploiements

## 📞 Support et documentation

- **Documentation Supabase**: [docs.supabase.com](https://supabase.com/docs)
- **Standards NYTH**: [Référence interne]
- **Support FoodSave**: [Contact technique]

---

### 🔄 Changelog

- **v1.0.0**: Configuration initiale avec schéma complet
- **v1.0.1**: Ajout Edge Functions pour gestion automatisée
- **v1.0.2**: Optimisations des performances et index
- **v1.0.3**: Politiques RLS renforcées et audit

---

*Configuration générée selon les standards NYTH - Zero Compromise pour FoodSave*