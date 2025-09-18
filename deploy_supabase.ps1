# Script de déploiement Supabase pour FoodSave
# Utilisation: .\deploy_supabase.ps1

Write-Host "🚀 Déploiement Supabase pour FoodSave" -ForegroundColor Green
Write-Host "=====================================" -ForegroundColor Green
Write-Host ""

# Vérifier si Scoop est installé
$scoopInstalled = Get-Command scoop -ErrorAction SilentlyContinue
if (-not $scoopInstalled) {
    Write-Host "❌ Scoop n'est pas installé ou pas dans le PATH" -ForegroundColor Red
    Write-Host "💡 Installation de Scoop..." -ForegroundColor Yellow
    try {
        Invoke-RestMethod -Uri https://get.scoop.sh | Invoke-Expression
        Write-Host "✅ Scoop installé avec succès!" -ForegroundColor Green
        # Recharger le PATH
        $env:PATH = [System.Environment]::GetEnvironmentVariable("PATH","Machine") + ";" + [System.Environment]::GetEnvironmentVariable("PATH","User")
    }
    catch {
        Write-Host "❌ Échec de l'installation de Scoop: $_" -ForegroundColor Red
        Write-Host "📝 Veuillez installer Scoop manuellement: https://scoop.sh" -ForegroundColor Yellow
        exit 1
    }
}

# Installer Supabase CLI si nécessaire
$supabaseInstalled = Get-Command supabase -ErrorAction SilentlyContinue
if (-not $supabaseInstalled) {
    Write-Host "💡 Installation de Supabase CLI..." -ForegroundColor Yellow
    try {
        scoop bucket add supabase https://github.com/supabase/scoop-bucket.git
        scoop install supabase
        Write-Host "✅ Supabase CLI installé avec succès!" -ForegroundColor Green
    }
    catch {
        Write-Host "❌ Échec de l'installation de Supabase CLI: $_" -ForegroundColor Red
        Write-Host "📝 Essayez d'installer manuellement: https://supabase.com/docs/guides/cli" -ForegroundColor Yellow
        exit 1
    }
}

Write-Host ""
Write-Host "📋 Vérification des prérequis..." -ForegroundColor Cyan

# Vérifier la structure des dossiers
if (-not (Test-Path "supabase")) {
    Write-Host "❌ Le dossier 'supabase' n'existe pas" -ForegroundColor Red
    exit 1
}

if (-not (Test-Path "supabase/config.toml")) {
    Write-Host "❌ Le fichier 'supabase/config.toml' n'existe pas" -ForegroundColor Red
    exit 1
}

if (-not (Test-Path "supabase/migrations")) {
    Write-Host "❌ Le dossier 'supabase/migrations' n'existe pas" -ForegroundColor Red
    exit 1
}

Write-Host "✅ Structure des dossiers OK" -ForegroundColor Green

# Vérifier les clés Supabase dans le fichier de configuration Flutter
$configFile = "lib/config/supabase_config.dart"
if (Test-Path $configFile) {
    $configContent = Get-Content $configFile -Raw
    if ($configContent -match "your-project\.supabase\.co" -or $configContent -match "your-anon-key-here") {
        Write-Host "⚠️  ATTENTION: Vous devez configurer vos vraies clés Supabase!" -ForegroundColor Yellow
        Write-Host "📝 Éditez le fichier: $configFile" -ForegroundColor Yellow
        Write-Host ""
        $continue = Read-Host "Voulez-vous continuer quand même ? (y/N)"
        if ($continue -ne "y" -and $continue -ne "Y") {
            Write-Host "❌ Arrêt du déploiement" -ForegroundColor Red
            exit 1
        }
    }
    else {
        Write-Host "✅ Configuration Supabase mise à jour" -ForegroundColor Green
    }
}
else {
    Write-Host "⚠️  Fichier de configuration non trouvé: $configFile" -ForegroundColor Yellow
}

Write-Host ""
Write-Host "🔧 Options de déploiement:" -ForegroundColor Cyan
Write-Host "1. Déployer vers un projet Supabase existant (recommandé)"
Write-Host "2. Démarrer un environnement local Supabase"
Write-Host "3. Afficher le SQL pour copie manuelle"
Write-Host ""

$choice = Read-Host "Choisissez une option (1-3)"

