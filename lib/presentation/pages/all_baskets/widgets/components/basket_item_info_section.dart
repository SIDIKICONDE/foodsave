import 'package:flutter/material.dart';
import 'package:foodsave_app/core/constants/app_colors.dart';
import 'package:foodsave_app/core/constants/app_dimensions.dart';
import 'package:foodsave_app/domain/entities/basket.dart';
import 'basket_info_chip.dart';

/// Section des informations pratiques d'un élément de panier.
///
/// Affiche les horaires de récupération et la quantité disponible.
class BasketItemInfoSection extends StatelessWidget {
  /// Crée une nouvelle instance de [BasketItemInfoSection].
  ///
  /// [basket] : Le panier à afficher.
  const BasketItemInfoSection({
    super.key,
    required this.basket,
  });

  /// Le panier à afficher.
  final Basket basket;

  @override
  Widget build(BuildContext context) {
    final spacing = AppDimensions.getResponsiveSpacing(
      MediaQuery.of(context).size.width,
    );

    return Row(
      children: [
        // Horaires de récupération
        Expanded(
          child: BasketInfoChip(
            icon: Icons.schedule,
            label: 'Récupération',
            value: '${_formatTime(basket.pickupTimeStart)} - ${_formatTime(basket.pickupTimeEnd)}',
            color: AppColors.success,
          ),
        ),

        SizedBox(width: spacing),

        // Quantité disponible
        BasketInfoChip(
          icon: Icons.inventory,
          label: 'Disponible',
          value: '${basket.quantity}',
          color: AppColors.info,
        ),
      ],
    );
  }

  /// Formate une heure pour l'affichage.
  String _formatTime(DateTime dateTime) {
    return '${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
  }
}
