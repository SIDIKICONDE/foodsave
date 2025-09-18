# Script de deploiement Supabase pour FoodSave
# Version simplifiee sans emojis

Write-Host "=== DEPLOIEMENT SUPABASE POUR FOODSAVE ===" -ForegroundColor Green
Write-Host ""

# Verifier Scoop
Write-Host "Verification de Scoop..." -ForegroundColor Cyan
if (-not (Get-Command scoop -ErrorAction SilentlyContinue)) {
    Write-Host "Installation de Scoop..." -ForegroundColor Yellow
    try {
        # Recharger le PATH depuis la session precedente
        $env:PATH = [System.Environment]::GetEnvironmentVariable("PATH","User")
        if (-not (Get-Command scoop -ErrorAction SilentlyContinue)) {
            Write-Host "Scoop n'est pas encore disponible, continuons..." -ForegroundColor Yellow
        }
    }
    catch {
        Write-Host "Erreur avec Scoop: $_" -ForegroundColor Red
    }
}

# Verifier la structure
Write-Host "Verification des fichiers..." -ForegroundColor Cyan

if (-not (Test-Path "supabase")) {
    Write-Host "ERREUR: Dossier 'supabase' manquant" -ForegroundColor Red
    exit 1
}

if (-not (Test-Path "supabase/migrations/20240101000000_initial_schema.sql")) {
    Write-Host "ERREUR: Fichier de migration manquant" -ForegroundColor Red
    exit 1
}

Write-Host "Structure des fichiers OK" -ForegroundColor Green
Write-Host ""

# Verification de la config Flutter
$configFile = "lib/config/supabase_config.dart"
if (Test-Path $configFile) {
    $configContent = Get-Content $configFile -Raw
    if ($configContent -match "your-project\.supabase\.co") {
        Write-Host "ATTENTION: Configurez vos vraies cles Supabase dans:" -ForegroundColor Yellow
        Write-Host $configFile -ForegroundColor Yellow
        Write-Host ""
    }
}

Write-Host "OPTIONS DE DEPLOIEMENT:" -ForegroundColor Cyan
Write-Host "1. Afficher le SQL pour copie manuelle (Recommande)"
Write-Host "2. Ouvrir le dashboard Supabase"
Write-Host "3. Afficher les instructions detaillees"
Write-Host ""

$choice = Read-Host "Choisissez une option (1-3)"

switch ($choice) {
    "1" {
        Write-Host ""
        Write-Host "=== CONTENU SQL A COPIER ===" -ForegroundColor Green
        Write-Host ""
        
        $migrationFile = "supabase/migrations/20240101000000_initial_schema.sql"
        if (Test-Path $migrationFile) {
            $sqlContent = Get-Content $migrationFile -Raw
            Write-Host $sqlContent -ForegroundColor White
            Write-Host ""
            Write-Host "=== INSTRUCTIONS ===" -ForegroundColor Yellow
            Write-Host "1. Connectez-vous a https://supabase.com/dashboard"
            Write-Host "2. Ouvrez votre projet Supabase"
            Write-Host "3. Allez dans 'SQL Editor'"
            Write-Host "4. Copiez-collez le SQL ci-dessus"
            Write-Host "5. Cliquez sur 'RUN'"
            Write-Host ""
            Write-Host "Le SQL va creer 5 tables + donnees de test" -ForegroundColor Green
        }
    }
    
    "2" {
        Write-Host "Ouverture du dashboard Supabase..." -ForegroundColor Yellow
        Start-Process "https://supabase.com/dashboard"
    }
    
    "3" {
        Write-Host ""
        Write-Host "=== INSTRUCTIONS DETAILLEES ===" -ForegroundColor Green
        Write-Host ""
        Write-Host "ETAPE 1: Configuration des cles Supabase"
        Write-Host "- Editez: lib/config/supabase_config.dart"
        Write-Host "- Remplacez 'your-project.supabase.co' par votre vraie URL"
        Write-Host "- Remplacez 'your-anon-key-here' par votre vraie cle"
        Write-Host ""
        Write-Host "ETAPE 2: Deploiement des tables"
        Write-Host "- Option A: Copiez le SQL (option 1) dans Supabase SQL Editor"
        Write-Host "- Option B: Utilisez Supabase CLI si installe"
        Write-Host ""
        Write-Host "ETAPE 3: Verification"
        Write-Host "- Verifiez que 5 tables sont creees: shops, baskets_map, user_favorites, proximity_notifications, search_history"
        Write-Host "- Testez la connexion depuis votre app Flutter"
        Write-Host ""
        Write-Host "FICHIERS IMPORTANTS:"
        Write-Host "- DEPLOIEMENT_SUPABASE.md : Guide complet"
        Write-Host "- SUPABASE_SETUP.md : Configuration complete"
        Write-Host "- lib/examples/supabase_usage_example.dart : Exemples d'utilisation"
    }
    
    default {
        Write-Host "Option invalide" -ForegroundColor Red
        exit 1
    }
}

Write-Host ""
Write-Host "=== PROCHAINES ETAPES ===" -ForegroundColor Cyan
Write-Host "1. Configurez vos cles Supabase dans lib/config/supabase_config.dart"
Write-Host "2. Deployez les tables avec le SQL fourni"
Write-Host "3. Testez la connexion depuis Flutter"
Write-Host "4. Consultez DEPLOIEMENT_SUPABASE.md pour plus de details"
Write-Host ""

$openDashboard = Read-Host "Voulez-vous ouvrir le dashboard Supabase maintenant ? (y/N)"
if ($openDashboard -eq "y" -or $openDashboard -eq "Y") {
    Start-Process "https://supabase.com/dashboard"
    Write-Host "Dashboard ouvert dans votre navigateur" -ForegroundColor Green
}