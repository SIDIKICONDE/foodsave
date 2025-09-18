import 'package:flutter/material.dart';
import 'package:foodsave_app/core/constants/app_colors.dart';
import 'package:foodsave_app/core/constants/app_dimensions.dart';
import 'package:foodsave_app/core/constants/app_text_styles.dart';

/// Grille des catégories de paniers disponibles.
/// 
/// Affiche les différentes catégories de nourriture sous forme
/// de grille avec des icônes et des couleurs distinctes.
class CategoriesGrid extends StatelessWidget {
  /// Crée une nouvelle instance de [CategoriesGrid].
  const CategoriesGrid({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.spacingL,
      ),
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: _categories.length,
        separatorBuilder: (context, _) => const SizedBox(width: AppDimensions.spacingM),
        itemBuilder: (context, index) {
          final category = _categories[index];
          return SizedBox(
            width: 110,
            child: _CategoryCard(
              category: category,
              index: index,
            ),
          );
        },
      ),
    );
  }

  /// Liste des catégories disponibles.
  static final List<CategoryModel> _categories = [
    CategoryModel(
      name: 'Boulangerie',
      icon: Icons.bakery_dining,
      color: const Color(0xFFFFA726),
      itemCount: 24,
    ),
    CategoryModel(
      name: 'Fruits & Légumes',
      icon: Icons.apple,
      color: AppColors.eco,
      itemCount: 18,
    ),
    CategoryModel(
      name: 'Restaurant',
      icon: Icons.restaurant,
      color: const Color(0xFFEF5350),
      itemCount: 32,
    ),
    CategoryModel(
      name: 'Épicerie',
      icon: Icons.shopping_basket,
      color: const Color(0xFF42A5F5),
      itemCount: 45,
    ),
    CategoryModel(
      name: 'Traiteur',
      icon: Icons.lunch_dining,
      color: const Color(0xFF9575CD),
      itemCount: 12,
    ),
    CategoryModel(
      name: 'Pâtisserie',
      icon: Icons.cake,
      color: const Color(0xFFEC407A),
      itemCount: 15,
    ),
    CategoryModel(
      name: 'Bio',
      icon: Icons.eco,
      color: AppColors.primary,
      itemCount: 28,
    ),
    CategoryModel(
      name: 'Végétarien',
      icon: Icons.grass,
      color: const Color(0xFF8BC34A),
      itemCount: 20,
    ),
  ];
}

/// Carte représentant une catégorie.
class _CategoryCard extends StatefulWidget {
  /// Modèle de catégorie.
  final CategoryModel category;
  
  /// Index de la carte pour l'animation.
  final int index;

  /// Crée une nouvelle instance de [_CategoryCard].
  const _CategoryCard({
    required this.category,
    required this.index,
  });

  @override
  State<_CategoryCard> createState() => _CategoryCardState();
}

class _CategoryCardState extends State<_CategoryCard>
    with SingleTickerProviderStateMixin {
  /// Contrôleur d'animation.
  late final AnimationController _animationController;
  
  /// Animation de scale.
  late final Animation<double> _scaleAnimation;
  
  /// État de pression.
  bool _isPressed = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: Duration(milliseconds: 300 + (widget.index * 50)),
      vsync: this,
    );

    _scaleAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.elasticOut,
    );

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _scaleAnimation,
      child: GestureDetector(
        onTapDown: (_) => setState(() => _isPressed = true),
        onTapUp: (_) => setState(() => _isPressed = false),
        onTapCancel: () => setState(() => _isPressed = false),
        onTap: () => _onCategoryTap(context),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          transform: Matrix4.diagonal3Values(
            _isPressed ? 0.95 : 1.0,
            _isPressed ? 0.95 : 1.0,
            1.0,
          ),
          child: Container(
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(AppDimensions.radiusL),
              boxShadow: [
                BoxShadow(
                  color: widget.category.color.withValues(alpha: 0.2),
                  blurRadius: _isPressed ? 4 : 8,
                  offset: Offset(0, _isPressed ? 2 : 4),
                ),
              ],
              border: Border.all(
                color: widget.category.color.withValues(alpha: 0.1),
                width: 1,
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Icône avec fond coloré
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: widget.category.color.withValues(alpha: 0.15),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    widget.category.icon,
                    color: widget.category.color,
                    size: 20,
                  ),
                ),

                const SizedBox(height: 4),

                // Nom de la catégorie
                Text(
                  widget.category.name,
                  style: AppTextStyles.labelSmall.copyWith(
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),

                // Nombre d'items
                Text(
                  '${widget.category.itemCount}',
                  style: AppTextStyles.labelSmall.copyWith(
                    color: AppColors.textSecondary,
                    fontSize: 10,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Gère le tap sur une catégorie.
  void _onCategoryTap(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(
              widget.category.icon,
              color: AppColors.textOnDark,
              size: 20,
            ),
            const SizedBox(width: 12),
            Text('Catégorie : ${widget.category.name}'),
          ],
        ),
        backgroundColor: widget.category.color,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }
}

/// Modèle de données pour une catégorie.
class CategoryModel {
  /// Nom de la catégorie.
  final String name;
  
  /// Icône de la catégorie.
  final IconData icon;
  
  /// Couleur de la catégorie.
  final Color color;
  
  /// Nombre d'éléments dans la catégorie.
  final int itemCount;

  /// Crée une nouvelle instance de [CategoryModel].
  const CategoryModel({
    required this.name,
    required this.icon,
    required this.color,
    required this.itemCount,
  });
}