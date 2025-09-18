import 'package:flutter/material.dart';
import 'package:foodsave_app/core/constants/app_colors.dart';
import 'package:foodsave_app/core/constants/app_dimensions.dart';
import 'package:foodsave_app/core/constants/app_text_styles.dart';

/// Carte affichant les statistiques écologiques de l'utilisateur.
/// 
/// Montre l'impact positif de l'utilisateur sur l'environnement
/// grâce à ses achats de paniers anti-gaspi.
class EcoStatsCard extends StatefulWidget {
  /// Crée une nouvelle instance de [EcoStatsCard].
  const EcoStatsCard({super.key});

  @override
  State<EcoStatsCard> createState() => _EcoStatsCardState();
}

class _EcoStatsCardState extends State<EcoStatsCard>
    with TickerProviderStateMixin {
  /// Contrôleur pour l'animation de compteur.
  late final AnimationController _counterController;
  
  /// Animation pour les valeurs numériques.
  late final Animation<double> _counterAnimation;
  
  /// Contrôleur pour l'animation de rotation.
  late final AnimationController _rotationController;

  @override
  void initState() {
    super.initState();
    _setupAnimations();
  }

  /// Configure les animations.
  void _setupAnimations() {
    _counterController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );

    _counterAnimation = CurvedAnimation(
      parent: _counterController,
      curve: Curves.easeOutCubic,
    );

    _rotationController = AnimationController(
      duration: const Duration(seconds: 20),
      vsync: this,
    );

    _counterController.forward();
    _rotationController.repeat();
  }

  @override
  void dispose() {
    _counterController.dispose();
    _rotationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: AppDimensions.spacingL,
        vertical: AppDimensions.spacingM,
      ),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.eco,
            AppColors.eco.withValues(alpha: 0.8),
          ],
        ),
        borderRadius: BorderRadius.circular(AppDimensions.radiusXL),
        boxShadow: [
          BoxShadow(
            color: AppColors.eco.withValues(alpha: 0.3),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Stack(
        children: [
          // Motif décoratif de fond
          _buildBackgroundPattern(),
          
          // Contenu principal
          Padding(
            padding: const EdgeInsets.all(AppDimensions.spacingL),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // En-tête
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(AppDimensions.spacingS),
                      decoration: BoxDecoration(
                        color: AppColors.surface.withValues(alpha: 0.2),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.eco,
                        color: AppColors.textOnDark,
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: AppDimensions.spacingM),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Votre impact écologique',
                            style: AppTextStyles.headline6.copyWith(
                              color: AppColors.textOnDark,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            'Ce mois-ci',
                            style: AppTextStyles.bodySmall.copyWith(
                              color: AppColors.textOnDark.withValues(alpha: 0.8),
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      onPressed: _showDetails,
                      icon: Icon(
                        Icons.info_outline,
                        color: AppColors.textOnDark.withValues(alpha: 0.8),
                      ),
                    ),
                  ],
                ),
                
                const SizedBox(height: AppDimensions.spacingL),
                
                // Statistiques
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildStatItem(
                      icon: Icons.shopping_bag,
                      value: 12,
                      label: 'Paniers sauvés',
                    ),
                    _buildStatItem(
                      icon: Icons.restaurant_menu,
                      value: 36,
                      label: 'Kg de nourriture',
                    ),
                    _buildStatItem(
                      icon: Icons.co2,
                      value: 48,
                      label: 'Kg CO₂ évités',
                    ),
                  ],
                ),
                
                const SizedBox(height: AppDimensions.spacingL),
                
                // Barre de progression
                _buildProgressBar(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Construit le motif de fond.
  Widget _buildBackgroundPattern() {
    return Positioned(
      right: -50,
      top: -50,
      child: RotationTransition(
        turns: _rotationController,
        child: Icon(
          Icons.eco,
          size: 200,
          color: AppColors.surface.withValues(alpha: 0.05),
        ),
      ),
    );
  }

  /// Construit un élément de statistique.
  Widget _buildStatItem({
    required IconData icon,
    required int value,
    required String label,
  }) {
    return AnimatedBuilder(
      animation: _counterAnimation,
      builder: (context, child) {
        final animatedValue = (value * _counterAnimation.value).round();
        
        return Column(
          children: [
            Container(
              padding: const EdgeInsets.all(AppDimensions.spacingS),
              decoration: BoxDecoration(
                color: AppColors.surface.withValues(alpha: 0.15),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                color: AppColors.textOnDark,
                size: 20,
              ),
            ),
            const SizedBox(height: AppDimensions.spacingS),
            Text(
              '$animatedValue',
              style: AppTextStyles.headline4.copyWith(
                color: AppColors.textOnDark,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              label,
              style: AppTextStyles.labelSmall.copyWith(
                color: AppColors.textOnDark.withValues(alpha: 0.9),
              ),
              textAlign: TextAlign.center,
            ),
          ],
        );
      },
    );
  }

  /// Construit la barre de progression.
  Widget _buildProgressBar() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Objectif mensuel',
              style: AppTextStyles.bodySmall.copyWith(
                color: AppColors.textOnDark.withValues(alpha: 0.9),
              ),
            ),
            Text(
              '60%',
              style: AppTextStyles.labelMedium.copyWith(
                color: AppColors.textOnDark,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const SizedBox(height: AppDimensions.spacingS),
        Container(
          height: 8,
          decoration: BoxDecoration(
            color: AppColors.surface.withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(4),
          ),
          child: AnimatedBuilder(
            animation: _counterAnimation,
            builder: (context, child) {
              return FractionallySizedBox(
                alignment: Alignment.centerLeft,
                widthFactor: 0.6 * _counterAnimation.value,
                child: Container(
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(4),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.surface.withValues(alpha: 0.3),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  /// Affiche les détails des statistiques.
  void _showDetails() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: const BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(AppDimensions.radiusXL),
          ),
        ),
        padding: const EdgeInsets.all(AppDimensions.spacingXL),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.divider,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: AppDimensions.spacingL),
            Icon(
              Icons.eco,
              color: AppColors.eco,
              size: 48,
            ),
            const SizedBox(height: AppDimensions.spacingL),
            Text(
              'Félicitations !',
              style: AppTextStyles.headline4.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: AppDimensions.spacingM),
            Text(
              'Grâce à vos actions, vous avez contribué à sauver '
              '36 kg de nourriture ce mois-ci, évitant ainsi '
              'l\'émission de 48 kg de CO₂.',
              style: AppTextStyles.bodyMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppDimensions.spacingXL),
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Compris !'),
            ),
          ],
        ),
      ),
    );
  }
}