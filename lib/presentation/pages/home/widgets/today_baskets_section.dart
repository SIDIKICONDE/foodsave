import 'package:flutter/material.dart';
import 'package:foodsave_app/core/constants/app_constants.dart';
import 'package:foodsave_app/core/constants/app_colors.dart';
import 'package:foodsave_app/core/constants/app_dimensions.dart';
import 'package:foodsave_app/core/constants/app_text_styles.dart';
import 'package:foodsave_app/presentation/pages/home/widgets/basket_card.dart';

/// Section des paniers du jour.
///
/// Affiche une liste horizontale des paniers disponibles aujourd'hui.
class TodayBasketsSection extends StatelessWidget {
  /// Crée une nouvelle instance de [TodayBasketsSection].
  const TodayBasketsSection({super.key});

  @override
  Widget build(BuildContext context) {
    // Utilisation des constantes responsives
    final screenWidth = MediaQuery.of(context).size.width;
    final responsiveSpacing = AppDimensions.getResponsiveSpacing(screenWidth);
    final responsiveIconSize = AppDimensions.getResponsiveIconSize(screenWidth, AppDimensions.iconM);

    return Container(
      padding: EdgeInsets.all(responsiveSpacing),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.surface.withValues(alpha: 0.8),
            AppColors.surfaceSecondary.withValues(alpha: 0.6),
          ],
        ),
        borderRadius: BorderRadius.circular(AppDimensions.radiusL),
        border: Border.all(
          color: AppColors.border.withValues(alpha: 0.3),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadowLight,
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  gradient: AppColors.primaryGradient,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.local_offer,
                  color: AppColors.textOnDark,
                  size: responsiveIconSize,
                ),
              ),
              SizedBox(width: responsiveSpacing),
              Text(
                AppConstants.todayBasketsTitle,
                style: AppTextStyles.headline5.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 600, // Hauteur augmentée pour plus de paniers
            child: GridView.builder(
              padding: EdgeInsets.zero,
              physics: const AlwaysScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: AppDimensions.isSmallScreen(screenWidth) ? 2 : 3,
                childAspectRatio: 0.75,
                crossAxisSpacing: 3,
                mainAxisSpacing: 3,
              ),
              itemCount: 12, // Plus de paniers pour démontrer le scroll
              itemBuilder: (context, index) {
                return BasketCard(
                  index: index % 3, // Cycle à travers les 3 types de paniers
                  isLast: false, // Plus nécessaire dans une grille
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
