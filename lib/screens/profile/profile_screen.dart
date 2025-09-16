import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../models/user.dart';
import '../common/custom_button.dart';
import '../common/loading_widget.dart';

/// Écran de profil générique pour les utilisateurs (étudiants, etc.)
/// Respecte les standards NYTH - Zero Compromise
class ProfileScreen extends ConsumerStatefulWidget {
  /// Constructeur de l'écran de profil
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  bool _isEditing = false;
  bool _isLoading = false;
  
  // Contrôleurs pour les formulaires
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _phoneController = TextEditingController();
  
  // Données factices pour la démo
  final _mockUser = User(
    id: '1',
    firstName: 'Marie',
    lastName: 'Martin',
    email: 'marie.martin@universite.fr',
    username: 'mmartin',
    phoneNumber: '06 12 34 56 78',
    userType: UserType.student,
    avatarUrl: 'https://picsum.photos/100/100?random=student',
    createdAt: DateTime.now().subtract(const Duration(days: 180)),
  );

  @override
  void initState() {
    super.initState();
    _initializeControllers();
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  /// Initialise les contrôleurs avec les données existantes
  void _initializeControllers() {
    _firstNameController.text = _mockUser.firstName ?? '';
    _lastNameController.text = _mockUser.lastName ?? '';
    _phoneController.text = _mockUser.phoneNumber ?? '';
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
    );
  }

  /// Construit le corps principal
  Widget _buildBody(BuildContext context) {
    if (_isLoading) {
      return const LoadingWidget(
        message: 'Mise à jour en cours...',
      );
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          // Photo de profil
          _buildProfilePicture(context),
          
          const SizedBox(height: 24),
          
          // Informations personnelles
          _buildPersonalInfo(context),
          
          const SizedBox(height: 24),
          
          // Statistiques utilisateur
          if (!_isEditing) _buildUserStats(context),
          
          const SizedBox(height: 24),
          
          // Paramètres
          if (!_isEditing) _buildSettings(context),
          
          // Bouton de sauvegarde
          if (_isEditing) ...[
            const SizedBox(height: 24),
            _buildSaveButton(context),
          ],
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
            
            // Prénom
            TextFormField(
              controller: _firstNameController,
              enabled: _isEditing,
              decoration: const InputDecoration(
                labelText: 'Prénom',
                prefixIcon: Icon(Icons.person),
              ),
            ),
            
            const SizedBox(height: 16),
            
            // Nom
            TextFormField(
              controller: _lastNameController,
              enabled: _isEditing,
              decoration: const InputDecoration(
                labelText: 'Nom',
                prefixIcon: Icon(Icons.person),
              ),
            ),
            
            const SizedBox(height: 16),
            
            // Email (non éditable)
            TextFormField(
              initialValue: _mockUser.email,
              enabled: false,
              decoration: const InputDecoration(
                labelText: 'Email',
                prefixIcon: Icon(Icons.email),
                helperText: 'L\'email ne peut pas être modifié',
              ),
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
            ),
            
            const SizedBox(height: 16),
            
            // Informations supplémentaires non éditables
            if (!_isEditing) ...[
              _buildReadOnlyField('Type de compte', _getUserTypeText(_mockUser.userType), Icons.account_circle),
              const SizedBox(height: 16),
              _buildReadOnlyField('Membre depuis', _formatMemberSince(_mockUser.createdAt ?? DateTime.now()), Icons.calendar_today),
            ],
          ],
        ),
      ),
    );
  }

  /// Construit les statistiques utilisateur
  Widget _buildUserStats(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Mes statistiques',
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
                    'Repas sauvés',
                    '47',
                    Icons.restaurant_menu,
                    Colors.green,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildStatCard(
                    'Économies',
                    '€142',
                    Icons.savings,
                    Colors.blue,
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 12),
            
            Row(
              children: [
                Expanded(
                  child: _buildStatCard(
                    'Impact carbone évité',
                    '12kg CO₂',
                    Icons.eco,
                    Colors.green,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildStatCard(
                    'Favoris',
                    '8',
                    Icons.favorite,
                    Colors.red,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  /// Construit les paramètres
  Widget _buildSettings(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Paramètres',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            
            ListTile(
              leading: const Icon(Icons.notifications),
              title: const Text('Notifications'),
              subtitle: const Text('Gérer les notifications'),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: _openNotificationSettings,
              contentPadding: EdgeInsets.zero,
            ),
            
            ListTile(
              leading: const Icon(Icons.lock),
              title: const Text('Changer le mot de passe'),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: _changePassword,
              contentPadding: EdgeInsets.zero,
            ),
            
            ListTile(
              leading: const Icon(Icons.help),
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
          ],
        ),
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
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          Text(
            label,
            style: const TextStyle(
              fontSize: 11,
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

  /// Ouvre les paramètres de notification
  void _openNotificationSettings() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Fonctionnalité à implémenter : paramètres de notifications 🔔'),
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
              context.go('/auth/login');
            },
            child: const Text('Déconnexion'),
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

  /// Obtient le texte du type d'utilisateur
  String _getUserTypeText(UserType type) {
    switch (type) {
      case UserType.student:
        return 'Étudiant';
      case UserType.merchant:
        return 'Commerçant';
    }
  }
}