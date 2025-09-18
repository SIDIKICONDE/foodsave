# Script PowerShell pour exécuter tous les tests unitaires du projet FoodSave
# Suit les directives strictes pour le développement Dart

Write-Host "🧪 Exécution des tests unitaires FoodSave App" -ForegroundColor Blue
Write-Host "==============================================" -ForegroundColor Blue

# Fonction pour afficher les messages colorés
function Write-Status {
    param([string]$Message)
    Write-Host "[INFO] $Message" -ForegroundColor Blue
}

function Write-Success {
    param([string]$Message)
    Write-Host "[SUCCESS] $Message" -ForegroundColor Green
}

function Write-Warning {
    param([string]$Message)
    Write-Host "[WARNING] $Message" -ForegroundColor Yellow
}

function Write-Error {
    param([string]$Message)
    Write-Host "[ERROR] $Message" -ForegroundColor Red
}

# Vérifier que Flutter est installé
try {
    $flutterVersion = flutter --version 2>$null
    if ($LASTEXITCODE -ne 0) {
        throw "Flutter non trouvé"
    }
} catch {
    Write-Error "Flutter n'est pas installé ou n'est pas dans le PATH"
    exit 1
}

# Vérifier que nous sommes dans le bon répertoire
if (-not (Test-Path "pubspec.yaml")) {
    Write-Error "Ce script doit être exécuté depuis la racine du projet"
    exit 1
}

Write-Status "Vérification de l'environnement Flutter..."
flutter doctor --version

# Nettoyer le projet
Write-Status "Nettoyage du projet..."
flutter clean

# Récupérer les dépendances
Write-Status "Récupération des dépendances..."
flutter pub get

# Analyser le code
Write-Status "Analyse du code..."
flutter analyze

if ($LASTEXITCODE -ne 0) {
    Write-Warning "Des problèmes d'analyse ont été détectés"
}

# Exécuter les tests unitaires
Write-Status "Exécution des tests unitaires..."
Write-Host ""

# Tests avec couverture
Write-Status "Exécution des tests avec couverture de code..."
flutter test --coverage

if ($LASTEXITCODE -eq 0) {
    Write-Success "Tous les tests sont passés avec succès !"
} else {
    Write-Error "Certains tests ont échoué"
    exit 1
}

# Vérifier si le fichier de couverture existe
if (Test-Path "coverage/lcov.info") {
    Write-Status "Fichier de couverture généré: coverage/lcov.info"
    Write-Status "Pour visualiser la couverture, vous pouvez utiliser un outil comme lcov ou un service en ligne"
} else {
    Write-Warning "Fichier de couverture non trouvé"
}

# Résumé des tests
Write-Host ""
Write-Host "📊 Résumé des tests unitaires" -ForegroundColor Blue
Write-Host "=============================" -ForegroundColor Blue

# Compter les fichiers de test
$testFiles = Get-ChildItem -Path "test" -Filter "*_test.dart" -Recurse
Write-Status "Fichiers de test trouvés: $($testFiles.Count)"

# Lister les fichiers de test
Write-Host ""
Write-Status "Fichiers de test:"
foreach ($file in $testFiles) {
    Write-Host "  - $($file.FullName.Replace((Get-Location).Path + '\', ''))"
}

Write-Host ""
Write-Success "Exécution des tests terminée !"
Write-Status "Pour exécuter des tests spécifiques:"
Write-Status "  flutter test test/unit/models/map_marker_test.dart"
Write-Status "  flutter test test/unit/domain/entities/basket_test.dart"
Write-Status "  flutter test test/unit/services/demo_map_service_test.dart"

Write-Host ""
Write-Status "Pour exécuter les tests en mode verbose:"
Write-Status "  flutter test --verbose"

Write-Host ""
Write-Status "Pour exécuter les tests avec un pattern spécifique:"
Write-Status "  flutter test --name 'devrait calculer correctement'"

Write-Host ""
Write-Status "Structure des tests créée:"
Write-Host "  ✅ Modèles et Entités (5 fichiers)"
Write-Host "  ✅ Services (1 fichier)"
Write-Host "  ✅ Cas d'usage (2 fichiers)"
Write-Host "  ✅ Repositories (1 fichier)"
Write-Host "  ✅ Utilitaires de test (1 fichier)"
Write-Host "  ✅ Documentation complète"
