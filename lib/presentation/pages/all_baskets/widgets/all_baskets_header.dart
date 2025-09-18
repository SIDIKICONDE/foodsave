import 'package:flutter/material.dart';
import 'package:foodsave_app/core/constants/app_dimensions.dart';
import 'package:foodsave_app/presentation/pages/all_baskets/widgets/all_baskets_header_widgets/all_baskets_header_widgets.dart';

/// Widget d'en-tête pour la page de tous les paniers.
///
/// Affiche les statistiques, options de tri et actions principales.
class AllBasketsHeader extends StatelessWidget {
  /// Crée une nouvelle instance de [AllBasketsHeader].
  ///
  /// [onSortChanged] : Callback appelé lors du changement de tri.
  /// [currentSort] : Option de tri actuellement sélectionnée.
  /// [onFilterPressed] : Callback appelé lors du clic sur les filtres.
  /// [totalBaskets] : Nombre total de paniers trouvés.
  const AllBasketsHeader({
    super.key,
    required this.onSortChanged,
    required this.currentSort,
    required this.onFilterPressed,
    this.totalBaskets = 0,
  });

  /// Callback appelé lors du changement de tri.
  final ValueChanged<String> onSortChanged;

  /// Option de tri actuellement sélectionnée.
  final String currentSort;

  /// Callback appelé lors du clic sur les filtres.
  final VoidCallback onFilterPressed;

  /// Nombre total de paniers trouvés.
  final int totalBaskets;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final responsiveSpacing = AppDimensions.getResponsiveSpacing(screenWidth);

    return Container(
      margin: EdgeInsets.all(responsiveSpacing),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Statistiques principales
          StatsSection(totalBaskets: totalBaskets),
          SizedBox(height: responsiveSpacing),

          // Actions et tri
          ActionsSection(
            onSortChanged: onSortChanged,
            currentSort: currentSort,
            onFilterPressed: onFilterPressed,
            onViewTogglePressed: () {
              // Changer la vue (liste/grille)
            },
          ),
        ],
      ),
    );
  }
}