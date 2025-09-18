import 'package:flutter/material.dart';

/// Utilitaires d'animation pour FoodSave
/// Respecte les standards NYTH - Zero Compromise
class AnimationUtils {
  /// Constructeur privé pour empêcher l'instanciation
  AnimationUtils._();

  // Durées d'animation standardisées
  static const Duration fastDuration = Duration(milliseconds: 150);
  static const Duration normalDuration = Duration(milliseconds: 300);
  static const Duration slowDuration = Duration(milliseconds: 500);
  static const Duration extraSlowDuration = Duration(milliseconds: 800);

  // Courbes d'animation personnalisées
  static const Curve smoothCurve = Curves.easeInOutCubic;
  static const Curve bouncyCurve = Curves.elasticOut;
  static const Curve quickCurve = Curves.easeOutQuart;
  static const Curve gentleCurve = Curves.easeInOut;
}

/// Widget d'animation de fondu
class FadeInAnimation extends StatefulWidget {
  /// Widget enfant à animer
  final Widget child;
  
  /// Durée de l'animation
  final Duration duration;
  
  /// Délai avant le début de l'animation
  final Duration delay;
  
  /// Courbe d'animation
  final Curve curve;
  
  /// Constructeur
  const FadeInAnimation({
    super.key,
    required this.child,
    this.duration = AnimationUtils.normalDuration,
    this.delay = Duration.zero,
    this.curve = AnimationUtils.gentleCurve,
  });

  @override
  State<FadeInAnimation> createState() => _FadeInAnimationState();
}

class _FadeInAnimationState extends State<FadeInAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.duration,
      vsync: this,
    );
    
    _animation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: widget.curve,
    ));

    // Démarrer l'animation après le délai
    if (widget.delay == Duration.zero) {
      _controller.forward();
    } else {
      Future.delayed(widget.delay, () {
        if (mounted) {
          _controller.forward();
        }
      });
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Opacity(
          opacity: _animation.value,
          child: widget.child,
        );
      },
    );
  }
}

/// Widget d'animation de glissement
class SlideInAnimation extends StatefulWidget {
  /// Widget enfant à animer
  final Widget child;
  
  /// Direction du glissement
  final SlideDirection direction;
  
  /// Distance du glissement
  final double offset;
  
  /// Durée de l'animation
  final Duration duration;
  
  /// Délai avant le début de l'animation
  final Duration delay;
  
  /// Courbe d'animation
  final Curve curve;
  
  /// Constructeur
  const SlideInAnimation({
    super.key,
    required this.child,
    this.direction = SlideDirection.bottom,
    this.offset = 50.0,
    this.duration = AnimationUtils.normalDuration,
    this.delay = Duration.zero,
    this.curve = AnimationUtils.smoothCurve,
  });

  @override
  State<SlideInAnimation> createState() => _SlideInAnimationState();
}

class _SlideInAnimationState extends State<SlideInAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _offsetAnimation;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.duration,
      vsync: this,
    );
    
    // Calcul de l'offset initial selon la direction
    Offset initialOffset;
    switch (widget.direction) {
      case SlideDirection.left:
        initialOffset = Offset(-widget.offset / 100, 0);
        break;
      case SlideDirection.right:
        initialOffset = Offset(widget.offset / 100, 0);
        break;
      case SlideDirection.top:
        initialOffset = Offset(0, -widget.offset / 100);
        break;
      case SlideDirection.bottom:
        initialOffset = Offset(0, widget.offset / 100);
        break;
    }
    
    _offsetAnimation = Tween<Offset>(
      begin: initialOffset,
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: widget.curve,
    ));
    
    _opacityAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeIn,
    ));

    // Démarrer l'animation après le délai
    if (widget.delay == Duration.zero) {
      _controller.forward();
    } else {
      Future.delayed(widget.delay, () {
        if (mounted) {
          _controller.forward();
        }
      });
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return SlideTransition(
          position: _offsetAnimation,
          child: FadeTransition(
            opacity: _opacityAnimation,
            child: widget.child,
          ),
        );
      },
    );
  }
}

/// Direction de glissement
enum SlideDirection {
  left,
  right,
  top,
  bottom,
}

/// Widget d'animation de mise à l'échelle
class ScaleInAnimation extends StatefulWidget {
  /// Widget enfant à animer
  final Widget child;
  
  /// Échelle initiale
  final double initialScale;
  
  /// Durée de l'animation
  final Duration duration;
  
  /// Délai avant le début de l'animation
  final Duration delay;
  
  /// Courbe d'animation
  final Curve curve;
  
  /// Constructeur
  const ScaleInAnimation({
    super.key,
    required this.child,
    this.initialScale = 0.0,
    this.duration = AnimationUtils.normalDuration,
    this.delay = Duration.zero,
    this.curve = AnimationUtils.bouncyCurve,
  });

  @override
  State<ScaleInAnimation> createState() => _ScaleInAnimationState();
}

