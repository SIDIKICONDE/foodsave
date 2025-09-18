import 'package:flutter/material.dart';
import 'package:foodsave_app/core/constants/app_colors.dart';
import 'package:foodsave_app/core/constants/app_dimensions.dart';
import 'package:foodsave_app/core/constants/app_text_styles.dart';

/// Barre de recherche flottante pour la page de carte.
///
/// Widget optimisé pour la superposition sur une carte Google Maps.
class MapFloatingSearch extends StatefulWidget {
  /// Crée une nouvelle instance de [MapFloatingSearch].
  ///
  /// [controller] : Contrôleur du champ de texte.
  /// [onSearchChanged] : Callback appelé lors du changement de recherche.
  /// [onFilterPressed] : Callback appelé lors du clic sur les filtres.
  const MapFloatingSearch({
    super.key,
    required this.controller,
    required this.onSearchChanged,
    required this.onFilterPressed,
  });

  /// Contrôleur du champ de texte.
  final TextEditingController controller;

  /// Callback appelé lors du changement de recherche.
  final ValueChanged<String> onSearchChanged;

  /// Callback appelé lors du clic sur les filtres.
  final VoidCallback onFilterPressed;

  @override
  State<MapFloatingSearch> createState() => _MapFloatingSearchState();
}

class _MapFloatingSearchState extends State<MapFloatingSearch>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _shadowAnimation;

  final FocusNode _focusNode = FocusNode();
  bool _isFocused = false;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _setupFocusListener();
  }

  /// Initialise les animations.
  void _initializeAnimations() {
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 1.02,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOut,
    ));

    _shadowAnimation = Tween<double>(
      begin: 8.0,
      end: 16.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOut,
    ));
  }

  /// Configure l'écouteur de focus.
  void _setupFocusListener() {
    _focusNode.addListener(() {
      final bool isNowFocused = _focusNode.hasFocus;
      if (isNowFocused != _isFocused) {
        setState(() {
          _isFocused = isNowFocused;
        });
        if (isNowFocused) {
          _animationController.forward();
        } else {
          _animationController.reverse();
        }
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
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: Container(
            decoration: BoxDecoration(
              color: AppColors.surface.withValues(alpha: 0.95),
              borderRadius: BorderRadius.circular(AppDimensions.radiusL),
              boxShadow: [
                BoxShadow(
                  color: AppColors.shadow.withValues(alpha: 0.3),
                  blurRadius: _shadowAnimation.value,
                  offset: const Offset(0, 4),
                ),
              ],
              border: Border.all(
                color: _isFocused
                    ? AppColors.primary.withValues(alpha: 0.5)
                    : AppColors.border.withValues(alpha: 0.3),
                width: _isFocused ? 2 : 1,
              ),
            ),
            child: Row(
              children: [
                // Icône de recherche
                Padding(
                  padding: const EdgeInsets.only(left: 16, right: 8),
                  child: Icon(
                    Icons.search,
                    color: _isFocused
                        ? AppColors.primary
                        : AppColors.textSecondary,
                    size: 24,
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
                      hintText: 'Rechercher sur la carte...',
                      hintStyle: AppTextStyles.bodyMedium.copyWith(
                        color: AppColors.textSecondary,
                      ),
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(
                        vertical: 16,
                      ),
                    ),
                  ),
                ),

                // Bouton effacer (si du texte est présent)
                if (widget.controller.text.isNotEmpty)
                  Container(
                    margin: const EdgeInsets.only(right: 8),
                    child: IconButton(
                      icon: Icon(
                        Icons.clear,
                        color: AppColors.textSecondary,
                        size: 20,
                      ),
                      onPressed: () {
                        widget.controller.clear();
                        widget.onSearchChanged('');
                      },
                      padding: const EdgeInsets.all(4),
                      constraints: const BoxConstraints(),
                    ),
                  ),

                // Séparateur vertical
                Container(
                  height: 24,
                  width: 1,
                  color: AppColors.divider,
                  margin: const EdgeInsets.symmetric(horizontal: 8),
                ),

                // Bouton filtres
                Container(
                  margin: const EdgeInsets.only(right: 8),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(AppDimensions.radiusM),
                  ),
                  child: IconButton(
                    icon: Icon(
                      Icons.tune,
                      color: AppColors.primary,
                      size: 20,
                    ),
                    onPressed: widget.onFilterPressed,
                    padding: const EdgeInsets.all(8),
                    constraints: const BoxConstraints(),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}