import 'package:flutter/material.dart';
import 'package:foodsave_app/core/constants/app_colors.dart';
import 'package:foodsave_app/core/constants/app_dimensions.dart';
import 'package:foodsave_app/core/constants/app_text_styles.dart';

/// Dropdown pour le tri des paniers avec icônes.
class SortDropdown extends StatelessWidget {
  const SortDropdown({super.key, required this.currentSort, required this.onSortChanged});

  final String currentSort;
  final ValueChanged<String> onSortChanged;

  static const List<Map<String, dynamic>> sortOptions = [
    {'value': 'proximity', 'label': 'Proximité', 'icon': Icons.near_me, 'color': AppColors.primary},
    {'value': 'price', 'label': 'Prix croissant', 'icon': Icons.euro, 'color': AppColors.secondary},
    {'value': 'discount', 'label': 'Réduction', 'icon': Icons.local_offer, 'color': AppColors.success},
    {'value': 'newest', 'label': 'Plus récents', 'icon': Icons.new_releases, 'color': AppColors.info},
  ];

  @override
  Widget build(BuildContext context) => Container(
    padding: EdgeInsets.symmetric(horizontal: AppDimensions.getResponsiveSpacing(MediaQuery.of(context).size.width) * 0.5, vertical: 2),
    decoration: BoxDecoration(
      color: AppColors.surface,
      borderRadius: BorderRadius.circular(AppDimensions.radiusM),
      border: Border.all(color: AppColors.border, width: 1),
      boxShadow: const [BoxShadow(color: AppColors.shadowLight, blurRadius: 4, offset: Offset(0, 2))],
    ),
    child: DropdownButtonHideUnderline(
      child: DropdownButton<String>(
        value: currentSort,
        onChanged: (v) => v != null ? onSortChanged(v) : null,
        icon: Icon(Icons.expand_more, color: AppColors.textSecondary, size: 18),
        style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textPrimary),
        items: sortOptions.map((o) => DropdownMenuItem<String>(
          value: o['value'] as String,
          child: Row(children: [
            Icon(o['icon'] as IconData, size: 14, color: o['color'] as Color),
            const SizedBox(width: 6),
            Text(o['label'] as String),
          ]),
        )).toList(),
      ),
    ),
  );
}