class _ScaleInAnimationState extends State<ScaleInAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.duration,
      vsync: this,
    );
    
    _scaleAnimation = Tween<double>(
      begin: widget.initialScale,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: widget.curve,
    ));
    
    _opacityAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeIn,
    ));

    // Démarrer l'animation après le délai
    if (widget.delay == Duration.zero) {
      _controller.forward();
    } else {
      Future.delayed(widget.delay, () {
        if (mounted) {
          _controller.forward();
        }
      });
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: Opacity(
            opacity: _opacityAnimation.value,
            child: widget.child,
          ),
        );
      },
    );
  }
}

/// Widget d'animation en cascade pour listes
class StaggeredListAnimation extends StatelessWidget {
  /// Liste des widgets enfants
  final List<Widget> children;
  
  /// Durée de base pour chaque élément
  final Duration itemDuration;
  
  /// Délai entre chaque élément
  final Duration staggerDelay;
  
  /// Direction de l'animation
  final SlideDirection direction;
  
  /// Constructeur
  const StaggeredListAnimation({
    super.key,
    required this.children,
    this.itemDuration = AnimationUtils.normalDuration,
    this.staggerDelay = const Duration(milliseconds: 100),
    this.direction = SlideDirection.bottom,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: children.asMap().entries.map((entry) {
        final index = entry.key;
        final child = entry.value;
        
        return SlideInAnimation(
          delay: Duration(milliseconds: staggerDelay.inMilliseconds * index),
          duration: itemDuration,
          direction: direction,
          child: child,
        );
      }).toList(),
    );
  }
}

/// Widget bouton avec effet de pression
class AnimatedPressButton extends StatefulWidget {
  /// Widget enfant (contenu du bouton)
  final Widget child;
  
  /// Callback lors du tap
  final VoidCallback? onPressed;
  
  /// Échelle lors de la pression
  final double pressedScale;
  
  /// Constructeur
  const AnimatedPressButton({
    super.key,
    required this.child,
    this.onPressed,
    this.pressedScale = 0.95,
  });

  @override
  State<AnimatedPressButton> createState() => _AnimatedPressButtonState();
}

class _AnimatedPressButtonState extends State<AnimatedPressButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: AnimationUtils.fastDuration,
      vsync: this,
    );
    
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: widget.pressedScale,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) {
        if (widget.onPressed != null) {
          _controller.forward();
        }
      },
      onTapUp: (_) {
        if (widget.onPressed != null) {
          _controller.reverse();
          widget.onPressed?.call();
        }
      },
      onTapCancel: () {
        _controller.reverse();
      },
      child: AnimatedBuilder(
        animation: _scaleAnimation,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: widget.child,
          );
        },
      ),
    );
  }
}

/// Widget de transition de page personnalisée
class CustomPageTransition extends PageRouteBuilder {
  /// Widget de destination
  final Widget child;
  
  /// Type de transition
  final PageTransitionType type;
  
  /// Durée de la transition
  final Duration duration;
  
  /// Constructeur
  CustomPageTransition({
    required this.child,
    this.type = PageTransitionType.slideRight,
    this.duration = AnimationUtils.normalDuration,
  }) : super(
          pageBuilder: (context, animation, secondaryAnimation) => child,
          transitionDuration: duration,
          reverseTransitionDuration: duration,
        );

  @override
  Widget buildTransitions(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    switch (type) {
      case PageTransitionType.fade:
        return FadeTransition(
          opacity: animation,
          child: child,
        );
      
      case PageTransitionType.slideRight:
        return SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(-1.0, 0.0),
            end: Offset.zero,
          ).animate(CurvedAnimation(
            parent: animation,
            curve: AnimationUtils.smoothCurve,
          )),
          child: child,
        );
      
      case PageTransitionType.slideLeft:
        return SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(1.0, 0.0),
            end: Offset.zero,
          ).animate(CurvedAnimation(
            parent: animation,
            curve: AnimationUtils.smoothCurve,
          )),
          child: child,
        );
      
      case PageTransitionType.slideUp:
        return SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(0.0, 1.0),
            end: Offset.zero,
          ).animate(CurvedAnimation(
            parent: animation,
            curve: AnimationUtils.smoothCurve,
          )),
          child: child,
        );
      
      case PageTransitionType.scale:
        return ScaleTransition(
          scale: Tween<double>(
            begin: 0.0,
            end: 1.0,
          ).animate(CurvedAnimation(
            parent: animation,
            curve: AnimationUtils.bouncyCurve,
          )),
          child: FadeTransition(
            opacity: animation,
            child: child,
          ),
        );
    }
  }
}

/// Types de transition de page
enum PageTransitionType {
  fade,
  slideRight,
  slideLeft,
  slideUp,
  scale,
}

/// Widget de chargement animé personnalisé
class AnimatedLoadingIndicator extends StatefulWidget {
  /// Couleur principale
  final Color color;
  
  /// Taille de l'indicateur
  final double size;
  
  /// Type d'animation
  final LoadingType type;
  
