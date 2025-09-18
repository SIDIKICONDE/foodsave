import 'package:flutter/material.dart';
import '../../models/map_marker.dart';
import '../../core/constants/app_colors.dart';

/// Widget pour les contrôles de la carte (zoom, localisation, etc.)
class MapControls extends StatelessWidget {
  final VoidCallback onMyLocation;
  final VoidCallback onZoomIn;
  final VoidCallback onZoomOut;
  final VoidCallback onShowAll;
  final bool isTrackingLocation;

  const MapControls({
    super.key,
    required this.onMyLocation,
    required this.onZoomIn,
    required this.onZoomOut,
    required this.onShowAll,
    this.isTrackingLocation = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Bouton Ma position
        _MapControlButton(
          icon: Icons.my_location,
          onPressed: onMyLocation,
          isActive: isTrackingLocation,
        ),
        const SizedBox(height: 8),

        // Boutons Zoom
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.1),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            children: [
              _MapControlButton(
                icon: Icons.add,
                onPressed: onZoomIn,
                noBorder: true,
              ),
              const Divider(height: 1),
              _MapControlButton(
                icon: Icons.remove,
                onPressed: onZoomOut,
                noBorder: true,
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),

        // Bouton Tout afficher
        _MapControlButton(
          icon: Icons.fit_screen,
          onPressed: onShowAll,
        ),
      ],
    );
  }
}

/// Bouton individuel pour les contrôles de carte
class _MapControlButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onPressed;
  final bool isActive;
  final bool noBorder;

  const _MapControlButton({
    required this.icon,
    required this.onPressed,
    this.isActive = false,
    this.noBorder = false,
  });

  @override
  Widget build(BuildContext context) {
    if (noBorder) {
      return Material(
        color: isActive ? AppColors.primary.withValues(alpha: 0.1) : Colors.white,
        child: InkWell(
          onTap: onPressed,
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Icon(
              icon,
              color: isActive ? AppColors.primary : Colors.grey[700],
              size: 20,
            ),
          ),
        ),
      );
    }

    return Material(
      color: isActive ? AppColors.primary.withValues(alpha: 0.1) : Colors.white,
      borderRadius: BorderRadius.circular(8),
      elevation: 2,
      shadowColor: Colors.black.withValues(alpha: 0.1),
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: const EdgeInsets.all(12),
          child: Icon(
            icon,
            color: isActive ? AppColors.primary : Colors.grey[700],
            size: 20,
          ),
        ),
      ),
    );
  }
}

/// Widget pour les filtres de types de paniers
class MapFilterChips extends StatelessWidget {
  final Set<MarkerType> activeFilters;
  final Function(MarkerType) onToggleFilter;
  final VoidCallback onSelectAll;
  final VoidCallback onClearAll;

  const MapFilterChips({
    super.key,
    required this.activeFilters,
    required this.onToggleFilter,
    required this.onSelectAll,
    required this.onClearAll,
  });

  @override
  Widget build(BuildContext context) {
    final List<MarkerType> filterTypes = MarkerType.values
        .where((type) => type != MarkerType.userLocation)
        .toList();

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Boutons Tout sélectionner / Tout désélectionner
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                const Text(
                  'Filtrer par type',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                const Spacer(),
                TextButton(
                  onPressed: onSelectAll,
                  child: const Text(
                    'Tout',
                    style: TextStyle(fontSize: 12),
                  ),
                ),
                TextButton(
                  onPressed: onClearAll,
                  child: const Text(
                    'Aucun',
                    style: TextStyle(fontSize: 12),
                  ),
                ),
              ],
            ),
          ),

          // Chips de filtres
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: filterTypes.map((type) {
                final bool isActive = activeFilters.contains(type);
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: FilterChip(
                    label: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          type.iconAsset,
                          style: const TextStyle(fontSize: 14),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          type.label,
                          style: TextStyle(
                            fontSize: 12,
                            color: isActive ? Colors.white : Colors.grey[700],
                          ),
                        ),
                      ],
                    ),
                    selected: isActive,
                    onSelected: (_) => onToggleFilter(type),
                    selectedColor: _getTypeColor(type),
                    backgroundColor: Colors.grey[200],
                    checkmarkColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  /// Obtenir la couleur associée au type
  Color _getTypeColor(MarkerType type) {
    switch (type) {
      case MarkerType.boulangerie:
        return Colors.orange;
      case MarkerType.restaurant:
        return Colors.red;
      case MarkerType.supermarche:
        return Colors.blue;
      case MarkerType.primeur:
        return Colors.green;
      case MarkerType.autre:
        return Colors.purple;
      case MarkerType.userLocation:
        return Colors.cyan;
    }
  }
}