# Refactorisation - Page d'Inscription Générale

Ce dossier contient la refactorisation complète de la page d'inscription générale selon les directives strictes de développement Dart.

## Structure

```
register/
├── README.md                                 # Cette documentation
├── constants/
│   └── register_constants.dart               # Toutes les constantes
├── services/
│   └── register_service.dart                 # Logique métier et validation
└── widgets/
    ├── widgets.dart                          # Export centralisé
    ├── error_message.dart                    # Messages d'erreur
    ├── login_link.dart                       # Lien vers connexion
    ├── register_button.dart                  # Bouton d'inscription
    ├── register_header.dart                  # En-tête avec logo
    ├── registration_form.dart                # Formulaire complet
    ├── terms_and_conditions.dart             # Conditions d'utilisation
    └── user_type_selector.dart               # Sélecteur de type utilisateur
```

## Fonctionnalités Préservées

- ✅ **Sélection du type d'utilisateur** (Consommateur/Commerçant)
- ✅ **Inscription complète** avec validation temps réel
- ✅ **Formulaire adaptatif** selon le type d'utilisateur
- ✅ **Gestion des états de chargement** avec indicateurs visuels
- ✅ **Messages d'erreur** contextuels et localisés
- ✅ **Navigation intelligente** vers la page de connexion
- ✅ **Interface responsive** adaptée aux différentes tailles d'écran

## Principes de Refactorisation

### 1. **Séparation des Responsabilités**
- **Constants** : Toutes les chaînes, dimensions et valeurs magiques
- **Services** : Logique métier, appels API et validation spécialisée
- **Widgets** : Composants d'interface modulaires et réutilisables

### 2. **Utilisation de Types Statiques Strictes**
- Élimination des `var` implicites
- Utilisation appropriée de `const` et `final`
- Types explicites partout

### 3. **Gestion d'Erreurs Robuste**
- Validation centralisée dans `RegisterService`
- Messages d'erreur localisés en français
- Gestion des exceptions avec try-catch

### 4. **Performance et Maintenabilité**
- Widgets stateless autant que possible
- Code modulaire et testable
- Imports optimisés et organisés

### 5. **Respect des Conventions Dart**
- Nommage camelCase et PascalCase
- Documentation complète avec DartDoc
- Code auto-documenté et lisible

## Nouveaux Widgets

### `RegisterHeader`
```dart
const RegisterHeader()
```
- Logo FoodSave stylisé avec couleur primaire
- Titre "Rejoignez FoodSave"
- Sous-titre explicatif du but de l'application

### `UserTypeSelector`
```dart
UserTypeSelector(
  selectedUserType: _selectedUserType,
  onUserTypeChanged: _onUserTypeChanged,
)
```
- Sélecteur avec RadioListTile pour Consommateur/Commerçant
- Descriptions explicatives pour chaque type
- Gestion automatique de l'état de sélection
- Utilise `RadioGroup` pour la gestion des boutons radio

### `RegistrationForm`
```dart
RegistrationForm(
  nameController: _nameController,
  emailController: _emailController,
  passwordController: _passwordController,
  confirmPasswordController: _confirmPasswordController,
  obscurePassword: _obscurePassword,
  obscureConfirmPassword: _obscureConfirmPassword,
  onTogglePasswordVisibility: _togglePasswordVisibility,
  onToggleConfirmPasswordVisibility: _toggleConfirmPasswordVisibility,
)
```
- **4 champs principaux** pour l'inscription générale :
  1. Nom complet (validation 2+ caractères)
  2. Email (validation format email)
  3. Mot de passe (validation 6+ caractères)
  4. Confirmation (validation correspondance)

### `RegisterButton`
```dart
RegisterButton(
  isLoading: _isLoading,
  onPressed: _handleRegister,
)
```
- Bouton d'inscription avec texte "Créer mon compte"
- Indicateur de chargement intégré
- Désactivation automatique pendant le traitement

### `LoginLink`
```dart
LoginLink(
  onPressed: () => Navigator.of(context).pop(),
)
```
- Lien "Déjà un compte ? Se connecter"
- Navigation retour vers la page de connexion
- Style cohérent avec le thème

## Service de Logique Métier

### `RegisterService`

#### Validation Complète
```dart
// Validation individuelle
String? nameError = RegisterService.validateName(name);
String? emailError = RegisterService.validateEmail(email);
String? passwordError = RegisterService.validatePassword(password);
String? confirmError = RegisterService.validateConfirmPassword(confirm, password);

// Validation complète du formulaire
Map<String, String?> errors = RegisterService.validateRegistrationForm(
  name: name,
  email: email,
  password: password,
  confirmPassword: confirm,
);
```

#### Inscription Utilisateur
```dart
final result = await RegisterService.registerUser(
  name: name,
  email: email,
  password: password,
  userType: selectedUserType, // UserType.consumer ou UserType.merchant
);

result.fold(
  (error) => handleError(error),
  (response) => handleSuccess(response),
);
```

