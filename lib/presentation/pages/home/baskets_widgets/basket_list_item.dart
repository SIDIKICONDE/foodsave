import 'package:flutter/material.dart';
import 'package:foodsave_app/core/constants/app_colors.dart';
import 'package:foodsave_app/core/constants/app_dimensions.dart';
import 'package:foodsave_app/core/constants/app_text_styles.dart';

/// Élément de la liste des paniers disponibles.
///
/// Affiche les détails d'un panier anti-gaspi avec prix, horaires et bouton de réservation.
class BasketListItem extends StatelessWidget {
  /// Crée une nouvelle instance de [BasketListItem].
  ///
  /// [storeName] : Nom du commerce.
  /// [price] : Prix du panier.
  /// [originalPrice] : Prix original avant réduction.
  /// [description] : Description du panier.
  /// [pickupTime] : Horaires de récupération.
  /// [hasLastChanceBadge] : Indique si le badge "Dernière chance" doit être affiché.
  const BasketListItem({
    super.key,
    required this.storeName,
    required this.price,
    required this.originalPrice,
    required this.description,
    required this.pickupTime,
    this.hasLastChanceBadge = false,
  });

  /// Nom du commerce.
  final String storeName;

  /// Prix du panier.
  final String price;

  /// Prix original avant réduction.
  final String originalPrice;

  /// Description du panier.
  final String description;

  /// Horaires de récupération.
  final String pickupTime;

  /// Indique si le badge "Dernière chance" doit être affiché.
  final bool hasLastChanceBadge;

  @override
  Widget build(BuildContext context) {
    // Utilisation des constantes responsives
    final screenWidth = MediaQuery.of(context).size.width;
    final responsiveSpacing = AppDimensions.getResponsiveSpacing(screenWidth);
    final responsiveIconSize = AppDimensions.getResponsiveIconSize(screenWidth, AppDimensions.iconS);

    return Container(
      margin: EdgeInsets.only(bottom: responsiveSpacing),
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
      ),
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(responsiveSpacing),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        storeName,
                        style: AppTextStyles.headline6.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    if (hasLastChanceBadge)
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: responsiveSpacing * 0.5,
                          vertical: AppDimensions.spacingXs,
                        ),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              AppColors.error,
                              AppColors.error.withValues(alpha: 0.8),
                            ],
                          ),
                          borderRadius: BorderRadius.circular(AppDimensions.radiusS),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.error.withValues(alpha: 0.3),
                              blurRadius: 4,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Text(
                          'Dernière chance',
                          style: AppTextStyles.labelSmall.copyWith(
                            color: AppColors.textOnDark,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                  ],
                ),
                SizedBox(height: responsiveSpacing * 0.5),
                Text(
                  description,
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
                SizedBox(height: responsiveSpacing),
                Row(
                  children: [
                    Icon(
                      Icons.schedule,
                      size: responsiveIconSize,
                      color: AppColors.textSecondary,
                    ),
                    SizedBox(width: responsiveSpacing * 0.25),
                    Text(
                      'Récupération : $pickupTime',
                      style: AppTextStyles.bodySmall.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: responsiveSpacing * 1.5),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          price,
                          style: AppTextStyles.headline5.copyWith(
                            color: AppColors.primary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          'au lieu de $originalPrice',
                          style: AppTextStyles.bodySmall.copyWith(
                            color: AppColors.textSecondary,
                            decoration: TextDecoration.lineThrough,
                          ),
                        ),
                      ],
                    ),
                    Container(
                      decoration: BoxDecoration(
                        gradient: AppColors.primaryGradient,
                        borderRadius: BorderRadius.circular(AppDimensions.radiusM),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.primary.withValues(alpha: 0.3),
                            blurRadius: 8,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: ElevatedButton.icon(
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('🛒 Réservation de $storeName'),
                              backgroundColor: AppColors.success,
                              behavior: SnackBarBehavior.floating,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          );
                        },
                        icon: Icon(
                          Icons.add_shopping_cart,
                          size: responsiveIconSize,
                          color: AppColors.textOnDark,
                        ),
                        label: Text(
                          'Réserver',
                          style: AppTextStyles.buttonPrimary,
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          foregroundColor: AppColors.textOnDark,
                          shadowColor: Colors.transparent,
                          padding: EdgeInsets.symmetric(
                            horizontal: responsiveSpacing,
                            vertical: responsiveSpacing * 0.6,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
