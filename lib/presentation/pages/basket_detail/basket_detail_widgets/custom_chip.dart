import 'package:flutter/material.dart';
import 'package:foodsave_app/core/constants/app_text_styles.dart';

/// Chip personnalisé pour les tags, ingrédients et allergènes.
///
/// Affiche un texte dans un conteneur stylisé avec couleur de fond et bordure.
class CustomChip extends StatelessWidget {
  /// Crée une nouvelle instance de [CustomChip].
  const CustomChip({
    super.key,
    required this.text,
    required this.backgroundColor,
    required this.textColor,
  });

  /// Le texte à afficher dans le chip.
  final String text;

  /// La couleur de fond du chip.
  final Color backgroundColor;

  /// La couleur du texte du chip.
  final Color textColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: textColor.withValues(alpha: 0.3)),
      ),
      child: Text(
        text,
        style: AppTextStyles.bodySmall.copyWith(
          color: textColor,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