switch ($choice) {
    "1" {
        Write-Host ""
        Write-Host "🌐 Déploiement vers Supabase Cloud" -ForegroundColor Green
        Write-Host ""
        
        # Vérifier si le projet est déjà lié
        if (Test-Path ".env") {
            Write-Host "✅ Projet déjà configuré" -ForegroundColor Green
        }
        else {
            Write-Host "🔑 Connexion à votre projet Supabase..." -ForegroundColor Yellow
            Write-Host "💡 Vous allez avoir besoin de:"
            Write-Host "   - Votre Project Reference (ex: abcdefghijklmnop)"
            Write-Host "   - Votre Database Password"
            Write-Host ""
            
            try {
                supabase login
                supabase link
                Write-Host "✅ Projet lié avec succès!" -ForegroundColor Green
            }
            catch {
                Write-Host "❌ Échec de la liaison du projet: $_" -ForegroundColor Red
                exit 1
            }
        }
        
        Write-Host ""
        Write-Host "📤 Application des migrations..." -ForegroundColor Yellow
        try {
            supabase db push
            Write-Host "✅ Migrations appliquées avec succès!" -ForegroundColor Green
        }
        catch {
            Write-Host "❌ Échec de l'application des migrations: $_" -ForegroundColor Red
            Write-Host "💡 Vérifiez vos permissions et la validité de votre base de données" -ForegroundColor Yellow
            exit 1
        }
    }
    
    "2" {
        Write-Host ""
        Write-Host "💻 Démarrage de l'environnement local" -ForegroundColor Green
        Write-Host ""
        
        Write-Host "🚀 Initialisation..." -ForegroundColor Yellow
        try {
            supabase start
            Write-Host "✅ Environnement local démarré!" -ForegroundColor Green
            Write-Host ""
            Write-Host "📋 Informations de connexion locale:" -ForegroundColor Cyan
            supabase status
        }
        catch {
            Write-Host "❌ Échec du démarrage local: $_" -ForegroundColor Red
            Write-Host "💡 Vérifiez que Docker est installé et en cours d'exécution" -ForegroundColor Yellow
            exit 1
        }
    }
    
    "3" {
        Write-Host ""
        Write-Host "📋 Contenu SQL à copier dans Supabase:" -ForegroundColor Green
        Write-Host "========================================" -ForegroundColor Green
        Write-Host ""
        
        $migrationFile = Get-ChildItem "supabase/migrations/*.sql" | Sort-Object Name | Select-Object -First 1
        if ($migrationFile) {
            $sqlContent = Get-Content $migrationFile.FullName -Raw
            Write-Host $sqlContent
            Write-Host ""
            Write-Host "========================================" -ForegroundColor Green
            Write-Host "📝 Instructions:" -ForegroundColor Yellow
            Write-Host "1. Connectez-vous à https://supabase.com/dashboard"
            Write-Host "2. Ouvrez votre projet"
            Write-Host "3. Allez dans 'SQL Editor'"
            Write-Host "4. Copiez-collez le SQL ci-dessus"
            Write-Host "5. Cliquez sur 'RUN'"
        }
        else {
            Write-Host "❌ Aucun fichier de migration trouvé" -ForegroundColor Red
            exit 1
        }
    }
    
    default {
        Write-Host "❌ Option invalide" -ForegroundColor Red
        exit 1
    }
}

Write-Host ""
Write-Host "🎉 Déploiement terminé!" -ForegroundColor Green
Write-Host ""
Write-Host "📱 Prochaines étapes:" -ForegroundColor Cyan
Write-Host "1. Vérifiez que les tables sont créées dans Supabase"
Write-Host "2. Testez l'authentification avec votre app Flutter"
Write-Host "3. Vérifiez les politiques de sécurité (RLS)"
Write-Host "4. Ajoutez des données de test si nécessaire"
Write-Host ""
Write-Host "📚 Resources utiles:" -ForegroundColor Cyan
Write-Host "- Dashboard Supabase: https://supabase.com/dashboard"
Write-Host "- Documentation: https://supabase.com/docs"
Write-Host "- Guide Flutter: https://supabase.com/docs/guides/getting-started/tutorials/with-flutter"
Write-Host ""

# Ouvrir le dashboard Supabase
$openDashboard = Read-Host "Voulez-vous ouvrir le dashboard Supabase ? (y/N)"
if ($openDashboard -eq "y" -or $openDashboard -eq "Y") {
    Start-Process "https://supabase.com/dashboard"
}