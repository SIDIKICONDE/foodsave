import 'package:flutter/material.dart';
import 'package:foodsave_app/core/constants/app_colors.dart';
import 'package:foodsave_app/core/constants/app_dimensions.dart';
import 'package:foodsave_app/core/constants/app_text_styles.dart';
import 'package:foodsave_app/domain/entities/basket.dart';

/// Section titre panier avec icône commerce et distance.
class BasketItemTitleSection extends StatelessWidget {
  const BasketItemTitleSection({super.key, required this.basket});

  final Basket basket;

  @override
  Widget build(BuildContext context) {
    final s = AppDimensions.getResponsiveSpacing(MediaQuery.of(context).size.width);
    return Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Container(padding: const EdgeInsets.all(6), decoration: BoxDecoration(color: AppColors.primary.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(10)), child: Icon(Icons.store, size: 18, color: AppColors.primary)),
      SizedBox(width: s * 0.8),
      Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(basket.commerce.name, style: AppTextStyles.headline6.copyWith(fontWeight: FontWeight.bold)),
        SizedBox(height: s * 0.2),
        Text(basket.title, style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary)),
      ])),
      Container(padding: EdgeInsets.symmetric(horizontal: s * 0.5, vertical: s * 0.2), decoration: BoxDecoration(color: AppColors.info.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(10)), child: Row(mainAxisSize: MainAxisSize.min, children: [
        Icon(Icons.near_me, size: 12, color: AppColors.info),
        SizedBox(width: s * 0.15),
        Text('1.2 km', style: AppTextStyles.labelSmall.copyWith(color: AppColors.info, fontWeight: FontWeight.w600)),
      ])),
    ]);
  }
}
