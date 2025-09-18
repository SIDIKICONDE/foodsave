import 'package:flutter/material.dart';
import 'package:foodsave_app/core/constants/app_colors.dart';
import 'package:foodsave_app/core/constants/app_dimensions.dart';
import 'package:foodsave_app/core/constants/app_text_styles.dart';
import 'package:foodsave_app/presentation/pages/home/baskets_widgets/history_item.dart';

/// Section de l'historique des paniers récupérés.
///
/// Affiche l'historique des paniers récupérés avec leurs notes.
class HistorySection extends StatefulWidget {
  /// Crée une nouvelle instance de [HistorySection].
  const HistorySection({super.key});

  @override
  State<HistorySection> createState() => _HistorySectionState();
}

class _HistorySectionState extends State<HistorySection>
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
          index * 0.25,
          (index + 1) * 0.25 + 0.25,
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
          index * 0.25,
          (index + 1) * 0.25 + 0.25,
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
                  AppColors.info.withValues(alpha: 0.1),
                  AppColors.primary.withValues(alpha: 0.08),
                ],
              ),
              borderRadius: BorderRadius.circular(AppDimensions.radiusL),
              border: Border.all(
                color: AppColors.info.withValues(alpha: 0.2),
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
                        AppColors.info,
                        AppColors.info.withValues(alpha: 0.8),
                      ],
                    ),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.info.withValues(alpha: 0.3),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Icon(
                    Icons.history,
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
                        'Historique',
                        style: AppTextStyles.headline5.copyWith(
                          color: AppColors.info,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: responsiveSpacing * 0.3),
                      Text(
                        'Vos paniers récupérés et vos notes',
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                // Badge avec le nombre total récupéré
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
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.star,
                        size: 14,
                        color: AppColors.textOnDark,
                      ),
                      SizedBox(width: responsiveSpacing * 0.25),
                      Text(
                        '4.8',
                        style: AppTextStyles.bodySmall.copyWith(
                          color: AppColors.textOnDark,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Liste animée de l'historique
          AnimatedBuilder(
            animation: _animationController,
            builder: (context, child) {
              return Column(
                children: List.generate(3, (index) {
                  final historyData = [
                    {
                      'storeName': 'Supermarché Local',
                      'price': '5,99€',
                      'date': 'Récupéré le 15/01/2024',
                      'rating': '4.5',
                    },
                    {
                      'storeName': 'Café des Arts',
                      'price': '3,50€',
                      'date': 'Récupéré le 12/01/2024',
                      'rating': '5.0',
                    },
                    {
                      'storeName': 'Fromager du Marché',
                      'price': '6,50€',
                      'date': 'Récupéré le 10/01/2024',
                      'rating': '4.8',
                    },
                  ][index];

                  return FadeTransition(
                    opacity: _fadeAnimations[index],
                    child: SlideTransition(
                      position: _slideAnimations[index],
                      child: Padding(
                        padding: EdgeInsets.only(bottom: responsiveSpacing),
                        child: HistoryItem(
                          storeName: historyData['storeName'] as String,
                          price: historyData['price'] as String,
                          date: historyData['date'] as String,
                          rating: historyData['rating'] as String,
                        ),
                      ),
                    ),
                  );
                }),
              );
            },
          ),

          // Statistiques de l'historique
          Container(
            margin: EdgeInsets.only(top: responsiveSpacing),
            padding: EdgeInsets.all(responsiveSpacing),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  AppColors.success.withValues(alpha: 0.1),
                  AppColors.eco.withValues(alpha: 0.08),
                ],
              ),
              borderRadius: BorderRadius.circular(AppDimensions.radiusL),
              border: Border.all(
                color: AppColors.success.withValues(alpha: 0.2),
                width: 1,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.trending_up,
                      color: AppColors.success,
                      size: 20,
                    ),
                    SizedBox(width: responsiveSpacing * 0.5),
                    Text(
                      'Vos statistiques',
                      style: AppTextStyles.bodyLarge.copyWith(
                        color: AppColors.success,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: responsiveSpacing),
                Row(
                  children: [
                    Expanded(
                      child: _buildStatItem(
                        '12',
                        'Paniers récupérés',
                        Icons.shopping_bag,
                        AppColors.primary,
                      ),
                    ),
                    Expanded(
                      child: _buildStatItem(
                        '€89.50',
                        'Économisés',
                        Icons.savings,
                        AppColors.success,
                      ),
                    ),
                    Expanded(
                      child: _buildStatItem(
                        '4.8',
                        'Note moyenne',
                        Icons.star,
                        AppColors.warning,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Message d'encouragement
          Container(
            margin: EdgeInsets.only(top: responsiveSpacing),
            padding: EdgeInsets.all(responsiveSpacing),
            decoration: BoxDecoration(
              color: AppColors.success.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(AppDimensions.radiusM),
              border: Border.all(
                color: AppColors.success.withValues(alpha: 0.2),
                width: 1,
              ),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.celebration,
                  color: AppColors.success,
                  size: 20,
                ),
                SizedBox(width: responsiveSpacing * 0.8),
                Expanded(
                  child: Text(
                    '🎉 Merci d\'aider à réduire le gaspillage alimentaire !',
                    style: AppTextStyles.bodySmall.copyWith(
                      color: AppColors.success,
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

  Widget _buildStatItem(String value, String label, IconData icon, Color color) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            icon,
            color: color,
            size: 20,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: AppTextStyles.headline6.copyWith(
            color: color,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: AppTextStyles.bodySmall.copyWith(
            color: AppColors.textSecondary,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
