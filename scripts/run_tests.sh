#!/bin/bash

# Script pour exécuter tous les tests unitaires du projet FoodSave
# Suit les directives strictes pour le développement Dart

echo "🧪 Exécution des tests unitaires FoodSave App"
echo "=============================================="

# Couleurs pour l'affichage
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Fonction pour afficher les messages colorés
print_status() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Vérifier que Flutter est installé
if ! command -v flutter &> /dev/null; then
    print_error "Flutter n'est pas installé ou n'est pas dans le PATH"
    exit 1
fi

# Vérifier que nous sommes dans le bon répertoire
if [ ! -f "pubspec.yaml" ]; then
    print_error "Ce script doit être exécuté depuis la racine du projet"
    exit 1
fi

print_status "Vérification de l'environnement Flutter..."
flutter doctor --version

# Nettoyer le projet
print_status "Nettoyage du projet..."
flutter clean

# Récupérer les dépendances
print_status "Récupération des dépendances..."
flutter pub get

# Analyser le code
print_status "Analyse du code..."
flutter analyze

if [ $? -ne 0 ]; then
    print_warning "Des problèmes d'analyse ont été détectés"
fi

# Exécuter les tests unitaires
print_status "Exécution des tests unitaires..."
echo ""

# Tests avec couverture
print_status "Exécution des tests avec couverture de code..."
flutter test --coverage

if [ $? -eq 0 ]; then
    print_success "Tous les tests sont passés avec succès !"
else
    print_error "Certains tests ont échoué"
    exit 1
fi

# Générer le rapport de couverture
if [ -f "coverage/lcov.info" ]; then
    print_status "Génération du rapport de couverture..."
    
    # Installer lcov si nécessaire
    if command -v genhtml &> /dev/null; then
        genhtml coverage/lcov.info -o coverage/html
        print_success "Rapport de couverture généré dans coverage/html/"
        print_status "Ouvrez coverage/html/index.html dans votre navigateur pour voir le rapport"
    else
        print_warning "genhtml n'est pas installé. Installez lcov pour générer le rapport HTML"
        print_status "Sur Ubuntu/Debian: sudo apt-get install lcov"
        print_status "Sur macOS: brew install lcov"
    fi
else
    print_warning "Fichier de couverture non trouvé"
fi

# Résumé des tests
echo ""
echo "📊 Résumé des tests unitaires"
echo "============================="

# Compter les fichiers de test
TEST_FILES=$(find test/ -name "*_test.dart" | wc -l)
print_status "Fichiers de test trouvés: $TEST_FILES"

# Lister les fichiers de test
echo ""
print_status "Fichiers de test:"
find test/ -name "*_test.dart" | while read -r file; do
    echo "  - $file"
done

echo ""
print_success "Exécution des tests terminée !"
print_status "Pour exécuter des tests spécifiques:"
print_status "  flutter test test/unit/models/map_marker_test.dart"
print_status "  flutter test test/unit/domain/entities/basket_test.dart"
print_status "  flutter test test/unit/services/demo_map_service_test.dart"

echo ""
print_status "Pour exécuter les tests en mode verbose:"
print_status "  flutter test --verbose"

echo ""
print_status "Pour exécuter les tests avec un pattern spécifique:"
print_status "  flutter test --name 'devrait calculer correctement'"
