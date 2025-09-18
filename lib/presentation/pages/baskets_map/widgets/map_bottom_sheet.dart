import 'package:flutter/material.dart';
import 'package:foodsave_app/core/constants/app_colors.dart';
import 'package:foodsave_app/core/constants/app_dimensions.dart';
import 'package:foodsave_app/core/constants/app_text_styles.dart';
import 'package:foodsave_app/domain/entities/basket.dart';

/// Bottom sheet pour afficher les détails d'un panier sélectionné.
///
/// S'affiche au bas de l'écran avec possibilité d'expansion.
class MapBottomSheet extends StatefulWidget {
  /// Crée une nouvelle instance de [MapBottomSheet].
  ///
  /// [basket] : Le panier à afficher.
  /// [isExpanded] : Indique si le sheet est expandé.
  /// [onToggleExpanded] : Callback pour basculer l'expansion.
  /// [onClose] : Callback pour fermer le sheet.
  /// [onReserve] : Callback pour réserver le panier.
  /// [onGetDirections] : Callback pour obtenir les directions.
  const MapBottomSheet({
    super.key,
    required this.basket,
    required this.isExpanded,
    required this.onToggleExpanded,
    required this.onClose,
    required this.onReserve,
    required this.onGetDirections,
  });

  /// Le panier à afficher.
  final Basket basket;

  /// Indique si le sheet est expandé.
  final bool isExpanded;

  /// Callback pour basculer l'expansion.
  final VoidCallback onToggleExpanded;

  /// Callback pour fermer le sheet.
  final VoidCallback onClose;

  /// Callback pour réserver le panier.
  final VoidCallback onReserve;

  /// Callback pour obtenir les directions.
  final VoidCallback onGetDirections;

  @override
  State<MapBottomSheet> createState() => _MapBottomSheetState();
}

