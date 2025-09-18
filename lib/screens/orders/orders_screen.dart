import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../models/user.dart';
import '../../providers/supabase_providers.dart';
import '../../utils/responsive_utils.dart';
import '../../utils/animation_utils.dart';
import '../../services/supabase_notification_service.dart';
import '../common/loading_widget.dart';

/// Écran de gestion des commandes pour étudiants et commerçants
/// Standards NYTH - Zero Compromise
class OrdersScreen extends ConsumerStatefulWidget {
  const OrdersScreen({super.key});

  @override
  ConsumerState<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends ConsumerState<OrdersScreen>
    with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late AnimationController _slideController;
  late TabController _tabController;

  final ScrollController _scrollController = ScrollController();

  List<Map<String, dynamic>> _orders = [];
  bool _isLoading = true;
  String? _errorMessage;
  UserType? _userType;

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
    _tabController = TabController(length: 4, vsync: this);

    _fadeController.forward();
    _slideController.forward();

    _loadOrders();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _slideController.dispose();
    _tabController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  /// Charge les commandes selon le type d'utilisateur
  Future<void> _loadOrders() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final user = await ref.read(currentUserProvider.future);
      if (user == null) {
        setState(() {
          _errorMessage = 'Utilisateur non connecté';
          _isLoading = false;
        });
        return;
      }

      setState(() {
        _userType = user.userType;
      });

      final ordersAsync = ref.read(userOrdersProvider);
      final orders = ordersAsync.when(
        data: (data) => data.cast<Map<String, dynamic>>(),
        loading: () => <Map<String, dynamic>>[],
        error: (error, stack) => throw error,
      );

