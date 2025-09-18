import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:foodsave_app/core/constants/app_colors.dart';
import 'package:foodsave_app/core/constants/app_dimensions.dart';
import 'package:foodsave_app/core/constants/app_text_styles.dart';
import 'package:foodsave_app/presentation/blocs/basket/basket_bloc.dart';
import 'package:foodsave_app/presentation/blocs/basket/basket_event.dart';
import 'package:foodsave_app/presentation/blocs/basket/basket_state.dart';
import 'package:foodsave_app/presentation/pages/all_baskets/widgets/all_baskets_header.dart';
import 'package:foodsave_app/presentation/pages/all_baskets/widgets/baskets_search_bar.dart';
import 'package:foodsave_app/presentation/pages/all_baskets/widgets/all_baskets_list.dart';
import 'package:foodsave_app/presentation/pages/all_baskets/widgets/baskets_filter_dialog.dart';
import 'package:foodsave_app/core/routes/app_routes.dart';

/// Page des paniers avec recherche, filtres et animations.
class AllBasketsPage extends StatefulWidget {
  const AllBasketsPage({super.key});

  @override
  State<AllBasketsPage> createState() => _AllBasketsPageState();
}

class _AllBasketsPageState extends State<AllBasketsPage> with TickerProviderStateMixin {
  late AnimationController _headerCtrl, _listCtrl;
  late Animation<double> _headerFade;
  late Animation<Offset> _headerSlide;
  final TextEditingController _searchCtrl = TextEditingController();
  final ScrollController _scrollCtrl = ScrollController();
  Map<String, dynamic> _filters = {};
  String _sortBy = 'proximity';
  bool _searchActive = false;

  @override
  void initState() {
    super.initState();
    _initAnimations();
    _loadData();
    _setupScroll();
  }

  void _initAnimations() {
    _headerCtrl = AnimationController(duration: const Duration(milliseconds: 800), vsync: this);
    _listCtrl = AnimationController(duration: const Duration(milliseconds: 1000), vsync: this);
    _headerFade = Tween<double>(begin: 0, end: 1).animate(CurvedAnimation(parent: _headerCtrl, curve: Curves.easeOut));
    _headerSlide = Tween<Offset>(begin: const Offset(0, -0.3), end: Offset.zero).animate(CurvedAnimation(parent: _headerCtrl, curve: Curves.easeOutBack));
    _headerCtrl.forward();
    Future.delayed(const Duration(milliseconds: 300), _listCtrl.forward);
  }

  void _setupScroll() => _scrollCtrl.addListener(() {
    if (_scrollCtrl.position.pixels >= _scrollCtrl.position.maxScrollExtent - 200) {
      context.read<BasketBloc>().add(const LoadMoreBaskets());
    }
  });

  void _loadData() => context.read<BasketBloc>().add(const LoadAvailableBaskets(latitude: 48.8566, longitude: 2.3522, radius: 10, refresh: true));

  @override
  void dispose() {
    _headerCtrl.dispose();
    _listCtrl.dispose();
    _searchCtrl.dispose();
    _scrollCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final s = AppDimensions.getResponsiveSpacing(MediaQuery.of(context).size.width);
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: _buildAppBar(),
      body: Container(
        decoration: BoxDecoration(gradient: LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [AppColors.primary.withValues(alpha: 0.05), AppColors.background, AppColors.surfaceSecondary.withValues(alpha: 0.3)])),
        child: SafeArea(
          child: Column(children: [
            FadeTransition(opacity: _headerFade, child: SlideTransition(position: _headerSlide, child: AllBasketsHeader(onSortChanged: _handleSortChanged, currentSort: _sortBy, onFilterPressed: _showFilterDialog, totalBaskets: _getTotalBaskets()))),
            Padding(padding: EdgeInsets.symmetric(horizontal: s), child: BasketsSearchBar(controller: _searchCtrl, onSearchChanged: _handleSearchChanged, onFilterPressed: _showFilterDialog, isActive: _searchActive)),
            SizedBox(height: s),
            Expanded(child: AllBasketsList(scrollController: _scrollCtrl, animationController: _listCtrl)),
          ]),
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() => AppBar(
    backgroundColor: AppColors.primary.withValues(alpha: 0.95),
    elevation: 0,
    flexibleSpace: Container(decoration: BoxDecoration(gradient: LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: [AppColors.primary.withValues(alpha: 0.95), AppColors.secondary.withValues(alpha: 0.8)]))),
    leading: IconButton(icon: Icon(Icons.arrow_back, color: AppColors.textOnDark), onPressed: () => Navigator.of(context).pop()),
    title: Text('Tous les Paniers', style: AppTextStyles.headline6.copyWith(color: AppColors.textOnDark, fontWeight: FontWeight.bold)),
    actions: [
      IconButton(icon: Icon(Icons.map, color: AppColors.textOnDark, size: 15), onPressed: () => AppRoutes.navigateToBasketsMap(context), iconSize: 20),
      IconButton(icon: Icon(Icons.bookmark_border, color: AppColors.textOnDark, size: 15), onPressed: () => ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: const Text('💖 Mes favoris'), backgroundColor: AppColors.secondary, behavior: SnackBarBehavior.floating, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)))), iconSize: 20),
    ],
  );

  void _handleSortChanged(String sortBy) { setState(() => _sortBy = sortBy); _refreshBaskets(); }

  void _handleSearchChanged(String query) {
    setState(() => _searchActive = query.isNotEmpty);
    if (query.isNotEmpty) {
      context.read<BasketBloc>().add(SearchBasketsEvent(query: query, latitude: 48.8566, longitude: 2.3522, radius: 10));
    } else {
      _refreshBaskets();
    }
  }

  void _showFilterDialog() => showModalBottomSheet(context: context, isScrollControlled: true, backgroundColor: Colors.transparent, builder: (context) => BasketsFilterDialog(currentFilters: _filters, onFiltersChanged: _handleFiltersChanged));

  void _handleFiltersChanged(Map<String, dynamic> filters) { setState(() => _filters = filters); _refreshBaskets(); }

  void _refreshBaskets() => context.read<BasketBloc>().add(const LoadAvailableBaskets(latitude: 48.8566, longitude: 2.3522, radius: 10, refresh: true));

  int _getTotalBaskets() => context.read<BasketBloc>().state is BasketLoaded ? (context.read<BasketBloc>().state as BasketLoaded).baskets.length : 0;
}