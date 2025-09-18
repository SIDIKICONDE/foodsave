import 'package:flutter/material.dart';
import 'package:foodsave_app/core/constants/app_colors.dart';
import 'package:foodsave_app/core/constants/app_dimensions.dart';
import 'package:foodsave_app/core/constants/app_text_styles.dart';
import 'package:foodsave_app/domain/entities/basket.dart';

/// Section de disponibilité du panier.
///
/// Affiche les informations de disponibilité, horaires de récupération et quantité disponible.
class AvailabilitySection extends StatelessWidget {
  /// Crée une nouvelle instance de [AvailabilitySection].
  const AvailabilitySection({
    super.key,
    required this.basket,
  });

  /// Le panier dont on affiche la disponibilité.
  final Basket basket;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppDimensions.radiusL),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppDimensions.spacingM),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Disponibilité & Récupération',
              style: AppTextStyles.headline6.copyWith(
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: AppDimensions.spacingM),
            _buildAvailabilityItem(
              Icons.access_time,
              'Disponible jusqu\'à',
              _formatDateTime(basket.availableUntil),
            ),
            const SizedBox(height: AppDimensions.spacingS),
            _buildAvailabilityItem(
              Icons.schedule,
              'Récupération',
              '${_formatTime(basket.pickupTimeStart)} - ${_formatTime(basket.pickupTimeEnd)}',
            ),
            const SizedBox(height: AppDimensions.spacingS),
            _buildAvailabilityItem(
              Icons.inventory,
              'Quantité disponible',
              '${basket.quantity} panier(s)',
            ),
            if (basket.estimatedWeight != null) ...[
              const SizedBox(height: AppDimensions.spacingS),
              _buildAvailabilityItem(
                Icons.scale,
                'Poids estimé',
                '~${basket.estimatedWeight!.toStringAsFixed(1)} kg',
              ),
            ],
          ],
        ),
      ),
    );
  }

  /// Construit un élément de la section disponibilité.
  Widget _buildAvailabilityItem(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, size: 20, color: AppColors.primary),
        const SizedBox(width: AppDimensions.spacingS),
        Expanded(
          child: Text(
            label,
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
        ),
        Text(
          value,
          style: AppTextStyles.bodyMedium.copyWith(
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
      ],
    );
  }

  /// Formate une date-heure.
  String _formatDateTime(DateTime dateTime) {
    return '${_formatTime(dateTime)} - ${_formatDate(dateTime)}';
  }

  /// Formate une heure.
  String _formatTime(DateTime dateTime) {
    return '${dateTime.hour.toString().padLeft(2, '0')}:'
           '${dateTime.minute.toString().padLeft(2, '0')}';
  }

  /// Formate une date.
  String _formatDate(DateTime dateTime) {
    final List<String> days = ['Lun', 'Mar', 'Mer', 'Jeu', 'Ven', 'Sam', 'Dim'];
    final List<String> months = [
      'Jan', 'Fév', 'Mar', 'Avr', 'Mai', 'Juin',
      'Juil', 'Août', 'Sep', 'Oct', 'Nov', 'Déc'
    ];

    return '${days[dateTime.weekday - 1]} ${dateTime.day} ${months[dateTime.month - 1]}';
  }
}
