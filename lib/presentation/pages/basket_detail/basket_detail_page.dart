import 'package:flutter/material.dart';
import 'package:foodsave_app/core/constants/app_dimensions.dart';
import 'package:foodsave_app/domain/entities/basket.dart';
import 'package:foodsave_app/presentation/pages/basket_detail/basket_detail_widgets/basket_detail_widgets.dart';

/// Page détaillée d'un panier.
/// 
/// Affiche toutes les informations d'un panier avec possibilité de réservation,
/// informations sur le commerce, horaires de récupération, etc.
class BasketDetailPage extends StatefulWidget {
  /// Crée une nouvelle instance de [BasketDetailPage].
  const BasketDetailPage({
    super.key,
    required this.basket,
  });

  /// Le panier à afficher en détail.
  final Basket basket;

  @override
  State<BasketDetailPage> createState() => _BasketDetailPageState();
}

class _BasketDetailPageState extends State<BasketDetailPage>
    with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    super.dispose();
  }

  void _initializeAnimations() {
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeOutCubic,
    ));

    // Démarrer l'animation après un court délai
    Future.delayed(const Duration(milliseconds: 200), () {
      if (mounted) {
        _fadeController.forward();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedBuilder(
        animation: _fadeController,
        builder: (context, child) {
          return Opacity(
            opacity: _fadeAnimation.value,
            child: CustomScrollView(
              slivers: [
                BasketSliverAppBar(basket: widget.basket),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.all(AppDimensions.spacingL),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildAnimatedSection(
                          child: BasketTitleSection(basket: widget.basket),
                          delay: 100,
                        ),
                        const SizedBox(height: AppDimensions.spacingS),
                        _buildAnimatedSection(
                          child: PriceSection(basket: widget.basket),
                          delay: 200,
                        ),
                        const SizedBox(height: AppDimensions.spacingM),
                        _buildAnimatedSection(
                          child: CommerceInfoSection(basket: widget.basket),
                          delay: 300,
                        ),
                        const SizedBox(height: AppDimensions.spacingM),
                        _buildAnimatedSection(
                          child: AvailabilitySection(basket: widget.basket),
                          delay: 400,
                        ),
                        const SizedBox(height: AppDimensions.spacingM),
                        _buildAnimatedSection(
                          child: DescriptionSection(basket: widget.basket),
                          delay: 500,
                        ),
                        const SizedBox(height: AppDimensions.spacingM),
                        _buildAnimatedSection(
                          child: IngredientsSection(basket: widget.basket),
                          delay: 600,
                        ),
                        const SizedBox(height: AppDimensions.spacingM),
                        _buildAnimatedSection(
                          child: DietaryTagsSection(basket: widget.basket),
                          delay: 700,
                        ),
                        const SizedBox(height: AppDimensions.spacingM),
                        _buildAnimatedSection(
                          child: AllergensSection(basket: widget.basket),
                          delay: 800,
                        ),
                        const SizedBox(height: AppDimensions.spacingL),
                        _buildAnimatedSection(
                          child: ReservationButton(basket: widget.basket),
                          delay: 900,
                        ),
                        const SizedBox(height: AppDimensions.spacingL),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  /// Construit une section avec animation d'entrée en cascade
  Widget _buildAnimatedSection({
    required Widget child,
    required int delay,
  }) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: const Duration(milliseconds: 600),
      curve: Curves.easeOutBack,
      builder: (context, value, child) {
        return Transform.translate(
          offset: Offset(0, 30 * (1 - value)),
          child: Opacity(
            opacity: value,
            child: child,
          ),
        );
      },
      child: FutureBuilder(
        future: Future.delayed(Duration(milliseconds: delay)),
        builder: (context, snapshot) {
          return child;
        },
      ),
    );
  }
}