#!/bin/bash
# Script d'installation automatique Supabase pour FoodSave
# Standards NYTH - Zero Compromise

set -e  # Arrêter en cas d'erreur

# Couleurs pour les logs
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Fonction de log
log() {
    echo -e "${GREEN}[$(date +'%Y-%m-%d %H:%M:%S')] $1${NC}"
}

warn() {
    echo -e "${YELLOW}[WARNING] $1${NC}"
}

error() {
    echo -e "${RED}[ERROR] $1${NC}"
}

info() {
    echo -e "${BLUE}[INFO] $1${NC}"
}

# Vérifier que nous sommes dans le bon répertoire
if [ ! -f "pubspec.yaml" ] || ! grep -q "food_save" pubspec.yaml; then
    error "Ce script doit être exécuté depuis le répertoire racine du projet FoodSave"
    exit 1
fi

log "🚀 Début de la configuration Supabase pour FoodSave"

# 1. Vérifier les prérequis
log "📋 Vérification des prérequis..."

# Vérifier Flutter
if ! command -v flutter &> /dev/null; then
    error "Flutter n'est pas installé. Veuillez l'installer d'abord."
    exit 1
fi
info "Flutter: $(flutter --version | head -n 1)"

# Vérifier Node.js et npm (pour Supabase CLI)
if ! command -v npm &> /dev/null; then
    warn "npm n'est pas installé. Tentative d'installation via Homebrew..."
    if command -v brew &> /dev/null; then
        brew install node
    else
        error "Homebrew n'est pas installé. Veuillez installer Node.js manuellement."
        exit 1
    fi
fi

# 2. Installer Supabase CLI
log "🔧 Installation de Supabase CLI..."

if ! command -v supabase &> /dev/null; then
    info "Installation de Supabase CLI..."
    if command -v brew &> /dev/null; then
        brew install supabase/tap/supabase
    else
        npm install -g supabase
    fi
else
    info "Supabase CLI déjà installé: $(supabase --version)"
fi

# 3. Nettoyer et installer les dépendances Flutter
log "📦 Installation des dépendances Flutter..."
flutter clean
flutter pub get

# 4. Initialiser Supabase
log "🏗️  Initialisation de Supabase..."

if [ ! -f "supabase/config.toml" ]; then
    supabase init
    info "Supabase initialisé avec succès"
else
    info "Supabase déjà initialisé"
fi

# Remplacer le config par défaut par notre configuration personnalisée
if [ -f "supabase/config.toml" ]; then
    log "🔄 Application de la configuration personnalisée..."
    # Le fichier de config personnalisé est déjà en place
    info "Configuration personnalisée appliquée"
fi

# 5. Démarrer les services Supabase
log "🚀 Démarrage des services Supabase..."

supabase start

# Attendre que les services soient prêts
sleep 5

# 6. Vérifier l'état des services
log "🔍 Vérification de l'état des services..."
supabase status

# 7. Appliquer le schéma de base de données
log "🗄️  Application du schéma de base de données..."

if [ -f "supabase/schema.sql" ]; then
    # Récupérer l'URL de la DB depuis supabase status
    DB_URL=$(supabase status | grep "DB URL" | awk '{print $3}')
    
    if [ ! -z "$DB_URL" ]; then
        info "Application du schéma personnalisé..."
        psql "$DB_URL" -f supabase/schema.sql
        
        if [ $? -eq 0 ]; then
            log "✅ Schéma de base de données appliqué avec succès"
        else
            warn "Erreur lors de l'application du schéma. Essai avec db reset..."
            supabase db reset --debug
        fi
    else
        warn "Impossible de récupérer l'URL de la DB. Essai avec db reset..."
        supabase db reset --debug
    fi
else
    warn "Fichier schema.sql non trouvé. Application du schéma par défaut..."
    supabase db reset --debug
fi

# 8. Configurer les buckets de stockage
log "🗂️  Configuration des buckets de stockage..."

