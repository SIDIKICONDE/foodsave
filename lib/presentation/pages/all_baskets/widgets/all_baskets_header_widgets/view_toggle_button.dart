import 'package:flutter/material.dart';
import 'package:foodsave_app/core/constants/app_colors.dart';
import 'package:foodsave_app/core/constants/app_dimensions.dart';

/// Bouton de changement de vue.
///
/// Permet de basculer entre vue liste et vue grille.
class ViewToggleButton extends StatelessWidget {
  /// Crée une nouvelle instance de [ViewToggleButton].
  ///
  /// [onPressed] : Callback appelé lors du clic sur le bouton.
  const ViewToggleButton({
    super.key,
    required this.onPressed,
  });

  /// Callback appelé lors du clic sur le bouton.
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final responsiveSpacing = AppDimensions.getResponsiveSpacing(
      MediaQuery.of(context).size.width
    );

    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppDimensions.radiusM),
        border: Border.all(
          color: AppColors.border,
          width: 1,
        ),
        boxShadow: const [
          BoxShadow(
            color: AppColors.shadowLight,
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(AppDimensions.radiusM),
          child: Padding(
            padding: EdgeInsets.all(responsiveSpacing * 0.75),
            child: Icon(
              Icons.view_module,
              color: AppColors.textSecondary,
              size: 20,
            ),
          ),
        ),
      ),
    );
  }
}
