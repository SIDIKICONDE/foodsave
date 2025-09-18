import 'package:flutter/material.dart';
import 'package:foodsave_app/core/constants/app_colors.dart';
import 'package:foodsave_app/core/constants/app_text_styles.dart';

/// Puice d'information réutilisable.
///
/// Affiche une icône, un label et une valeur dans un conteneur stylisé.
class BasketInfoChip extends StatelessWidget {
  /// Crée une nouvelle instance de [BasketInfoChip].
  ///
  /// [icon] : L'icône à afficher.
  /// [label] : Le label descriptif.
  /// [value] : La valeur à afficher.
  /// [color] : La couleur du thème.
  const BasketInfoChip({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });

  /// L'icône à afficher.
  final IconData icon;

  /// Le label descriptif.
  final String label;

  /// La valeur à afficher.
  final String value;

  /// La couleur du thème.
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: color.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 14, color: color),
              const SizedBox(width: 3),
              Text(
                label,
                style: AppTextStyles.labelSmall.copyWith(
                  color: color,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 2),
          Text(
            value,
            style: AppTextStyles.bodySmall.copyWith(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
