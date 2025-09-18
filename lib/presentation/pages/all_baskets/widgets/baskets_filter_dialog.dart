import 'package:flutter/material.dart';
import 'package:foodsave_app/core/constants/app_colors.dart';
import 'package:foodsave_app/core/constants/app_dimensions.dart';
import 'package:foodsave_app/presentation/pages/all_baskets/widgets/baskets_filter_widgets/baskets_filter_widgets.dart';

/// Boîte de dialogue de filtres avancés pour les paniers.
///
/// Permet de filtrer par prix, type de commerce, régime alimentaire, distance, etc.
class BasketsFilterDialog extends StatefulWidget {
  /// Crée une nouvelle instance de [BasketsFilterDialog].
  ///
  /// [currentFilters] : Filtres actuellement appliqués.
  /// [onFiltersChanged] : Callback appelé lors du changement de filtres.
  const BasketsFilterDialog({
    super.key,
    required this.currentFilters,
    required this.onFiltersChanged,
  });

  /// Filtres actuellement appliqués.
  final Map<String, dynamic> currentFilters;

  /// Callback appelé lors du changement de filtres.
  final ValueChanged<Map<String, dynamic>> onFiltersChanged;

  @override
  State<BasketsFilterDialog> createState() => _BasketsFilterDialogState();
}

class _BasketsFilterDialogState extends State<BasketsFilterDialog>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _slideAnimation;
  late Animation<double> _fadeAnimation;

  // État des filtres
  Map<String, dynamic> _filters = {};

  @override
  void initState() {
    super.initState();
    _filters = Map.from(widget.currentFilters);
    _initializeAnimations();
  }

  /// Initialise les animations.
  void _initializeAnimations() {
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );

    _slideAnimation = Tween<double>(
      begin: 1.0,
      end: 0.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutCubic,
    ));

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOut,
    ));

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    final responsiveSpacing = AppDimensions.getResponsiveSpacing(screenWidth);

    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return Stack(
          children: [
            // Fond semi-transparent
            FadeTransition(
              opacity: _fadeAnimation,
              child: GestureDetector(
                onTap: _closeDialog,
                child: Container(
                  color: AppColors.overlayDark,
                ),
              ),
            ),

            // Dialogue principal
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Transform.translate(
                offset: Offset(0, screenHeight * 0.7 * _slideAnimation.value),
                child: Container(
                  height: screenHeight * 0.7,
                  decoration: const BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(24),
                      topRight: Radius.circular(24),
                    ),
                  ),
                  child: Column(
                    children: [
                      // En-tête
                      _buildHeader(responsiveSpacing),

                      // Contenu défilable
                      Expanded(
                        child: SingleChildScrollView(
                          padding: EdgeInsets.all(responsiveSpacing),
                          child: Column(
                            children: [
                              _buildPriceSection(responsiveSpacing),
                              SizedBox(height: responsiveSpacing * 1.5),
                              _buildDistanceSection(responsiveSpacing),
                              SizedBox(height: responsiveSpacing * 1.5),
                              _buildCommerceTypesSection(responsiveSpacing),
                              SizedBox(height: responsiveSpacing * 1.5),
                              _buildDietaryTagsSection(responsiveSpacing),
                              SizedBox(height: responsiveSpacing * 1.5),
                              _buildDiscountSection(responsiveSpacing),
                              SizedBox(height: responsiveSpacing * 1.5),
                              _buildAvailabilitySection(responsiveSpacing),
                            ],
                          ),
                        ),
                      ),

                      // Boutons d'action
                      _buildActionButtons(responsiveSpacing),
                    ],
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  /// Construit l'en-tête du dialogue.
  Widget _buildHeader(double spacing) {
    return FilterHeader(onReset: _resetFilters);
  }

  /// Construit la section prix.
  Widget _buildPriceSection(double spacing) {
    return PriceFilterSection(
      currentMinPrice: _filters['minPrice']?.toDouble() ?? 0.0,
      currentMaxPrice: _filters['maxPrice']?.toDouble() ?? 50.0,
      onPriceRangeChanged: (min, max) {
        setState(() {
          _filters['minPrice'] = min.toInt();
          _filters['maxPrice'] = max.toInt();
        });
      },
    );
  }

  /// Construit la section distance.
  Widget _buildDistanceSection(double spacing) {
    return DistanceFilterSection(
      currentDistance: _filters['maxDistance']?.toDouble() ?? 5.0,
      onDistanceChanged: (value) {
        setState(() {
          _filters['maxDistance'] = value.toInt();
        });
      },
    );
  }

  /// Construit la section types de commerce.
  Widget _buildCommerceTypesSection(double spacing) {
    return CommerceTypesFilterSection(
      selectedTypes: _filters['commerceTypes'] as List<String>? ?? [],
      onTypeToggle: (type, selected) {
        setState(() {
          if (_filters['commerceTypes'] == null) {
            _filters['commerceTypes'] = <String>[];
          }
          if (selected) {
            (_filters['commerceTypes'] as List<String>).add(type);
          } else {
            (_filters['commerceTypes'] as List<String>).remove(type);
          }
        });
      },
    );
  }

  /// Construit la section tags diététiques.
  Widget _buildDietaryTagsSection(double spacing) {
    return DietaryTagsFilterSection(
      selectedTags: _filters['dietaryTags'] as List<String>? ?? [],
      onTagToggle: (tag, selected) {
        setState(() {
          if (_filters['dietaryTags'] == null) {
            _filters['dietaryTags'] = <String>[];
          }
          if (selected) {
            (_filters['dietaryTags'] as List<String>).add(tag);
          } else {
            (_filters['dietaryTags'] as List<String>).remove(tag);
          }
        });
      },
    );
  }

  /// Construit la section réduction.
  Widget _buildDiscountSection(double spacing) {
    return DiscountFilterSection(
      selectedDiscountRange: _filters['discountRange'] as String?,
      onDiscountRangeChanged: (range, min, max) {
        setState(() {
          _filters['discountRange'] = range;
          _filters['minDiscount'] = min;
          _filters['maxDiscount'] = max;
        });
      },
    );
  }

  /// Construit la section disponibilité.
  Widget _buildAvailabilitySection(double spacing) {
    return AvailabilityFilterSection(
      lastChanceOnly: _filters['lastChanceOnly'] as bool? ?? false,
      availableNow: _filters['availableNow'] as bool? ?? false,
      onLastChanceChanged: (value) {
        setState(() {
          _filters['lastChanceOnly'] = value;
        });
      },
      onAvailableNowChanged: (value) {
        setState(() {
          _filters['availableNow'] = value;
        });
      },
    );
  }

  /// Construit les boutons d'action.
  Widget _buildActionButtons(double spacing) {
    return FilterActionButtons(
      onCancel: _closeDialog,
      onApply: _applyFilters,
    );
  }

  /// Ferme le dialogue.
  void _closeDialog() {
    _animationController.reverse().then((_) {
      if (mounted) {
        Navigator.of(context).pop();
      }
    });
  }

  /// Applique les filtres.
  void _applyFilters() {
    widget.onFiltersChanged(_filters);
    _closeDialog();
  }

  /// Réinitialise les filtres.
  void _resetFilters() {
    setState(() {
      _filters.clear();
    });
  }
}