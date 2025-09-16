import 'package:flutter/material.dart';

import '../../models/meal.dart';

/// Widget de carte pour afficher un repas
/// Respecte les standards NYTH - Zero Compromise
class MealCard extends StatelessWidget {
  /// Le repas à afficher
  final Meal meal;
  
  /// Callback appelé lors du tap sur la carte
  final VoidCallback? onTap;
  
  /// Indique si la carte est compacte
  final bool isCompact;
  
  /// Indique si on affiche les boutons d'action
  final bool showActions;
  
  /// Callback pour le bouton de réservation
  final VoidCallback? onReserve;
  
  /// Callback pour le bouton de favoris
  final VoidCallback? onFavorite;
  
  /// Indique si le repas est en favori
  final bool isFavorite;

  /// Constructeur de la carte de repas
  const MealCard({
    super.key,
    required this.meal,
    this.onTap,
    this.isCompact = false,
    this.showActions = true,
    this.onReserve,
    this.onFavorite,
    this.isFavorite = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Card(
      clipBehavior: Clip.antiAlias,
      elevation: 2,
      margin: EdgeInsets.symmetric(
        horizontal: 16,
        vertical: isCompact ? 4 : 8,
      ),
      child: InkWell(
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image du repas
            _buildMealImage(context),
            
            // Contenu principal
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Titre et badges
                  _buildTitleSection(theme),
                  
                  if (!isCompact) ...[
                    const SizedBox(height: 8),
                    // Description
                    _buildDescription(theme),
                  ],
                  
                  const SizedBox(height: 12),
                  
                  // Prix et économies
                  _buildPriceSection(theme),
                  
                  const SizedBox(height: 8),
                  
                  // Informations temporelles
                  _buildTimeSection(theme),
                  
                  if (showActions) ...[
                    const SizedBox(height: 12),
                    // Boutons d'action
                    _buildActionButtons(theme),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Construit l'image du repas
  Widget _buildMealImage(BuildContext context) {
    return Stack(
      children: [
        // Image principale
        Container(
          height: isCompact ? 120 : 200,
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.grey[300],
            image: meal.imageUrls.isNotEmpty
                ? DecorationImage(
                    image: NetworkImage(meal.imageUrls.first),
                    fit: BoxFit.cover,
                    onError: (error, stackTrace) {
                      // Fallback vers image par défaut
                    },
                  )
                : null,
          ),
          child: meal.imageUrls.isEmpty
              ? Icon(
                  Icons.restaurant,
                  size: isCompact ? 40 : 60,
                  color: Colors.grey[600],
                )
              : null,
        ),
        
        // Badge de statut
        Positioned(
          top: 8,
          right: 8,
          child: _buildStatusBadge(),
        ),
        
        // Badge de favori
        if (onFavorite != null)
          Positioned(
            top: 8,
            left: 8,
            child: _buildFavoriteButton(),
          ),
        
        // Badge de réduction
        if (meal.discountPercentage > 0)
          Positioned(
            bottom: 8,
            left: 8,
            child: _buildDiscountBadge(),
          ),
      ],
    );
  }

  /// Construit le badge de statut
  Widget _buildStatusBadge() {
    Color badgeColor;
    String badgeText;
    
    if (!meal.isAvailable) {
      badgeColor = Colors.red;
      badgeText = 'Épuisé';
    } else if (meal.timeUntilExpiration.inHours < 2) {
      badgeColor = Colors.orange;
      badgeText = 'Bientôt expiré';
    } else {
      badgeColor = Colors.green;
      badgeText = 'Disponible';
    }
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: badgeColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        badgeText,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  /// Construit le bouton de favori
  Widget _buildFavoriteButton() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.9),
        shape: BoxShape.circle,
      ),
      child: IconButton(
        onPressed: onFavorite,
        icon: Icon(
          isFavorite ? Icons.favorite : Icons.favorite_border,
          color: isFavorite ? Colors.red : Colors.grey[700],
          size: 20,
        ),
        padding: const EdgeInsets.all(4),
        constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
      ),
    );
  }

  /// Construit le badge de réduction
  Widget _buildDiscountBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
      decoration: BoxDecoration(
        color: Colors.red,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        '-${meal.discountPercentage.toInt()}%',
        style: const TextStyle(
          color: Colors.white,
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  /// Construit la section titre avec badges
  Widget _buildTitleSection(ThemeData theme) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                meal.title,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 4),
              _buildCategoryBadges(theme),
            ],
          ),
        ),
        // Note moyenne
        if (meal.averageRating > 0) _buildRating(theme),
      ],
    );
  }

  /// Construit les badges de catégorie et spécificités
  Widget _buildCategoryBadges(ThemeData theme) {
    final badges = <Widget>[];
    
    // Catégorie
    badges.add(_createBadge(
      _getCategoryText(meal.category),
      theme.primaryColor.withOpacity(0.1),
      theme.primaryColor,
    ));
    
    // Badges spéciaux
    if (meal.isVegetarian) {
      badges.add(_createBadge('Végétarien', Colors.green.withOpacity(0.1), Colors.green));
    }
    if (meal.isVegan) {
      badges.add(_createBadge('Végétalien', Colors.green.withOpacity(0.1), Colors.green));
    }
    if (meal.isGlutenFree) {
      badges.add(_createBadge('Sans gluten', Colors.blue.withOpacity(0.1), Colors.blue));
    }
    
    return Wrap(
      spacing: 4,
      runSpacing: 4,
      children: badges,
    );
  }

  /// Crée un badge
  Widget _createBadge(String text, Color backgroundColor, Color textColor) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: textColor,
          fontSize: 10,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  /// Construit la note
  Widget _buildRating(ThemeData theme) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          Icons.star,
          size: 16,
          color: Colors.amber[600],
        ),
        const SizedBox(width: 2),
        Text(
          meal.averageRating.toStringAsFixed(1),
          style: theme.textTheme.bodySmall?.copyWith(
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  /// Construit la description
  Widget _buildDescription(ThemeData theme) {
    return Text(
      meal.description,
      style: theme.textTheme.bodyMedium?.copyWith(
        color: Colors.grey[700],
      ),
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
    );
  }

  /// Construit la section prix
  Widget _buildPriceSection(ThemeData theme) {
    return Row(
      children: [
        // Prix réduit
        Text(
          '${meal.discountedPrice.toStringAsFixed(2)} €',
          style: theme.textTheme.titleLarge?.copyWith(
            color: theme.primaryColor,
            fontWeight: FontWeight.bold,
          ),
        ),
        
        const SizedBox(width: 8),
        
        // Prix original barré
        if (meal.originalPrice > meal.discountedPrice)
          Text(
            '${meal.originalPrice.toStringAsFixed(2)} €',
            style: theme.textTheme.bodyMedium?.copyWith(
              decoration: TextDecoration.lineThrough,
              color: Colors.grey[600],
            ),
          ),
        
        const Spacer(),
        
        // Économie réalisée
        if (meal.savings > 0)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              color: Colors.green.withOpacity(0.1),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              'Économie ${meal.savings.toStringAsFixed(2)} €',
              style: TextStyle(
                color: Colors.green[700],
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
      ],
    );
  }

  /// Construit la section temporelle
  Widget _buildTimeSection(ThemeData theme) {
    final timeRemaining = meal.timeUntilExpiration;
    final isUrgent = timeRemaining.inHours < 2;
    
    return Row(
      children: [
        Icon(
          Icons.access_time,
          size: 16,
          color: isUrgent ? Colors.orange : Colors.grey[600],
        ),
        const SizedBox(width: 4),
        Text(
          _formatTimeRemaining(timeRemaining),
          style: theme.textTheme.bodySmall?.copyWith(
            color: isUrgent ? Colors.orange : Colors.grey[600],
            fontWeight: isUrgent ? FontWeight.w600 : null,
          ),
        ),
        
        const SizedBox(width: 16),
        
        Icon(
          Icons.inventory,
          size: 16,
          color: Colors.grey[600],
        ),
        const SizedBox(width: 4),
        Text(
          '${meal.remainingQuantity} restant${meal.remainingQuantity > 1 ? 's' : ''}',
          style: theme.textTheme.bodySmall?.copyWith(
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }

  /// Construit les boutons d'action
  Widget _buildActionButtons(ThemeData theme) {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton.icon(
            onPressed: meal.isAvailable ? onReserve : null,
            icon: const Icon(Icons.shopping_cart, size: 18),
            label: Text(
              meal.isAvailable ? 'Réserver' : 'Indisponible',
              style: const TextStyle(fontSize: 14),
            ),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 8),
            ),
          ),
        ),
        
        const SizedBox(width: 8),
        
        OutlinedButton.icon(
          onPressed: onTap,
          icon: const Icon(Icons.info_outline, size: 18),
          label: const Text(
            'Détails',
            style: TextStyle(fontSize: 14),
          ),
          style: OutlinedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          ),
        ),
      ],
    );
  }

  /// Formate le temps restant
  String _formatTimeRemaining(Duration duration) {
    if (duration.inDays > 0) {
      return '${duration.inDays} jour${duration.inDays > 1 ? 's' : ''}';
    } else if (duration.inHours > 0) {
      return '${duration.inHours}h${duration.inMinutes.remainder(60).toString().padLeft(2, '0')}';
    } else if (duration.inMinutes > 0) {
      return '${duration.inMinutes} min';
    } else {
      return 'Expiré';
    }
  }

  /// Obtient le texte de la catégorie
  String _getCategoryText(MealCategory category) {
    switch (category) {
      case MealCategory.mainCourse:
        return 'Plat principal';
      case MealCategory.appetizer:
        return 'Entrée';
      case MealCategory.dessert:
        return 'Dessert';
      case MealCategory.beverage:
        return 'Boisson';
      case MealCategory.snack:
        return 'Snack';
      case MealCategory.bakery:
        return 'Boulangerie';
      case MealCategory.other:
        return 'Autre';
    }
  }
}