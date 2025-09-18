import 'package:flutter/material.dart';
import 'package:foodsave_app/core/constants/app_colors.dart';
import 'package:foodsave_app/core/constants/app_text_styles.dart';

/// Widget affichant une statistique rapide.
///
/// Affiche un emoji, une valeur et un label dans un conteneur stylisé.
class QuickStat extends StatelessWidget {
  /// Crée une nouvelle instance de [QuickStat].
  ///
  /// [emoji] : Emoji représentant la statistique.
  /// [value] : Valeur numérique de la statistique.
  /// [label] : Label descriptif de la statistique.
  const QuickStat({
    super.key,
    required this.emoji,
    required this.value,
    required this.label,
  });

  /// Emoji représentant la statistique.
  final String emoji;

  /// Valeur numérique de la statistique.
  final String value;

  /// Label descriptif de la statistique.
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.surface.withValues(alpha: 0.8),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppColors.border.withValues(alpha: 0.5),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                emoji,
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(width: 4),
              Text(
                value,
                style: AppTextStyles.labelLarge.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 2),
          Text(
            label,
            textAlign: TextAlign.center,
            style: AppTextStyles.labelSmall.copyWith(
              color: AppColors.textSecondary,
              fontSize: 10,
            ),
          ),
        ],
      ),
    );
  }
}
