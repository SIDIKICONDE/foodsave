# 🚀 GUIDE DE DÉMARRAGE - FOODSAVE

## ⚡ PROJET NYTH - ZERO COMPROMISE

### Prérequis
- Flutter SDK 3.24.5+
- Dart SDK 3.5.4+
- Android Studio ou VS Code
- Émulateur Android/iOS ou appareil physique

### Installation
```bash
# Cloner le projet (si applicable)
cd /Users/m1/Desktop/FoodSave

# Installer les dépendances
flutter pub get

# Générer le code (si nécessaire)
flutter packages pub run build_runner build

# Lancer l'application
flutter run
```

### Structure du Projet
```
lib/
├── core/                 # Logique centrale
│   ├── constants/        # Constantes de l'app
│   ├── errors/          # Gestion des erreurs
│   └── network/         # Configuration réseau
├── data/                # Couche de données
│   ├── models/          # Modèles de données
│   ├── repositories/    # Implémentation repositories
│   └── services/        # Services API
├── domain/              # Logique métier
│   ├── entities/        # Entités du domaine
│   └── usecases/        # Cas d'usage
├── presentation/        # Interface utilisateur
│   ├── pages/           # Écrans de l'app
│   ├── widgets/         # Composants réutilisables
│   └── providers/       # Gestion d'état
└── utils/               # Utilitaires
```

### Standards de Code
- **Documentation** : Commentaires obligatoires
- **Tests** : Couverture minimum 80%
- **Performance** : Optimisation maximale
- **Sécurité** : Validation stricte
- **Architecture** : Clean Architecture

### Commandes Utiles
```bash
# Analyser le code
flutter analyze

# Exécuter les tests
flutter test

# Construire l'APK
flutter build apk --release

# Construire pour iOS
flutter build ios --release
```

## 🎯 OBJECTIFS
- Gestion intelligente des aliments
- Réduction du gaspillage
- Interface utilisateur moderne
- Performance optimale
- Sécurité renforcée