## Gestion des Types d'Utilisateur

### Sélecteur Dynamique
```dart
UserTypeSelector(
  selectedUserType: _selectedUserType,
  onUserTypeChanged: (UserType? value) {
    if (value != null) {
      setState(() {
        _selectedUserType = value;
        // Ici, on pourrait adapter l'interface selon le type
      });
    }
  },
)
```

### Options Disponibles
- **Consommateur** : "Je recherche des paniers anti-gaspi"
- **Commerçant** : "Je propose mes invendus à prix réduit"

### Métadonnées Automatiques
Lors de l'inscription, les métadonnées suivantes sont automatiquement ajoutées :
```json
{
  "full_name": "Nom de l'utilisateur",
  "app_name": "FoodSave",
  "user_type": "consumer" | "merchant",
  "created_at": "2024-01-01T00:00:00.000Z"
}
```

## Gestion des États

La page gère plusieurs états complexes :

- **Sélection du type** : Interface adaptée selon le choix
- **Saisie utilisateur** : Validation temps réel des champs
- **Soumission** : Indicateur de chargement et désactivation
- **Succès** : Dialogue de confirmation avec navigation
- **Erreur** : Messages d'erreur contextuels avec retry

## Champs du Formulaire

### 1. Nom Complet
- **Type** : TextInputType.name
- **Validation** : Minimum 2 caractères
- **Capitalization** : Mots (titres)
- **Icône** : Icons.person_outline

### 2. Email
- **Type** : TextInputType.emailAddress
- **Validation** : Format email standard
- **Autocorrect** : Désactivé
- **Icône** : Icons.email_outlined

### 3. Mot de Passe
- **Type** : TextInputType.text (obscurci)
- **Validation** : Minimum 6 caractères
- **Visibilité** : Basculement icône œil
- **Icône** : Icons.lock_outline

### 4. Confirmation Mot de Passe
- **Type** : TextInputType.text (obscurci)
- **Validation** : Correspondance exacte
- **Visibilité** : Synchronisée avec mot de passe
- **Feedback** : Message d'erreur spécifique

## Localisation

Toutes les erreurs sont automatiquement traduites :
```dart
'Email not confirmed' → 'Email pas encore confirmé'
'Too many requests' → 'Trop de tentatives. Veuillez réessayer plus tard'
'Invalid email' → 'Adresse email invalide'
'Email address is invalid' → 'L\'adresse email n\'est pas valide'
```

## Métriques d'Amélioration

| Aspect | Avant | Après |
|--------|-------|-------|
| **Fichiers** | 1 fichier (462 lignes) | 11 fichiers organisés |
| **Responsabilités** | Tout mélangé | Séparées clairement |
| **Sélecteur de type** | Code inline complexe | Widget spécialisé |
| **Testabilité** | Complexe | Facile (chaque composant) |
| **Maintenabilité** | Difficile | Simple et modulaire |
| **Réutilisabilité** | Limitée | Élevée |

## Conformité aux Directives

Cette refactorisation respecte parfaitement vos directives strictes :

- **Utilisation obligatoire des types statiques** ✅
- **Utilisation de `const` et `final`** ✅
- **Préférence pour les fonctions pures** ✅
- **Gestion stricte des erreurs** ✅
- **Respect des conventions de style** ✅
- **Optimisation des performances** ✅
- **Séparation des responsabilités** ✅
- **Tests unitaires facilités** ✅
- **Documentation claire** ✅

## Tests Facilités

La refactorisation facilite grandement les tests unitaires :

- **Services** : Logique testable indépendamment de l'UI
- **Widgets** : Composants isolés et mockables
- **Validations** : Règles séparées et vérifiables
- **Sélecteur de type** : Gestion d'état testable
- **États** : Gestion d'état prévisible et testable

## Utilisation dans le Code Principal

Le fichier principal utilise maintenant tous ces composants :

```dart
Column(
  children: <Widget>[
    const RegisterHeader(),
    UserTypeSelector(
      selectedUserType: _selectedUserType,
      onUserTypeChanged: _onUserTypeChanged,
    ),
    if (_errorMessage != null) ErrorMessage(errorMessage: _errorMessage!),
    RegistrationForm(...),
    RegisterButton(
      isLoading: _isLoading,
      onPressed: _handleRegister,
    ),
    LoginLink(
      onPressed: () => Navigator.of(context).pop(),
    ),
    const TermsAndConditions(),
  ],
)
```

La refactorisation maintient **100% de la fonctionnalité** tout en offrant une **architecture modulaire**, **facilement testable** et **évolutive** ! 🚀

Le code est maintenant organisé selon les meilleures pratiques Dart et facilite grandement la maintenance et l'évolution future. 🎯

**Généralité** : Contrairement aux pages spécialisées, celle-ci permet la sélection du type d'utilisateur et constitue le point d'entrée principal pour l'inscription. 🏠
