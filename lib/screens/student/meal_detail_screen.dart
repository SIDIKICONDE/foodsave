import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../models/meal.dart';
import '../../models/restaurant.dart';
import '../common/custom_button.dart';
import '../common/loading_widget.dart';

/// Écran de détails d'un repas pour les étudiants
/// Respecte les standards NYTH - Zero Compromise
class MealDetailScreen extends ConsumerStatefulWidget {
  /// ID du repas à afficher
  final String mealId;
  
  /// Constructeur de l'écran de détail
  const MealDetailScreen({
    super.key,
    required this.mealId,
  });

  @override
  ConsumerState<MealDetailScreen> createState() => _MealDetailScreenState();
}

class _MealDetailScreenState extends ConsumerState<MealDetailScreen> {
  bool _isLoading = false;
  bool _isFavorite = false;
  int _quantity = 1;
  
  // Données factices pour la démo
  final _mockMeal = Meal(
    id: '1',
    merchantId: '1',
    title: 'Pizza Margherita Artisanale',
    description: 'Pizza authentique avec sauce tomate maison, mozzarella di Buffala, basilic frais et huile d\'olive extra vierge. Pâte pétrie à la main et cuite au four à bois.',
    category: MealCategory.mainCourse,
    originalPrice: 14.90,
    discountedPrice: 8.90,
    quantity: 3,
    remainingQuantity: 3,
    availableFrom: DateTime.now().subtract(const Duration(hours: 1)),
    availableUntil: DateTime.now().add(const Duration(hours: 4)),
    imageUrls: [
      'https://picsum.photos/400/300?random=1',
      'https://picsum.photos/400/300?random=2',
      'https://picsum.photos/400/300?random=3',
    ],
    allergens: ['Gluten', 'Lactose'],
    isVegetarian: true,
    isVegan: false,
    isGlutenFree: false,
    isHalal: false,
    nutritionalInfo: const NutritionalInfo(
      calories: 650,
      proteins: 25.0,
      carbohydrates: 45.0,
      fats: 35.0,
    ),
    createdAt: DateTime.now().subtract(const Duration(hours: 1)),
  );
  
