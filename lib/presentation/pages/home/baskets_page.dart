import 'package:flutter/material.dart';
import 'package:foodsave_app/core/constants/app_constants.dart';
import 'package:foodsave_app/core/constants/app_colors.dart';
import 'package:foodsave_app/core/constants/app_dimensions.dart';
import 'package:foodsave_app/core/constants/app_text_styles.dart';
import 'package:foodsave_app/presentation/pages/home/baskets_widgets/available_baskets_section.dart';
import 'package:foodsave_app/presentation/pages/home/baskets_widgets/reservations_section.dart';
import 'package:foodsave_app/presentation/pages/home/baskets_widgets/history_section.dart';

/// Page de gestion des paniers anti-gaspi.
///
/// Cette page permet aux utilisateurs de voir leurs réservations,
/// l'historique et les paniers disponibles avec les détails complets.
///
/// Utilise une architecture modulaire avec des widgets séparés pour
/// chaque section (paniers disponibles, réservations, historique).
class BasketsPage extends StatefulWidget {
  /// Crée une nouvelle instance de [BasketsPage].
  const BasketsPage({super.key});

  @override
  State<BasketsPage> createState() => _BasketsPageState();
}

class _BasketsPageState extends State<BasketsPage> with TickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: _buildAppBar(),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppColors.primary.withValues(alpha: 0.08),
              AppColors.background,
              AppColors.surfaceSecondary.withValues(alpha: 0.3),
            ],
          ),
        ),
        child: TabBarView(
          controller: _tabController,
          children: const [
            AvailableBasketsSection(),
            ReservationsSection(),
            HistorySection(),
          ],
        ),
      ),
    );
  }

  /// Construit la barre d'application avec les onglets.
  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: AppColors.primary.withValues(alpha: 0.95),
      elevation: 0,
      flexibleSpace: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppColors.primary.withValues(alpha: 0.95),
              AppColors.secondary.withValues(alpha: 0.8),
            ],
          ),
        ),
      ),
      title: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  AppColors.surface.withValues(alpha: 0.25),
                  AppColors.surface.withValues(alpha: 0.15),
                ],
              ),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: AppColors.surface.withValues(alpha: 0.3),
                width: 1,
              ),
            ),
            child: Icon(
              Icons.shopping_basket,
              color: AppColors.textOnDark,
              size: 22,
            ),
          ),
          const SizedBox(width: 12),
          Text(
            AppConstants.basketsTabLabel,
            style: AppTextStyles.headline6.copyWith(
              color: AppColors.textOnDark,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
      actions: [
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 8),
          decoration: BoxDecoration(
            color: AppColors.surface.withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(12),
          ),
          child: IconButton(
            icon: Icon(
              Icons.filter_list,
              color: AppColors.textOnDark,
              size: AppDimensions.iconM,
            ),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: const Text('🔍 Filtres avancés'),
                  backgroundColor: AppColors.secondary,
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              );
            },
          ),
        ),
      ],
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: AppColors.surface.withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: AppColors.surface.withValues(alpha: 0.2),
              width: 1,
            ),
          ),
          child: TabBar(
            controller: _tabController,
            indicator: BoxDecoration(
              gradient: AppColors.primaryGradient,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primary.withValues(alpha: 0.4),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            indicatorSize: TabBarIndicatorSize.tab,
            labelColor: AppColors.textOnDark,
            unselectedLabelColor: AppColors.textOnDark.withValues(alpha: 0.7),
            labelStyle: AppTextStyles.bodySmall.copyWith(
              fontWeight: FontWeight.w700,
            ),
            unselectedLabelStyle: AppTextStyles.bodySmall.copyWith(
              fontWeight: FontWeight.w500,
            ),
            tabs: const [
              Tab(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.inventory_2, size: 18),
                    SizedBox(width: 6),
                    Text('Disponibles'),
                  ],
                ),
              ),
              Tab(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.bookmark_border, size: 18),
                    SizedBox(width: 6),
                    Text('Réservations'),
                  ],
                ),
              ),
              Tab(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.history, size: 18),
                    SizedBox(width: 6),
                    Text('Historique'),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

}