import 'package:flutter/material.dart';
import 'package:foodsave_app/core/constants/app_colors.dart';
import 'package:foodsave_app/core/constants/app_dimensions.dart';
import 'package:foodsave_app/core/constants/app_text_styles.dart';

/// Section de filtrage par distance.
///
/// Permet de définir une distance maximale avec un Slider.
class DistanceFilterSection extends StatelessWidget {
  /// Crée une nouvelle instance de [DistanceFilterSection].
  ///
  /// [currentDistance] : Distance maximale actuelle.
  /// [onDistanceChanged] : Callback appelé lors du changement de distance.
  const DistanceFilterSection({
    super.key,
    required this.currentDistance,
    required this.onDistanceChanged,
  });

  /// Distance maximale actuelle en km.
  final double currentDistance;

  /// Callback appelé lors du changement de distance.
  final ValueChanged<double> onDistanceChanged;

  @override
  Widget build(BuildContext context) {
    return _buildSection(
      title: 'Distance maximale',
      icon: Icons.near_me,
      child: Column(
        children: [
          Slider(
            value: currentDistance,
            min: 1,
            max: 20,
            divisions: 19,
            label: '${currentDistance.toInt()} km',
            onChanged: onDistanceChanged,
          ),
          Text(
            '${currentDistance.toInt()} km',
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.primary,
              fontWeight: FontWeight.w600,
            ),
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
