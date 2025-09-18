import 'package:flutter/material.dart';
import 'package:foodsave_app/core/constants/app_colors.dart';
import 'package:foodsave_app/core/constants/app_dimensions.dart';
import 'package:foodsave_app/core/constants/app_text_styles.dart';

/// Bannière principale de la page d'accueil.
/// 
/// Affiche un message d'accueil attrayant avec un appel à l'action
/// pour encourager les utilisateurs à découvrir les paniers disponibles.
class HeroBanner extends StatefulWidget {
  /// Crée une nouvelle instance de [HeroBanner].
  const HeroBanner({super.key});

  @override
  State<HeroBanner> createState() => _HeroBannerState();
}

class _HeroBannerState extends State<HeroBanner>
    with SingleTickerProviderStateMixin {
  /// Contrôleur pour l'animation du texte.
  late final AnimationController _animationController;
  
  /// Animation pour le fade in du texte.
  late final Animation<double> _fadeAnimation;
  

  @override
  void initState() {
    super.initState();
    _setupAnimations();
  }

  /// Configure les animations de la bannière.
  void _setupAnimations() {
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    _fadeAnimation = CurvedAnimation(
      parent: _animationController,
      curve: const Interval(0.0, 0.6, curve: Curves.easeOut),
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
    final Size screenSize = MediaQuery.of(context).size;
    
    return Container(
      height: screenSize.height * 0.20,
      // Marge supérieure à 0 comme demandé
      margin: const EdgeInsets.only(top: 0),
      child: Stack(
        children: [
          // Image de fond avec overlay
          _buildBackgroundImage(),
          
          // Contenu de la bannière
          _buildBannerContent(),
          
          // Décoration en vague en bas
          _buildWaveDecoration(),
        ],
      ),
    );
  }

  /// Construit l'image de fond avec overlay.
  Widget _buildBackgroundImage() {
    return Container(
      decoration: BoxDecoration(
        gradient: AppColors.primaryGradient,
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(AppDimensions.radiusXXL),
          bottomRight: Radius.circular(AppDimensions.radiusXXL),
        ),
        image: DecorationImage(
          image: const AssetImage('assets/images/hero_food.jpg'),
          fit: BoxFit.cover,
          colorFilter: ColorFilter.mode(
            AppColors.primary.withValues(alpha: 0.3),
            BlendMode.darken,
          ),
          onError: (exception, stackTrace) {},
        ),
      ),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppColors.primaryDark.withValues(alpha: 0.7),
              AppColors.primary.withValues(alpha: 0.85),
            ],
          ),
          borderRadius: const BorderRadius.only(
            bottomLeft: Radius.circular(AppDimensions.radiusXXL),
            bottomRight: Radius.circular(AppDimensions.radiusXXL),
          ),
        ),
      ),
    );
  }

  /// Construit le contenu principal de la bannière.
  Widget _buildBannerContent() {
    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.only(
          left: AppDimensions.spacingXL,
          right: AppDimensions.spacingXL,
          top: AppDimensions.spacingXL,
          bottom: AppDimensions.spacingL,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            FadeTransition(
              opacity: _fadeAnimation,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Badge écologique
                  _buildEcoBadge(),
                  
                  const SizedBox(height: AppDimensions.spacingM),
                  
                  // Titre principal
                  Text(
                    'Sauvez de la nourriture',
                    style: AppTextStyles.headline1.copyWith(
                      color: AppColors.textOnDark,
                      fontWeight: FontWeight.w800,
                      fontSize: 24,
                      height: 1.1,
                    ),
                  ),
                  
                  const SizedBox(height: AppDimensions.spacingS),
                  
                  // Sous-titre
                  Text(
                    'Découvrez des paniers anti-gaspi\nprès de chez vous',
                    style: AppTextStyles.bodyLarge.copyWith(
                      color: AppColors.textOnDark.withValues(alpha: 0.9),
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Construit le badge écologique.
  Widget _buildEcoBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.spacingM,
        vertical: AppDimensions.spacingS,
      ),
      decoration: BoxDecoration(
        color: AppColors.eco.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(AppDimensions.radiusL),
        border: Border.all(
          color: AppColors.eco.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.eco,
            color: AppColors.textOnDark,
            size: AppDimensions.iconS,
          ),
          const SizedBox(width: AppDimensions.spacingS),
          Text(
            '🌱 Écologique',
            style: AppTextStyles.labelMedium.copyWith(
              color: AppColors.textOnDark,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }


  /// Construit la décoration en vague.
  Widget _buildWaveDecoration() {
    return Positioned(
      bottom: -1,
      left: 0,
      right: 0,
      child: CustomPaint(
        size: Size(MediaQuery.of(context).size.width, 30),
        painter: WavePainter(
          color: AppColors.background,
        ),
      ),
    );
  }

}

/// Painter pour dessiner la vague décorative.
class WavePainter extends CustomPainter {
  /// Couleur de la vague.
  final Color color;

  /// Crée une nouvelle instance de [WavePainter].
  const WavePainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final Path path = Path()
      ..moveTo(0, size.height)
      ..lineTo(0, size.height * 0.5)
      ..quadraticBezierTo(
        size.width * 0.25,
        0,
        size.width * 0.5,
        size.height * 0.5,
      )
      ..quadraticBezierTo(
        size.width * 0.75,
        size.height,
        size.width,
        size.height * 0.5,
      )
      ..lineTo(size.width, size.height)
      ..close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}