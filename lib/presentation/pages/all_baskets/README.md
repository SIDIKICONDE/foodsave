# Page "Voir tous les paniers" 🛒

## Vue d'ensemble

La page "Voir tous les paniers" est une interface avancée permettant aux utilisateurs d'explorer tous les paniers anti-gaspi disponibles avec des fonctionnalités de recherche, filtrage et tri sophistiquées.

## Architecture

```
all_baskets/
├── all_baskets_page.dart          # Page principale
└── widgets/
    ├── all_baskets_header.dart     # En-tête avec statistiques et tri
    ├── baskets_search_bar.dart     # Barre de recherche avancée
    ├── baskets_filter_dialog.dart  # Dialogue de filtres avancés
    ├── all_baskets_list.dart       # Liste principale avec pagination
    ├── basket_advanced_item.dart   # Élément de panier amélioré
    └── all_baskets_widgets.dart    # Export centralisé
```

## Fonctionnalités

### 🎨 Interface utilisateur

- **Design moderne** : Interface épurée avec animations fluides
- **Responsive** : Adaptation automatique aux différentes tailles d'écran
- **Thème cohérent** : Respecte la charte graphique de l'application
- **Accessibilité** : Textes lisibles et contraste approprié

### 🔍 Recherche et filtres

#### Recherche textuelle
- Recherche en temps réel
- Suggestions populaires
- Historique des recherches
- Filtres rapides (dernière chance, bio, végan, etc.)

#### Filtres avancés
- **Prix** : Fourchette personnalisable (0€ - 50€)
- **Distance** : Rayon de recherche (1km - 20km)
- **Types de commerce** : Boulangerie, Restaurant, Fruits & Légumes, etc.
- **Régimes alimentaires** : Bio, Végétarien, Végan, Sans gluten, etc.
- **Réduction** : Seuils de réduction (30%, 50%, 70%+)
- **Disponibilité** : Dernière chance, Disponible maintenant

#### Options de tri
- **Proximité** : Tri par distance (par défaut)
- **Prix croissant** : Du moins cher au plus cher
- **Réduction** : Par pourcentage de réduction décroissant
- **Plus récents** : Par date de création
- **Note** : Par évaluation des commerces
- **Expiration** : Par proximité de l'expiration

### 📱 Interactions

#### Gestion des favoris
- Ajouter/retirer des favoris avec animation
- Synchronisation avec le profil utilisateur
- Indicateur visuel d'état

#### Actions sur les paniers
- **Réservation directe** : Ajout au panier en un clic
- **Détails** : Navigation vers la page de détails
- **Partage** : Partage sur les réseaux sociaux

### 🔄 Pagination et performance

#### Pagination intelligente
- Chargement progressif (20 éléments par page)
- Indicateur de chargement élégant
- Gestion des états vides et d'erreur

#### Performance
- Animations optimisées
- Cache des résultats
- Chargement asynchrone des images

### 📊 Statistiques

#### En-tête informatif
- Nombre total de paniers trouvés
- Statistiques rapides (dernière chance, économie moyenne)
- Indicateurs visuels avec émojis

## Composants

### AllBasketsPage
**Fichier** : `all_baskets_page.dart`

Page principale orchestrant tous les composants :
- Gestion des animations d'entrée
- Coordination entre recherche, filtres et liste
- Navigation et routing
- Gestion des états de l'application

### AllBasketsHeader
**Fichier** : `widgets/all_baskets_header.dart`

En-tête avec informations et contrôles :
- Statistiques en temps réel
- Sélecteur de tri
- Bouton filtres avec indicateur d'état actif
- Commutateur de vue (liste/grille)

### BasketsSearchBar
**Fichier** : `widgets/baskets_search_bar.dart`

Barre de recherche avancée :
- Animation de focus
- Suggestions contextuelles
- Filtres rapides en chips
- Effacement intelligent

### BasketsFilterDialog
**Fichier** : `widgets/baskets_filter_dialog.dart`

Dialogue modal de filtres avancés :
- Interface glissante depuis le bas
- Sections organisées par catégorie
- Réinitialisation en un clic
- Validation/annulation

