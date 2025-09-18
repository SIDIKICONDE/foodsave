import 'package:flutter/material.dart';
import 'package:foodsave_app/core/constants/app_colors.dart';
import 'package:foodsave_app/core/constants/app_dimensions.dart';
import 'package:foodsave_app/core/constants/app_text_styles.dart';

/// Barre de recherche avancée pour les paniers.
///
/// Inclut la recherche textuelle, les suggestions et filtres rapides.
class BasketsSearchBar extends StatefulWidget {
  /// Crée une nouvelle instance de [BasketsSearchBar].
  ///
  /// [controller] : Contrôleur du champ de texte.
  /// [onSearchChanged] : Callback appelé lors du changement de recherche.
  /// [onFilterPressed] : Callback appelé lors du clic sur les filtres.
  /// [isActive] : Indique si la recherche est active.
  const BasketsSearchBar({
    super.key,
    required this.controller,
    required this.onSearchChanged,
    required this.onFilterPressed,
    this.isActive = false,
  });

  /// Contrôleur du champ de texte.
  final TextEditingController controller;

  /// Callback appelé lors du changement de recherche.
  final ValueChanged<String> onSearchChanged;

  /// Callback appelé lors du clic sur les filtres.
  final VoidCallback onFilterPressed;

  /// Indique si la recherche est active.
  final bool isActive;

  @override
  State<BasketsSearchBar> createState() => _BasketsSearchBarState();
}

