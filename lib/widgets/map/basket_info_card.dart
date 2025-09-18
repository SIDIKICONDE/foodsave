import 'package:flutter/material.dart';
import '../../models/map_marker.dart';
import '../../core/constants/app_colors.dart';

/// Widget pour afficher les informations d'un panier sélectionné sur la carte
class BasketInfoCard extends StatelessWidget {
  final MapMarker marker;
  final VoidCallback onClose;
  final VoidCallback? onNavigate;
  final VoidCallback? onToggleFavorite;

  const BasketInfoCard({
    super.key,
    required this.marker,
    required this.onClose,
    this.onNavigate,
    this.onToggleFavorite,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 10,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // En-tête avec image
          if (marker.imageUrl != null) ...[
            ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
              child: Stack(
                children: [
                  Image.network(
                    marker.imageUrl!,
                    height: 150,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        height: 150,
                        color: Colors.grey[300],
                        child: const Icon(Icons.image_not_supported, size: 50),
                      );
                    },
                  ),
                  Positioned(
                    top: 8,
                    right: 8,
                    child: CircleAvatar(
                      backgroundColor: Colors.white,
                      child: IconButton(
                        icon: const Icon(Icons.close, color: Colors.black),
                        onPressed: onClose,
                        padding: EdgeInsets.zero,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ] else ...[
            // En-tête sans image
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    marker.type.iconAsset,
                    style: const TextStyle(fontSize: 24),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: onClose,
                    padding: EdgeInsets.zero,
                  ),
                ],
              ),
            ),
          ],

          // Contenu
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Type et titre
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: _getTypeColor(marker.type).withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        marker.type.label,
                        style: TextStyle(
                          color: _getTypeColor(marker.type),
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    if (marker.rating != null) ...[
                      const Icon(Icons.star, color: Colors.amber, size: 16),
                      Text(
                        marker.rating!.toStringAsFixed(1),
                        style: const TextStyle(fontSize: 12),
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: 8),

                // Titre
                Text(
                  marker.title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                if (marker.shopName != null) ...[
                  const SizedBox(height: 4),
                  Text(
                    marker.shopName!,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                  ),
                ],

                // Description
                const SizedBox(height: 8),
                Text(
                  marker.description,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[700],
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),

                // Adresse
                if (marker.address != null) ...[
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(Icons.location_on, size: 16, color: Colors.grey[600]),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          marker.address!,
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ],

                // Informations supplémentaires
                const SizedBox(height: 12),
                Row(
                  children: [
                    // Prix
                    if (marker.price != null) ...[
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          '${marker.price!.toStringAsFixed(2)} €',
                          style: const TextStyle(
                            color: AppColors.primary,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                    ],

                    // Quantité
                    if (marker.quantity != null) ...[
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey[300]!),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.inventory_2, size: 14, color: Colors.grey),
                            const SizedBox(width: 4),
                            Text(
                              '${marker.quantity}',
                              style: const TextStyle(fontSize: 12),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                    ],

                    // Temps restant
                    if (marker.availableUntil != null) ...[
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.orange[300]!),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.access_time, size: 14, color: Colors.orange[700]),
                            const SizedBox(width: 4),
                            Text(
                              _formatTimeRemaining(marker.availableUntil!),
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.orange[700],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ],
                ),

                // Actions
                const SizedBox(height: 16),
                Row(
                  children: [
                    // Bouton favori
                    if (onToggleFavorite != null) ...[
                      IconButton(
                        icon: Icon(
                          marker.isFavorite ? Icons.favorite : Icons.favorite_border,
                          color: marker.isFavorite ? Colors.red : Colors.grey,
                        ),
                        onPressed: onToggleFavorite,
                      ),
                      const SizedBox(width: 8),
                    ],

                    // Bouton navigation
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: onNavigate ?? () {},
                        icon: const Icon(Icons.directions),
                        label: const Text('Y aller'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Obtenir la couleur associée au type de marqueur
  Color _getTypeColor(MarkerType type) {
    switch (type) {
      case MarkerType.boulangerie:
        return Colors.orange;
      case MarkerType.restaurant:
        return Colors.red;
      case MarkerType.supermarche:
        return Colors.blue;
      case MarkerType.primeur:
        return Colors.green;
      case MarkerType.autre:
        return Colors.purple;
      case MarkerType.userLocation:
        return Colors.cyan;
    }
  }

  /// Formater le temps restant
  String _formatTimeRemaining(DateTime availableUntil) {
    final Duration difference = availableUntil.difference(DateTime.now());
    
    if (difference.isNegative) {
      return 'Expiré';
    }
    
    if (difference.inDays > 0) {
      return '${difference.inDays}j';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}min';
    } else {
      return 'Bientôt';
    }
  }
}