      setState(() {
        _orders = orders;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Erreur lors du chargement des commandes';
        _isLoading = false;
      });
      print('Erreur lors du chargement des commandes: $e');
    }
  }

  /// Filtre les commandes selon le statut
  List<Map<String, dynamic>> _getFilteredOrders(String status) {
    if (status == 'all') return _orders;
    return _orders.where((order) => order['status'] == status).toList();
  }

  /// Met à jour le statut d'une commande (pour commerçants)
  Future<void> _updateOrderStatus(String orderId, String newStatus) async {
    try {
      final orderActions = ref.read(orderActionsProvider);
      await orderActions.updateOrderStatus(orderId, newStatus);

      // Envoyer une notification au client
      final order = _orders.firstWhere((o) => o['id'] == orderId);
      await SupabaseNotificationService.instance.sendOrderStatusNotification(
        customerId: order['customer_id'],
        orderId: orderId,
        status: newStatus,
        mealTitle: order['meal_title'] ?? 'Votre repas',
      );

      // Rafraîchir la liste
      await _loadOrders();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Statut mis à jour avec succès'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Erreur lors de la mise à jour'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  /// Annule une commande
  Future<void> _cancelOrder(String orderId, String reason) async {
    try {
      final orderActions = ref.read(orderActionsProvider);
      await orderActions.cancelOrder(orderId, reason);

      await _loadOrders();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Commande annulée'),
            backgroundColor: Colors.orange,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Erreur lors de l\'annulation'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final padding = ResponsiveUtils.getAdaptivePadding(context);

    if (_isLoading) {
      return Scaffold(
        appBar: AppBar(title: const Text('Commandes')),
        body: const Center(child: LoadingWidget()),
      );
    }

    if (_errorMessage != null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Commandes')),
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
                _errorMessage!,
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.grey[700],
                ),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _loadOrders,
                child: const Text('Réessayer'),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text(
          _userType == UserType.merchant
              ? 'Mes commandes reçues'
              : 'Mes commandes',
        ),
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadOrders,
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          indicatorColor: Colors.white,
          tabs: [
            Tab(text: 'Toutes (${_orders.length})'),
            Tab(text: 'En attente (${_getFilteredOrders('pending').length})'),
            Tab(text: 'En cours (${_getFilteredOrders('preparing').length})'),
            Tab(text: 'Terminées (${_getFilteredOrders('completed').length})'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildOrdersList('all'),
          _buildOrdersList('pending'),
          _buildOrdersList('preparing'),
          _buildOrdersList('completed'),
        ],
      ),
    );
  }

  /// Construit la liste des commandes pour un statut donné
  Widget _buildOrdersList(String status) {
    final filteredOrders = _getFilteredOrders(status);

    if (filteredOrders.isEmpty) {
      return FadeInAnimation(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.shopping_bag_outlined,
                size: 80,
                color: Colors.grey[400],
              ),
              const SizedBox(height: 16),
              Text(
                status == 'all'
                    ? 'Aucune commande'
                    : 'Aucune commande ${_getStatusText(status).toLowerCase()}',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey[700],
                ),
              ),
              const SizedBox(height: 8),
              Text(
                _userType == UserType.merchant
                    ? 'Les commandes de vos clients apparaîtront ici'
                    : 'Vos commandes apparaîtront ici',
                style: TextStyle(
                  color: Colors.grey[600],
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _loadOrders,
      child: ListView.builder(
        controller: _scrollController,
        padding: const EdgeInsets.all(16),
        itemCount: filteredOrders.length,
        itemBuilder: (context, index) {
          final order = filteredOrders[index];

          return SlideInAnimation(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: _buildOrderCard(order),
            ),
          );
        },
      ),
    );
  }

  /// Construit une carte de commande
  Widget _buildOrderCard(Map<String, dynamic> order) {
    final status = order['status'] ?? 'pending';
    final createdAt = DateTime.parse(order['created_at']);
    final totalPrice = (order['total_price'] ?? 0).toDouble();
    final quantity = order['quantity'] ?? 1;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // En-tête avec numéro de commande et statut
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: _getStatusColor(status).withOpacity(0.1),
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(16)),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Commande #${order['order_number'] ?? order['id'].substring(0, 8)}',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        DateFormat('dd/MM/yyyy à HH:mm').format(createdAt),
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
                _buildStatusBadge(status),
              ],
            ),
          ),

          // Contenu de la commande
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Informations du repas
                Row(
                  children: [
                    Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        Icons.restaurant,
                        color: Colors.grey[400],
                        size: 30,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            order['meal_title'] ?? 'Repas',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(height: 4),
                          if (_userType == UserType.merchant) ...[
                            Text(
                              'Client: ${order['customer_username'] ?? 'Anonyme'}',
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: 14,
                              ),
                            ),
                          ] else ...[
                            Text(
                              'Restaurant: ${order['restaurant_name'] ?? 'Restaurant'}',
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: 14,
                              ),
                            ),
                          ],
                          const SizedBox(height: 4),
                          Text(
                            '$quantity x ${(totalPrice / quantity).toStringAsFixed(2)}€',
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          '${totalPrice.toStringAsFixed(2)}€',
                          style: TextStyle(
                            color: Theme.of(context).primaryColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),

                // Notes si présentes
                if (order['notes'] != null &&
                    order['notes'].toString().isNotEmpty) ...[
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.blue[50],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.note, size: 16, color: Colors.blue[600]),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            order['notes'],
                            style: TextStyle(
                              color: Colors.blue[700],
                              fontSize: 13,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],

                const SizedBox(height: 16),

                // Actions selon le type d'utilisateur et le statut
                _buildOrderActions(order),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Construit les actions disponibles pour une commande
  Widget _buildOrderActions(Map<String, dynamic> order) {
    final status = order['status'] ?? 'pending';
    final orderId = order['id'];

    if (_userType == UserType.merchant) {
      // Actions pour commerçants
      switch (status) {
        case 'pending':
          return Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () => _showCancelDialog(orderId),
                  icon: const Icon(Icons.close, size: 18),
                  label: const Text('Refuser'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.red,
                    side: const BorderSide(color: Colors.red),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                flex: 2,
                child: ElevatedButton.icon(
                  onPressed: () => _updateOrderStatus(orderId, 'confirmed'),
                  icon: const Icon(Icons.check, size: 18),
                  label: const Text('Confirmer'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                  ),
                ),
              ),
            ],
          );

        case 'confirmed':
          return ElevatedButton.icon(
            onPressed: () => _updateOrderStatus(orderId, 'preparing'),
            icon: const Icon(Icons.restaurant, size: 18),
            label: const Text('Commencer la préparation'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).primaryColor,
              foregroundColor: Colors.white,
            ),
          );

        case 'preparing':
          return ElevatedButton.icon(
            onPressed: () => _updateOrderStatus(orderId, 'ready'),
            icon: const Icon(Icons.done, size: 18),
            label: const Text('Marquer comme prêt'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.orange,
              foregroundColor: Colors.white,
            ),
          );

        case 'ready':
          return ElevatedButton.icon(
            onPressed: () => _updateOrderStatus(orderId, 'completed'),
            icon: const Icon(Icons.check_circle, size: 18),
            label: const Text('Marquer comme récupéré'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              foregroundColor: Colors.white,
            ),
          );

        default:
          return const SizedBox.shrink();
      }
    } else {
      // Actions pour étudiants
      return Row(
        children: [
          if (status == 'pending' || status == 'confirmed') ...[
            Expanded(
              child: OutlinedButton.icon(
                onPressed: () => _showCancelDialog(orderId),
                icon: const Icon(Icons.close, size: 18),
                label: const Text('Annuler'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.red,
                  side: const BorderSide(color: Colors.red),
                ),
              ),
            ),
            const SizedBox(width: 8),
          ],
          Expanded(
            flex: status == 'pending' || status == 'confirmed' ? 2 : 1,
            child: ElevatedButton.icon(
              onPressed: () => context.push('/order/$orderId'),
              icon: const Icon(Icons.visibility, size: 18),
              label: const Text('Voir détails'),
            ),
          ),
        ],
      );
    }
  }

  /// Affiche le dialogue d'annulation
  void _showCancelDialog(String orderId) {
    final reasonController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Annuler la commande'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Êtes-vous sûr de vouloir annuler cette commande ?'),
            const SizedBox(height: 16),
            TextField(
              controller: reasonController,
              decoration: const InputDecoration(
                labelText: 'Raison (optionnel)',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Garder'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              _cancelOrder(
                orderId,
                reasonController.text.trim().isEmpty
                    ? 'Annulée par ${_userType == UserType.merchant ? "le commerçant" : "le client"}'
                    : reasonController.text.trim(),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Annuler'),
          ),
        ],
      ),
    );
  }

  /// Construit le badge de statut
  Widget _buildStatusBadge(String status) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: _getStatusColor(status),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Text(
        _getStatusText(status),
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 12,
        ),
      ),
    );
  }

  /// Retourne la couleur selon le statut
  Color _getStatusColor(String status) {
    switch (status) {
      case 'pending':
        return Colors.orange;
      case 'confirmed':
        return Colors.blue;
      case 'preparing':
        return Colors.purple;
      case 'ready':
        return Colors.green;
      case 'completed':
        return Colors.teal;
      case 'cancelled':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  /// Retourne le texte selon le statut
  String _getStatusText(String status) {
    switch (status) {
      case 'pending':
        return 'En attente';
      case 'confirmed':
        return 'Confirmée';
      case 'preparing':
        return 'En préparation';
      case 'ready':
        return 'Prête';
      case 'completed':
        return 'Terminée';
      case 'cancelled':
        return 'Annulée';
      default:
        return 'Inconnu';
    }
  }
}
