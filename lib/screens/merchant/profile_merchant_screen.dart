import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../models/user.dart';
import '../../models/restaurant.dart';
import '../../utils/validators.dart';
import '../common/custom_button.dart';
import '../common/loading_widget.dart';

/// Écran de profil pour les commerçants
/// Permet de gérer les informations du restaurant et les paramètres du compte
/// Respecte les standards NYTH - Zero Compromise
class ProfileMerchantScreen extends ConsumerStatefulWidget {
  /// Constructeur de l'écran de profil commerçant
  const ProfileMerchantScreen({super.key});

  @override
  ConsumerState<ProfileMerchantScreen> createState() => _ProfileMerchantScreenState();
}

class _ProfileMerchantScreenState extends ConsumerState<ProfileMerchantScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool _isEditing = false;
  bool _isLoading = false;
  
  // Contrôleurs pour les formulaires
  final _restaurantNameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _addressController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _websiteController = TextEditingController();
  
  // Données factices pour la démo
  final _mockRestaurant = Restaurant(
    id: '1',
    ownerId: '1',
    name: 'Le Petit Bistrot',
    description: 'Cuisine française traditionnelle avec des produits frais et locaux',
    type: RestaurantType.restaurant,
    address: '123 Rue de la Paix',
    city: 'Paris',
    postalCode: '75001',
    coordinates: const LocationCoordinates(
      latitude: 48.8566,
      longitude: 2.3522,
    ),
    phoneNumber: '01 42 33 44 55',
    email: 'contact@petitbistrot.fr',
    website: 'www.petitbistrot.fr',
    coverImageUrl: 'https://picsum.photos/400/200?random=restaurant',
    averageRating: 4.5,
    isOpen: true,
  );
  
  final _mockUser = User(
    id: '1',
    firstName: 'Jean',
    lastName: 'Dubois',
    email: 'jean.dubois@petitbistrot.fr',
    username: 'jdubois',
    phoneNumber: '06 12 34 56 78',
    userType: UserType.merchant,
    avatarUrl: 'https://picsum.photos/100/100?random=user',
    createdAt: DateTime.now().subtract(const Duration(days: 365)),
  );

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _initializeControllers();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _restaurantNameController.dispose();
    _descriptionController.dispose();
    _addressController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _websiteController.dispose();
    super.dispose();
  }

  /// Initialise les contrôleurs avec les données existantes
  void _initializeControllers() {
    _restaurantNameController.text = _mockRestaurant.name;
    _descriptionController.text = _mockRestaurant.description;
    _addressController.text = _mockRestaurant.address;
    _phoneController.text = _mockRestaurant.phoneNumber ?? '';
    _emailController.text = _mockRestaurant.email ?? '';
    _websiteController.text = _mockRestaurant.website ?? '';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(context),
      body: _buildBody(context),
    );
  }

  /// Construit l'AppBar
  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      title: const Text(
        'Mon Profil',
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      actions: [
        if (_isEditing)
          TextButton(
            onPressed: _cancelEditing,
            child: const Text('Annuler'),
          )
        else
          IconButton(
            onPressed: _startEditing,
            icon: const Icon(Icons.edit),
            tooltip: 'Modifier',
          ),
      ],
      bottom: TabBar(
        controller: _tabController,
        tabs: const [
          Tab(
            icon: Icon(Icons.restaurant),
            text: 'Restaurant',
          ),
          Tab(
            icon: Icon(Icons.person),
            text: 'Personnel',
          ),
          Tab(
            icon: Icon(Icons.settings),
            text: 'Paramètres',
          ),
        ],
      ),
    );
  }

  /// Construit le corps principal
  Widget _buildBody(BuildContext context) {
    if (_isLoading) {
      return const LoadingWidget(
        message: 'Mise à jour en cours...',
      );
    }

    return TabBarView(
      controller: _tabController,
      children: [
        _buildRestaurantTab(context),
        _buildPersonalTab(context),
        _buildSettingsTab(context),
      ],
    );
  }

  /// Construit l'onglet Restaurant
  Widget _buildRestaurantTab(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Photo du restaurant
          _buildRestaurantImage(context),
          
          const SizedBox(height: 24),
          
          // Informations de base
          _buildRestaurantBasicInfo(context),
          
          const SizedBox(height: 24),
          
          // Contact et localisation
          _buildRestaurantContact(context),
          
          const SizedBox(height: 24),
          
          // Statistiques
          if (!_isEditing) _buildRestaurantStats(context),
          
          // Bouton de sauvegarde
          if (_isEditing) ...[
            const SizedBox(height: 24),
            _buildSaveButton(context),
          ],
        ],
      ),
    );
  }

  /// Construit l'image du restaurant
  Widget _buildRestaurantImage(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Photo du restaurant',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            
            Center(
              child: Stack(
                children: [
                  Container(
                    width: double.infinity,
                    height: 200,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      image: DecorationImage(
                        image: NetworkImage(_mockRestaurant.coverImageUrl ?? 'https://picsum.photos/400/200'),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  
                  if (_isEditing)
                    Positioned(
                      right: 8,
                      bottom: 8,
                      child: FloatingActionButton.small(
                        onPressed: _changeRestaurantImage,
                        backgroundColor: Colors.white,
                        child: const Icon(Icons.camera_alt, color: Colors.grey),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Construit les informations de base du restaurant
  Widget _buildRestaurantBasicInfo(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Informations générales',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            
            // Nom du restaurant
            TextFormField(
              controller: _restaurantNameController,
              enabled: _isEditing,
              decoration: const InputDecoration(
                labelText: 'Nom du restaurant',
                prefixIcon: Icon(Icons.restaurant),
              ),
              validator: Validators.restaurantName,
            ),
            
            const SizedBox(height: 16),
            
            // Description
            TextFormField(
              controller: _descriptionController,
              enabled: _isEditing,
              decoration: const InputDecoration(
                labelText: 'Description',
                prefixIcon: Icon(Icons.description),
              ),
              maxLines: 3,
              validator: Validators.description,
            ),
            
            const SizedBox(height: 16),
            
            // Type de restaurant (non éditable dans cette version)
            if (!_isEditing) ...[
              Row(
                children: [
                  Expanded(
                    child: _buildInfoChip(
                      'Type',
                      _getRestaurantTypeText(_mockRestaurant.type),
                      Icons.local_dining,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildInfoChip(
                      'Note',
                      '${_mockRestaurant.averageRating.toStringAsFixed(1)}/5',
                      Icons.star,
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  /// Construit les informations de contact
  Widget _buildRestaurantContact(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Contact et localisation',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            
            // Adresse
            TextFormField(
              controller: _addressController,
              enabled: _isEditing,
              decoration: const InputDecoration(
                labelText: 'Adresse',
                prefixIcon: Icon(Icons.location_on),
              ),
              validator: Validators.address,
            ),
            
            const SizedBox(height: 16),
            
            // Téléphone
            TextFormField(
              controller: _phoneController,
              enabled: _isEditing,
              decoration: const InputDecoration(
                labelText: 'Téléphone',
                prefixIcon: Icon(Icons.phone),
              ),
              validator: Validators.phoneNumber,
            ),
            
            const SizedBox(height: 16),
            
            // Email
            TextFormField(
              controller: _emailController,
              enabled: _isEditing,
              decoration: const InputDecoration(
                labelText: 'Email',
                prefixIcon: Icon(Icons.email),
              ),
              validator: Validators.email,
            ),
            
            const SizedBox(height: 16),
            
            // Site web
            TextFormField(
              controller: _websiteController,
              enabled: _isEditing,
              decoration: const InputDecoration(
                labelText: 'Site web (optionnel)',
                prefixIcon: Icon(Icons.web),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Construit les statistiques du restaurant
  Widget _buildRestaurantStats(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Statistiques',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            
            Row(
              children: [
                Expanded(
                  child: _buildStatCard(
                    'Note moyenne',
                    '${_mockRestaurant.averageRating.toStringAsFixed(1)}/5',
                    Icons.star,
                    Colors.amber,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildStatCard(
                    'Repas vendus',
                    '1,247',
                    Icons.restaurant_menu,
                    Colors.green,
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 12),
            
            Row(
              children: [
                Expanded(
                  child: _buildStatCard(
                    'Économies générées',
                    '€2,456',
                    Icons.trending_up,
                    Colors.blue,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildStatCard(
                    'Avis clients',
                    '89',
                    Icons.comment,
                    Colors.purple,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  /// Construit l'onglet Personnel
  Widget _buildPersonalTab(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          // Photo de profil
          _buildProfilePicture(context),
          
          const SizedBox(height: 24),
          
          // Informations personnelles
          _buildPersonalInfo(context),
        ],
      ),
    );
  }

  /// Construit la photo de profil
  Widget _buildProfilePicture(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const Text(
              'Photo de profil',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            
            Stack(
              children: [
                CircleAvatar(
                  radius: 50,
                  backgroundImage: NetworkImage(_mockUser.avatarUrl ?? 'https://picsum.photos/100/100'),
                ),
                
                if (_isEditing)
                  Positioned(
                    right: 0,
                    bottom: 0,
                    child: FloatingActionButton.small(
                      onPressed: _changeProfilePicture,
                      backgroundColor: Theme.of(context).primaryColor,
                      child: const Icon(Icons.camera_alt, color: Colors.white),
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  /// Construit les informations personnelles
  Widget _buildPersonalInfo(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Informations personnelles',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            
            // Informations non éditables pour cette démo
            _buildReadOnlyField('Prénom', _mockUser.firstName ?? 'Non renseigné', Icons.person),
            const SizedBox(height: 16),
            _buildReadOnlyField('Nom', _mockUser.lastName ?? 'Non renseigné', Icons.person),
            const SizedBox(height: 16),
            _buildReadOnlyField('Email', _mockUser.email, Icons.email),
            const SizedBox(height: 16),
            _buildReadOnlyField('Téléphone', _mockUser.phoneNumber ?? 'Non renseigné', Icons.phone),
            const SizedBox(height: 16),
            _buildReadOnlyField('Membre depuis', _formatMemberSince(_mockUser.createdAt ?? DateTime.now()), Icons.calendar_today),
          ],
        ),
      ),
    );
  }

  /// Construit l'onglet Paramètres
  Widget _buildSettingsTab(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          // Paramètres des notifications
          _buildNotificationSettings(context),
          
          const SizedBox(height: 24),
          
          // Paramètres de confidentialité
          _buildPrivacySettings(context),
          
          const SizedBox(height: 24),
          
          // Actions du compte
          _buildAccountActions(context),
        ],
      ),
    );
  }

  /// Construit les paramètres de notification
  Widget _buildNotificationSettings(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Notifications',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            
            SwitchListTile(
              title: const Text('Nouvelles commandes'),
              subtitle: const Text('Recevoir une notification pour chaque nouvelle commande'),
              value: true,
              onChanged: (value) {
                // TODO: Implémenter la logique
              },
              contentPadding: EdgeInsets.zero,
            ),
            
            SwitchListTile(
              title: const Text('Rappels de stock'),
              subtitle: const Text('Être alerté quand un repas est bientôt épuisé'),
              value: true,
              onChanged: (value) {
                // TODO: Implémenter la logique
              },
              contentPadding: EdgeInsets.zero,
            ),
            
            SwitchListTile(
              title: const Text('Promotions et conseils'),
              subtitle: const Text('Recevoir des conseils pour optimiser les ventes'),
              value: false,
              onChanged: (value) {
                // TODO: Implémenter la logique
              },
              contentPadding: EdgeInsets.zero,
            ),
          ],
        ),
      ),
    );
  }

  /// Construit les paramètres de confidentialité
  Widget _buildPrivacySettings(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Confidentialité',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            
            ListTile(
              leading: const Icon(Icons.visibility),
              title: const Text('Visibilité du profil'),
              subtitle: const Text('Public'),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () {
                // TODO: Ouvrir les paramètres de visibilité
              },
              contentPadding: EdgeInsets.zero,
            ),
            
            ListTile(
              leading: const Icon(Icons.analytics),
              title: const Text('Partage de données'),
              subtitle: const Text('Gérer le partage des données anonymisées'),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () {
                // TODO: Ouvrir les paramètres de données
              },
              contentPadding: EdgeInsets.zero,
            ),
          ],
        ),
      ),
    );
  }

  /// Construit les actions du compte
  Widget _buildAccountActions(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Compte',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            
            ListTile(
              leading: const Icon(Icons.lock, color: Colors.blue),
              title: const Text('Changer le mot de passe'),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: _changePassword,
              contentPadding: EdgeInsets.zero,
            ),
            
            ListTile(
              leading: const Icon(Icons.help, color: Colors.green),
              title: const Text('Aide et support'),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: _openSupport,
              contentPadding: EdgeInsets.zero,
            ),
            
            const Divider(),
            
            ListTile(
              leading: const Icon(Icons.logout, color: Colors.orange),
              title: const Text('Se déconnecter'),
              onTap: _logout,
              contentPadding: EdgeInsets.zero,
            ),
            
            ListTile(
              leading: const Icon(Icons.delete_forever, color: Colors.red),
              title: const Text('Supprimer le compte'),
              onTap: _deleteAccount,
              contentPadding: EdgeInsets.zero,
            ),
          ],
        ),
      ),
    );
  }

  /// Construit un champ d'information
  Widget _buildInfoChip(String label, String value, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Icon(icon, size: 16, color: Colors.grey[600]),
          const SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                ),
              ),
              Text(
                value,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// Construit une carte de statistique
  Widget _buildStatCard(String label, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 8),
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
            style: const TextStyle(
              fontSize: 12,
              color: Colors.grey,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  /// Construit un champ en lecture seule
  Widget _buildReadOnlyField(String label, String value, IconData icon) {
    return Row(
      children: [
        Icon(icon, color: Colors.grey[600]),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
              ),
            ),
            Text(
              value,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ],
    );
  }

  /// Construit le bouton de sauvegarde
  Widget _buildSaveButton(BuildContext context) {
    return CustomButton(
      text: 'Sauvegarder les modifications',
      onPressed: _saveChanges,
      icon: Icons.save,
    );
  }

  /// Commence l'édition
  void _startEditing() {
    setState(() {
      _isEditing = true;
    });
  }

  /// Annule l'édition
  void _cancelEditing() {
    setState(() {
      _isEditing = false;
    });
    _initializeControllers(); // Restaure les valeurs originales
  }

  /// Sauvegarde les modifications
  Future<void> _saveChanges() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // Simulation d'appel API
      await Future.delayed(const Duration(seconds: 1));

      if (mounted) {
        setState(() {
          _isEditing = false;
          _isLoading = false;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Modifications sauvegardées avec succès ! ✅'),
            backgroundColor: Colors.green,
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
            content: Text('Erreur lors de la sauvegarde: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  /// Change l'image du restaurant
  void _changeRestaurantImage() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Fonctionnalité à implémenter : changement d\'image 📷'),
      ),
    );
  }

  /// Change la photo de profil
  void _changeProfilePicture() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Fonctionnalité à implémenter : changement de photo 📷'),
      ),
    );
  }

  /// Change le mot de passe
  void _changePassword() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Fonctionnalité à implémenter : changement de mot de passe 🔒'),
      ),
    );
  }

  /// Ouvre le support
  void _openSupport() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Fonctionnalité à implémenter : support client 📞'),
      ),
    );
  }

  /// Déconnexion
  void _logout() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Se déconnecter'),
        content: const Text('Êtes-vous sûr de vouloir vous déconnecter ?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Annuler'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              context.go('/login');
            },
            child: const Text('Déconnexion'),
          ),
        ],
      ),
    );
  }

  /// Suppression du compte
  void _deleteAccount() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Supprimer le compte'),
        content: const Text(
          'Cette action est irréversible. Toutes vos données seront définitivement supprimées.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Annuler'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Fonctionnalité à implémenter : suppression du compte ⚠️'),
                  backgroundColor: Colors.red,
                ),
              );
            },
            child: const Text(
              'Supprimer',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }

  /// Formate la date d'inscription
  String _formatMemberSince(DateTime date) {
    final months = [
      'janvier', 'février', 'mars', 'avril', 'mai', 'juin',
      'juillet', 'août', 'septembre', 'octobre', 'novembre', 'décembre'
    ];
    
    return '${months[date.month - 1]} ${date.year}';
  }

  /// Obtient le texte du type de restaurant
  String _getRestaurantTypeText(RestaurantType type) {
    switch (type) {
      case RestaurantType.restaurant:
        return 'Restaurant';
      case RestaurantType.bakery:
        return 'Boulangerie';
      case RestaurantType.cafe:
        return 'Café';
      case RestaurantType.fastFood:
        return 'Fast Food';
      case RestaurantType.caterer:
        return 'Traiteur';
      case RestaurantType.foodTruck:
        return 'Food Truck';
      case RestaurantType.supermarket:
        return 'Supermarché';
      case RestaurantType.groceryStore:
        return 'Épicerie';
      case RestaurantType.other:
        return 'Autre';
    }
  }
}