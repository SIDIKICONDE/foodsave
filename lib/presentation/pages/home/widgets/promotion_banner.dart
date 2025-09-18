import 'package:flutter/material.dart';
import 'package:foodsave_app/core/constants/app_colors.dart';
import 'package:foodsave_app/core/constants/app_dimensions.dart';
import 'package:foodsave_app/core/constants/app_text_styles.dart';

/// Bannière promotionnelle animée.
/// 
/// Affiche les offres spéciales et promotions en cours
/// avec des animations attractives.
class PromotionBanner extends StatefulWidget {
  /// Crée une nouvelle instance de [PromotionBanner].
  const PromotionBanner({super.key});

  @override
  State<PromotionBanner> createState() => _PromotionBannerState();
}

class _PromotionBannerState extends State<PromotionBanner>
    with SingleTickerProviderStateMixin {
  /// Contrôleur pour l'animation de pulsation.
  late final AnimationController _pulseController;
  
  /// Animation de pulsation.
  late final Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _setupAnimation();
  }

  /// Configure l'animation.
  void _setupAnimation() {
    _pulseController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );

    _pulseAnimation = Tween<double>(
      begin: 0.99,
      end: 1.01,
    ).animate(
      CurvedAnimation(
        parent: _pulseController,
        curve: Curves.easeInOut,
      ),
    );

    _pulseController.repeat(reverse: true);
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: AppDimensions.spacingL,
        vertical: AppDimensions.spacingS,
      ),
      child: AnimatedBuilder(
        animation: _pulseAnimation,
        builder: (context, child) {
          return Transform.scale(
            scale: _pulseAnimation.value,
            child: GestureDetector(
              onTap: _onBannerTap,
              child: Container(
                padding: const EdgeInsets.all(AppDimensions.spacingM),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      AppColors.promotion,
                      AppColors.promotion.withValues(alpha: 0.8),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(AppDimensions.radiusL),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.promotion.withValues(alpha: 0.25),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Stack(
                  children: [
                    // Motif décoratif
                    Positioned(
                      right: -20,
                      bottom: -20,
                      child: Icon(
                        Icons.celebration,
                        size: 100,
                        color: AppColors.surface.withValues(alpha: 0.1),
                      ),
                    ),
                    
                    // Contenu
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: AppDimensions.spacingS,
                                vertical: AppDimensions.spacingXs,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.surface.withValues(alpha: 0.2),
                                borderRadius: BorderRadius.circular(
                                  AppDimensions.radiusM,
                                ),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(
                                    Icons.local_offer,
                                    color: AppColors.textOnDark,
                                    size: 16,
                                  ),
                                  const SizedBox(width: AppDimensions.spacingS),
                                  Text(
                                    'OFFRE LIMITÉE',
                                    style: AppTextStyles.labelMedium.copyWith(
                                      color: AppColors.textOnDark,
                                      fontWeight: FontWeight.bold,
                                      letterSpacing: 1.5,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const Spacer(),
                            Container(
                              padding: const EdgeInsets.all(AppDimensions.spacingXs),
                              decoration: BoxDecoration(
                                color: AppColors.surface.withValues(alpha: 0.15),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.arrow_forward,
                                color: AppColors.textOnDark,
                                size: 18,
                              ),
                            ),
                          ],
                        ),
                        
                        const SizedBox(height: AppDimensions.spacingS),
                        
                        Text(
                          '50% de réduction',
                          style: AppTextStyles.headline5.copyWith(
                            color: AppColors.textOnDark,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        
                        const SizedBox(height: AppDimensions.spacingXs),
                        
                        Text(
                          'Sur votre premier panier',
                          style: AppTextStyles.bodyLarge.copyWith(
                            color: AppColors.textOnDark.withValues(alpha: 0.9),
                          ),
                        ),
                        
                        const SizedBox(height: AppDimensions.spacingS),
                        
                        Row(
                          children: [
                            Icon(
                              Icons.timer,
                              color: AppColors.textOnDark.withValues(alpha: 0.8),
                              size: 14,
                            ),
                            const SizedBox(width: AppDimensions.spacingXs),
                            Text(
                              'Valable encore 2 jours',
                              style: AppTextStyles.bodySmall.copyWith(
                                color: AppColors.textOnDark.withValues(alpha: 0.8),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  /// Gère le tap sur la bannière.
  void _onBannerTap() {
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
              Icons.celebration,
              color: AppColors.promotion,
              size: 64,
            ),
            const SizedBox(height: AppDimensions.spacingL),
            Text(
              'Offre de bienvenue',
              style: AppTextStyles.headline4.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: AppDimensions.spacingM),
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppDimensions.spacingL,
                vertical: AppDimensions.spacingM,
              ),
              decoration: BoxDecoration(
                color: AppColors.promotion.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(AppDimensions.radiusL),
                border: Border.all(
                  color: AppColors.promotion.withValues(alpha: 0.3),
                  width: 1,
                ),
              ),
              child: Column(
                children: [
                  Text(
                    'Code promo',
                    style: AppTextStyles.bodySmall.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: AppDimensions.spacingS),
                  Text(
                    'BIENVENUE50',
                    style: AppTextStyles.headline5.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppColors.promotion,
                      letterSpacing: 2,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppDimensions.spacingM),
            Text(
              'Profitez de 50% de réduction sur votre premier '
              'panier anti-gaspi. Valable sur tous les commerces '
              'participants.',
              style: AppTextStyles.bodyMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppDimensions.spacingXL),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Plus tard'),
                  ),
                ),
                const SizedBox(width: AppDimensions.spacingM),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      _copyPromoCode();
                    },
                    child: const Text('Copier le code'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  /// Copie le code promo.
  void _copyPromoCode() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Row(
          children: [
            Icon(Icons.check_circle, color: AppColors.textOnDark, size: 20),
            SizedBox(width: 12),
            Text('Code promo copié !'),
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