  final _mockRestaurant = Restaurant(
    id: '1',
    ownerId: '1',
    name: 'Ristorante Italiano',
    description: 'Cuisine italienne authentique',
    type: RestaurantType.restaurant,
    address: '15 Rue du Commerce',
    city: 'Paris',
    postalCode: '75015',
    coordinates: const LocationCoordinates(latitude: 48.8566, longitude: 2.3522),
    phoneNumber: '01 45 67 89 12',
    averageRating: 4.7,
    totalReviews: 156,
    coverImageUrl: 'https://picsum.photos/400/200?random=restaurant2',
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(context),
      body: _buildBody(context),
      bottomNavigationBar: _buildBottomBar(context),
    );
  }

  /// Construit l'AppBar
  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      title: Text(_mockMeal.title),
      backgroundColor: Colors.transparent,
      elevation: 0,
      actions: [
        IconButton(
          onPressed: _toggleFavorite,
          icon: Icon(
            _isFavorite ? Icons.favorite : Icons.favorite_border,
            color: _isFavorite ? Colors.red : null,
          ),
          tooltip: _isFavorite ? 'Retirer des favoris' : 'Ajouter aux favoris',
        ),
        IconButton(
          onPressed: _shareMeal,
          icon: const Icon(Icons.share),
          tooltip: 'Partager',
        ),
      ],
    );
  }

  /// Construit le corps principal
  Widget _buildBody(BuildContext context) {
    if (_isLoading) {
      return const LoadingWidget(
        message: 'Chargement des détails...',
      );
    }

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Carrousel d'images
          _buildImageCarousel(context),
          
          const SizedBox(height: 16),
          
          // Contenu principal
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // En-tête avec prix et économies
                _buildHeader(context),
                
                const SizedBox(height: 24),
                
                // Restaurant
                _buildRestaurantInfo(context),
                
                const SizedBox(height: 24),
                
                // Description
                _buildDescription(context),
                
                const SizedBox(height: 24),
                
                // Spécificités alimentaires
                _buildDietaryInfo(context),
                
                const SizedBox(height: 24),
                
                // Allergènes
                _buildAllergenInfo(context),
                
                const SizedBox(height: 24),
                
                // Informations nutritionnelles
                _buildNutritionalInfo(context),
                
                const SizedBox(height: 24),
                
                // Disponibilité
                _buildAvailabilityInfo(context),
                
                const SizedBox(height: 100), // Espace pour le bottom bar
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Construit le carrousel d'images
  Widget _buildImageCarousel(BuildContext context) {
    return SizedBox(
      height: 250,
      child: PageView.builder(
        itemCount: _mockMeal.imageUrls.length,
        itemBuilder: (context, index) {
          return Container(
            margin: const EdgeInsets.symmetric(horizontal: 4),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              image: DecorationImage(
                image: NetworkImage(_mockMeal.imageUrls[index]),
                fit: BoxFit.cover,
              ),
            ),
          );
        },
      ),
    );
  }

  /// Construit l'en-tête avec prix
  Widget _buildHeader(BuildContext context) {
    final savings = _mockMeal.originalPrice - _mockMeal.discountedPrice;
    final discountPercentage = ((savings / _mockMeal.originalPrice) * 100).round();
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          _mockMeal.title,
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        
        const SizedBox(height: 8),
        
        Row(
          children: [
            // Prix actuel
            Text(
              '${_mockMeal.discountedPrice.toStringAsFixed(2)} €',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                color: Colors.green[700],
                fontWeight: FontWeight.bold,
              ),
            ),
            
            const SizedBox(width: 12),
            
            // Prix original barré
            Text(
              '${_mockMeal.originalPrice.toStringAsFixed(2)} €',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                decoration: TextDecoration.lineThrough,
                color: Colors.grey[600],
              ),
            ),
            
            const Spacer(),
            
            // Badge de réduction
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.orange,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                '-$discountPercentage%',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
            ),
          ],
        ),
        
        const SizedBox(height: 8),
        
        // Économies
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.green.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            children: [
              Icon(
                Icons.eco,
                color: Colors.green[700],
                size: 16,
              ),
              const SizedBox(width: 8),
              Text(
                'Vous économisez ${savings.toStringAsFixed(2)} € et réduisez le gaspillage !',
                style: TextStyle(
                  color: Colors.green[700],
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  /// Construit les informations du restaurant
  Widget _buildRestaurantInfo(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Row(
        children: [
          // Avatar du restaurant
          CircleAvatar(
            radius: 25,
            backgroundImage: NetworkImage(_mockRestaurant.coverImageUrl ?? ''),
          ),
          
          const SizedBox(width: 12),
          
          // Informations
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _mockRestaurant.name,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                
                Row(
                  children: [
                    Icon(
                      Icons.star,
                      color: Colors.amber,
                      size: 16,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '${_mockRestaurant.averageRating}',
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                    Text(
                      ' (${_mockRestaurant.totalReviews} avis)',
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                  ],
                ),
                
                Text(
                  _mockRestaurant.address,
                  style: TextStyle(color: Colors.grey[600]),
                ),
              ],
            ),
          ),
          
          // Bouton voir plus
          IconButton(
            onPressed: () {
              // TODO: Naviguer vers le profil du restaurant
            },
            icon: const Icon(Icons.arrow_forward_ios),
          ),
        ],
      ),
    );
  }

  /// Construit la description
  Widget _buildDescription(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Description',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        
        const SizedBox(height: 8),
        
        Text(
          _mockMeal.description,
          style: Theme.of(context).textTheme.bodyLarge,
        ),
      ],
    );
  }

  /// Construit les spécificités alimentaires
  Widget _buildDietaryInfo(BuildContext context) {
    final dietaryFeatures = <String, bool>{
      'Végétarien': _mockMeal.isVegetarian,
      'Végétalien': _mockMeal.isVegan,
      'Sans gluten': _mockMeal.isGlutenFree,
      'Halal': _mockMeal.isHalal,
    };
    
    final activeDietary = dietaryFeatures.entries
        .where((entry) => entry.value)
        .map((entry) => entry.key)
        .toList();
    
    if (activeDietary.isEmpty) return const SizedBox.shrink();
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Spécificités alimentaires',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        
        const SizedBox(height: 8),
        
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: activeDietary.map((dietary) {
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.green.withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.green.withOpacity(0.3)),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.check_circle,
                    color: Colors.green[700],
                    size: 16,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    dietary,
                    style: TextStyle(
                      color: Colors.green[700],
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  /// Construit les informations sur les allergènes
  Widget _buildAllergenInfo(BuildContext context) {
    if (_mockMeal.allergens.isEmpty) return const SizedBox.shrink();
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Allergènes présents',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        
        const SizedBox(height: 8),
        
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.orange.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.orange.withOpacity(0.3)),
          ),
          child: Row(
            children: [
              Icon(
                Icons.warning,
                color: Colors.orange[700],
                size: 16,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Contient : ${_mockMeal.allergens.join(', ')}',
                  style: TextStyle(
                    color: Colors.orange[700],
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  /// Construit les informations nutritionnelles
  Widget _buildNutritionalInfo(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Informations nutritionnelles',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        
        const SizedBox(height: 8),
        
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.grey[50],
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey[200]!),
          ),
          child: Column(
            children: _buildNutritionalRows(),
          ),
        ),
      ],
    );
  }

  /// Construit les informations de disponibilité
  Widget _buildAvailabilityInfo(BuildContext context) {
    final remainingTime = _mockMeal.availableUntil.difference(DateTime.now());
    final isUrgent = remainingTime.inHours < 2;
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Disponibilité',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        
        const SizedBox(height: 8),
        
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: isUrgent ? Colors.red.withOpacity(0.1) : Colors.blue.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: isUrgent ? Colors.red.withOpacity(0.3) : Colors.blue.withOpacity(0.3),
            ),
          ),
          child: Row(
            children: [
              Icon(
                isUrgent ? Icons.timer : Icons.access_time,
                color: isUrgent ? Colors.red[700] : Colors.blue[700],
                size: 16,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Disponible jusqu\'à ${_formatDateTime(_mockMeal.availableUntil)}',
                      style: TextStyle(
                        color: isUrgent ? Colors.red[700] : Colors.blue[700],
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    if (isUrgent)
                      Text(
                        'Dernière chance ! Plus que ${remainingTime.inHours}h${remainingTime.inMinutes.remainder(60)}min',
                        style: TextStyle(
                          color: Colors.red[700],
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
        
        const SizedBox(height: 8),
        
        Row(
          children: [
            Icon(
              Icons.inventory_2,
              color: Colors.grey[600],
              size: 16,
            ),
            const SizedBox(width: 8),
            Text(
              '${_mockMeal.remainingQuantity} portions restantes',
              style: TextStyle(
                color: Colors.grey[600],
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ],
    );
  }

  /// Construit la barre inférieure
  Widget _buildBottomBar(BuildContext context) {
    final totalPrice = _mockMeal.discountedPrice * _quantity;
    
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Sélecteur de quantité
            Row(
              children: [
                const Text(
                  'Quantité :',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                ),
                
                const Spacer(),
                
                // Contrôles de quantité
                Row(
                  children: [
                    IconButton(
                      onPressed: _quantity > 1 ? () => setState(() => _quantity--) : null,
                      icon: const Icon(Icons.remove_circle_outline),
                    ),
                    
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey[300]!),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        '$_quantity',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                    
                    IconButton(
                      onPressed: _quantity < _mockMeal.remainingQuantity ? () => setState(() => _quantity++) : null,
                      icon: const Icon(Icons.add_circle_outline),
                    ),
                  ],
                ),
              ],
            ),
            
            const SizedBox(height: 16),
            
            // Bouton de commande
            SizedBox(
              width: double.infinity,
              child: CustomButton(
                text: 'Commander • ${totalPrice.toStringAsFixed(2)} €',
                onPressed: _orderMeal,
                icon: Icons.shopping_cart,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Bascule le statut favori
  void _toggleFavorite() {
    setState(() {
      _isFavorite = !_isFavorite;
    });
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          _isFavorite ? 'Ajouté aux favoris ❤️' : 'Retiré des favoris',
        ),
      ),
    );
  }

  /// Partage le repas
  void _shareMeal() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Fonctionnalité à implémenter : partage 📤'),
      ),
    );
  }

  /// Commande le repas
  Future<void> _orderMeal() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // Simulation d'appel API
      await Future.delayed(const Duration(seconds: 2));

      if (mounted) {
        setState(() {
          _isLoading = false;
        });

        // Succès
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Commande confirmée ! 🎉'),
            content: Text(
              'Votre commande de $_quantity x ${_mockMeal.title} a été confirmée.\n\n'
              'Rendez-vous chez ${_mockRestaurant.name} pour récupérer votre repas.',
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  context.pop(); // Retour à l'écran précédent
                },
                child: const Text('OK'),
              ),
            ],
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erreur lors de la commande: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  /// Formate une date/heure
  String _formatDateTime(DateTime dateTime) {
    final now = DateTime.now();
    final isToday = dateTime.day == now.day && 
                   dateTime.month == now.month && 
                   dateTime.year == now.year;
    
    final isTomorrow = dateTime.day == now.day + 1 && 
                      dateTime.month == now.month && 
                      dateTime.year == now.year;
    
    String dateText;
    if (isToday) {
      dateText = 'aujourd\'hui';
    } else if (isTomorrow) {
      dateText = 'demain';
    } else {
      dateText = '${dateTime.day.toString().padLeft(2, '0')}/${dateTime.month.toString().padLeft(2, '0')}';
    }
    
    final timeText = '${dateTime.hour.toString().padLeft(2, '0')}h${dateTime.minute.toString().padLeft(2, '0')}';
    
    return '$dateText à $timeText';
  }

  /// Construit les lignes d'informations nutritionnelles
  List<Widget> _buildNutritionalRows() {
    final nutritionalInfo = _mockMeal.nutritionalInfo;
    if (nutritionalInfo == null) return [];
    
    final Map<String, String> nutritionalData = {};
    
    if (nutritionalInfo.calories != null) {
      nutritionalData['Calories'] = '${nutritionalInfo.calories} kcal';
    }
    if (nutritionalInfo.proteins != null) {
      nutritionalData['Protéines'] = '${nutritionalInfo.proteins!.toStringAsFixed(1)} g';
    }
    if (nutritionalInfo.carbohydrates != null) {
      nutritionalData['Glucides'] = '${nutritionalInfo.carbohydrates!.toStringAsFixed(1)} g';
    }
    if (nutritionalInfo.fats != null) {
      nutritionalData['Lipides'] = '${nutritionalInfo.fats!.toStringAsFixed(1)} g';
    }
    
    return nutritionalData.entries.map((entry) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              entry.key,
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
            Text(
              entry.value,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
      );
    }).toList();
  }
}