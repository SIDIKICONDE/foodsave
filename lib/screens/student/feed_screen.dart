import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../models/meal.dart';
import '../../models/user.dart';
import '../../services/auth_service.dart';
import '../common/meal_card.dart';
import '../common/loading_widget.dart';

/// Écran de feed pour les étudiants
/// Respecte les standards NYTH - Zero Compromise
class FeedScreen extends ConsumerStatefulWidget {
  /// Constructeur de l'écran feed
  const FeedScreen({super.key});

  @override
  ConsumerState<FeedScreen> createState() => _FeedScreenState();
}

class _FeedScreenState extends ConsumerState<FeedScreen>
    with TickerProviderStateMixin {
  final _searchController = TextEditingController();
  final _scrollController = ScrollController();
  late TabController _tabController;
  
  // États locaux
  bool _isLoading = false;
  String _searchQuery = '';
  MealCategory? _selectedCategory;
  List<String> _selectedFilters = [];
  
  // Mock data pour la démonstration
  List<Meal> _meals = [];
  List<String> _favoriteIds = [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _loadMockData();
    _loadFeed();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    _tabController.dispose();
    super.dispose();
  }

  /// Charge les données mock
  void _loadMockData() {
    _meals = [
      Meal(
        id: '1',
        merchantId: 'merchant1',
        title: 'Pizza Margherita',
        description: 'Pizza fraîche avec mozzarella, tomates et basilic. Préparée aujourd\'hui midi, parfaite pour un repas rapide et délicieux.',
        originalPrice: 12.00,
        discountedPrice: 7.50,
        category: MealCategory.mainCourse,
        imageUrls: ['https://via.placeholder.com/400x300'],
        quantity: 3,
        remainingQuantity: 2,
        availableFrom: DateTime.now().subtract(const Duration(hours: 2)),
        availableUntil: DateTime.now().add(const Duration(hours: 4)),
        averageRating: 4.5,
        ratingCount: 12,
        isVegetarian: true,
        allergens: ['Gluten', 'Lactose'],
      ),
      Meal(
        id: '2',
        merchantId: 'merchant2',
        title: 'Salade César au Poulet',
        description: 'Salade fraîche avec poulet grillé, croûtons, parmesan et sauce César maison.',
        originalPrice: 10.50,
        discountedPrice: 6.00,
        category: MealCategory.mainCourse,
        imageUrls: ['https://via.placeholder.com/400x300'],
        quantity: 2,
        remainingQuantity: 1,
        availableFrom: DateTime.now().subtract(const Duration(hours: 1)),
        availableUntil: DateTime.now().add(const Duration(hours: 2)),
        averageRating: 4.2,
        ratingCount: 8,
        allergens: ['Gluten'],
      ),
      Meal(
        id: '3',
        merchantId: 'merchant3',
        title: 'Croissants aux Amandes',
        description: 'Croissants frais garnis aux amandes, parfaits pour le petit-déjeuner ou la collation.',
        originalPrice: 3.50,
        discountedPrice: 2.00,
        category: MealCategory.bakery,
        imageUrls: [],
        quantity: 5,
        remainingQuantity: 3,
        availableFrom: DateTime.now().subtract(const Duration(minutes: 30)),
        availableUntil: DateTime.now().add(const Duration(hours: 6)),
        averageRating: 4.8,
        ratingCount: 25,
        allergens: ['Gluten', 'Fruits à coque'],
      ),
    ];
  }

  /// Charge le feed
  Future<void> _loadFeed() async {
    setState(() {
      _isLoading = true;
    });

    // Simulation d'appel API
    await Future.delayed(const Duration(seconds: 1));

    if (mounted) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  /// Filtre les repas selon les critères
  List<Meal> get _filteredMeals {
    return _meals.where((meal) {
      // Filtre par recherche
      if (_searchQuery.isNotEmpty) {
        if (!meal.title.toLowerCase().contains(_searchQuery.toLowerCase()) &&
            !meal.description.toLowerCase().contains(_searchQuery.toLowerCase())) {
          return false;
        }
      }
      
      // Filtre par catégorie
      if (_selectedCategory != null && meal.category != _selectedCategory) {
        return false;
      }
      
      // Filtre par statut selon l'onglet actuel
      switch (_tabController.index) {
        case 0: // Tous
          return true;
        case 1: // Disponibles
          return meal.isAvailable;
        case 2: // Favoris
          return _favoriteIds.contains(meal.id);
        default:
          return true;
      }
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final currentUser = ref.watch(currentUserProvider);
    
    return Scaffold(
      appBar: _buildAppBar(context, currentUser),
      body: Column(
        children: [
          // Barre de recherche et filtres
          _buildSearchAndFilters(context),
          
          // Onglets
          _buildTabBar(context),
          
          // Contenu principal
          Expanded(
            child: _buildContent(context),
          ),
        ],
      ),
      floatingActionButton: _buildFloatingActionButton(context),
    );
  }

  /// Construit l'AppBar
  PreferredSizeWidget _buildAppBar(BuildContext context, User? currentUser) {
    return AppBar(
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'FoodSave',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          if (currentUser != null)
            Text(
              'Bonjour ${currentUser.firstName ?? currentUser.username} 👋',
              style: const TextStyle(fontSize: 12),
            ),
        ],
      ),
      backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      actions: [
        IconButton(
          onPressed: () => context.push('/student/profile'),
          icon: CircleAvatar(
            radius: 16,
            backgroundColor: Theme.of(context).primaryColor,
            child: Text(
              (currentUser?.firstName?.isNotEmpty == true 
                  ? currentUser!.firstName![0] 
                  : currentUser?.username[0] ?? 'U').toUpperCase(),
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
          ),
        ),
        const SizedBox(width: 8),
      ],
    );
  }

  /// Construit la barre de recherche et filtres
  Widget _buildSearchAndFilters(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          // Barre de recherche
          TextField(
            controller: _searchController,
            decoration: InputDecoration(
              hintText: 'Rechercher des repas...',
              prefixIcon: const Icon(Icons.search),
              suffixIcon: _searchQuery.isNotEmpty
                  ? IconButton(
                      onPressed: () {
                        _searchController.clear();
                        setState(() {
                          _searchQuery = '';
                        });
                      },
                      icon: const Icon(Icons.clear),
                    )
                  : null,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              filled: true,
              fillColor: Colors.grey[100],
            ),
            onChanged: (value) {
              setState(() {
                _searchQuery = value;
              });
            },
          ),
          
          const SizedBox(height: 12),
          
          // Filtres rapides
          _buildQuickFilters(context),
        ],
      ),
    );
  }

  /// Construit les filtres rapides
  Widget _buildQuickFilters(BuildContext context) {
    final categories = MealCategory.values;
    
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          // Filtre "Tous"
          _buildFilterChip(
            label: 'Tous',
            isSelected: _selectedCategory == null,
            onSelected: () {
              setState(() {
                _selectedCategory = null;
              });
            },
          ),
          
          const SizedBox(width: 8),
          
          // Filtres par catégorie
          ...categories.map(
            (category) => Padding(
              padding: const EdgeInsets.only(right: 8),
              child: _buildFilterChip(
                label: _getCategoryText(category),
                isSelected: _selectedCategory == category,
                onSelected: () {
                  setState(() {
                    _selectedCategory = _selectedCategory == category ? null : category;
                  });
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Construit un chip de filtre
  Widget _buildFilterChip({
    required String label,
    required bool isSelected,
    required VoidCallback onSelected,
  }) {
    return FilterChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (_) => onSelected(),
      selectedColor: Theme.of(context).primaryColor.withOpacity(0.2),
      backgroundColor: Colors.grey[200],
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
    );
  }

  /// Construit la barre d'onglets
  Widget _buildTabBar(BuildContext context) {
    return TabBar(
      controller: _tabController,
      onTap: (_) => setState(() {}),
      tabs: const [
        Tab(
          icon: Icon(Icons.restaurant_menu),
          text: 'Tous',
        ),
        Tab(
          icon: Icon(Icons.check_circle_outline),
          text: 'Disponibles',
        ),
        Tab(
          icon: Icon(Icons.favorite_outline),
          text: 'Favoris',
        ),
      ],
    );
  }

  /// Construit le contenu principal
  Widget _buildContent(BuildContext context) {
    if (_isLoading) {
      return const LoadingWidget(
        message: 'Chargement des repas...',
      );
    }

    final filteredMeals = _filteredMeals;

    if (filteredMeals.isEmpty) {
      return _buildEmptyState(context);
    }

    return RefreshIndicator(
      onRefresh: _loadFeed,
      child: ListView.builder(
        controller: _scrollController,
        itemCount: filteredMeals.length,
        itemBuilder: (context, index) {
          final meal = filteredMeals[index];
          
          return MealCard(
            meal: meal,
            isFavorite: _favoriteIds.contains(meal.id),
            onTap: () => context.push('/student/meal/${meal.id}'),
            onReserve: () => _showReservationDialog(context, meal),
            onFavorite: () => _toggleFavorite(meal.id),
          );
        },
      ),
    );
  }

  /// Construit l'état vide
  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.search_off,
              size: 80,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 20),
            Text(
              'Aucun repas trouvé',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                color: Colors.grey[600],
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'Essayez de modifier vos filtres ou votre recherche',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: Colors.grey[500],
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 30),
            ElevatedButton.icon(
              onPressed: () {
                _searchController.clear();
                setState(() {
                  _searchQuery = '';
                  _selectedCategory = null;
                  _selectedFilters.clear();
                });
              },
              icon: const Icon(Icons.refresh),
              label: const Text('Réinitialiser les filtres'),
            ),
          ],
        ),
      ),
    );
  }

  /// Construit le bouton flottant
  Widget? _buildFloatingActionButton(BuildContext context) {
    return FloatingActionButton.extended(
      onPressed: () => _showFiltersBottomSheet(context),
      icon: const Icon(Icons.tune),
      label: const Text('Filtres'),
    );
  }

  /// Affiche la boîte de dialogue de réservation
  void _showReservationDialog(BuildContext context, Meal meal) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Réserver ce repas'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(meal.title),
            const SizedBox(height: 8),
            Text(
              '${meal.discountedPrice.toStringAsFixed(2)} €',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.green,
              ),
            ),
            const SizedBox(height: 16),
            const Text('Voulez-vous réserver ce repas ?'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Annuler'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              _reserveMeal(context, meal);
            },
            child: const Text('Réserver'),
          ),
        ],
      ),
    );
  }

  /// Réserve un repas
  void _reserveMeal(BuildContext context, Meal meal) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Réservation de "${meal.title}" confirmée !'),
        backgroundColor: Colors.green,
        action: SnackBarAction(
          label: 'Voir',
          textColor: Colors.white,
          onPressed: () => context.push('/student/reservation'),
        ),
      ),
    );
  }

  /// Bascule le statut favori
  void _toggleFavorite(String mealId) {
    setState(() {
      if (_favoriteIds.contains(mealId)) {
        _favoriteIds.remove(mealId);
      } else {
        _favoriteIds.add(mealId);
      }
    });

    final isFavorite = _favoriteIds.contains(mealId);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          isFavorite 
              ? 'Ajouté aux favoris ❤️'
              : 'Retiré des favoris',
        ),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  /// Affiche la feuille de filtres
  void _showFiltersBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.6,
        maxChildSize: 0.9,
        minChildSize: 0.3,
        expand: false,
        builder: (context, scrollController) {
          return Container(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // En-tête
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Filtres avancés',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.close),
                    ),
                  ],
                ),
                
                const Divider(),
                
                Expanded(
                  child: ListView(
                    controller: scrollController,
                    children: [
                      // Régime alimentaire
                      const Text(
                        'Régime alimentaire',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 8,
                        children: [
                          FilterChip(
                            label: const Text('Végétarien'),
                            selected: _selectedFilters.contains('vegetarian'),
                            onSelected: (selected) {
                              setState(() {
                                if (selected) {
                                  _selectedFilters.add('vegetarian');
                                } else {
                                  _selectedFilters.remove('vegetarian');
                                }
                              });
                            },
                          ),
                          FilterChip(
                            label: const Text('Végétalien'),
                            selected: _selectedFilters.contains('vegan'),
                            onSelected: (selected) {
                              setState(() {
                                if (selected) {
                                  _selectedFilters.add('vegan');
                                } else {
                                  _selectedFilters.remove('vegan');
                                }
                              });
                            },
                          ),
                          FilterChip(
                            label: const Text('Sans gluten'),
                            selected: _selectedFilters.contains('gluten_free'),
                            onSelected: (selected) {
                              setState(() {
                                if (selected) {
                                  _selectedFilters.add('gluten_free');
                                } else {
                                  _selectedFilters.remove('gluten_free');
                                }
                              });
                            },
                          ),
                        ],
                      ),
                      
                      const SizedBox(height: 24),
                      
                      // Prix
                      const Text(
                        'Prix maximum',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text('Fonctionnalité à venir...'),
                    ],
                  ),
                ),
                
                // Boutons d'action
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () {
                          setState(() {
                            _selectedFilters.clear();
                            _selectedCategory = null;
                          });
                          Navigator.pop(context);
                        },
                        child: const Text('Réinitialiser'),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('Appliquer'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  /// Obtient le texte de la catégorie
  String _getCategoryText(MealCategory category) {
    switch (category) {
      case MealCategory.mainCourse:
        return 'Plats';
      case MealCategory.appetizer:
        return 'Entrées';
      case MealCategory.dessert:
        return 'Desserts';
      case MealCategory.beverage:
        return 'Boissons';
      case MealCategory.snack:
        return 'Snacks';
      case MealCategory.bakery:
        return 'Boulangerie';
      case MealCategory.other:
        return 'Autres';
    }
  }
}