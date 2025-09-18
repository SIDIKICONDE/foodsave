import 'package:flutter/material.dart';
import 'package:foodsave_app/core/constants/app_colors.dart';
import 'package:foodsave_app/core/constants/app_dimensions.dart';
import 'package:foodsave_app/core/constants/app_text_styles.dart';
import 'package:foodsave_app/presentation/pages/home/baskets_widgets/reservation_item.dart';

/// Section des réservations de paniers.
///
/// Affiche la liste des paniers réservés par l'utilisateur.
class ReservationsSection extends StatefulWidget {
  /// Crée une nouvelle instance de [ReservationsSection].
  const ReservationsSection({super.key});

  @override
  State<ReservationsSection> createState() => _ReservationsSectionState();
}

class _ReservationsSectionState extends State<ReservationsSection>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late List<Animation<double>> _fadeAnimations;
  late List<Animation<Offset>> _slideAnimations;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    // Créer des animations pour chaque élément
    _fadeAnimations = List.generate(2, (index) {
      return Tween<double>(
        begin: 0.0,
        end: 1.0,
      ).animate(CurvedAnimation(
        parent: _animationController,
        curve: Interval(
          index * 0.3,
          (index + 1) * 0.3 + 0.4,
          curve: Curves.easeOut,
        ),
      ));
    });

    _slideAnimations = List.generate(2, (index) {
      return Tween<Offset>(
        begin: const Offset(0, 0.2),
        end: Offset.zero,
      ).animate(CurvedAnimation(
        parent: _animationController,
        curve: Interval(
          index * 0.3,
          (index + 1) * 0.3 + 0.4,
          curve: Curves.easeOutBack,
        ),
      ));
    });

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Utilisation des constantes responsives
    final screenWidth = MediaQuery.of(context).size.width;
    final responsiveSpacing = AppDimensions.getResponsiveSpacing(screenWidth);

    return SingleChildScrollView(
      padding: EdgeInsets.all(responsiveSpacing),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header avec titre et statistiques
          Container(
            margin: EdgeInsets.only(bottom: responsiveSpacing * 1.5),
            padding: EdgeInsets.all(responsiveSpacing),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  AppColors.warning.withValues(alpha: 0.1),
                  AppColors.secondary.withValues(alpha: 0.08),
                ],
              ),
              borderRadius: BorderRadius.circular(AppDimensions.radiusL),
              border: Border.all(
                color: AppColors.warning.withValues(alpha: 0.2),
                width: 1,
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        AppColors.warning,
                        AppColors.warning.withValues(alpha: 0.8),
                      ],
                    ),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.warning.withValues(alpha: 0.3),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Icon(
                    Icons.bookmark,
                    color: AppColors.textOnDark,
                    size: 24,
                  ),
                ),
                SizedBox(width: responsiveSpacing),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Mes Réservations',
                        style: AppTextStyles.headline5.copyWith(
                          color: AppColors.warning,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: responsiveSpacing * 0.3),
                      Text(
                        'Suivez vos réservations actives',
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                // Badge avec le nombre de réservations
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: responsiveSpacing * 0.8,
                    vertical: responsiveSpacing * 0.4,
                  ),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        AppColors.warning,
                        AppColors.warning.withValues(alpha: 0.8),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.warning.withValues(alpha: 0.3),
                        blurRadius: 6,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Text(
                    '2',
                    style: AppTextStyles.bodySmall.copyWith(
                      color: AppColors.textOnDark,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Liste animée des réservations
          AnimatedBuilder(
            animation: _animationController,
            builder: (context, child) {
              return Column(
                children: List.generate(2, (index) {
                  final reservationData = [
                    {
                      'storeName': 'Boulangerie Martin',
                      'price': '4,50€',
                      'status': 'Réservé',
                      'info': 'À récupérer avant 18:00',
                      'statusColor': AppColors.warning,
                    },
                    {
                      'storeName': 'Pizzeria Bella',
                      'price': '8,00€',
                      'status': 'Confirmé',
                      'info': 'Récupération : 20:00 - 21:00',
                      'statusColor': AppColors.success,
                    },
                  ][index];

                  return FadeTransition(
                    opacity: _fadeAnimations[index],
                    child: SlideTransition(
                      position: _slideAnimations[index],
                      child: Padding(
                        padding: EdgeInsets.only(bottom: responsiveSpacing),
                        child: ReservationItem(
                          storeName: reservationData['storeName'] as String,
                          price: reservationData['price'] as String,
                          status: reservationData['status'] as String,
                          info: reservationData['info'] as String,
                          statusColor: reservationData['statusColor'] as Color,
                        ),
                      ),
                    ),
                  );
                }),
              );
            },
          ),

          // Message informatif
          Container(
            margin: EdgeInsets.only(top: responsiveSpacing),
            padding: EdgeInsets.all(responsiveSpacing),
            decoration: BoxDecoration(
              color: AppColors.warning.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(AppDimensions.radiusM),
              border: Border.all(
                color: AppColors.warning.withValues(alpha: 0.2),
                width: 1,
              ),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.access_time,
                  color: AppColors.warning,
                  size: 20,
                ),
                SizedBox(width: responsiveSpacing * 0.8),
                Expanded(
                  child: Text(
                    '⏰ N\'oubliez pas de récupérer vos paniers dans les délais !',
                    style: AppTextStyles.bodySmall.copyWith(
                      color: AppColors.warning,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
