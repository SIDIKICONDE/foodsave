import 'package:flutter/material.dart';
import 'package:foodsave_app/core/constants/app_colors.dart';
import 'package:foodsave_app/core/constants/app_dimensions.dart';
import 'package:foodsave_app/core/constants/app_text_styles.dart';
import 'package:foodsave_app/presentation/pages/auth/email_verification/constants/email_verification_constants.dart';

/// Widget pour la section d'instructions de vérification.
///
/// Affiche la liste des étapes à suivre pour vérifier l'email.
class InstructionsSection extends StatelessWidget {
  /// Crée une section d'instructions.
  const InstructionsSection({super.key});

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;

    return Column(
      children: <Widget>[
        Icon(
          Icons.info_outline,
          color: AppColors.primary,
          size: AppDimensions.iconM,
        ),
        SizedBox(height: AppDimensions.spacingM),
        Text(
          EmailVerificationConstants.instructionsTitle,
          style: AppTextStyles.responsive(AppTextStyles.headline6, screenWidth)
              .copyWith(color: AppColors.primary),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: AppDimensions.spacingM),

        // Liste des instructions
        _buildInstructionItem(
          icon: Icons.email_outlined,
          text: EmailVerificationConstants.instruction1,
        ),
        SizedBox(height: AppDimensions.spacingS),
        _buildInstructionItem(
          icon: Icons.search_outlined,
          text: EmailVerificationConstants.instruction2,
        ),
        SizedBox(height: AppDimensions.spacingS),
        _buildInstructionItem(
          icon: Icons.touch_app_outlined,
          text: EmailVerificationConstants.instruction3,
        ),
        SizedBox(height: AppDimensions.spacingS),
        _buildInstructionItem(
          icon: Icons.check_circle_outline,
          text: EmailVerificationConstants.instruction4,
        ),
      ],
    );
  }

  /// Construit un élément d'instruction.
  Widget _buildInstructionItem({
    required IconData icon,
    required String text,
  }) {
    return Row(
      children: <Widget>[
        Icon(
          icon,
          color: AppColors.textSecondary,
          size: EmailVerificationConstants.instructionIconSize,
        ),
        SizedBox(width: AppDimensions.spacingM),
        Expanded(
          child: Text(
            text,
            style: AppTextStyles.bodySmall.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
        ),
      ],
    );
  }
}
