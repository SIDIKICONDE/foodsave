import 'package:flutter/material.dart';
import 'package:foodsave_app/core/constants/app_colors.dart';
import 'package:foodsave_app/core/constants/app_dimensions.dart';
import 'package:foodsave_app/core/constants/app_text_styles.dart';
import 'package:foodsave_app/presentation/pages/auth/consumer_register/constants/consumer_register_constants.dart';

/// Widget d'en-tête pour la page d'inscription consommateur.
///
/// Affiche l'icône, le titre et le sous-titre de la page.
class ConsumerHeader extends StatelessWidget {
  /// Crée un nouvel en-tête consommateur.
  const ConsumerHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          width: ConsumerRegisterConstants.headerContainerSize.toDouble(),
          height: ConsumerRegisterConstants.headerContainerSize.toDouble(),
          decoration: BoxDecoration(
            color: AppColors.lighten(AppColors.primary, 0.8),
            shape: BoxShape.circle,
          ),
          child: Icon(
            Icons.shopping_basket,
            size: ConsumerRegisterConstants.headerIconSize.toDouble(),
            color: AppColors.primary,
          ),
        ),
        const SizedBox(height: AppDimensions.spacingL),
        Text(
          ConsumerRegisterConstants.pageTitle,
          style: AppTextStyles.headline4.copyWith(
            color: AppColors.primary,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: AppDimensions.spacingS),
        Text(
          ConsumerRegisterConstants.pageSubtitle,
          style: AppTextStyles.bodyMedium.copyWith(
            color: AppColors.textSecondary,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
