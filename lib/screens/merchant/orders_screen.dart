import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../models/order.dart';
import '../../models/meal.dart';
import '../../models/user.dart';
import '../../services/auth_service.dart';
import '../common/loading_widget.dart';

/// Écran de gestion des commandes pour les commerçants
/// Respecte les standards NYTH - Zero Compromise
class OrdersScreen extends ConsumerStatefulWidget {
  /// Constructeur de l'écran des commandes
  const OrdersScreen({super.key});

  @override
  ConsumerState<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends ConsumerState<OrdersScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;
  bool _isLoading = false;
  
  // Mock data pour la démonstration
  List<Order> _orders = [];
  List<Meal> _meals = [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _loadMockData();
    _loadOrders();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  /// Charge les données mock
  void _loadMockData() {
    _meals = [
      Meal(
        id: '1',
        merchantId: 'current_merchant',
        title: 'Pizza Margherita',
        description: 'Pizza fraîche avec mozzarella, tomates et basilic',
        originalPrice: 12.00,
        discountedPrice: 7.50,
        category: MealCategory.mainCourse,
        quantity: 3,
        remainingQuantity: 1,
        availableFrom: DateTime.now().subtract(const Duration(hours: 2)),
        availableUntil: DateTime.now().add(const Duration(hours: 4)),
      ),
      Meal(
        id: '2',
        merchantId: 'current_merchant',
        title: 'Salade César',
        description: 'Salade fraîche avec poulet grillé',
        originalPrice: 10.50,
        discountedPrice: 6.00,
        category: MealCategory.mainCourse,
        quantity: 2,
        remainingQuantity: 0,
        availableFrom: DateTime.now().subtract(const Duration(hours: 1)),
        availableUntil: DateTime.now().add(const Duration(hours: 2)),
      ),
    ];

    _orders = [
      Order(
        id: '1',
        studentId: 'student1',
        merchantId: 'current_merchant',
        mealId: '1',
        quantity: 1,
        totalPrice: 7.50,
        unitPrice: 7.50,
        status: OrderStatus.pending,
        createdAt: DateTime.now().subtract(const Duration(minutes: 15)),
        pickupCode: 'ABC123',
      ),
      Order(
        id: '2',
        studentId: 'student2',
        merchantId: 'current_merchant',
        mealId: '1',
        quantity: 1,
        totalPrice: 7.50,
        unitPrice: 7.50,
        status: OrderStatus.confirmed,
        createdAt: DateTime.now().subtract(const Duration(hours: 1)),
        confirmedAt: DateTime.now().subtract(const Duration(minutes: 45)),
        pickupCode: 'DEF456',
      ),
      Order(
        id: '3',
        studentId: 'student3',
        merchantId: 'current_merchant',
        mealId: '2',
        quantity: 2,
        totalPrice: 12.00,
        unitPrice: 6.00,
        status: OrderStatus.ready,
        createdAt: DateTime.now().subtract(const Duration(hours: 2)),
        confirmedAt: DateTime.now().subtract(const Duration(hours: 1, minutes: 30)),
        preparedAt: DateTime.now().subtract(const Duration(minutes: 15)),
        pickupCode: 'GHI789',
      ),
      Order(
        id: '4',
        studentId: 'student4',
        merchantId: 'current_merchant',
        mealId: '1',
        quantity: 1,
        totalPrice: 7.50,
        unitPrice: 7.50,
        status: OrderStatus.pickedUp,
        createdAt: DateTime.now().subtract(const Duration(days: 1)),
        confirmedAt: DateTime.now().subtract(const Duration(days: 1)).add(const Duration(minutes: 10)),
        preparedAt: DateTime.now().subtract(const Duration(days: 1)).add(const Duration(hours: 1)),
        pickedUpAt: DateTime.now().subtract(const Duration(days: 1)).add(const Duration(hours: 1, minutes: 30)),
        pickupCode: 'JKL012',
      ),
    ];
  }

  /// Charge les commandes
  Future<void> _loadOrders() async {
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

  /// Filtre les commandes selon l'onglet sélectionné
  List<Order> get _filteredOrders {
    switch (_tabController.index) {
      case 0: // En attente
        return _orders.where((o) => o.status == OrderStatus.pending).toList();
      case 1: // Confirmées
        return _orders.where((o) => o.status == OrderStatus.confirmed || o.status == OrderStatus.preparing).toList();
      case 2: // Prêtes
        return _orders.where((o) => o.status == OrderStatus.ready).toList();
      case 3: // Terminées
        return _orders.where((o) => o.status == OrderStatus.pickedUp || o.status == OrderStatus.cancelled).toList();
      default:
        return _orders;
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentUser = ref.watch(currentUserProvider);
    
    return Scaffold(
      appBar: _buildAppBar(context, currentUser),
      body: Column(
        children: [
          // Statistiques rapides
          _buildQuickStats(context),
          
          // Onglets
          _buildTabBar(context),
          
          // Contenu des commandes
          Expanded(
            child: _buildOrdersList(context),
          ),
        ],
      ),
      floatingActionButton: _buildFloatingActionButton(context),
    );
  }

  /// Construit l'AppBar
  PreferredSizeWidget _buildAppBar(BuildContext context, User? currentUser) {
    return AppBar(
      title: const Text(
        'Gestion des Commandes',
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      actions: [
        IconButton(
          onPressed: _loadOrders,
          icon: const Icon(Icons.refresh),
          tooltip: 'Actualiser',
        ),
        IconButton(
          onPressed: () => context.push('/merchant/profile'),
          icon: const Icon(Icons.person),
          tooltip: 'Profil',
        ),
      ],
    );
  }

  /// Construit les statistiques rapides
  Widget _buildQuickStats(BuildContext context) {
    final pendingCount = _orders.where((o) => o.status == OrderStatus.pending).length;
    final readyCount = _orders.where((o) => o.status == OrderStatus.ready).length;
    final todayRevenue = _orders
        .where((o) => o.pickedUpAt?.day == DateTime.now().day)
        .fold(0.0, (sum, order) => sum + order.totalPrice);

    return Container(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Expanded(
            child: _buildStatCard(
              context,
              icon: Icons.pending_actions,
              label: 'En attente',
              value: '$pendingCount',
              color: Colors.orange,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _buildStatCard(
              context,
              icon: Icons.check_circle,
              label: 'Prêtes',
              value: '$readyCount',
              color: Colors.green,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _buildStatCard(
              context,
              icon: Icons.euro,
              label: 'Aujourd\'hui',
              value: '${todayRevenue.toStringAsFixed(0)}€',
              color: Colors.blue,
            ),
          ),
        ],
      ),
    );
  }

  /// Construit une carte de statistique
  Widget _buildStatCard(
    BuildContext context, {
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: color.withOpacity(0.8),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  /// Construit la barre d'onglets
  Widget _buildTabBar(BuildContext context) {
    return TabBar(
      controller: _tabController,
      onTap: (_) => setState(() {}),
      isScrollable: true,
      tabs: const [
        Tab(
          icon: Icon(Icons.schedule),
          text: 'En attente',
        ),
        Tab(
          icon: Icon(Icons.pending),
          text: 'Confirmées',
        ),
        Tab(
          icon: Icon(Icons.check_circle),
          text: 'Prêtes',
        ),
        Tab(
          icon: Icon(Icons.history),
          text: 'Terminées',
        ),
      ],
    );
  }

  /// Construit la liste des commandes
  Widget _buildOrdersList(BuildContext context) {
    if (_isLoading) {
      return const LoadingWidget(
        message: 'Chargement des commandes...',
      );
    }

    final filteredOrders = _filteredOrders;

    if (filteredOrders.isEmpty) {
      return _buildEmptyState(context);
    }

    return RefreshIndicator(
      onRefresh: _loadOrders,
      child: ListView.builder(
        itemCount: filteredOrders.length,
        itemBuilder: (context, index) {
          final order = filteredOrders[index];
          final meal = _meals.firstWhere(
            (m) => m.id == order.mealId,
            orElse: () => Meal(
              id: 'unknown',
              merchantId: 'unknown',
              title: 'Repas inconnu',
              description: 'Description non disponible',
              originalPrice: 0,
              discountedPrice: 0,
              category: MealCategory.other,
              quantity: 0,
              availableFrom: DateTime.now(),
              availableUntil: DateTime.now(),
            ),
          );
          
          return _buildOrderCard(context, order, meal);
        },
      ),
    );
  }

  /// Construit une carte de commande
  Widget _buildOrderCard(BuildContext context, Order order, Meal meal) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // En-tête avec ID et statut
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Commande #${order.id.substring(0, 8)}',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                _buildStatusBadge(order.status),
              ],
            ),
            
            const SizedBox(height: 8),
            
            // Informations du repas
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        meal.title,
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Quantité: ${order.quantity}',
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
                Text(
                  '${order.totalPrice.toStringAsFixed(2)} €',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 8),
            
            // Informations temporelles
            _buildTimeInfo(context, order),
            
            if (order.pickupCode != null) ...[
              const SizedBox(height: 8),
              // Code de récupération
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey[300]!),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.qr_code, size: 16),
                    const SizedBox(width: 6),
                    Text(
                      'Code: ${order.pickupCode}',
                      style: const TextStyle(
                        fontFamily: 'monospace',
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
            
            const SizedBox(height: 12),
            
            // Boutons d'action
            _buildActionButtons(context, order),
          ],
        ),
      ),
    );
  }

