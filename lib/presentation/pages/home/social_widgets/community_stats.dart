import 'package:flutter/material.dart';
import 'package:foodsave_app/core/constants/app_colors.dart';
import 'package:foodsave_app/core/constants/app_dimensions.dart';
import 'package:foodsave_app/core/constants/app_text_styles.dart';

/// Section des statistiques communautaires.
///
/// Affiche l'impact collectif de la semaine avec les métriques principales.
class CommunityStats extends StatefulWidget {
  /// Crée une nouvelle instance de [CommunityStats].
  const CommunityStats({super.key});

  @override
  State<CommunityStats> createState() => _CommunityStatsState();
}

class _CommunityStatsState extends State<CommunityStats> with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: const Interval(0.0, 0.6, curve: Curves.easeOut),
    ));

    _scaleAnimation = Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: const Interval(0.2, 1.0, curve: Curves.elasticOut),
    ));

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return FadeTransition(
          opacity: _fadeAnimation,
          child: Transform.scale(
            scale: _scaleAnimation.value,
            child: _buildContent(),
          ),
        );
      },
    );
  }

  Widget _buildContent() {
    return Container(
      padding: const EdgeInsets.all(AppDimensions.spacingL),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.lighten(AppColors.success, 0.9),
            AppColors.lighten(AppColors.success, 0.8),
          ],
        ),
        borderRadius: BorderRadius.circular(AppDimensions.radiusL),
        border: Border.all(
          color: AppColors.lighten(AppColors.success, 0.7),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.success.withValues(alpha: 0.2),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            'Impact collectif cette semaine',
            style: AppTextStyles.headline6.copyWith(
              color: AppColors.success,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppDimensions.spacingL),
          Row(
            children: [
              Expanded(
                child: _buildCommunityStatItem(
                  '847',
                  'kg sauvés',
                  Icons.scale,
                ),
              ),
              Container(
                width: 1,
                height: 60,
                color: AppColors.lighten(AppColors.success, 0.7),
              ),
              Expanded(
                child: _buildCommunityStatItem(
                  '1,203',
                  'paniers récupérés',
                  Icons.shopping_basket,
                ),
              ),
              Container(
                width: 1,
                height: 60,
                color: AppColors.lighten(AppColors.success, 0.7),
              ),
              Expanded(
                child: _buildCommunityStatItem(
                  '2,341',
                  'membres actifs',
                  Icons.people,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// Construit un élément de statistique communautaire.
  Widget _buildCommunityStatItem(String value, String label, IconData icon) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppColors.success.withValues(alpha: 0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(
            icon,
            size: AppDimensions.iconM,
            color: AppColors.success,
          ),
        ),
        const SizedBox(height: AppDimensions.spacingS),
        Text(
          value,
          style: AppTextStyles.headline5.copyWith(
            color: AppColors.success,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: AppTextStyles.bodySmall.copyWith(
            color: AppColors.darken(AppColors.success, 0.3),
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
