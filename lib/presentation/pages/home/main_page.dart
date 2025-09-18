import 'package:flutter/material.dart';
import 'package:foodsave_app/core/constants/app_constants.dart';
import 'package:foodsave_app/core/constants/app_colors.dart';
import 'package:foodsave_app/core/constants/app_dimensions.dart';
import 'package:foodsave_app/core/constants/app_text_styles.dart';
import 'package:foodsave_app/presentation/pages/home/discovery_page.dart';
import 'package:foodsave_app/presentation/pages/home/baskets_page.dart';
import 'package:foodsave_app/presentation/pages/home/profile_page.dart';
import 'package:foodsave_app/presentation/pages/home/social_page.dart';

/// Page principale de l'application FoodSave avec navigation par onglets.
/// 
/// Cette page sert de container principal pour toutes les sections
/// de l'application : Découverte, Paniers, Profil, et Social.
class MainPage extends StatefulWidget {
  /// Crée une nouvelle instance de [MainPage].
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _currentIndex = 0;

  /// Liste des pages correspondant aux onglets.
  static final List<Widget> _pages = [
    const DiscoveryPage(),
    const BasketsPage(),
    const ProfilePage(),
    const SocialPage(),
  ];

  /// Liste des éléments de navigation.
  static const List<BottomNavigationBarItem> _navigationItems = [
    BottomNavigationBarItem(
      icon: Icon(Icons.explore),
      activeIcon: Icon(Icons.explore),
      label: AppConstants.discoveryTabLabel,
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.shopping_basket_outlined),
      activeIcon: Icon(Icons.shopping_basket),
      label: AppConstants.basketsTabLabel,
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.person_outline),
      activeIcon: Icon(Icons.person),
      label: AppConstants.profileTabLabel,
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.people_outline),
      activeIcon: Icon(Icons.people),
      label: AppConstants.socialTabLabel,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _pages,
      ),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  /// Construit la barre de navigation inférieure.
  Widget _buildBottomNavigationBar() {
    return Container(
      decoration: const BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow,
            blurRadius: AppDimensions.elevationCard,
            offset: Offset(0, -2),
          ),
        ],
      ),
      child: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _currentIndex,
        onTap: _onTabTapped,
        items: _navigationItems,
        backgroundColor: AppColors.surface,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: AppColors.textSecondary,
        selectedLabelStyle: AppTextStyles.labelSmall.copyWith(
          fontWeight: FontWeight.w600,
        ),
        unselectedLabelStyle: AppTextStyles.labelSmall,
        iconSize: AppDimensions.iconL,
        elevation: 0,
      ),
    );
  }

  /// Gère le changement d'onglet.
  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }
}