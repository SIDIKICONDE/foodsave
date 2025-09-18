import 'package:flutter/material.dart';
import 'package:foodsave_app/core/constants/app_constants.dart';
import 'package:foodsave_app/core/constants/app_colors.dart';
import 'package:foodsave_app/core/constants/app_dimensions.dart';
import 'package:foodsave_app/core/constants/app_text_styles.dart';
import 'package:foodsave_app/presentation/pages/home/social_widgets/social_widgets.dart';

/// Page sociale avec communauté, partages et invitations.
///
/// Cette page permet aux utilisateurs d'interagir avec la communauté FoodSave,
/// partager des paniers, inviter des amis et consulter le blog anti-gaspi.
class SocialPage extends StatefulWidget {
  /// Crée une nouvelle instance de [SocialPage].
  const SocialPage({super.key});

  @override
  State<SocialPage> createState() => _SocialPageState();
}

class _SocialPageState extends State<SocialPage> with TickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Utilisation des constantes responsives
    final screenWidth = MediaQuery.of(context).size.width;
    final responsiveSpacing = AppDimensions.getResponsiveSpacing(screenWidth);

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: _buildAppBar(),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppColors.primary.withValues(alpha: 0.05),
              AppColors.background,
              AppColors.background,
            ],
          ),
        ),
        child: TabBarView(
          controller: _tabController,
          children: [
            _buildCommunityTab(responsiveSpacing),
            _buildFriendsTab(responsiveSpacing),
            _buildBlogTab(responsiveSpacing),
          ],
        ),
      ),
      floatingActionButton: _buildFloatingActionButton(),
    );
  }

  /// Construit la barre d'application avec les onglets.
  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: AppColors.primary.withValues(alpha: 0.9),
      elevation: 0,
      flexibleSpace: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppColors.primary.withValues(alpha: 0.9),
              AppColors.primary.withValues(alpha: 0.7),
            ],
          ),
        ),
      ),
      title: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.surface.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              Icons.people,
              color: AppColors.textOnDark,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Text(
            AppConstants.socialTabLabel,
            style: AppTextStyles.headline6.copyWith(
              color: AppColors.textOnDark,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
      actions: [
        IconButton(
          icon: Icon(
            Icons.notifications,
            color: AppColors.textOnDark,
            size: 24,
          ),
          onPressed: () {
            // TODO: Implémenter les notifications
          },
        ),
        const SizedBox(width: 8),
      ],
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(48),
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: AppColors.surface.withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(25),
            border: Border.all(
              color: AppColors.surface.withValues(alpha: 0.2),
              width: 1,
            ),
          ),
          child: TabBar(
            controller: _tabController,
            labelColor: AppColors.textOnDark,
            unselectedLabelColor: AppColors.textOnDark.withValues(alpha: 0.7),
            labelStyle: AppTextStyles.bodyMedium.copyWith(
              fontWeight: FontWeight.w600,
            ),
            unselectedLabelStyle: AppTextStyles.bodyMedium,
            indicator: BoxDecoration(
              color: AppColors.surface.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: AppColors.surface.withValues(alpha: 0.4),
                width: 1,
              ),
            ),
            indicatorSize: TabBarIndicatorSize.tab,
            tabs: const [
              Tab(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.group, size: 16),
                    SizedBox(width: 4),
                    Text('Communauté'),
                  ],
                ),
              ),
              Tab(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.people, size: 16),
                    SizedBox(width: 4),
                    Text('Amis'),
                  ],
                ),
              ),
              Tab(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.article, size: 16),
                    SizedBox(width: 4),
                    Text('Blog'),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Construit le bouton d'action flottant.
  Widget _buildFloatingActionButton() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.primary,
            AppColors.primary.withValues(alpha: 0.8),
          ],
        ),
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.3),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: FloatingActionButton(
        onPressed: () {
          _showShareBottomSheet();
        },
        backgroundColor: Colors.transparent,
        foregroundColor: AppColors.textOnDark,
        elevation: 0,
        child: Icon(
          Icons.share,
          size: 24,
        ),
      ),
    );
  }

  /// Construit l'onglet communauté.
  Widget _buildCommunityTab(double responsiveSpacing) {
    return SingleChildScrollView(
      padding: EdgeInsets.only(
        top: kToolbarHeight + 80, // Espace pour l'AppBar transparente avec les onglets
        left: responsiveSpacing,
        right: responsiveSpacing,
        bottom: responsiveSpacing,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const CommunityStats(),
          SizedBox(height: responsiveSpacing * 1.5),
          const RecentActivity(),
          SizedBox(height: responsiveSpacing * 1.5),
          const ChallengesSection(),
        ],
      ),
    );
  }

  /// Construit l'onglet amis.
  Widget _buildFriendsTab(double responsiveSpacing) {
    return SingleChildScrollView(
      padding: EdgeInsets.only(
        top: kToolbarHeight + 80, // Espace pour l'AppBar transparente avec les onglets
        left: responsiveSpacing,
        right: responsiveSpacing,
        bottom: responsiveSpacing,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const InviteFriendsCard(),
          SizedBox(height: responsiveSpacing * 1.5),
          const FriendsList(),
        ],
      ),
    );
  }

  /// Construit l'onglet blog.
  Widget _buildBlogTab(double responsiveSpacing) {
    return SingleChildScrollView(
      padding: EdgeInsets.only(
        top: kToolbarHeight + 80, // Espace pour l'AppBar transparente avec les onglets
        left: responsiveSpacing,
        right: responsiveSpacing,
        bottom: responsiveSpacing,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.all(responsiveSpacing),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  AppColors.primary.withValues(alpha: 0.1),
                  AppColors.primary.withValues(alpha: 0.05),
                ],
              ),
              borderRadius: BorderRadius.circular(AppDimensions.radiusL),
              border: Border.all(
                color: AppColors.primary.withValues(alpha: 0.2),
                width: 1,
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        AppColors.primary,
                        AppColors.primary.withValues(alpha: 0.8),
                      ],
                    ),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primary.withValues(alpha: 0.3),
                        blurRadius: 8,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Icon(
                    Icons.restaurant_menu,
                    color: AppColors.textOnDark,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    'Recettes et astuces anti-gaspi',
                    style: AppTextStyles.headline5.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: responsiveSpacing * 1.5),
          BlogPost(
            title: 'Comment cuisiner avec des légumes défraîchis',
            excerpt: 'Des astuces pour donner une seconde vie à vos légumes...',
            imagePath: 'assets/images/vegetables.jpg',
          ),
          SizedBox(height: responsiveSpacing),
          BlogPost(
            title: 'Recette : Pain perdu revisité',
            excerpt: 'Transformez votre pain dur en délicieux dessert...',
            imagePath: 'assets/images/bread.jpg',
          ),
          SizedBox(height: responsiveSpacing),
          BlogPost(
            title: '10 conseils pour réduire le gaspillage',
            excerpt: 'Des gestes simples pour un mode de vie durable...',
            imagePath: 'assets/images/tips.jpg',
          ),
        ],
      ),
    );
  }

  /// Affiche la bottom sheet de partage.
  void _showShareBottomSheet() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppDimensions.radiusL),
        ),
      ),
      builder: (context) => const ShareBottomSheet(),
    );
  }
}