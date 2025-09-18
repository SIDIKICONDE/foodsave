import 'package:flutter/material.dart';
import 'package:foodsave_app/core/constants/app_colors.dart';
import 'package:foodsave_app/core/constants/app_text_styles.dart';
import 'package:foodsave_app/presentation/pages/auth/merchant_register/constants/merchant_register_constants.dart';

/// Widget pour afficher les conditions d'utilisation commerçant.
///
/// Affiche le texte des conditions d'utilisation avec le style approprié.
class MerchantTermsAndConditions extends StatelessWidget {
  /// Crée un widget de conditions d'utilisation commerçant.
  const MerchantTermsAndConditions({super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      MerchantRegisterConstants.termsAndConditions,
      style: AppTextStyles.bodySmall.copyWith(
        color: AppColors.textSecondary,
      ),
      textAlign: TextAlign.center,
    );
  }
}
