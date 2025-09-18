import 'package:flutter/material.dart';
import 'package:foodsave_app/core/constants/app_colors.dart';

/// Widget pour le bouton de retour.
///
/// Affiche un bouton de retour simple dans le coin supérieur gauche.
class BackButtonWidget extends StatelessWidget {
  /// Crée un bouton de retour.
  const BackButtonWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topLeft,
      child: IconButton(
        onPressed: () => Navigator.of(context).pop(),
        icon: const Icon(Icons.arrow_back),
        color: AppColors.textPrimary,
      ),
    );
  }
}
