import 'package:flutter/material.dart';
import 'package:foodsave_app/core/constants/app_colors.dart';
import 'package:foodsave_app/core/constants/app_text_styles.dart';
import 'package:foodsave_app/presentation/pages/auth/consumer_register/constants/consumer_register_constants.dart';

/// Widget pour afficher les conditions d'utilisation.
///
/// Affiche le texte des conditions d'utilisation avec le style approprié.
class TermsAndConditions extends StatelessWidget {
  /// Crée un widget de conditions d'utilisation.
  const TermsAndConditions({super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      ConsumerRegisterConstants.termsAndConditions,
      style: AppTextStyles.bodySmall.copyWith(
        color: AppColors.textSecondary,
      ),
      textAlign: TextAlign.center,
    );
  }
}
