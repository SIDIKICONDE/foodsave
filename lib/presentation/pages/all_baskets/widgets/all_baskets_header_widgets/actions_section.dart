import 'package:flutter/material.dart';
import 'package:foodsave_app/core/constants/app_dimensions.dart';
import 'package:foodsave_app/presentation/pages/all_baskets/widgets/all_baskets_header_widgets/filter_button.dart';
import 'package:foodsave_app/presentation/pages/all_baskets/widgets/all_baskets_header_widgets/sort_dropdown.dart';
import 'package:foodsave_app/presentation/pages/all_baskets/widgets/all_baskets_header_widgets/view_toggle_button.dart';

/// Section des actions principales.
///
/// Contient le sélecteur de tri, le bouton filtres et le bouton de vue.
class ActionsSection extends StatelessWidget {
  /// Crée une nouvelle instance de [ActionsSection].
  ///
  /// [onSortChanged] : Callback appelé lors du changement de tri.
  /// [currentSort] : Option de tri actuellement sélectionnée.
  /// [onFilterPressed] : Callback appelé lors du clic sur les filtres.
  /// [onViewTogglePressed] : Callback appelé lors du changement de vue.
  const ActionsSection({
    super.key,
    required this.onSortChanged,
    required this.currentSort,
    required this.onFilterPressed,
    required this.onViewTogglePressed,
  });

  /// Callback appelé lors du changement de tri.
  final ValueChanged<String> onSortChanged;

  /// Option de tri actuellement sélectionnée.
  final String currentSort;

  /// Callback appelé lors du clic sur les filtres.
  final VoidCallback onFilterPressed;

  /// Callback appelé lors du changement de vue.
  final VoidCallback onViewTogglePressed;

  @override
  Widget build(BuildContext context) {
    final responsiveSpacing = AppDimensions.getResponsiveSpacing(
      MediaQuery.of(context).size.width
    );

    return Row(
      children: [
        // Sélecteur de tri
        Expanded(
          child: SortDropdown(
            currentSort: currentSort,
            onSortChanged: onSortChanged,
          ),
        ),

        SizedBox(width: responsiveSpacing * 0.8),

        // Bouton filtres
        FilterButton(onPressed: onFilterPressed),

        SizedBox(width: responsiveSpacing * 0.8),

        // Bouton vue
        ViewToggleButton(onPressed: onViewTogglePressed),
      ],
    );
  }
}
