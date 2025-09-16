import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../models/order.dart';
import '../../models/meal.dart';
import '../common/loading_widget.dart';

/// Écran des réservations/commandes pour les étudiants
/// Respecte les standards NYTH - Zero Compromise
class ReservationsScreen extends ConsumerStatefulWidget {
  const ReservationsScreen({super.key});

  @override
  ConsumerState<ReservationsScreen> createState() => _ReservationsScreenState();
}

class _ReservationsScreenState extends ConsumerState<ReservationsScreen>
    with SingleTickerProviderStateMixin {
  
  late TabController _tabController;
  bool _isLoading = false;
  String? _errorMessage;
  
  // Filtres
  OrderStatus? _selectedStatus;
  final _searchController = TextEditingController();
  
  // Données factices pour la démo
  final List<Order> _mockOrders = [
    Order(
      id: '1',
      studentId: 'user1',
      merchantId: 'merchant1',
      mealId: 'meal1',
      quantity: 2,
      totalPrice: 15.98,
      unitPrice: 7.99,
      status: OrderStatus.ready,
      createdAt: DateTime.now().subtract(const Duration(hours: 2)),
    ),
    Order(
      id: '2',
      studentId: 'user1',
      merchantId: 'merchant2',
      mealId: 'meal2',
      quantity: 1,
      totalPrice: 8.50,
      unitPrice: 8.50,
      status: OrderStatus.pending,
      createdAt: DateTime.now().subtract(const Duration(days: 1)),
    ),
    Order(
      id: '3',
      studentId: 'user1',
      merchantId: 'merchant1',
      mealId: 'meal3',
      quantity: 3,
      totalPrice: 22.47,
      unitPrice: 7.49,
      status: OrderStatus.pickedUp,
      createdAt: DateTime.now().subtract(const Duration(days: 5)),
      pickedUpAt: DateTime.now().subtract(const Duration(days: 5, hours: 2)),
    ),
    Order(
      id: '4',
      studentId: 'user1',
      merchantId: 'merchant3',
      mealId: 'meal4',
      quantity: 1,
      totalPrice: 12.90,
      unitPrice: 12.90,
      status: OrderStatus.cancelled,
      createdAt: DateTime.now().subtract(const Duration(days: 10)),
      cancelledAt: DateTime.now().subtract(const Duration(days: 10)),
    ),
  ];
  
  final Map<String, Meal> _mockMeals = {
    'meal1': Meal(
      id: 'meal1',
      merchantId: 'merchant1',
      title: 'Salade César au Poulet',
      description: 'Salade fraîche avec poulet grillé',
      originalPrice: 12.99,
      discountedPrice: 7.99,
      imageUrls: ['https://picsum.photos/300/200?random=1'],
      category: MealCategory.mainCourse,
      quantity: 5,
      remainingQuantity: 3,
      availableFrom: DateTime.now().subtract(const Duration(hours: 2)),
      availableUntil: DateTime.now().add(const Duration(hours: 4)),
    ),
    'meal2': Meal(
      id: 'meal2',
      merchantId: 'merchant2',
      title: 'Pizza Margherita',
      description: 'Pizza classique tomate mozzarella',
      originalPrice: 12.00,
      discountedPrice: 8.50,
      imageUrls: ['https://picsum.photos/300/200?random=2'],
      category: MealCategory.mainCourse,
      quantity: 3,
      remainingQuantity: 1,
      availableFrom: DateTime.now().subtract(const Duration(hours: 1)),
      availableUntil: DateTime.now().add(const Duration(hours: 6)),
    ),
    'meal3': Meal(
      id: 'meal3',
      merchantId: 'merchant1',
      title: 'Sandwich Club',
      description: 'Sandwich complet avec frites',
      originalPrice: 10.99,
      discountedPrice: 7.49,
      imageUrls: ['https://picsum.photos/300/200?random=3'],
      category: MealCategory.snack,
      quantity: 2,
      remainingQuantity: 0,
      availableFrom: DateTime.now().subtract(const Duration(days: 5, hours: 3)),
      availableUntil: DateTime.now().subtract(const Duration(days: 5, hours: 1)),
    ),
    'meal4': Meal(
      id: 'meal4',
      merchantId: 'merchant3',
      title: 'Tarte aux Pommes',
      description: 'Dessert maison du jour',
      originalPrice: 15.90,
      discountedPrice: 12.90,
      imageUrls: ['https://picsum.photos/300/200?random=4'],
      category: MealCategory.dessert,
      quantity: 1,
      remainingQuantity: 0,
      availableFrom: DateTime.now().subtract(const Duration(days: 10, hours: 2)),
      availableUntil: DateTime.now().subtract(const Duration(days: 10)),
    ),
  };

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _loadOrders();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadOrders() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      // Simulation du chargement
      await Future.delayed(const Duration(milliseconds: 800));
      
      // TODO: Intégrer avec le service Supabase
      // final orders = await ref.read(supabaseServiceProvider).getUserOrders();
      
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
          _errorMessage = 'Erreur lors du chargement des commandes';
        });
      }
    }
  }

  List<Order> get _filteredOrders {
    var orders = _mockOrders;
    
    // Filtre par statut selon l'onglet
    switch (_tabController.index) {
      case 0: // Toutes
        break;
      case 1: // En cours
        orders = orders.where((o) => 
          o.status == OrderStatus.pending || o.status == OrderStatus.ready
        ).toList();
        break;
      case 2: // Terminées
        orders = orders.where((o) => o.status == OrderStatus.pickedUp).toList();
        break;
      case 3: // Annulées
        orders = orders.where((o) => o.status == OrderStatus.cancelled).toList();
        break;
    }
    
    // Filtre par recherche
    if (_searchController.text.isNotEmpty) {
      final search = _searchController.text.toLowerCase();
      orders = orders.where((order) {
        final meal = _mockMeals[order.mealId];
        return meal?.title.toLowerCase().contains(search) ?? false;
      }).toList();
    }
    
    // Trier par date (plus récent en premier)
    orders.sort((a, b) => b.createdAt!.compareTo(a.createdAt!));
    
    return orders;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: _buildBody(),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      title: const Text(
        'Mes Réservations',
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      actions: [
        IconButton(
          onPressed: _showFilterDialog,
          icon: const Icon(Icons.filter_list),
          tooltip: 'Filtres',
        ),
        IconButton(
          onPressed: _loadOrders,
          icon: const Icon(Icons.refresh),
          tooltip: 'Actualiser',
        ),
      ],
      bottom: TabBar(
        controller: _tabController,
        tabs: const [
          Tab(text: 'Toutes'),
          Tab(text: 'En cours'),
          Tab(text: 'Terminées'),
          Tab(text: 'Annulées'),
        ],
        onTap: (index) => setState(() {}),
      ),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const LoadingWidget(message: 'Chargement des réservations...');
    }

    if (_errorMessage != null) {
      return _buildErrorState();
    }

    return Column(
      children: [
        // Barre de recherche
        _buildSearchBar(),
        
        // Liste des commandes
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: List.generate(4, (index) => _buildOrdersList()),
          ),
        ),
      ],
    );
  }

  Widget _buildSearchBar() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: TextField(
        controller: _searchController,
        decoration: InputDecoration(
          hintText: 'Rechercher un repas...',
          prefixIcon: const Icon(Icons.search),
          suffixIcon: _searchController.text.isNotEmpty
              ? IconButton(
                  onPressed: () {
                    _searchController.clear();
                    setState(() {});
                  },
                  icon: const Icon(Icons.clear),
                )
              : null,
          filled: true,
          fillColor: Colors.grey[100],
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
        ),
        onChanged: (value) => setState(() {}),
      ),
    );
  }

  Widget _buildOrdersList() {
    final orders = _filteredOrders;
    
    if (orders.isEmpty) {
      return _buildEmptyState();
    }

    return RefreshIndicator(
      onRefresh: _loadOrders,
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: orders.length,
        itemBuilder: (context, index) => _buildOrderCard(orders[index]),
      ),
    );
  }

  Widget _buildOrderCard(Order order) {
    final meal = _mockMeals[order.mealId];
    if (meal == null) return const SizedBox.shrink();

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () => _showOrderDetails(order, meal),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  // Image du repas
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(
                      meal.imageUrls.isNotEmpty ? meal.imageUrls[0] : 'https://picsum.photos/60/60',
                      width: 60,
                      height: 60,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Container(
                        width: 60,
                        height: 60,
                        color: Colors.grey[300],
                        child: const Icon(Icons.restaurant),
                      ),
                    ),
                  ),
                  
                  const SizedBox(width: 12),
                  
                  // Détails de la commande
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          meal.title,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Quantité: ${order.quantity}x',
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '€${order.totalPrice.toStringAsFixed(2)}',
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                            color: Colors.green,
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  // Statut
                  _buildStatusChip(order.status),
                ],
              ),
              
              const SizedBox(height: 12),
              
              // Informations temporelles
              Row(
                children: [
                  Icon(Icons.access_time, size: 14, color: Colors.grey[600]),
                  const SizedBox(width: 4),
                  Text(
                    'Commandé le ${DateFormat('dd/MM à HH:mm').format(order.createdAt!)}',
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
              
              // Informations de statut spécifiques
              if (order.status == OrderStatus.ready) ...[
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(Icons.done, size: 14, color: Colors.green),
                    const SizedBox(width: 4),
                    Text(
                      'Prêt à récupérer',
                      style: TextStyle(
                        color: Colors.green,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ] else if (order.pickedUpAt != null) ...[
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(Icons.check_circle, size: 14, color: Colors.blue),
                    const SizedBox(width: 4),
                    Text(
                      'Récupéré le ${DateFormat('dd/MM à HH:mm').format(order.pickedUpAt!)}',
                      style: const TextStyle(
                        color: Colors.blue,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ] else if (order.cancelledAt != null) ...[
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(Icons.cancel, size: 14, color: Colors.red),
                    const SizedBox(width: 4),
                    Text(
                      'Annulé le ${DateFormat('dd/MM à HH:mm').format(order.cancelledAt!)}',
                      style: const TextStyle(
                        color: Colors.red,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ],
              
              // Actions selon le statut
              if (order.status == OrderStatus.pending) ...[
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => _cancelOrder(order),
                        child: const Text('Annuler'),
                      ),
                    ),
                  ],
                ),
              ] else if (order.status == OrderStatus.ready) ...[
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () => _markAsCollected(order),
                        icon: const Icon(Icons.check),
                        label: const Text('Marquer comme récupéré'),
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatusChip(OrderStatus status) {
    Color color;
    String text;
    IconData icon;

    switch (status) {
      case OrderStatus.pending:
        color = Colors.orange;
        text = 'En attente';
        icon = Icons.hourglass_top;
        break;
      case OrderStatus.confirmed:
        color = Colors.blue;
        text = 'Confirmé';
        icon = Icons.check;
        break;
      case OrderStatus.preparing:
        color = Colors.purple;
        text = 'En préparation';
        icon = Icons.restaurant;
        break;
      case OrderStatus.ready:
        color = Colors.green;
        text = 'Prêt';
        icon = Icons.done;
        break;
      case OrderStatus.pickedUp:
        color = Colors.blue;
        text = 'Récupéré';
        icon = Icons.check_circle;
        break;
      case OrderStatus.cancelled:
        color = Colors.red;
        text = 'Annulé';
        icon = Icons.cancel;
        break;
      case OrderStatus.expired:
        color = Colors.grey;
        text = 'Expiré';
        icon = Icons.access_time;
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(width: 4),
          Text(
            text,
            style: TextStyle(
              color: color,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.receipt_long,
            size: 80,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            'Aucune réservation',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Vos commandes apparaîtront ici',
            style: TextStyle(color: Colors.grey[500]),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () => context.go('/student/feed'),
            icon: const Icon(Icons.restaurant_menu),
            label: const Text('Découvrir des repas'),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            size: 80,
            color: Colors.red[300],
          ),
          const SizedBox(height: 16),
          Text(
            'Erreur de chargement',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              color: Colors.red[700],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            _errorMessage ?? 'Une erreur est survenue',
            style: TextStyle(color: Colors.grey[600]),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: _loadOrders,
            icon: const Icon(Icons.refresh),
            label: const Text('Réessayer'),
          ),
        ],
      ),
    );
  }

  void _showOrderDetails(Order order, Meal meal) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => DraggableScrollableSheet(
        expand: false,
        builder: (context, scrollController) => Container(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Handle
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              
              const SizedBox(height: 20),
              
              // Titre
              Text(
                'Détails de la commande',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              
              const SizedBox(height: 20),
              
              // Détails
              Text('Repas: ${meal.title}'),
              const SizedBox(height: 8),
              Text('Quantité: ${order.quantity}x'),
              const SizedBox(height: 8),
              Text('Prix total: €${order.totalPrice.toStringAsFixed(2)}'),
              const SizedBox(height: 8),
              Text('Statut: ${_getStatusText(order.status)}'),
              const SizedBox(height: 8),
              Text('Commandé: ${DateFormat('dd/MM/yyyy à HH:mm').format(order.createdAt!)}'),
              // Informations de récupération si disponibles
              if (order.pickedUpAt != null) ...[
                const SizedBox(height: 8),
                Text('Récupéré le: ${DateFormat('dd/MM/yyyy à HH:mm').format(order.pickedUpAt!)}'),
              ],
              
              const SizedBox(height: 24),
              
              // Actions
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Text('Fermer'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                        context.go('/student/meal/${meal.id}');
                      },
                      child: const Text('Voir le repas'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showFilterDialog() {
    // TODO: Implémenter les filtres avancés
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Filtres avancés à implémenter 🔧'),
      ),
    );
  }

  Future<void> _cancelOrder(Order order) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Annuler la commande'),
        content: const Text('Êtes-vous sûr de vouloir annuler cette commande ?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Non'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Oui, annuler'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      // TODO: Appeler le service pour annuler la commande
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Commande annulée'),
          backgroundColor: Colors.orange,
        ),
      );
    }
  }

  Future<void> _markAsCollected(Order order) async {
    // TODO: Marquer comme récupéré
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Commande marquée comme récupérée ! 🎉'),
        backgroundColor: Colors.green,
      ),
    );
  }

  String _getStatusText(OrderStatus status) {
    switch (status) {
      case OrderStatus.pending:
        return 'En attente';
      case OrderStatus.confirmed:
        return 'Confirmé';
      case OrderStatus.preparing:
        return 'En préparation';
      case OrderStatus.ready:
        return 'Prêt à récupérer';
      case OrderStatus.pickedUp:
        return 'Récupéré';
      case OrderStatus.cancelled:
        return 'Annulé';
      case OrderStatus.expired:
        return 'Expiré';
    }
  }
}