  /// Construit le badge de statut
  Widget _buildStatusBadge(OrderStatus status) {
    Color color;
    String text;
    IconData icon;
    
    switch (status) {
      case OrderStatus.pending:
        color = Colors.orange;
        text = 'En attente';
        icon = Icons.schedule;
        break;
      case OrderStatus.confirmed:
        color = Colors.blue;
        text = 'Confirmée';
        icon = Icons.check;
        break;
      case OrderStatus.preparing:
        color = Colors.purple;
        text = 'En préparation';
        icon = Icons.restaurant;
        break;
      case OrderStatus.ready:
        color = Colors.green;
        text = 'Prête';
        icon = Icons.check_circle;
        break;
      case OrderStatus.pickedUp:
        color = Colors.grey;
        text = 'Récupérée';
        icon = Icons.done_all;
        break;
      case OrderStatus.cancelled:
        color = Colors.red;
        text = 'Annulée';
        icon = Icons.cancel;
        break;
      case OrderStatus.expired:
        color = Colors.red;
        text = 'Expirée';
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
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  /// Construit les informations temporelles
  Widget _buildTimeInfo(BuildContext context, Order order) {
    return Row(
      children: [
        Icon(
          Icons.access_time,
          size: 16,
          color: Colors.grey[600],
        ),
        const SizedBox(width: 4),
        Text(
          'Commandé il y a ${_getTimeAgo(order.createdAt)}',
          style: TextStyle(
            color: Colors.grey[600],
            fontSize: 14,
          ),
        ),
      ],
    );
  }

  /// Construit les boutons d'action
  Widget _buildActionButtons(BuildContext context, Order order) {
    switch (order.status) {
      case OrderStatus.pending:
        return Row(
          children: [
            Expanded(
              child: OutlinedButton.icon(
                onPressed: () => _updateOrderStatus(order, OrderStatus.cancelled),
                icon: const Icon(Icons.cancel, size: 16),
                label: const Text('Refuser'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.red,
                  side: const BorderSide(color: Colors.red),
                ),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: ElevatedButton.icon(
                onPressed: () => _updateOrderStatus(order, OrderStatus.confirmed),
                icon: const Icon(Icons.check, size: 16),
                label: const Text('Accepter'),
              ),
            ),
          ],
        );
        
      case OrderStatus.confirmed:
        return SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: () => _updateOrderStatus(order, OrderStatus.ready),
            icon: const Icon(Icons.restaurant, size: 16),
            label: const Text('Marquer comme prêt'),
          ),
        );
        
      case OrderStatus.ready:
        return SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: () => _updateOrderStatus(order, OrderStatus.pickedUp),
            icon: const Icon(Icons.done_all, size: 16),
            label: const Text('Marquer comme récupéré'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              foregroundColor: Colors.white,
            ),
          ),
        );
        
      default:
        return const SizedBox.shrink();
    }
  }

  /// Construit l'état vide
  Widget _buildEmptyState(BuildContext context) {
    String message;
    IconData icon;
    
    switch (_tabController.index) {
      case 0:
        message = 'Aucune commande en attente';
        icon = Icons.schedule;
        break;
      case 1:
        message = 'Aucune commande confirmée';
        icon = Icons.pending;
        break;
      case 2:
        message = 'Aucune commande prête';
        icon = Icons.check_circle;
        break;
      default:
        message = 'Aucune commande terminée';
        icon = Icons.history;
    }
    
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 80,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 20),
            Text(
              message,
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                color: Colors.grey[600],
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 30),
            ElevatedButton.icon(
              onPressed: _loadOrders,
              icon: const Icon(Icons.refresh),
              label: const Text('Actualiser'),
            ),
          ],
        ),
      ),
    );
  }

  /// Construit le bouton flottant
  Widget _buildFloatingActionButton(BuildContext context) {
    return FloatingActionButton.extended(
      onPressed: () => context.push('/merchant/post-meal'),
      icon: const Icon(Icons.add),
      label: const Text('Nouveau repas'),
    );
  }

  /// Met à jour le statut d'une commande
  void _updateOrderStatus(Order order, OrderStatus newStatus) {
    setState(() {
      final index = _orders.indexWhere((o) => o.id == order.id);
      if (index != -1) {
        _orders[index] = order.copyWith(
          status: newStatus,
          confirmedAt: newStatus == OrderStatus.confirmed ? DateTime.now() : order.confirmedAt,
          preparedAt: newStatus == OrderStatus.ready ? DateTime.now() : order.preparedAt,
          pickedUpAt: newStatus == OrderStatus.pickedUp ? DateTime.now() : order.pickedUpAt,
          cancelledAt: newStatus == OrderStatus.cancelled ? DateTime.now() : order.cancelledAt,
        );
      }
    });

    String message;
    switch (newStatus) {
      case OrderStatus.confirmed:
        message = 'Commande acceptée';
        break;
      case OrderStatus.ready:
        message = 'Commande marquée comme prête';
        break;
      case OrderStatus.pickedUp:
        message = 'Commande marquée comme récupérée';
        break;
      case OrderStatus.cancelled:
        message = 'Commande refusée';
        break;
      default:
        message = 'Statut mis à jour';
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: newStatus == OrderStatus.cancelled ? Colors.red : Colors.green,
      ),
    );
  }

  /// Calcule le temps écoulé depuis une date
  String _getTimeAgo(DateTime dateTime) {
    final difference = DateTime.now().difference(dateTime);
    
    if (difference.inDays > 0) {
      return '${difference.inDays} jour${difference.inDays > 1 ? 's' : ''}';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h${difference.inMinutes.remainder(60).toString().padLeft(2, '0')}';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} min';
    } else {
      return 'À l\'instant';
    }
  }
}