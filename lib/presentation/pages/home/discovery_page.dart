import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:foodsave_app/core/constants/app_colors.dart';
import 'package:foodsave_app/core/constants/app_dimensions.dart';
import 'package:foodsave_app/core/constants/app_text_styles.dart';
import 'package:foodsave_app/presentation/pages/home/widgets/hero_banner.dart';
import 'package:foodsave_app/presentation/pages/home/widgets/categories_grid.dart';
import 'package:foodsave_app/presentation/pages/home/widgets/featured_baskets.dart';
import 'package:foodsave_app/presentation/pages/home/widgets/near_you_section.dart';
import 'package:foodsave_app/presentation/pages/home/widgets/search_dialog.dart';
import 'package:foodsave_app/core/routes/app_routes.dart';

/// Page d'accueil principale de l'application FoodSave.
/// 
/// Interface moderne et professionnelle permettant aux utilisateurs
/// de découvrir rapidement les paniers anti-gaspi disponibles,
/// explorer les catégories et accéder aux fonctionnalités principales.
class DiscoveryPage extends StatefulWidget {
  /// Crée une nouvelle instance de [DiscoveryPage].
  const DiscoveryPage({super.key});

  @override
  State<DiscoveryPage> createState() => _DiscoveryPageState();
}

class _DiscoveryPageState extends State<DiscoveryPage>
    with TickerProviderStateMixin {
  /// Contrôleur de scroll pour les animations parallaxe.
  final ScrollController _scrollController = ScrollController();
  
  /// Contrôleur d'animation pour les effets d'entrée.
  late final AnimationController _fadeController;
  
  /// Contrôleur pour l'animation du header.
  late final AnimationController _headerController;
  
  /// Opacité du header basée sur le scroll.
  double _headerOpacity = 0.0;
  
  /// État de chargement des données.
  bool _isLoading = false;
  
  /// Indicateur de rafraîchissement.
  // ignore: unused_field
  bool _isRefreshing = false;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _setupScrollListener();
    _loadInitialData();
  }

  /// Initialise les contrôleurs d'animation.
  void _initializeAnimations() {
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    
    _headerController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    
    // Démarre l'animation d'entrée
    _fadeController.forward();
  }

  /// Configure l'écouteur de scroll pour les animations.
  void _setupScrollListener() {
    _scrollController.addListener(() {
      final double offset = _scrollController.offset;
      final double opacity = (offset / 150).clamp(0.0, 1.0);
      
      if (_headerOpacity != opacity) {
        setState(() {
          _headerOpacity = opacity;
        });
      }
    });
  }

  /// Charge les données initiales.
  Future<void> _loadInitialData() async {
    setState(() => _isLoading = true);
    
    // Simulation du chargement des données
    await Future.delayed(const Duration(milliseconds: 500));
    
    if (mounted) {
      setState(() => _isLoading = false);
    }
  }

  /// Rafraîchit les données.
  Future<void> _onRefresh() async {
    setState(() => _isRefreshing = true);
    
    // Simulation du rafraîchissement
    await Future.delayed(const Duration(seconds: 1));
    
    if (mounted) {
      setState(() => _isRefreshing = false);
      _showSuccessMessage('Données mises à jour');
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _fadeController.dispose();
    _headerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Configuration de la status bar
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
      ),
    );
    
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: _buildModernAppBar(),
      body: Stack(
        children: [
          // Fond avec dégradé subtil
          _buildBackgroundGradient(),
          
          // Contenu principal
          RefreshIndicator(
            color: AppColors.primary,
            onRefresh: _onRefresh,
            child: CustomScrollView(
              controller: _scrollController,
              physics: const BouncingScrollPhysics(),
              slivers: [
                // Hero Banner avec parallaxe
                SliverToBoxAdapter(
                  child: FadeTransition(
                    opacity: _fadeController,
                    child: const HeroBanner(),
                  ),
                ),
                
                // (Supprimé) Statistiques écologiques
                
                // Catégories
                SliverToBoxAdapter(
                  child: _buildAnimatedSection(
                    delay: 300,
                    child: _buildSectionHeader(
                      title: 'Catégories',
                      subtitle: 'Trouvez vos paniers préférés',
                      onSeeAll: _navigateToCategories,
                    ),
                  ),
                ),
                
                SliverToBoxAdapter(
                  child: _buildAnimatedSection(
                    delay: 400,
                    child: const CategoriesGrid(),
                  ),
                ),
                
                // (Supprimé) Bannière promotionnelle
                
                // Paniers en vedette
                SliverToBoxAdapter(
                  child: _buildAnimatedSection(
                    delay: 600,
                    child: _buildSectionHeader(
                      title: 'Paniers en vedette',
                      subtitle: 'Les meilleures offres du moment',
                      onSeeAll: _navigateToAllBaskets,
                    ),
                  ),
                ),
                
                SliverToBoxAdapter(
                  child: _buildAnimatedSection(
                    delay: 700,
                    child: const FeaturedBaskets(),
                  ),
                ),
                
                // Paniers près de vous
                SliverToBoxAdapter(
                  child: _buildAnimatedSection(
                    delay: 800,
                    child: _buildSectionHeader(
                      title: 'Près de vous',
                      subtitle: 'Dans un rayon de 2 km',
                      onSeeAll: _navigateToMap,
                    ),
                  ),
                ),
                
                SliverToBoxAdapter(
                  child: _buildAnimatedSection(
                    delay: 900,
                    child: const NearYouSection(),
                  ),
                ),
                
                // Espace pour la navigation
                const SliverToBoxAdapter(
                  child: SizedBox(height: 100),
                ),
              ],
            ),
          ),
          
          // Indicateur de chargement
          if (_isLoading) _buildLoadingOverlay(),
        ],
      ),
      floatingActionButton: _buildFloatingActionButton(),
    );
  }

  /// Construit l'AppBar moderne avec animations.
  PreferredSizeWidget _buildModernAppBar() {
    return AppBar(
      elevation: 0,
      backgroundColor: AppColors.primary.withValues(alpha: _headerOpacity * 0.95),
      flexibleSpace: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppColors.primary.withValues(alpha: _headerOpacity * 0.95),
              AppColors.primaryDark.withValues(alpha: _headerOpacity * 0.85),
            ],
          ),
        ),
      ),
      title: AnimatedOpacity(
        opacity: _headerOpacity,
        duration: const Duration(milliseconds: 200),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.surface.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.shadow.withValues(alpha: 0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: const Icon(
                Icons.eco,
                color: AppColors.textOnDark,
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'FoodSave',
                  style: AppTextStyles.headline6.copyWith(
                    color: AppColors.textOnDark,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                Text(
                  'Sauvez de la nourriture',
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.textOnDark.withValues(alpha: 0.8),
                    fontSize: 10,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      actions: [
        _buildAppBarAction(
          icon: Icons.search_rounded,
          onPressed: _openSearch,
        ),
        _buildAppBarAction(
          icon: Icons.notifications_none_rounded,
          onPressed: _openNotifications,
          badge: '3',
        ),
        _buildAppBarAction(
          icon: Icons.location_on_outlined,
          onPressed: _changeLocation,
        ),
        const SizedBox(width: 8),
      ],
    );
  }

  /// Construit un bouton d'action pour l'AppBar.
  Widget _buildAppBarAction({
    required IconData icon,
    required VoidCallback onPressed,
    String? badge,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 4),
      child: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              color: AppColors.surface.withValues(
                alpha: _headerOpacity > 0.5 ? 0.15 : 0.25,
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: IconButton(
              icon: Icon(
                icon,
                color: AppColors.textOnDark,
                size: 22,
              ),
              onPressed: onPressed,
              tooltip: icon == Icons.search_rounded
                  ? 'Rechercher'
                  : icon == Icons.notifications_none_rounded
                      ? 'Notifications'
                      : 'Localisation',
            ),
          ),
          if (badge != null)
            Positioned(
              right: 6,
              top: 6,
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: AppColors.error,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: AppColors.surface,
                    width: 1.5,
                  ),
                ),
                constraints: const BoxConstraints(
                  minWidth: 18,
                  minHeight: 18,
                ),
                child: Text(
                  badge,
                  style: AppTextStyles.labelSmall.copyWith(
                    color: AppColors.textOnDark,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
        ],
      ),
    );
  }

  /// Construit le fond avec dégradé.
  Widget _buildBackgroundGradient() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          stops: const [0.0, 0.3, 1.0],
          colors: [
            AppColors.primary.withValues(alpha: 0.08),
            AppColors.background,
            AppColors.surfaceLight,
          ],
        ),
      ),
    );
  }

  /// Construit une section avec animation.
  Widget _buildAnimatedSection({
    required Widget child,
    int delay = 0,
  }) {
    return TweenAnimationBuilder<double>(
      duration: Duration(milliseconds: 600 + delay),
      tween: Tween(begin: 0.0, end: 1.0),
      curve: Curves.easeOutCubic,
      builder: (context, value, child) {
        return Transform.translate(
          offset: Offset(0, 20 * (1 - value)),
          child: Opacity(
            opacity: value,
            child: child,
          ),
        );
      },
      child: child,
    );
  }

  /// Construit un en-tête de section.
  Widget _buildSectionHeader({
    required String title,
    required String subtitle,
    VoidCallback? onSeeAll,
  }) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppDimensions.spacingL,
        AppDimensions.spacingXL,
        AppDimensions.spacingL,
        AppDimensions.spacingM,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTextStyles.headline4.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          if (onSeeAll != null)
            TextButton.icon(
              onPressed: onSeeAll,
              style: TextButton.styleFrom(
                foregroundColor: AppColors.primary,
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              icon: const Icon(Icons.arrow_forward, size: 18),
              label: Text(
                'Voir tout',
                style: AppTextStyles.labelMedium.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
        ],
      ),
    );
  }

  /// Construit le bouton flottant.
  Widget _buildFloatingActionButton() {
    return AnimatedOpacity(
      opacity: _headerOpacity > 0.5 ? 1.0 : 0.0,
      duration: const Duration(milliseconds: 200),
      child: AnimatedScale(
        scale: _headerOpacity > 0.5 ? 1.0 : 0.0,
        duration: const Duration(milliseconds: 200),
        child: FloatingActionButton(
          onPressed: _scrollToTop,
          backgroundColor: AppColors.primary,
          elevation: 8,
          child: const Icon(
            Icons.arrow_upward,
            color: AppColors.textOnDark,
          ),
        ),
      ),
    );
  }

  /// Construit l'overlay de chargement.
  Widget _buildLoadingOverlay() {
    return Container(
      color: AppColors.overlayDark.withValues(alpha: 0.3),
      child: const Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
        ),
      ),
    );
  }

  /// Fait défiler vers le haut.
  void _scrollToTop() {
    _scrollController.animateTo(
      0,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeOutCubic,
    );
  }

  /// Ouvre la recherche.
  void _openSearch() {
    showSearchDialog(context);
  }

  /// Ouvre les notifications.
  void _openNotifications() {
    _showMessage('Notifications', Icons.notifications);
  }

  /// Change la localisation.
  void _changeLocation() {
    _showMessage('Localisation', Icons.location_on);
  }

  /// Navigue vers les catégories.
  void _navigateToCategories() {
    _showMessage('Catégories', Icons.category);
  }

  /// Navigue vers tous les paniers.
  void _navigateToAllBaskets() {
    AppRoutes.navigateToAllBaskets(context);
  }

  /// Navigue vers la carte.
  void _navigateToMap() {
    AppRoutes.navigateToBasketsMap(context);
  }

  /// Affiche un message temporaire.
  void _showMessage(String text, IconData icon) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(icon, color: AppColors.textOnDark, size: 20),
            const SizedBox(width: 12),
            Text(text),
          ],
        ),
        backgroundColor: AppColors.primaryDark,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        margin: EdgeInsets.only(
          bottom: MediaQuery.of(context).size.height * 0.1,
          left: 16,
          right: 16,
        ),
      ),
    );
  }

  /// Affiche un message de succès.
  void _showSuccessMessage(String text) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle, color: AppColors.textOnDark, size: 20),
            const SizedBox(width: 12),
            Text(text),
          ],
        ),
        backgroundColor: AppColors.success,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }
}
