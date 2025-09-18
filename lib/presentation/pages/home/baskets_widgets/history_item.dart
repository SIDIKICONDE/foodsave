import 'package:flutter/material.dart';
import 'package:foodsave_app/core/constants/app_colors.dart';
import 'package:foodsave_app/core/constants/app_dimensions.dart';
import 'package:foodsave_app/core/constants/app_text_styles.dart';

/// Élément de l'historique des paniers récupérés.
///
/// Affiche les détails d'un panier récupéré avec date, prix et note.
class HistoryItem extends StatelessWidget {
  /// Crée une nouvelle instance de [HistoryItem].
  ///
  /// [storeName] : Nom du commerce.
  /// [price] : Prix du panier récupéré.
  /// [date] : Date de récupération.
  /// [rating] : Note donnée au panier.
  const HistoryItem({
    super.key,
    required this.storeName,
    required this.price,
    required this.date,
    required this.rating,
  });

  /// Nom du commerce.
  final String storeName;

  /// Prix du panier récupéré.
  final String price;

  /// Date de récupération.
  final String date;

  /// Note donnée au panier.
  final String rating;

  @override
  Widget build(BuildContext context) {
    // Utilisation des constantes responsives
    final screenWidth = MediaQuery.of(context).size.width;
    final responsiveSpacing = AppDimensions.getResponsiveSpacing(screenWidth);
    final responsiveIconSize = AppDimensions.getResponsiveIconSize(screenWidth, AppDimensions.iconS);

    return Container(
      margin: EdgeInsets.only(bottom: responsiveSpacing),
      padding: EdgeInsets.all(responsiveSpacing),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppDimensions.radiusL),
        boxShadow: const [
          BoxShadow(
            color: AppColors.shadow,
            blurRadius: AppDimensions.elevationCard,
            offset: Offset(0, 2),
          ),
        ],
        border: Border.all(
          color: AppColors.border.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                storeName,
                style: AppTextStyles.headline6.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: responsiveSpacing * 0.6,
                  vertical: responsiveSpacing * 0.3,
                ),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      AppColors.warning,
                      AppColors.warning.withValues(alpha: 0.8),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(AppDimensions.radiusM),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.warning.withValues(alpha: 0.3),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.star,
                      size: responsiveIconSize,
                      color: AppColors.textOnDark,
                    ),
                    SizedBox(width: responsiveSpacing * 0.25),
                    Text(
                      rating,
                      style: AppTextStyles.bodySmall.copyWith(
                        color: AppColors.textOnDark,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: responsiveSpacing * 0.5),
          Row(
            children: [
              Icon(
                Icons.history,
                size: responsiveIconSize,
                color: AppColors.textSecondary,
              ),
              SizedBox(width: responsiveSpacing * 0.25),
              Text(
                date,
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
          SizedBox(height: responsiveSpacing * 1.5),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                price,
                style: AppTextStyles.headline6.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(AppDimensions.radiusM),
                  border: Border.all(
                    color: AppColors.primary.withValues(alpha: 0.3),
                    width: 1,
                  ),
                ),
                child: TextButton.icon(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: const Text('⭐ Noter ce panier'),
                        backgroundColor: AppColors.warning,
                        behavior: SnackBarBehavior.floating,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    );
                  },
                  icon: Icon(
                    Icons.star_border,
                    size: responsiveIconSize,
                    color: AppColors.warning,
                  ),
                  label: Text(
                    'Noter',
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: AppColors.warning,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.symmetric(
                      horizontal: responsiveSpacing * 0.8,
                      vertical: responsiveSpacing * 0.4,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
