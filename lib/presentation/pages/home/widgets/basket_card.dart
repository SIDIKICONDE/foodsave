import 'package:flutter/material.dart';
import 'package:foodsave_app/core/constants/app_colors.dart';
import 'package:foodsave_app/core/constants/app_dimensions.dart';
import 'package:foodsave_app/core/constants/app_text_styles.dart';

/// Carte représentant un panier disponible.
///
/// Affiche les informations essentielles d'un panier (nom, prix, prix original).
class BasketCard extends StatelessWidget {
  /// Crée une nouvelle instance de [BasketCard].
  ///
  /// [index] : Index du panier pour déterminer les données d'exemple.
  /// [isLast] : Indique si c'est le dernier élément de la liste.
  const BasketCard({
    super.key,
    required this.index,
    this.isLast = false,
  });

  /// Index du panier pour les données d'exemple.
  final int index;

  /// Indique si c'est le dernier élément de la liste.
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    final List<String> basketNames = ['Boulangerie Martin', 'Fruits & Bio', 'Chez Luigi'];
    final List<String> prices = ['4,50€', '6,00€', '8,50€'];
    final List<String> originalPrices = ['15,00€', '20,00€', '25,00€'];
    final List<Color> colors = [AppColors.primary, AppColors.secondary, AppColors.eco];

    // Utilisation des constantes responsives
    final screenWidth = MediaQuery.of(context).size.width;
    final responsiveIconSize = AppDimensions.getResponsiveIconSize(screenWidth, AppDimensions.iconM);

    return Card(
        elevation: 8,
        margin: EdgeInsets.zero, // Supprimer les marges par défaut
        shadowColor: colors[index].withValues(alpha: 0.3),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radiusL),
        ),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                AppColors.surface,
                AppColors.surfaceSecondary.withValues(alpha: 0.3),
              ],
            ),
            borderRadius: BorderRadius.circular(AppDimensions.radiusL),
            border: Border.all(
              color: colors[index].withValues(alpha: 0.2),
              width: 1,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header avec icône et badge promotionnel
              Expanded(
                flex: 8, // 80% de la hauteur pour l'image/visuel
                child: Stack(
                  children: [
                    ClipRRect(
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(AppDimensions.radiusL),
                        topRight: Radius.circular(AppDimensions.radiusL),
                      ),
                      child: Container(
                        width: double.infinity,
                        height: double.infinity,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              colors[index].withValues(alpha: 0.25),
                              colors[index].withValues(alpha: 0.15),
                            ],
                          ),
                        ),
                        child: Center(
                          child: Container(
                            width: 60,
                            height: 60,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [
                                  colors[index],
                                  colors[index].withValues(alpha: 0.8),
                                ],
                              ),
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: colors[index].withValues(alpha: 0.4),
                                  blurRadius: 12,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Icon(
                              index == 0 ? Icons.bakery_dining :
                              index == 1 ? Icons.apple : Icons.restaurant,
                              size: responsiveIconSize + 8,
                              color: AppColors.textOnDark,
                            ),
                          ),
                        ),
                      ),
                    ),
                    // Badge promotionnel
                    Positioned(
                      top: 8,
                      right: 8,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(colors: [AppColors.promotion, AppColors.promotion.withValues(alpha: 0.8)]),
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.promotion.withValues(alpha: 0.3),
                              blurRadius: 6,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Text(
                          '-70%',
                          style: AppTextStyles.bodySmall.copyWith(
                            color: AppColors.textOnDark,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                flex: 2, // 20% pour les infos + bouton
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(AppDimensions.spacingS, AppDimensions.spacingS, AppDimensions.spacingS, 6), // Padding bottom réduit
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Nom du commerce
                    Text(
                      basketNames[index],
                      style: AppTextStyles.bodyMedium.copyWith(
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: AppDimensions.spacingXs),

                    // Prix avec réduction
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.baseline,
                      textBaseline: TextBaseline.alphabetic,
                      children: [
                        Text(
                          prices[index],
                          style: AppTextStyles.headline6.copyWith(
                            color: AppColors.primary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(width: AppDimensions.spacingXs),
                        Expanded(
                          child: Text(
                            originalPrices[index],
                            style: AppTextStyles.bodySmall.copyWith(
                              color: AppColors.textSecondary,
                              decoration: TextDecoration.lineThrough,
                              decorationColor: AppColors.error,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 4),

                    // Bouton d'action compact
                    SizedBox(
                      width: double.infinity,
                      height: 28, // Hauteur fixe réduite
                      child: ElevatedButton(
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('🛒 ${basketNames[index]} ajouté au panier'),
                              backgroundColor: colors[index],
                              behavior: SnackBarBehavior.floating,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: colors[index],
                          foregroundColor: AppColors.textOnDark,
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(6),
                          ),
                          elevation: 2,
                          shadowColor: colors[index].withValues(alpha: 0.3),
                        ),
                        child: Text(
                          'Réserver',
                          style: AppTextStyles.bodySmall.copyWith(
                            color: AppColors.textOnDark,
                            fontWeight: FontWeight.w600,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ),
                  ],
                  ),
                ),
              ),
            ],
          ),
        ),
      );
  }
}
