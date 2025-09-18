import 'package:flutter/material.dart';
import 'package:foodsave_app/core/constants/app_colors.dart';
import 'package:foodsave_app/core/constants/app_dimensions.dart';
import 'package:foodsave_app/core/constants/app_text_styles.dart';
import 'package:foodsave_app/presentation/pages/auth/merchant_register/constants/merchant_register_constants.dart';

/// Widget d'en-tête pour la page d'inscription commerçant.
///
/// Affiche l'icône de magasin, le titre et le sous-titre spécifique aux commerçants.
class MerchantHeader extends StatelessWidget {
  /// Crée un nouvel en-tête commerçant.
  const MerchantHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          width: MerchantRegisterConstants.headerContainerSize.toDouble(),
          height: MerchantRegisterConstants.headerContainerSize.toDouble(),
          decoration: BoxDecoration(
            color: AppColors.lighten(AppColors.secondary, 0.8),
            shape: BoxShape.circle,
          ),
          child: Icon(
            Icons.store,
            size: MerchantRegisterConstants.headerIconSize.toDouble(),
            color: AppColors.secondary,
          ),
        ),
        const SizedBox(height: AppDimensions.spacingL),
        Text(
          MerchantRegisterConstants.pageTitle,
          style: AppTextStyles.headline4.copyWith(
            color: AppColors.secondary,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: AppDimensions.spacingS),
        Text(
          MerchantRegisterConstants.pageSubtitle,
          style: AppTextStyles.bodyMedium.copyWith(
            color: AppColors.textSecondary,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
