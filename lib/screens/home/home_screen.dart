import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../models/user.dart';
import '../../widgets/notification_bell.dart';
import '../../controllers/notification_controller.dart';

/// Écran d'accueil principal de FoodSave
/// Respecte les standards NYTH - Zero Compromise
class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen>
    with SingleTickerProviderStateMixin {
  
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  
  // Simulation de l'utilisateur actuel pour la démo
  final _mockUser = User(
    id: '1',
    firstName: 'Marie',
    lastName: 'Martin',
    email: 'marie.martin@universite.fr',
    username: 'mmartin',
    phoneNumber: '06 12 34 56 78',
    userType: UserType.student,
    avatarUrl: 'https://picsum.photos/100/100?random=user',
    createdAt: DateTime.now().subtract(const Duration(days: 30)),
  );

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: _buildBody(context),
      ),
      bottomNavigationBar: _buildBottomNavigation(context),
    );
  }

  Widget _buildBody(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header avec salutation
            _buildWelcomeHeader(context),
            
            const SizedBox(height: 24),
            
            // Actions rapides
            _buildQuickActions(context),
            
            const SizedBox(height: 24),
            
            // Statistiques/Info utilisateur
            _buildUserStats(context),
            
            const SizedBox(height: 24),
            
            // Section récents / suggestions
            _buildRecentSection(context),
          ],
        ),
      ),
    );
  }

  Widget _buildWelcomeHeader(BuildContext context) {
    final timeOfDay = DateTime.now().hour;
    String greeting;
    
    if (timeOfDay < 12) {
      greeting = 'Bonjour';
    } else if (timeOfDay < 18) {
      greeting = 'Bon après-midi';
    } else {
      greeting = 'Bonsoir';
    }

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Theme.of(context).primaryColor,
            Theme.of(context).primaryColor.withOpacity(0.8),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).primaryColor.withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 30,
            backgroundImage: NetworkImage(_mockUser.avatarUrl ?? 'https://picsum.photos/100/100'),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '$greeting, ${_mockUser.firstName}!',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  _getUserTypeText(_mockUser.userType),
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white.withOpacity(0.9),
                  ),
                ),
              ],
            ),
          ),
          const NotificationBell(),
        ],
      ),
    );
  }

  Widget _buildQuickActions(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Actions rapides',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        
        if (_mockUser.userType == UserType.student) ...[
          // Actions pour les étudiants
          Row(
            children: [
              Expanded(
                child: _buildActionCard(
                  'Découvrir',
                  'Trouvez des repas près de vous',
                  Icons.restaurant_menu,
                  Colors.green,
                  () => context.go('/student/feed'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildActionCard(
                  'Mes commandes',
                  'Suivez vos réservations',
                  Icons.receipt_long,
                  Colors.blue,
                  () => context.go('/student/reservation'),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _buildActionCard(
                  'Mon profil',
                  'Gérer mon compte',
                  Icons.person,
                  Colors.purple,
                  () => context.go('/student/profile'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildActionCard(
                  'Aide',
                  'Support et FAQ',
                  Icons.help,
                  Colors.orange,
                  () => _showHelp(context),
                ),
              ),
            ],
          ),
        ] else if (_mockUser.userType == UserType.merchant) ...[
          // Actions pour les commerçants
          Row(
            children: [
              Expanded(
                child: _buildActionCard(
                  'Publier',
                  'Nouveau repas',
                  Icons.add_box,
                  Colors.green,
                  () => context.go('/merchant/post-meal'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildActionCard(
                  'Commandes',
                  'Gérer les commandes',
                  Icons.list_alt,
                  Colors.blue,
                  () => context.go('/merchant/orders'),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _buildActionCard(
                  'Mon restaurant',
                  'Profil et paramètres',
                  Icons.store,
                  Colors.purple,
                  () => context.go('/merchant/profile'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildActionCard(
                  'Statistiques',
                  'Analyses et rapports',
                  Icons.analytics,
                  Colors.orange,
                  () => _showStats(context),
                ),
              ),
            ],
          ),
        ],
      ],
    );
  }

  Widget _buildActionCard(
    String title,
    String subtitle,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, color: color, size: 24),
              ),
              const SizedBox(height: 8),
              Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildUserStats(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  _mockUser.userType == UserType.student ? Icons.eco : Icons.store,
                  color: Colors.green,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Text(
                  _mockUser.userType == UserType.student 
                      ? 'Mon impact environnemental' 
                      : 'Mes performances',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            
            if (_mockUser.userType == UserType.student) ...[
              Row(
                children: [
                  Expanded(
                    child: _buildStatItem('47', 'Repas sauvés', Icons.restaurant_menu),
                  ),
                  Expanded(
                    child: _buildStatItem('€142', 'Économies', Icons.savings),
                  ),
                  Expanded(
                    child: _buildStatItem('12kg', 'CO₂ évité', Icons.eco),
                  ),
                ],
              ),
            ] else ...[
              Row(
                children: [
                  Expanded(
                    child: _buildStatItem('156', 'Repas vendus', Icons.restaurant_menu),
                  ),
                  Expanded(
                    child: _buildStatItem('€1,247', 'Revenus', Icons.euro),
                  ),
                  Expanded(
                    child: _buildStatItem('4.6/5', 'Note moyenne', Icons.star),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(String value, String label, IconData icon) {
    return Column(
      children: [
        Icon(icon, color: Colors.green, size: 20),
        const SizedBox(height: 8),
        Text(
          value,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.green,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[600],
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildRecentSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              _mockUser.userType == UserType.student 
                  ? 'Récemment vus' 
                  : 'Activité récente',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            TextButton(
              onPressed: () {
                if (_mockUser.userType == UserType.student) {
                  context.go('/student/feed');
                } else {
                  context.go('/merchant/orders');
                }
              },
              child: const Text('Voir tout'),
            ),
          ],
        ),
        const SizedBox(height: 12),
        
        // Liste horizontale simulée
        SizedBox(
          height: 120,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: 5,
            itemBuilder: (context, index) => Container(
              width: 120,
              margin: const EdgeInsets.only(right: 12),
              child: Card(
                elevation: 2,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                child: Column(
                  children: [
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: const BorderRadius.vertical(top: Radius.circular(8)),
                          image: DecorationImage(
                            image: NetworkImage('https://picsum.photos/120/80?random=$index'),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        _mockUser.userType == UserType.student 
                            ? 'Repas ${index + 1}' 
                            : 'Commande #${index + 1}',
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBottomNavigation(BuildContext context) {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      currentIndex: 0, // Home est sélectionné
      selectedItemColor: Theme.of(context).primaryColor,
      unselectedItemColor: Colors.grey,
      items: [
        const BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Accueil',
        ),
        BottomNavigationBarItem(
          icon: Icon(_mockUser.userType == UserType.student ? Icons.restaurant_menu : Icons.add_box),
          label: _mockUser.userType == UserType.student ? 'Explorer' : 'Publier',
        ),
        BottomNavigationBarItem(
          icon: Icon(_mockUser.userType == UserType.student ? Icons.receipt_long : Icons.list_alt),
          label: _mockUser.userType == UserType.student ? 'Mes commandes' : 'Commandes',
        ),
        const BottomNavigationBarItem(
          icon: Icon(Icons.person),
          label: 'Profil',
        ),
      ],
      onTap: (index) {
        switch (index) {
          case 0:
            // Déjà sur l'accueil
            break;
          case 1:
            if (_mockUser.userType == UserType.student) {
              context.go('/student/feed');
            } else {
              context.go('/merchant/post-meal');
            }
            break;
          case 2:
            if (_mockUser.userType == UserType.student) {
              context.go('/student/reservation');
            } else {
              context.go('/merchant/orders');
            }
            break;
          case 3:
            if (_mockUser.userType == UserType.student) {
              context.go('/student/profile');
            } else {
              context.go('/merchant/profile');
            }
            break;
        }
      },
    );
  }

  void _showNotifications(BuildContext context) {
    // Déclencher une notification de démonstration
    final controller = ref.read(notificationControllerProvider.notifier);
    
    // Exemples de notifications selon le type d'utilisateur
    if (_mockUser.userType == UserType.student) {
      controller.showInAppNotification(
        context,
        title: '🍕 Nouvelle offre près de vous !',
        body: 'Pizza Margherita à -50% chez Pizza Express',
        type: NotificationType.meal,
        actionRoute: '/student/feed',
      );
    } else {
      controller.showInAppNotification(
        context,
        title: '📦 Nouvelle commande reçue !',
        body: 'Un étudiant vient de commander votre repas',
        type: NotificationType.order,
        actionRoute: '/merchant/orders',
      );
    }
  }

  void _showHelp(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Aide FoodSave'),
        content: const Text(
          'FoodSave vous aide à lutter contre le gaspillage alimentaire !\n\n'
          '• Découvrez des repas à prix réduits\n'
          '• Réservez et récupérez facilement\n'
          '• Suivez votre impact environnemental\n\n'
          'Besoin d\'aide ? Contactez-nous !',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _showStats(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Statistiques détaillées à implémenter 📊'),
      ),
    );
  }

  String _getUserTypeText(UserType type) {
    switch (type) {
      case UserType.student:
        return 'Étudiant FoodSave';
      case UserType.merchant:
        return 'Partenaire Commerçant';
    }
  }
}