### AllBasketsList
**Fichier** : `widgets/all_baskets_list.dart`

Liste principale avec gestion d'état :
- Pull-to-refresh
- Pagination automatique
- États de chargement/vide/erreur
- Animations d'apparition

### BasketAdvancedItem
**Fichier** : `widgets/basket_advanced_item.dart`

Élément de panier enrichi :
- Image avec placeholder gradients
- Badges dynamiques (dernière chance, réduction)
- Informations détaillées (horaires, quantité, distance)
- Actions contextuelles

## Intégration

### Navigation
La page est intégrée au système de navigation de l'application :

```dart
// Depuis available_baskets_section.dart
AppRoutes.navigateToAllBaskets(context);
```

### État global
Utilise le `BasketBloc` existant pour :
- Chargement des paniers
- Gestion des favoris
- Recherche et filtrage
- Pagination

### Données de démonstration
Le service `DemoDataService` fournit :
- 5 paniers d'exemple avec données réalistes
- 4 commerces partenaires
- Simulation de tri et filtrage

## Utilisation

### Navigation depuis l'accueil
1. Page d'accueil → Onglet "Paniers"
2. Section "Paniers Disponibles"
3. Bouton "Voir tous les paniers disponibles"

### Recherche
1. Taper dans la barre de recherche
2. Sélectionner des filtres rapides
3. Utiliser les suggestions populaires

### Filtrage avancé
1. Cliquer sur le bouton "Filtres"
2. Ajuster les critères dans le dialogue
3. Appliquer les filtres

### Tri
1. Utiliser le menu déroulant dans l'en-tête
2. Sélectionner l'option souhaitée
3. La liste se met à jour automatiquement

## Personnalisation

### Ajout de nouveaux filtres
1. Modifier `BasketsFilterDialog`
2. Étendre `DemoDataService.filterBaskets()`
3. Mettre à jour les constantes dans `app_constants.dart`

### Nouveaux critères de tri
1. Ajouter l'option dans `AppConstants.sortOptions`
2. Implémenter la logique dans `DemoDataService.sortBaskets()`
3. Mettre à jour le dropdown dans `AllBasketsHeader`

### Personnalisation visuelle
Toutes les couleurs et dimensions utilisent les constantes centralisées :
- `AppColors` pour les couleurs
- `AppDimensions` pour les espacements et rayons
- `AppTextStyles` pour la typographie

## Performance et bonnes pratiques

### Optimisations implémentées
- ✅ Animations légères avec `AnimationController`
- ✅ Pagination pour limiter le nombre d'éléments
- ✅ Debouncing sur la recherche (300ms)
- ✅ Cache des résultats de filtrage
- ✅ Widgets const là où possible

### Recommandations
- Implémenter le cache réseau pour les images
- Ajouter l'analyse des performances avec Flutter Inspector
- Optimiser les rebuilds avec `BlocBuilder` sélectifs
- Considérer `flutter_staggered_grid_view` pour la vue grille

## Tests

### Tests suggérés
```dart
// Test des filtres
testWidgets('should filter baskets by price range', (tester) async {
  // Test implementation
});

// Test de la recherche
testWidgets('should show suggestions when search is focused', (tester) async {
  // Test implementation
});

// Test de la pagination
testWidgets('should load more baskets on scroll', (tester) async {
  // Test implementation
});
```

## Évolutions futures

### Fonctionnalités prévues
- [ ] Vue carte avec géolocalisation
- [ ] Notifications push pour nouveaux paniers
- [ ] Partage social des paniers
- [ ] Mode sombre
- [ ] Sauvegarde des filtres favoris
- [ ] Comparaison de paniers
- [ ] Réservation groupée

### Améliorations techniques
- [ ] Cache intelligent des images
- [ ] Optimisation des animations
- [ ] Support hors ligne
- [ ] Tests automatisés complets
- [ ] Métriques d'utilisation

---

*Cette documentation est maintenue à jour avec chaque modification de la fonctionnalité.*