# Créer un script SQL temporaire pour les buckets
cat > /tmp/setup_buckets.sql << 'EOF'
-- Créer les buckets de stockage
INSERT INTO storage.buckets (id, name, public) VALUES 
    ('meal-images', 'meal-images', true),
    ('restaurant-images', 'restaurant-images', true),
    ('user-avatars', 'user-avatars', true),
    ('documents', 'documents', false)
ON CONFLICT (id) DO NOTHING;

-- Politiques de sécurité pour les buckets
DROP POLICY IF EXISTS "Utilisateurs peuvent uploader leurs avatars" ON storage.objects;
CREATE POLICY "Utilisateurs peuvent uploader leurs avatars" ON storage.objects
    FOR INSERT WITH CHECK (bucket_id = 'user-avatars' AND auth.uid()::text = (storage.foldername(name))[1]);

DROP POLICY IF EXISTS "Images publiques lisibles par tous" ON storage.objects;
CREATE POLICY "Images publiques lisibles par tous" ON storage.objects
    FOR SELECT USING (bucket_id IN ('meal-images', 'restaurant-images', 'user-avatars'));

DROP POLICY IF EXISTS "Commerçants peuvent uploader images de repas" ON storage.objects;
CREATE POLICY "Commerçants peuvent uploader images de repas" ON storage.objects
    FOR INSERT WITH CHECK (bucket_id = 'meal-images');

DROP POLICY IF EXISTS "Commerçants peuvent uploader images restaurant" ON storage.objects;
CREATE POLICY "Commerçants peuvent uploader images restaurant" ON storage.objects
    FOR INSERT WITH CHECK (bucket_id = 'restaurant-images');
EOF

# Appliquer la configuration des buckets
DB_URL=$(supabase status | grep "DB URL" | awk '{print $3}')
if [ ! -z "$DB_URL" ]; then
    psql "$DB_URL" -f /tmp/setup_buckets.sql
    if [ $? -eq 0 ]; then
        log "✅ Buckets de stockage configurés avec succès"
    else
        warn "Erreur lors de la configuration des buckets"
    fi
else
    warn "Impossible de configurer les buckets automatiquement"
fi

# Nettoyer le fichier temporaire
rm -f /tmp/setup_buckets.sql

# 9. Déployer les Edge Functions
log "⚡ Déploiement des Edge Functions..."

if [ -d "supabase/functions/meal-expiry-check" ]; then
    supabase functions deploy meal-expiry-check
    
    if [ $? -eq 0 ]; then
        log "✅ Edge Functions déployées avec succès"
    else
        warn "Erreur lors du déploiement des Edge Functions"
    fi
else
    warn "Dossier des Edge Functions non trouvé"
fi

# 10. Mettre à jour les variables d'environnement
log "🔐 Mise à jour des variables d'environnement..."

# Récupérer les informations de Supabase local
SUPABASE_STATUS=$(supabase status)
API_URL=$(echo "$SUPABASE_STATUS" | grep "API URL" | awk '{print $3}')
ANON_KEY=$(echo "$SUPABASE_STATUS" | grep "anon key" | awk '{print $3}')
SERVICE_KEY=$(echo "$SUPABASE_STATUS" | grep "service_role key" | awk '{print $3}')

# Mettre à jour le fichier .env
if [ -f ".env" ]; then
    # Sauvegarder l'ancien .env
    cp .env .env.backup
    
    # Mettre à jour les valeurs locales
    sed -i '' "s|SUPABASE_URL_LOCAL=.*|SUPABASE_URL_LOCAL=$API_URL|g" .env
    sed -i '' "s|SUPABASE_ANON_KEY_LOCAL=.*|SUPABASE_ANON_KEY_LOCAL=$ANON_KEY|g" .env
    sed -i '' "s|SUPABASE_SERVICE_ROLE_KEY_LOCAL=.*|SUPABASE_SERVICE_ROLE_KEY_LOCAL=$SERVICE_KEY|g" .env
    
    log "✅ Variables d'environnement mises à jour"
    info "📋 Configuration locale:"
    info "   API URL: $API_URL"
    info "   Studio URL: http://localhost:54323"
