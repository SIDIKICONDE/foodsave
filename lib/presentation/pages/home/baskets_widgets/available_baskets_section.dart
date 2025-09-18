import 'package:flutter/material.dart';
import 'package:foodsave_app/core/constants/app_colors.dart';
import 'package:foodsave_app/core/constants/app_dimensions.dart';
import 'package:foodsave_app/core/constants/app_text_styles.dart';
import 'package:foodsave_app/core/routes/app_routes.dart';
import 'basket_list_item.dart';

/// Section des paniers disponibles.
///
/// Affiche une liste des paniers anti-gaspi disponibles à la réservation.
class AvailableBasketsSection extends StatefulWidget {
  /// Crée une nouvelle instance de [AvailableBasketsSection].
  const AvailableBasketsSection({super.key});

  @override
  State<AvailableBasketsSection> createState() => _AvailableBasketsSectionState();
}

class _AvailableBasketsSectionState extends State<AvailableBasketsSection>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late List<Animation<double>> _fadeAnimations;
  late List<Animation<Offset>> _slideAnimations;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    // Créer des animations pour chaque élément
    _fadeAnimations = List.generate(3, (index) {
      return Tween<double>(
        begin: 0.0,
        end: 1.0,
      ).animate(CurvedAnimation(
        parent: _animationController,
        curve: Interval(
          index * 0.2,
          (index + 1) * 0.2 + 0.3,
          curve: Curves.easeOut,
        ),
      ));
    });

    _slideAnimations = List.generate(3, (index) {
      return Tween<Offset>(
        begin: const Offset(0, 0.2),
        end: Offset.zero,
      ).animate(CurvedAnimation(
        parent: _animationController,
        curve: Interval(
          index * 0.2,
          (index + 1) * 0.2 + 0.3,
          curve: Curves.easeOutBack,
        ),
      ));
    });

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Utilisation des constantes responsives
    final screenWidth = MediaQuery.of(context).size.width;
    final responsiveSpacing = AppDimensions.getResponsiveSpacing(screenWidth);

    return SingleChildScrollView(
      padding: EdgeInsets.all(responsiveSpacing),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header avec titre et statistiques
          Container(
            margin: EdgeInsets.only(bottom: responsiveSpacing * 1.5),
            padding: EdgeInsets.all(responsiveSpacing),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  AppColors.primary.withValues(alpha: 0.1),
                  AppColors.secondary.withValues(alpha: 0.08),
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
                    gradient: AppColors.primaryGradient,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primary.withValues(alpha: 0.3),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Icon(
                    Icons.inventory_2,
                    color: AppColors.textOnDark,
                    size: 24,
                  ),
                ),
                SizedBox(width: responsiveSpacing),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Paniers Disponibles',
                        style: AppTextStyles.headline5.copyWith(
                          color: AppColors.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: responsiveSpacing * 0.3),
                      Text(
                        'Découvrez les paniers anti-gaspi près de chez vous',
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                // Badge avec le nombre de paniers
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: responsiveSpacing * 0.8,
                    vertical: responsiveSpacing * 0.4,
                  ),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        AppColors.success,
                        AppColors.eco,
                      ],
                    ),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.success.withValues(alpha: 0.3),
                        blurRadius: 6,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Text(
                    '3',
                    style: AppTextStyles.bodySmall.copyWith(
                      color: AppColors.textOnDark,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Liste animée des paniers
          AnimatedBuilder(
            animation: _animationController,
            builder: (context, child) {
              return Column(
                children: List.generate(3, (index) {
                  final basketData = [
                    {
                      'storeName': 'Boulangerie du Coin',
                      'price': '4,99€',
                      'originalPrice': '18,00€',
                      'description': 'Viennoiseries et pains du jour',
                      'pickupTime': '12:00 - 18:00',
                      'hasLastChanceBadge': true,
                    },
                    {
                      'storeName': 'Fruits & Légumes Bio',
                      'price': '7,50€',
                      'originalPrice': '22,00€',
                      'description': 'Fruits et légumes de saison',
                      'pickupTime': '16:00 - 19:00',
                      'hasLastChanceBadge': false,
                    },
                    {
                      'storeName': 'Restaurant Chez Marie',
                      'price': '6,00€',
                      'originalPrice': '25,00€',
                      'description': 'Plats cuisinés maison',
                      'pickupTime': '19:30 - 21:00',
                      'hasLastChanceBadge': true,
                    },
                  ][index];

                  return FadeTransition(
                    opacity: _fadeAnimations[index],
                    child: SlideTransition(
                      position: _slideAnimations[index],
                      child: Padding(
                        padding: EdgeInsets.only(bottom: responsiveSpacing),
                        child: BasketListItem(
                          storeName: basketData['storeName'] as String,
                          price: basketData['price'] as String,
                          originalPrice: basketData['originalPrice'] as String,
                          description: basketData['description'] as String,
                          pickupTime: basketData['pickupTime'] as String,
                          hasLastChanceBadge: basketData['hasLastChanceBadge'] as bool,
                        ),
                      ),
                    ),
                  );
                }),
              );
            },
          ),

          // Bouton "Voir tous les paniers"
          Container(
            margin: EdgeInsets.only(top: responsiveSpacing * 1.5),
            width: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: [
                  AppColors.secondary.withValues(alpha: 0.1),
                  AppColors.primary.withValues(alpha: 0.1),
                ],
              ),
              borderRadius: BorderRadius.circular(AppDimensions.radiusL),
              border: Border.all(
                color: AppColors.primary.withValues(alpha: 0.2),
                width: 1.5,
              ),
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () {
                  AppRoutes.navigateToAllBaskets(context);
                },
                borderRadius: BorderRadius.circular(AppDimensions.radiusL),
                child: Padding(
                  padding: EdgeInsets.all(responsiveSpacing),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          gradient: AppColors.primaryGradient,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.inventory_2,
                          color: AppColors.textOnDark,
                          size: 20,
                        ),
                      ),
                      SizedBox(width: responsiveSpacing),
                      Text(
                        'Voir tous les paniers disponibles',
                        style: AppTextStyles.labelLarge.copyWith(
                          color: AppColors.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(width: responsiveSpacing * 0.5),
                      Icon(
                        Icons.arrow_forward,
                        color: AppColors.primary,
                        size: 20,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          // Bouton "Voir sur la carte"
          Container(
            margin: EdgeInsets.only(top: responsiveSpacing),
            width: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: [
                  AppColors.eco.withValues(alpha: 0.1),
                  AppColors.success.withValues(alpha: 0.1),
                ],
              ),
              borderRadius: BorderRadius.circular(AppDimensions.radiusL),
              border: Border.all(
                color: AppColors.eco.withValues(alpha: 0.3),
                width: 1.5,
              ),
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () {
                  AppRoutes.navigateToMapPage(context);
                },
                borderRadius: BorderRadius.circular(AppDimensions.radiusL),
                child: Padding(
                  padding: EdgeInsets.all(responsiveSpacing),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              AppColors.eco,
                              AppColors.success,
                            ],
                          ),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.map,
                          color: AppColors.textOnDark,
                          size: 20,
                        ),
                      ),
                      SizedBox(width: responsiveSpacing),
                      Text(
                        'Voir sur la carte',
                        style: AppTextStyles.labelLarge.copyWith(
                          color: AppColors.eco,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(width: responsiveSpacing * 0.5),
                      Icon(
                        Icons.location_on,
                        color: AppColors.eco,
                        size: 20,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          // Message d'encouragement en bas
          Container(
            margin: EdgeInsets.only(top: responsiveSpacing),
            padding: EdgeInsets.all(responsiveSpacing),
            decoration: BoxDecoration(
              color: AppColors.info.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(AppDimensions.radiusM),
              border: Border.all(
                color: AppColors.info.withValues(alpha: 0.2),
                width: 1,
              ),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.lightbulb,
                  color: AppColors.info,
                  size: 20,
                ),
                SizedBox(width: responsiveSpacing * 0.8),
                Expanded(
                  child: Text(
                    '💡 Réservez tôt pour éviter les déceptions !',
                    style: AppTextStyles.bodySmall.copyWith(
                      color: AppColors.info,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
