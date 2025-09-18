import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../../providers/supabase_providers.dart';
import '../../utils/responsive_utils.dart';
import '../../utils/animation_utils.dart';
import '../../services/supabase_notification_service.dart';
import '../common/custom_button.dart';
import '../common/loading_widget.dart';

/// Écran de détail d'un repas avec possibilité de commande
/// Standards NYTH - Zero Compromise
class MealDetailScreen extends ConsumerStatefulWidget {
  final String mealId;

  const MealDetailScreen({
    super.key,
    required this.mealId,
  });

  @override
  ConsumerState<MealDetailScreen> createState() => _MealDetailScreenState();
}

class _MealDetailScreenState extends ConsumerState<MealDetailScreen>
    with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late AnimationController _slideController;
  late AnimationController _scaleController;

  final ScrollController _scrollController = ScrollController();
  final TextEditingController _notesController = TextEditingController();

  Map<String, dynamic>? _meal;
  bool _isLoading = true;
  bool _isOrdering = false;
  bool _isFavorite = false;
  int _quantity = 1;
  double _totalPrice = 0.0;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();

    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _scaleController = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );

    _loadMealDetails();

    _fadeController.forward();
    _slideController.forward();
    _scaleController.forward();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _slideController.dispose();
    _scaleController.dispose();
    _scrollController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  /// Charge les détails du repas
  Future<void> _loadMealDetails() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final supabaseService = ref.read(supabaseServiceProvider);
      final response = await supabaseService.client
          .from('meals')
          .select('*')
          .eq('id', widget.mealId)
          .single();
      final meal = response;

      if (meal != null) {
        setState(() {
          _meal = meal;
          _isFavorite = meal['is_favorite'] ?? false;
          _totalPrice = (meal['discounted_price'] ?? 0).toDouble() * _quantity;
          _isLoading = false;
        });
      } else {
        setState(() {
          _errorMessage = 'Repas non trouvé';
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Erreur lors du chargement du repas';
        _isLoading = false;
      });
      print('Erreur lors du chargement du repas: $e');
    }
  }

  /// Bascule le statut favori
  Future<void> _toggleFavorite() async {
    try {
      final supabaseService = ref.read(supabaseServiceProvider);
      final user = supabaseService.client.auth.currentUser;
      if (user != null) {
        // Vérifier si le repas est déjà en favori
        final favoriteResponse = await supabaseService.client
            .from('user_favorites')
            .select('id')
            .eq('user_id', user.id)
            .eq('meal_id', widget.mealId)
            .maybeSingle();

        if (favoriteResponse != null) {
          // Supprimer des favoris
          await supabaseService.client
              .from('user_favorites')
              .delete()
              .eq('user_id', user.id)
              .eq('meal_id', widget.mealId);
        } else {
          // Ajouter aux favoris
          await supabaseService.client.from('user_favorites').insert({
            'user_id': user.id,
            'meal_id': widget.mealId,
            'created_at': DateTime.now().toIso8601String(),
          });
        }
      }

      setState(() {
        _isFavorite = !_isFavorite;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            _isFavorite ? 'Ajouté aux favoris ❤️' : 'Retiré des favoris',
          ),
          duration: const Duration(seconds: 2),
        ),
      );
    } catch (e) {
      print('Erreur lors de l\'ajout aux favoris: $e');
    }
  }

  /// Passe une commande
  Future<void> _placeOrder() async {
    if (_meal == null) return;

    setState(() {
      _isOrdering = true;
      _errorMessage = null;
    });

    try {
      final orderActions = ref.read(orderActionsProvider);
      final order = await orderActions.createOrder(
        mealId: widget.mealId,
        quantity: _quantity,
        notes: _notesController.text.trim().isEmpty
            ? null
            : _notesController.text.trim(),
      );

      if (order != null) {
        // Envoyer une notification au commerçant
        final user = await ref.read(currentUserProvider.future);
        if (user != null) {
          await SupabaseNotificationService.instance.sendNewOrderNotification(
            merchantId: _meal!['merchant_id'],
            customerName: user.firstName ?? user.username,
            mealTitle: _meal!['title'],
            quantity: _quantity,
            orderId: order['id'],
          );
        }

        if (mounted) {
          // Afficher un message de succès
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Commande passée avec succès ! 🎉'),
              backgroundColor: Colors.green,
              duration: Duration(seconds: 3),
            ),
          );

          // Naviguer vers la page de commande
          context.go('/order/${order['id']}');
        }
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Erreur lors de la commande: ${e.toString()}';
      });
    } finally {
      if (mounted) {
        setState(() {
          _isOrdering = false;
        });
      }
    }
  }

  /// Met à jour la quantité et recalcule le prix
  void _updateQuantity(int delta) {
    if (_meal == null) return;

    final newQuantity = _quantity + delta;
    final maxQuantity = _meal!['remaining_quantity'] ?? 0;

    if (newQuantity >= 1 && newQuantity <= maxQuantity) {
      setState(() {
        _quantity = newQuantity;
        _totalPrice = (_meal!['discounted_price'] ?? 0).toDouble() * _quantity;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final padding = ResponsiveUtils.getAdaptivePadding(context);

    if (_isLoading) {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        body: const Center(child: LoadingWidget()),
      );
    }

    if (_errorMessage != null || _meal == null) {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.error_outline,
                size: 80,
                color: Colors.grey[400],
              ),
              const SizedBox(height: 16),
              Text(
                _errorMessage ?? 'Repas non trouvé',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.grey[700],
                ),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () => context.pop(),
                child: const Text('Retour'),
              ),
            ],
          ),
        ),
      );
    }

    final imageUrls = _meal!['image_urls'] as List<dynamic>? ?? [];
    final imageUrl = imageUrls.isNotEmpty ? imageUrls[0] : null;

    return Scaffold(
      body: CustomScrollView(
        controller: _scrollController,
        slivers: [
          // AppBar avec image
          SliverAppBar(
            expandedHeight: 300,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  // Image du repas
                  FadeInAnimation(
                    child: imageUrl != null
                        ? CachedNetworkImage(
                            imageUrl: imageUrl,
                            fit: BoxFit.cover,
                            placeholder: (context, url) => Container(
                              color: Colors.grey[200],
                              child: const Center(
                                child: CircularProgressIndicator(),
                              ),
                            ),
                            errorWidget: (context, url, error) => Container(
                              color: Colors.grey[200],
                              child: Icon(
                                Icons.restaurant,
                                size: 80,
                                color: Colors.grey[400],
                              ),
                            ),
                          )
                        : Container(
                            color: Colors.grey[200],
                            child: Icon(
                              Icons.restaurant,
                              size: 80,
                              color: Colors.grey[400],
                            ),
                          ),
                  ),

                  // Gradient overlay
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Colors.black.withOpacity(0.7),
                        ],
                      ),
                    ),
                  ),

                  // Badge de réduction
                  if ((_meal!['original_price'] ?? 0) >
                      (_meal!['discounted_price'] ?? 0))
                    Positioned(
                      top: 100,
                      left: 16,
                      child: ScaleInAnimation(
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            '-${((((_meal!['original_price'] ?? 0) - (_meal!['discounted_price'] ?? 0)) / (_meal!['original_price'] ?? 1)) * 100).round()}%',
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
            actions: [
              // Bouton favori
              ScaleInAnimation(
                child: Container(
                  margin: const EdgeInsets.only(right: 8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 4,
                      ),
                    ],
                  ),
                  child: IconButton(
                    icon: Icon(
                      _isFavorite ? Icons.favorite : Icons.favorite_border,
                      color: _isFavorite ? Colors.red : Colors.grey[600],
                    ),
                    onPressed: _toggleFavorite,
                  ),
                ),
              ),

              // Bouton partage
              ScaleInAnimation(
                child: Container(
                  margin: const EdgeInsets.only(right: 16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 4,
                      ),
                    ],
                  ),
                  child: IconButton(
                    icon: Icon(Icons.share, color: Colors.grey[600]),
                    onPressed: () {
                      // TODO: Implémenter le partage
                    },
                  ),
                ),
              ),
            ],
          ),

          // Contenu principal
          SliverPadding(
            padding: padding,
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                // Titre et restaurant
                SlideInAnimation(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _meal!['title'] ?? 'Repas mystère',
                        style: Theme.of(context)
                            .textTheme
                            .headlineMedium
                            ?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Icon(Icons.store, size: 16, color: Colors.grey[600]),
                          const SizedBox(width: 4),
                          Text(
                            _meal!['restaurant']?['name'] ?? 'Restaurant',
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                // Prix et quantité disponible
                SlideInAnimation(
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: Theme.of(context).primaryColor.withOpacity(0.3),
                      ),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Prix',
                                style: TextStyle(
                                  color: Colors.grey[600],
                                  fontSize: 14,
                                ),
                              ),
                              Row(
                                children: [
                                  Text(
                                    '${(_meal!['discounted_price'] ?? 0).toStringAsFixed(2)}€',
                                    style: TextStyle(
                                      color: Theme.of(context).primaryColor,
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  if ((_meal!['original_price'] ?? 0) >
                                      (_meal!['discounted_price'] ?? 0)) ...[
                                    const SizedBox(width: 8),
                                    Text(
                                      '${(_meal!['original_price'] ?? 0).toStringAsFixed(2)}€',
                                      style: TextStyle(
                                        color: Colors.grey[500],
                                        fontSize: 16,
                                        decoration: TextDecoration.lineThrough,
                                      ),
                                    ),
                                  ],
                                ],
                              ),
                            ],
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              'Disponible',
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: 14,
                              ),
                            ),
                            Text(
                              '${_meal!['remaining_quantity'] ?? 0} portion(s)',
                              style: TextStyle(
                                color: (_meal!['remaining_quantity'] ?? 0) <= 3
                                    ? Colors.orange[700]
                                    : Colors.grey[700],
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                // Description
                SlideInAnimation(
                  child: Column(
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
                        _meal!['description'] ??
                            'Aucune description disponible',
                        style: TextStyle(
                          color: Colors.grey[700],
                          fontSize: 16,
                          height: 1.5,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                // Tags diététiques et allergènes
                SlideInAnimation(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (_hasDietaryInfo()) ...[
                        Text(
                          'Informations diététiques',
                          style:
                              Theme.of(context).textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                        ),
                        const SizedBox(height: 8),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: [
                            if (_meal!['is_vegetarian'] ?? false)
                              _buildDietTag(
                                  'Végétarien', Colors.green, Icons.eco),
                            if (_meal!['is_vegan'] ?? false)
                              _buildDietTag('Vegan', Colors.teal, Icons.grass),
                            if (_meal!['is_gluten_free'] ?? false)
                              _buildDietTag(
                                  'Sans gluten', Colors.orange, Icons.no_food),
                            if (_meal!['is_halal'] ?? false)
                              _buildDietTag(
                                  'Halal', Colors.purple, Icons.verified),
                          ],
                        ),
                        const SizedBox(height: 16),
                      ],

                      // Allergènes
                      if ((_meal!['allergens'] as List?)?.isNotEmpty ??
                          false) ...[
                        Text(
                          'Allergènes',
                          style:
                              Theme.of(context).textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                        ),
                        const SizedBox(height: 8),
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.red[50],
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.red[200]!),
                          ),
                          child: Row(
                            children: [
                              Icon(Icons.warning_amber,
                                  color: Colors.red[600], size: 20),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  'Contient: ${(_meal!['allergens'] as List).join(', ')}',
                                  style: TextStyle(color: Colors.red[700]),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                // Disponibilité
                SlideInAnimation(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Disponibilité',
                        style:
                            Theme.of(context).textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.blue[50],
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.blue[200]!),
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.access_time,
                                color: Colors.blue[600], size: 20),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                'Disponible jusqu\'à ${DateTime.parse(_meal!['available_until']).hour}h${DateTime.parse(_meal!['available_until']).minute.toString().padLeft(2, '0')}',
                                style: TextStyle(color: Colors.blue[700]),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 32),

                // Section commande
                SlideInAnimation(
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Passer commande',
                          style:
                              Theme.of(context).textTheme.titleLarge?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                        ),
                        const SizedBox(height: 16),

                        // Sélecteur de quantité
                        Row(
                          children: [
                            const Text(
                              'Quantité:',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const Spacer(),
                            Container(
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey[300]!),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Row(
                                children: [
                                  IconButton(
                                    onPressed: () => _updateQuantity(-1),
                                    icon: const Icon(Icons.remove),
                                    splashRadius: 20,
                                  ),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 16),
                                    child: Text(
                                      _quantity.toString(),
                                      style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  IconButton(
                                    onPressed: () => _updateQuantity(1),
                                    icon: const Icon(Icons.add),
                                    splashRadius: 20,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 16),

                        // Notes (optionnel)
                        TextField(
                          controller: _notesController,
                          maxLines: 3,
                          decoration: InputDecoration(
                            labelText: 'Notes (optionnel)',
                            hintText: 'Demandes spéciales, allergies...',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),

                        const SizedBox(height: 20),

                        // Prix total
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.grey[50],
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            children: [
                              const Text(
                                'Total:',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const Spacer(),
                              Text(
                                '${_totalPrice.toStringAsFixed(2)}€',
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: Theme.of(context).primaryColor,
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 20),

                        // Message d'erreur
                        if (_errorMessage != null) ...[
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.red[50],
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: Colors.red[200]!),
                            ),
                            child: Row(
                              children: [
                                Icon(Icons.error_outline,
                                    color: Colors.red[600], size: 20),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    _errorMessage!,
                                    style: TextStyle(color: Colors.red[700]),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 16),
                        ],

                        // Bouton commander
                        SizedBox(
                          width: double.infinity,
                          child: _isOrdering
                              ? const LoadingWidget()
                              : CustomButton(
                                  text: 'Commander maintenant',
                                  onPressed:
                                      (_meal!['remaining_quantity'] ?? 0) > 0
                                          ? _placeOrder
                                          : null,
                                  icon: Icons.shopping_bag,
                                ),
                        ),
                      ],
                    ),
                  ),
                ),

                // Espacement en bas
                const SizedBox(height: 40),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  /// Vérifie s'il y a des informations diététiques à afficher
  bool _hasDietaryInfo() {
    return (_meal!['is_vegetarian'] ?? false) ||
        (_meal!['is_vegan'] ?? false) ||
        (_meal!['is_gluten_free'] ?? false) ||
        (_meal!['is_halal'] ?? false);
  }

  /// Construit un tag diététique
  Widget _buildDietTag(String label, Color color, IconData icon) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.2),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.5)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: 16),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}