  /// Constructeur
  const AnimatedLoadingIndicator({
    super.key,
    this.color = Colors.blue,
    this.size = 40.0,
    this.type = LoadingType.dots,
  });

  @override
  State<AnimatedLoadingIndicator> createState() => _AnimatedLoadingIndicatorState();
}

class _AnimatedLoadingIndicatorState extends State<AnimatedLoadingIndicator>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late List<AnimationController> _dotControllers;
  late List<Animation<double>> _dotAnimations;

  @override
  void initState() {
    super.initState();
    
    switch (widget.type) {
      case LoadingType.dots:
        _initializeDotAnimations();
        break;
      case LoadingType.pulse:
        _initializePulseAnimation();
        break;
      case LoadingType.wave:
        _initializeWaveAnimation();
        break;
    }
  }

  void _initializeDotAnimations() {
    _dotControllers = List.generate(3, (index) {
      return AnimationController(
        duration: const Duration(milliseconds: 600),
        vsync: this,
      );
    });
    
    _dotAnimations = _dotControllers.map((controller) {
      return Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(parent: controller, curve: Curves.easeInOut),
      );
    }).toList();
    
    // Démarrer les animations en cascade
    for (int i = 0; i < _dotControllers.length; i++) {
      Future.delayed(Duration(milliseconds: i * 200), () {
        if (mounted) {
          _dotControllers[i].repeat(reverse: true);
        }
      });
    }
  }

  void _initializePulseAnimation() {
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    _controller.repeat(reverse: true);
  }

  void _initializeWaveAnimation() {
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );
    _controller.repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    for (final controller in _dotControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    switch (widget.type) {
      case LoadingType.dots:
        return _buildDotsLoader();
      case LoadingType.pulse:
        return _buildPulseLoader();
      case LoadingType.wave:
        return _buildWaveLoader();
    }
  }

  Widget _buildDotsLoader() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(3, (index) {
        return AnimatedBuilder(
          animation: _dotAnimations[index],
          builder: (context, child) {
            return Container(
              margin: const EdgeInsets.symmetric(horizontal: 4),
              child: Transform.scale(
                scale: 0.5 + (_dotAnimations[index].value * 0.5),
                child: Container(
                  width: widget.size / 4,
                  height: widget.size / 4,
                  decoration: BoxDecoration(
                    color: widget.color.withOpacity(0.3 + (_dotAnimations[index].value * 0.7)),
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            );
          },
        );
      }),
    );
  }

  Widget _buildPulseLoader() {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Transform.scale(
          scale: 0.8 + (_controller.value * 0.2),
          child: Container(
            width: widget.size,
            height: widget.size,
            decoration: BoxDecoration(
              color: widget.color.withOpacity(0.3 + (_controller.value * 0.4)),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.refresh,
              color: widget.color,
              size: widget.size * 0.6,
            ),
          ),
        );
      },
    );
  }

  Widget _buildWaveLoader() {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Transform.rotate(
          angle: _controller.value * 2 * 3.14159,
          child: Container(
            width: widget.size,
            height: widget.size,
            decoration: BoxDecoration(
              gradient: SweepGradient(
                colors: [
                  widget.color.withOpacity(0.1),
                  widget.color,
                  widget.color.withOpacity(0.1),
                ],
                stops: const [0.0, 0.5, 1.0],
              ),
              shape: BoxShape.circle,
            ),
          ),
        );
      },
    );
  }
}

/// Types d'indicateur de chargement
enum LoadingType {
  dots,
  pulse,
  wave,
}

/// Widget d'animation de compteur
class AnimatedCounter extends StatefulWidget {
  /// Valeur cible
  final double value;
  
  /// Durée de l'animation
  final Duration duration;
  
  /// Style du texte
  final TextStyle? textStyle;
  
  /// Formatage personnalisé
  final String Function(double)? formatter;
  
  /// Constructeur
  const AnimatedCounter({
    super.key,
    required this.value,
    this.duration = AnimationUtils.normalDuration,
    this.textStyle,
    this.formatter,
  });

  @override
  State<AnimatedCounter> createState() => _AnimatedCounterState();
}

class _AnimatedCounterState extends State<AnimatedCounter>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  double _previousValue = 0.0;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.duration,
      vsync: this,
    );
    
    _animation = Tween<double>(
      begin: _previousValue,
      end: widget.value,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: AnimationUtils.smoothCurve,
    ));
    
    _controller.forward();
  }

  @override
  void didUpdateWidget(AnimatedCounter oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.value != widget.value) {
      _previousValue = _animation.value;
      _animation = Tween<double>(
        begin: _previousValue,
        end: widget.value,
      ).animate(CurvedAnimation(
        parent: _controller,
        curve: AnimationUtils.smoothCurve,
      ));
      _controller.reset();
      _controller.forward();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        final value = _animation.value;
        final formattedValue = widget.formatter?.call(value) ?? 
                             value.toStringAsFixed(value % 1 == 0 ? 0 : 1);
        
        return Text(
          formattedValue,
          style: widget.textStyle,
        );
      },
    );
  }
}