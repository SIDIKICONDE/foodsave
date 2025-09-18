import 'package:flutter/material.dart';
import 'package:foodsave_app/core/constants/app_constants.dart';
import 'package:foodsave_app/core/constants/app_dimensions.dart';
import 'package:foodsave_app/core/constants/app_text_styles.dart';
import 'package:foodsave_app/presentation/pages/home/widgets/placeholder_widget.dart';

/// Section des commerces favoris.
///
/// Affiche la liste des commerces favoris de l'utilisateur.
class FavoriteStoresSection extends StatelessWidget {
  /// Crée une nouvelle instance de [FavoriteStoresSection].
  const FavoriteStoresSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppConstants.favoriteStoresTitle,
          style: AppTextStyles.headline5.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: AppDimensions.spacingL),
        const PlaceholderWidget(text: 'Commerces favoris à implémenter'),
      ],
    );
  }
}
