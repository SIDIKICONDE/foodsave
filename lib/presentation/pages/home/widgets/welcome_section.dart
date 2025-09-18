import 'package:flutter/material.dart';
import 'package:foodsave_app/core/constants/app_constants.dart';
import 'package:foodsave_app/core/constants/app_colors.dart';
import 'package:foodsave_app/core/constants/app_dimensions.dart';
import 'package:foodsave_app/core/constants/app_text_styles.dart';

/// Section de bienvenue de la page de découverte.
///
/// Affiche un message de bienvenue personnalisé avec le titre et le sous-titre.
class WelcomeSection extends StatefulWidget {
  /// Crée une nouvelle instance de [WelcomeSection].
  const WelcomeSection({super.key});

  @override
  State<WelcomeSection> createState() => _WelcomeSectionState();
}

class _WelcomeSectionState extends State<WelcomeSection>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOut,
    ));

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOut,
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
    // Utilisation des constantes responsives
    final screenWidth = MediaQuery.of(context).size.width;
    final responsiveSpacing = AppDimensions.getResponsiveSpacing(screenWidth);
    final responsiveIconSize = AppDimensions.getResponsiveIconSize(screenWidth, AppDimensions.iconL);

    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return FadeTransition(
          opacity: _fadeAnimation,
          child: SlideTransition(
            position: _slideAnimation,
            child: Container(
              padding: EdgeInsets.all(responsiveSpacing * 0.4),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    AppColors.primary.withValues(alpha: 0.1),
                    AppColors.secondary.withValues(alpha: 0.05),
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
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.waving_hand,
                              color: AppColors.primary,
                              size: responsiveIconSize,
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                '${AppConstants.homeWelcomeTitle} !',
                                style: AppTextStyles.headline4.copyWith(
                                  color: AppColors.primary,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: AppDimensions.spacingXs),
                        Text(
                          AppConstants.homeSubtitle,
                          style: AppTextStyles.bodyLarge.copyWith(
                            color: AppColors.textSecondary,
                            height: 1.4,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: 45,
                    height: 45,
                    decoration: BoxDecoration(
                      gradient: AppColors.primaryGradient,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primary.withValues(alpha: 0.3),
                          blurRadius: 15,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: Icon(
                      Icons.restaurant_menu,
                      color: AppColors.textOnDark,
                      size: responsiveIconSize + 4, // Légèrement plus grand pour l'icône principale
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
