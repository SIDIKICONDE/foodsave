import 'package:flutter/material.dart';
import 'package:foodsave_app/core/constants/app_colors.dart';
import 'package:foodsave_app/core/constants/app_dimensions.dart';
import 'package:foodsave_app/core/constants/app_text_styles.dart';

/// Section de filtrage par disponibilité.
///
/// Permet de filtrer les paniers par critères de disponibilité avec des SwitchListTile.
class AvailabilityFilterSection extends StatelessWidget {
  /// Crée une nouvelle instance de [AvailabilityFilterSection].
  ///
  /// [lastChanceOnly] : Si seuls les paniers "dernière chance" doivent être affichés.
  /// [availableNow] : Si seuls les paniers disponibles immédiatement doivent être affichés.
  /// [onLastChanceChanged] : Callback pour le changement du filtre "dernière chance".
  /// [onAvailableNowChanged] : Callback pour le changement du filtre "disponible maintenant".
  const AvailabilityFilterSection({
    super.key,
    required this.lastChanceOnly,
    required this.availableNow,
    required this.onLastChanceChanged,
    required this.onAvailableNowChanged,
  });

  /// Si seuls les paniers "dernière chance" doivent être affichés.
  final bool lastChanceOnly;

  /// Si seuls les paniers disponibles immédiatement doivent être affichés.
  final bool availableNow;

  /// Callback pour le changement du filtre "dernière chance".
  final ValueChanged<bool> onLastChanceChanged;

  /// Callback pour le changement du filtre "disponible maintenant".
  final ValueChanged<bool> onAvailableNowChanged;

  @override
  Widget build(BuildContext context) {
    return _buildSection(
      title: 'Disponibilité',
      icon: Icons.schedule,
      child: Column(
        children: [
          SwitchListTile(
            title: Text(
              'Dernière chance uniquement',
              style: AppTextStyles.bodyMedium,
            ),
            subtitle: Text(
              'Paniers bientôt expirés',
              style: AppTextStyles.bodySmall.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
            value: lastChanceOnly,
            onChanged: onLastChanceChanged,
            activeThumbColor: AppColors.error,
            contentPadding: EdgeInsets.zero,
          ),
          SwitchListTile(
            title: Text(
              'Disponible maintenant',
              style: AppTextStyles.bodyMedium,
            ),
            subtitle: Text(
              'Récupération possible immédiatement',
              style: AppTextStyles.bodySmall.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
            value: availableNow,
            onChanged: onAvailableNowChanged,
            activeThumbColor: AppColors.success,
            contentPadding: EdgeInsets.zero,
          ),
        ],
      ),
    );
  }

  /// Construit une section avec titre et icône.
  Widget _buildSection({
    required String title,
    required IconData icon,
    required Widget child,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surfaceSecondary.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(AppDimensions.radiusM),
        border: Border.all(
          color: AppColors.border.withValues(alpha: 0.5),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                icon,
                size: 20,
                color: AppColors.primary,
              ),
              const SizedBox(width: 8),
              Text(
                title,
                style: AppTextStyles.labelLarge.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          child,
        ],
      ),
    );
  }
}
