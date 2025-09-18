import 'package:flutter/material.dart';
import 'package:foodsave_app/core/constants/app_colors.dart';

/// Contrôles flottants pour la carte Google Maps.
///
/// Inclut les boutons pour la localisation, les couches et autres actions.
class MapControls extends StatelessWidget {
  /// Crée une nouvelle instance de [MapControls].
  ///
  /// [onCurrentLocationPressed] : Callback pour aller à la position actuelle.
  /// [onLayersPressed] : Callback pour changer les couches de carte.
  /// [isLocationEnabled] : Indique si la géolocalisation est activée.
  const MapControls({
    super.key,
    required this.onCurrentLocationPressed,
    required this.onLayersPressed,
    this.isLocationEnabled = false,
  });

  /// Callback pour aller à la position actuelle.
  final VoidCallback onCurrentLocationPressed;

  /// Callback pour changer les couches de carte.
  final VoidCallback onLayersPressed;

  /// Indique si la géolocalisation est activée.
  final bool isLocationEnabled;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Bouton position actuelle
        _buildControlButton(
          icon: Icons.my_location,
          onPressed: onCurrentLocationPressed,
          isEnabled: isLocationEnabled,
          backgroundColor: isLocationEnabled 
              ? AppColors.primary 
              : AppColors.textDisabled,
          iconColor: isLocationEnabled 
              ? AppColors.textOnDark 
              : AppColors.surface,
        ),

        const SizedBox(height: 12),

        // Bouton couches/style de carte
        _buildControlButton(
          icon: Icons.layers,
          onPressed: onLayersPressed,
          backgroundColor: AppColors.surface,
          iconColor: AppColors.textPrimary,
        ),
      ],
    );
  }

  /// Construit un bouton de contrôle.
  Widget _buildControlButton({
    required IconData icon,
    required VoidCallback onPressed,
    Color backgroundColor = AppColors.surface,
    Color iconColor = AppColors.textPrimary,
    bool isEnabled = true,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: backgroundColor,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow.withValues(alpha: 0.3),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(
          color: AppColors.border.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        shape: const CircleBorder(),
        child: InkWell(
          onTap: isEnabled ? onPressed : null,
          customBorder: const CircleBorder(),
          child: SizedBox(
            width: 56,
            height: 56,
            child: Icon(
              icon,
              color: iconColor,
              size: 24,
            ),
          ),
        ),
      ),
    );
  }
}