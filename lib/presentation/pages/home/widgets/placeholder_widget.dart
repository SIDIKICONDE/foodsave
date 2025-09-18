import 'package:flutter/material.dart';
import 'package:foodsave_app/core/constants/app_colors.dart';
import 'package:foodsave_app/core/constants/app_dimensions.dart';
import 'package:foodsave_app/core/constants/app_text_styles.dart';

/// Widget placeholder pour les sections à implémenter.
///
/// Affiche un message informatif dans un conteneur stylisé.
class PlaceholderWidget extends StatelessWidget {
  /// Crée une nouvelle instance de [PlaceholderWidget].
  ///
  /// [text] : Le texte à afficher dans le placeholder.
  const PlaceholderWidget({
    super.key,
    required this.text,
  });

  /// Le texte à afficher dans le placeholder.
  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.lighten(AppColors.info, 0.9),
        borderRadius: BorderRadius.circular(AppDimensions.radiusL),
        border: Border.all(
          color: AppColors.lighten(AppColors.info, 0.7),
          style: BorderStyle.solid,
        ),
      ),
      child: Center(
        child: Text(
          text,
          style: AppTextStyles.bodyMedium.copyWith(
            color: AppColors.info,
            fontStyle: FontStyle.italic,
          ),
        ),
      ),
    );
  }
}
