# 📁 DIRECTIVES NYTH - STANDARDS OBLIGATOIRES

## 🎯 PHILOSOPHIE ZERO COMPROMISE
- **Excellence** : Seul standard acceptable
- **Qualité** : Code conforme = Respect total des directives
- **Performance** : Optimisation maximale requise
- **Sécurité** : Standards de sécurité stricts

## 🏗️ STRUCTURE DE PROJET FLUTTER

### Architecture Obligatoire
```
lib/
├── core/           # Logique métier centrale
├── data/           # Couche de données
├── domain/         # Entités et cas d'usage
├── presentation/   # Interface utilisateur
│   ├── pages/      # Écrans
│   ├── widgets/    # Composants réutilisables
│   └── providers/  # Gestion d'état
└── utils/          # Utilitaires
```

### Standards de Code
- **Nommage** : camelCase pour variables, PascalCase pour classes
- **Documentation** : Commentaires obligatoires pour toutes les fonctions publiques
- **Tests** : Couverture de test minimum 80%
- **Performance** : Aucun widget rebuild inutile
- **Sécurité** : Validation stricte des entrées utilisateur

## 🚫 INTERDICTIONS STRICTES
- ❌ Aucun fichier exemple ou démo
- ❌ Code non documenté
- ❌ Variables non typées
- ❌ Gestion d'erreur manquante
- ❌ Code dupliqué

## ✅ EXIGENCES OBLIGATOIRES
- ✅ Tests unitaires pour chaque fonction
- ✅ Documentation complète
- ✅ Gestion d'erreur robuste
- ✅ Architecture modulaire
- ✅ Performance optimisée

## 🔧 OUTILS REQUIS
- Flutter SDK (dernière version stable)
- Dart SDK
- VS Code ou Android Studio
- Packages de test (test, mockito)
- Packages de state management (Provider/Riverpod)