class _BasketsSearchBarState extends State<BasketsSearchBar>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;

  final FocusNode _focusNode = FocusNode();
  bool _showSuggestions = false;

  // Suggestions de recherche populaires
  final List<String> _popularSearches = [
    'boulangerie',
    'fruits et légumes',
    'restaurant',
    'bio',
    'vegan',
    'sans gluten',
    'dernière chance',
  ];

  // Filtres rapides
  final List<Map<String, dynamic>> _quickFilters = [
    {'label': '🔥 Dernière chance', 'value': 'last_chance', 'color': AppColors.error},
    {'label': '🥬 Bio', 'value': 'bio', 'color': AppColors.eco},
    {'label': '🌱 Vegan', 'value': 'vegan', 'color': AppColors.success},
    {'label': '💰 -50%', 'value': 'high_discount', 'color': AppColors.secondary},
    {'label': '⚡ Livraison', 'value': 'delivery', 'color': AppColors.info},
  ];

  final Set<String> _activeQuickFilters = {};

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _setupFocusListener();
  }

  /// Initialise les animations.
  void _initializeAnimations() {
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 1.02,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOut,
    ));

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOut,
    ));
  }

  /// Configure l'écouteur de focus.
  void _setupFocusListener() {
    _focusNode.addListener(() {
      if (_focusNode.hasFocus) {
        _animationController.forward();
        setState(() {
          _showSuggestions = true;
        });
      } else {
        _animationController.reverse();
        Future.delayed(const Duration(milliseconds: 200), () {
          if (mounted) {
            setState(() {
              _showSuggestions = false;
            });
          }
        });
      }
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final responsiveSpacing = AppDimensions.getResponsiveSpacing(screenWidth);

    return Column(
      children: [
        // Barre de recherche principale
        AnimatedBuilder(
          animation: _scaleAnimation,
          builder: (context, child) {
            return Transform.scale(
              scale: _scaleAnimation.value,
              child: Container(
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(AppDimensions.radiusL),
                  boxShadow: [
                    BoxShadow(
                      color: widget.isActive
                          ? AppColors.primary.withValues(alpha: 0.2)
                          : AppColors.shadowLight,
                      blurRadius: widget.isActive ? 12 : 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                  border: Border.all(
                    color: widget.isActive
                        ? AppColors.primary.withValues(alpha: 0.3)
                        : AppColors.border,
                    width: widget.isActive ? 2 : 1,
                  ),
                ),
                child: Row(
                  children: [
                    // Icône de recherche
                    Padding(
                      padding: EdgeInsets.only(
                        left: responsiveSpacing,
                        right: responsiveSpacing * 0.5,
                      ),
                      child: Icon(
                        Icons.search,
                        color: widget.isActive
                            ? AppColors.primary
                            : AppColors.textSecondary,
                        size: 22,
                      ),
                    ),

                    // Champ de texte
                    Expanded(
                      child: TextField(
                        controller: widget.controller,
                        focusNode: _focusNode,
                        onChanged: widget.onSearchChanged,
                        style: AppTextStyles.bodyMedium,
                        decoration: InputDecoration(
                          hintText: 'Rechercher des paniers, commerces...',
                          hintStyle: AppTextStyles.bodyMedium.copyWith(
                            color: AppColors.textSecondary,
                          ),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(
                            vertical: responsiveSpacing,
                          ),
                        ),
                      ),
                    ),

                    // Bouton effacer
                    if (widget.controller.text.isNotEmpty)
                      IconButton(
                        icon: Icon(
                          Icons.clear,
                          color: AppColors.textSecondary,
                          size: 16,
                        ),
                        iconSize: 16,
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                        onPressed: () {
                          widget.controller.clear();
                          widget.onSearchChanged('');
                        },
                      ),

                    // Bouton filtres
                    Container(
                      margin: EdgeInsets.only(right: responsiveSpacing * 0.5),
                      decoration: BoxDecoration(
                        color: _activeQuickFilters.isNotEmpty
                            ? AppColors.secondary
                            : AppColors.surfaceSecondary,
                        borderRadius: BorderRadius.circular(AppDimensions.radiusM),
                      ),
                      child: IconButton(
                        icon: Icon(
                          Icons.tune,
                          color: _activeQuickFilters.isNotEmpty
                              ? AppColors.textOnDark
                              : AppColors.textSecondary,
                          size: 16,
                        ),
                        iconSize: 16,
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                        onPressed: widget.onFilterPressed,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),

        // Filtres rapides
        if (_activeQuickFilters.isNotEmpty || _showSuggestions)
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            height: _showSuggestions ? null : 60,
            margin: EdgeInsets.only(top: responsiveSpacing * 0.8),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: _quickFilters.map((filter) {
                  final bool isActive = _activeQuickFilters.contains(filter['value']);
                  return Container(
                    margin: EdgeInsets.only(right: responsiveSpacing * 0.6),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      child: FilterChip(
                        label: Text(filter['label'] as String),
                        selected: isActive,
                        onSelected: (selected) {
                          setState(() {
                            if (selected) {
                              _activeQuickFilters.add(filter['value'] as String);
                            } else {
                              _activeQuickFilters.remove(filter['value'] as String);
                            }
                          });
                          // Déclencher la recherche avec les nouveaux filtres
                          _applyFilters();
                        },
                        backgroundColor: AppColors.surfaceSecondary,
                        selectedColor: (filter['color'] as Color).withValues(alpha: 0.2),
                        checkmarkColor: filter['color'] as Color,
                        labelStyle: AppTextStyles.labelSmall.copyWith(
                          color: isActive
                              ? filter['color'] as Color
                              : AppColors.textSecondary,
                          fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
                        ),
                        side: BorderSide(
                          color: isActive
                              ? filter['color'] as Color
                              : AppColors.border,
                          width: isActive ? 2 : 1,
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),

        // Suggestions de recherche
        if (_showSuggestions)
          FadeTransition(
            opacity: _fadeAnimation,
            child: Container(
              margin: EdgeInsets.only(top: responsiveSpacing * 0.8),
              padding: EdgeInsets.all(responsiveSpacing),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(AppDimensions.radiusM),
                boxShadow: const [
                  BoxShadow(
                    color: AppColors.shadowLight,
                    blurRadius: 8,
                    offset: Offset(0, 4),
                  ),
                ],
                border: Border.all(
                  color: AppColors.border,
                  width: 1,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Recherches populaires',
                    style: AppTextStyles.labelLarge.copyWith(
                      color: AppColors.textSecondary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: responsiveSpacing * 0.6),
                  Wrap(
                    spacing: responsiveSpacing * 0.6,
                    runSpacing: responsiveSpacing * 0.4,
                    children: _popularSearches.map((search) {
                      return GestureDetector(
                        onTap: () {
                          widget.controller.text = search;
                          widget.onSearchChanged(search);
                          _focusNode.unfocus();
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: responsiveSpacing * 0.8,
                            vertical: responsiveSpacing * 0.4,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.surfaceSecondary,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: AppColors.border,
                              width: 1,
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.trending_up,
                                size: 14,
                                color: AppColors.textSecondary,
                              ),
                              SizedBox(width: responsiveSpacing * 0.3),
                              Text(
                                search,
                                style: AppTextStyles.labelSmall.copyWith(
                                  color: AppColors.textSecondary,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }

  /// Applique les filtres rapides.
  void _applyFilters() {
    // Ici, on pourrait déclencher une recherche avec les filtres actifs
    // Pour l'instant, on se contente de déclencher la recherche normale
    widget.onSearchChanged(widget.controller.text);
  }
}