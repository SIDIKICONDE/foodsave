import 'package:flutter/material.dart';
import 'package:foodsave_app/core/constants/app_colors.dart';
import 'package:foodsave_app/core/constants/app_dimensions.dart';
import 'package:foodsave_app/core/constants/app_text_styles.dart';
import 'package:foodsave_app/presentation/pages/all_baskets/widgets/all_baskets_header_widgets/quick_stat.dart';

/// Section des statistiques avec icône panier et stats rapides.
class StatsSection extends StatelessWidget {
  const StatsSection({super.key, required this.totalBaskets});

  final int totalBaskets;

  @override
  Widget build(BuildContext context) {
    final s = AppDimensions.getResponsiveSpacing(MediaQuery.of(context).size.width);
    return Container(
      padding: EdgeInsets.all(s * 0.8),
      decoration: BoxDecoration(
        gradient: LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: [AppColors.primary.withValues(alpha: 0.1), AppColors.secondary.withValues(alpha: 0.08)]),
        borderRadius: BorderRadius.circular(AppDimensions.radiusL),
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.2), width: 1),
      ),
      child: Row(children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            gradient: AppColors.primaryGradient,
            shape: BoxShape.circle,
            boxShadow: [BoxShadow(color: AppColors.primary.withValues(alpha: 0.3), blurRadius: 8, offset: const Offset(0, 3))],
          ),
          child: Icon(Icons.shopping_basket, color: AppColors.textOnDark, size: 24),
        ),
        SizedBox(width: s * 0.8),
        Expanded(
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text('Paniers Disponibles', style: AppTextStyles.headline5.copyWith(color: AppColors.primary, fontWeight: FontWeight.bold)),
            SizedBox(height: s * 0.2),
            Text('$totalBaskets paniers trouvés dans votre région', style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary)),
          ]),
        ),
        Column(children: [
          const QuickStat(emoji: '🔥', value: '8', label: 'Dernière\nchance'),
          SizedBox(height: s * 0.4),
          const QuickStat(emoji: '💰', value: '67%', label: 'Économie\nmoyenne'),
        ]),
      ]),
    );
  }
}