class _MapBottomSheetState extends State<MapBottomSheet>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _heightAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    
    _heightAnimation = Tween<double>(
      begin: 0.25,
      end: 0.7,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void didUpdateWidget(MapBottomSheet oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isExpanded != oldWidget.isExpanded) {
      if (widget.isExpanded) {
        _animationController.forward();
      } else {
        _animationController.reverse();
      }
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    
    return Positioned(
      left: 0,
      right: 0,
      bottom: 0,
      child: AnimatedBuilder(
        animation: _heightAnimation,
        builder: (context, child) {
          final height = widget.isExpanded 
              ? screenHeight * _heightAnimation.value
              : screenHeight * 0.25;
              
          return Container(
            height: height,
            decoration: const BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(24),
                topRight: Radius.circular(24),
              ),
              boxShadow: [
                BoxShadow(
                  color: AppColors.shadow,
                  blurRadius: 16,
                  offset: Offset(0, -4),
                ),
              ],
            ),
            child: Column(
              children: [
                // En-tête du sheet
                _buildSheetHeader(),
                
                // Contenu principal
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(16),
                    child: widget.isExpanded
                        ? _buildExpandedContent()
                        : _buildCollapsedContent(),
                  ),
                ),
                
                // Boutons d'action
                _buildActionButtons(),
              ],
            ),
          );
        },
      ),
    );
  }

  /// Construit l'en-tête du sheet.
  Widget _buildSheetHeader() {
    return GestureDetector(
      onTap: widget.onToggleExpanded,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Column(
          children: [
            // Indicateur de glissement
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.divider,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 12),
            
            // Titre et bouton fermer
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      widget.basket.commerce.name,
                      style: AppTextStyles.headline6.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: widget.onClose,
                    icon: Icon(
                      Icons.close,
                      color: AppColors.textSecondary,
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

  /// Contenu quand le sheet est réduit.
  Widget _buildCollapsedContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Titre du panier
        Text(
          widget.basket.title,
          style: AppTextStyles.bodyLarge.copyWith(
            fontWeight: FontWeight.w600,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        
        const SizedBox(height: 8),
        
        // Prix et réduction
        Row(
          children: [
            Text(
              '${widget.basket.discountedPrice.toStringAsFixed(2)}€',
              style: AppTextStyles.headline5.copyWith(
                color: AppColors.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(width: 8),
            Text(
              '${widget.basket.originalPrice.toStringAsFixed(2)}€',
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textSecondary,
                decoration: TextDecoration.lineThrough,
              ),
            ),
            const Spacer(),
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 8,
                vertical: 4,
              ),
              decoration: BoxDecoration(
                color: AppColors.secondary.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                '-${widget.basket.discountPercentage.toInt()}%',
                style: AppTextStyles.labelSmall.copyWith(
                  color: AppColors.secondary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        
        const SizedBox(height: 12),
        
        // Horaires
        Row(
          children: [
            Icon(
              Icons.schedule,
              size: 16,
              color: AppColors.success,
            ),
            const SizedBox(width: 4),
            Text(
              'Récupération : ${_formatTime(widget.basket.pickupTimeStart)} - ${_formatTime(widget.basket.pickupTimeEnd)}',
              style: AppTextStyles.bodySmall.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ],
    );
  }

  /// Contenu quand le sheet est expandé.
  Widget _buildExpandedContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Image placeholder
        Container(
          height: 120,
          width: double.infinity,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                AppColors.primary.withValues(alpha: 0.1),
                AppColors.secondary.withValues(alpha: 0.1),
              ],
            ),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Center(
            child: Icon(
              Icons.image_outlined,
              size: 48,
              color: AppColors.textSecondary.withValues(alpha: 0.5),
            ),
          ),
        ),
        
        const SizedBox(height: 16),
        
        // Titre et badges
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Text(
                widget.basket.title,
                style: AppTextStyles.headline6.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            if (widget.basket.isLastChance)
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: AppColors.error,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '🔥 Dernière chance',
                  style: AppTextStyles.labelSmall.copyWith(
                    color: AppColors.textOnDark,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
          ],
        ),
        
        const SizedBox(height: 12),
        
        // Description
        Text(
          widget.basket.description,
          style: AppTextStyles.bodyMedium.copyWith(
            color: AppColors.textSecondary,
            height: 1.4,
          ),
        ),
        
        const SizedBox(height: 16),
        
        // Informations détaillées
        _buildDetailRow(
          Icons.euro,
          'Prix',
          '${widget.basket.discountedPrice.toStringAsFixed(2)}€ (était ${widget.basket.originalPrice.toStringAsFixed(2)}€)',
        ),
        _buildDetailRow(
          Icons.schedule,
          'Récupération',
          '${_formatTime(widget.basket.pickupTimeStart)} - ${_formatTime(widget.basket.pickupTimeEnd)}',
        ),
        _buildDetailRow(
          Icons.inventory,
          'Quantité',
          '${widget.basket.quantity} disponible${widget.basket.quantity > 1 ? 's' : ''}',
        ),
        if (widget.basket.estimatedWeight != null)
          _buildDetailRow(
            Icons.monitor_weight,
            'Poids estimé',
            '${widget.basket.estimatedWeight!.toStringAsFixed(1)} kg',
          ),
        
        const SizedBox(height: 16),
        
        // Tags diététiques
        if (widget.basket.dietaryTags.isNotEmpty)
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: widget.basket.dietaryTags.map((tag) {
              return Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: AppColors.eco.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: AppColors.eco.withValues(alpha: 0.3),
                  ),
                ),
                child: Text(
                  tag,
                  style: AppTextStyles.labelSmall.copyWith(
                    color: AppColors.eco,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              );
            }).toList(),
          ),
      ],
    );
  }

  /// Construit une ligne de détail.
  Widget _buildDetailRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 18, color: AppColors.primary),
          const SizedBox(width: 8),
          Text(
            '$label : ',
            style: AppTextStyles.bodyMedium.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Construit les boutons d'action.
  Widget _buildActionButtons() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        color: AppColors.surface,
        border: Border(
          top: BorderSide(color: AppColors.border, width: 1),
        ),
      ),
      child: Row(
        children: [
          // Bouton Directions
          Expanded(
            child: OutlinedButton.icon(
              onPressed: widget.onGetDirections,
              icon: Icon(Icons.directions, color: AppColors.primary),
              label: Text(
                'Directions',
                style: AppTextStyles.labelLarge.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
              style: OutlinedButton.styleFrom(
                side: BorderSide(color: AppColors.primary, width: 2),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppDimensions.radiusM),
                ),
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
            ),
          ),
          
          const SizedBox(width: 12),
          
          // Bouton Réserver
          Expanded(
            flex: 2,
            child: Container(
              decoration: BoxDecoration(
                gradient: AppColors.primaryGradient,
                borderRadius: BorderRadius.circular(AppDimensions.radiusM),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary.withValues(alpha: 0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: ElevatedButton.icon(
                onPressed: widget.basket.isAvailable ? widget.onReserve : null,
                icon: Icon(
                  widget.basket.isAvailable 
                      ? Icons.add_shopping_cart 
                      : Icons.not_interested,
                  color: AppColors.textOnDark,
                ),
                label: Text(
                  widget.basket.isAvailable 
                      ? 'Réserver ${widget.basket.discountedPrice.toStringAsFixed(2)}€'
                      : 'Indisponible',
                  style: AppTextStyles.labelLarge.copyWith(
                    color: AppColors.textOnDark,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  shadowColor: Colors.transparent,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppDimensions.radiusM),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Formate une heure.
  String _formatTime(DateTime dateTime) {
    return '${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
  }
}