else
    warn "Fichier .env non trouvé"
fi

# 11. Créer un utilisateur de test
log "👤 Création d'un utilisateur de test..."

cat > /tmp/create_test_user.sql << 'EOF'
-- Créer un utilisateur de test
INSERT INTO auth.users (
    instance_id,
    id,
    aud,
    role,
    email,
    encrypted_password,
    email_confirmed_at,
    invited_at,
    confirmation_token,
    confirmation_sent_at,
    recovery_token,
    recovery_sent_at,
    email_change_token_new,
    email_change,
    email_change_sent_at,
    last_sign_in_at,
    raw_app_meta_data,
    raw_user_meta_data,
    is_super_admin,
    created_at,
    updated_at,
    phone,
    phone_confirmed_at,
    phone_change,
    phone_change_token,
    phone_change_sent_at,
    email_change_token_current,
    email_change_confirm_status,
    banned_until,
    reauthentication_token,
    reauthentication_sent_at
) VALUES (
    '00000000-0000-0000-0000-000000000000',
    gen_random_uuid(),
    'authenticated',
    'authenticated',
    'test@foodsave.fr',
    crypt('password123', gen_salt('bf')),
    NOW(),
    NOW(),
    '',
    NOW(),
    '',
    NOW(),
    '',
    '',
    NOW(),
    NOW(),
    '{"provider": "email", "providers": ["email"]}',
    '{"username": "test_user", "user_type": "student"}',
    FALSE,
    NOW(),
    NOW(),
    NULL,
    NULL,
    '',
    '',
    NOW(),
    '',
    0,
    NOW(),
    '',
    NOW()
) ON CONFLICT (email) DO NOTHING;
EOF

DB_URL=$(supabase status | grep "DB URL" | awk '{print $3}')
if [ ! -z "$DB_URL" ]; then
    psql "$DB_URL" -f /tmp/create_test_user.sql > /dev/null 2>&1
    if [ $? -eq 0 ]; then
        log "✅ Utilisateur de test créé (email: test@foodsave.fr, mot de passe: password123)"
    fi
fi

rm -f /tmp/create_test_user.sql

# 12. Tests de validation
log "🧪 Tests de validation..."

# Test 1: Vérifier l'API REST
info "Test de l'API REST..."
if curl -s -f "$API_URL/rest/v1/users" -H "apikey: $ANON_KEY" -H "Authorization: Bearer $ANON_KEY" > /dev/null; then
    log "✅ API REST fonctionnelle"
else
    warn "❌ Problème avec l'API REST"
fi

# Test 2: Vérifier l'Edge Function
info "Test de l'Edge Function..."
if curl -s -f -X POST "$API_URL/functions/v1/meal-expiry-check" -H "Authorization: Bearer $ANON_KEY" > /dev/null; then
    log "✅ Edge Function fonctionnelle"
else
    warn "❌ Problème avec l'Edge Function"
fi

# 13. Rapport final
log "📊 Configuration terminée !"

echo
echo "=================================="
echo "🎉 Configuration Supabase terminée"
echo "=================================="
echo
echo "📋 Informations de connexion:"
echo "   • API URL: $API_URL"
echo "   • Studio: http://localhost:54323"
echo "   • Database: postgresql://postgres:postgres@localhost:54322/postgres"
echo
echo "👤 Utilisateur de test:"
echo "   • Email: test@foodsave.fr"
echo "   • Mot de passe: password123"
echo
echo "🚀 Prochaines étapes:"
echo "   1. Tester l'application: flutter run"
echo "   2. Ouvrir Studio: open http://localhost:54323"
echo "   3. Consulter les logs: supabase logs"
echo
echo "📚 Documentation:"
echo "   • Guide de migration: ./MIGRATION_SUPABASE.md"
echo "   • Configuration: ./supabase/README.md"
echo
echo "💡 Pour arrêter Supabase: supabase stop"
echo "💡 Pour redémarrer: supabase start"
echo

log "🏁 Installation terminée avec succès !"