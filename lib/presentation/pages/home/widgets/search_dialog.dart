import 'package:flutter/material.dart';
import 'package:foodsave_app/core/constants/app_colors.dart';
import 'package:foodsave_app/core/constants/app_dimensions.dart';
import 'package:foodsave_app/core/constants/app_text_styles.dart';

/// Dialogue de recherche pour les paniers et commerces.
///
/// Affiche un dialogue modal avec une barre de recherche et des suggestions.
class SearchDialog extends StatefulWidget {
  /// Crée une nouvelle instance de [SearchDialog].
  const SearchDialog({super.key});

  @override
  State<SearchDialog> createState() => _SearchDialogState();
}

class _SearchDialogState extends State<SearchDialog> {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();

  /// Données complètes pour la recherche.
  late List<Map<String, dynamic>> _allSearchData;

  /// Résultats de recherche filtrés.
  List<Map<String, dynamic>> _searchResults = [];

  @override
  void initState() {
    super.initState();
    // Ouvrir automatiquement le clavier
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _searchFocusNode.requestFocus();
    });

    // Charger les données de recherche initiales
    _loadSearchData();
  }

  /// Charge les données pour la recherche.
  void _loadSearchData() {
    // Simulation des données de paniers pour la recherche
    // TODO: Remplacer par des données réelles depuis un repository
    _allSearchData = [
      {
        'id': '1',
        'title': 'Panier Surprise Boulangerie',
        'shop': 'Boulangerie Artisanale',
        'price': 4.99,
        'distance': 0.5,
        'category': 'Boulangerie',
      },
      {
        'id': '2',
        'title': 'Panier Fruits & Légumes Bio',
        'shop': 'Marché Bio Local',
        'price': 6.99,
        'distance': 1.2,
        'category': 'Bio',
      },
      {
        'id': '3',
        'title': 'Menu Restaurant Asiatique',
        'shop': 'Tokyo Express',
        'price': 8.99,
        'distance': 2.0,
        'category': 'Restaurant',
      },
      {
        'id': '4',
        'title': 'Panier Pâtisserie Française',
        'shop': 'Pâtisserie du Coin',
        'price': 5.50,
        'distance': 0.8,
        'category': 'Pâtisserie',
      },
      {
        'id': '5',
        'title': 'Panier Vegan Healthy',
        'shop': 'Green Food Market',
        'price': 7.25,
        'distance': 1.5,
        'category': 'Végétarien',
      },
    ];
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  /// Filtre les résultats de recherche selon la requête.
  void _filterSearchResults(String query) {
    if (query.isEmpty) {
      setState(() => _searchResults = []);
      return;
    }

    final searchTerm = query.toLowerCase();
    final filtered = _allSearchData.where((item) {
      final title = item['title'].toString().toLowerCase();
      final shop = item['shop'].toString().toLowerCase();
      final category = item['category'].toString().toLowerCase();

      return title.contains(searchTerm) ||
             shop.contains(searchTerm) ||
             category.contains(searchTerm);
    }).toList();

    setState(() => _searchResults = filtered);
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.all(AppDimensions.spacingL),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppColors.surface,
              AppColors.surfaceSecondary,
            ],
          ),
          borderRadius: BorderRadius.circular(AppDimensions.radiusL),
          boxShadow: [
            BoxShadow(
              color: AppColors.shadow,
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header avec titre et bouton fermer
            Container(
              padding: const EdgeInsets.all(AppDimensions.spacingL),
              decoration: BoxDecoration(
                gradient: AppColors.primaryGradient,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(AppDimensions.radiusL),
                  topRight: Radius.circular(AppDimensions.radiusL),
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.search,
                    color: AppColors.textOnDark,
                    size: AppDimensions.iconM,
                  ),
                  const SizedBox(width: AppDimensions.spacingM),
                  Expanded(
                    child: Text(
                      'Rechercher',
                      style: AppTextStyles.headline6.copyWith(
                        color: AppColors.textOnDark,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: Icon(
                      Icons.close,
                      color: AppColors.textOnDark,
                      size: AppDimensions.iconM,
                    ),
                    style: IconButton.styleFrom(
                      backgroundColor: AppColors.surface.withValues(alpha: 0.2),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            
            // Contenu principal
            Padding(
              padding: const EdgeInsets.all(AppDimensions.spacingL),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Barre de recherche
                  Container(
                    decoration: BoxDecoration(
                      color: AppColors.background,
                      borderRadius: BorderRadius.circular(AppDimensions.radiusM),
                      border: Border.all(
                        color: AppColors.primary.withValues(alpha: 0.3),
                        width: 2,
                      ),
                    ),
                    child: TextField(
                      controller: _searchController,
                      focusNode: _searchFocusNode,
                      decoration: InputDecoration(
                        hintText: '🔍 Rechercher des paniers ou commerces...',
                        hintStyle: AppTextStyles.withColor(
                          AppTextStyles.bodyMedium,
                          AppColors.textSecondary,
                        ),
                        prefixIcon: Container(
                          margin: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            gradient: AppColors.primaryGradient,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.search,
                            color: AppColors.textOnDark,
                            size: 20,
                          ),
                        ),
                        suffixIcon: _searchController.text.isNotEmpty
                            ? IconButton(
                                icon: Icon(
                                  Icons.clear,
                                  color: AppColors.textSecondary,
                                ),
                                onPressed: () {
                                  _searchController.clear();
                                  setState(() {});
                                },
                              )
                            : null,
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: AppDimensions.spacingL,
                          vertical: AppDimensions.spacingM,
                        ),
                      ),
                      onChanged: (value) {
                        setState(() {});
                        _filterSearchResults(value);
                      },
                      onSubmitted: (value) {
                        _performSearch(value);
                      },
                    ),
                  ),
                  
                  const SizedBox(height: AppDimensions.spacingL),

                  // Afficher les résultats de recherche ou les suggestions
                  if (_searchController.text.isNotEmpty && _searchResults.isNotEmpty)
                    _buildSearchResults()
                  else if (_searchController.text.isNotEmpty && _searchResults.isEmpty)
                    _buildNoResults()
                  else
                    _buildSuggestions(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  /// Construit les résultats de recherche.
  Widget _buildSearchResults() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '${_searchResults.length} résultat(s) trouvé(s)',
          style: AppTextStyles.bodyMedium.copyWith(
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: AppDimensions.spacingM),
        Container(
          constraints: const BoxConstraints(maxHeight: 300),
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: _searchResults.length,
            itemBuilder: (context, index) {
              final item = _searchResults[index];
              return _buildSearchResultItem(item);
            },
          ),
        ),
      ],
    );
  }

  /// Construit un élément de résultat de recherche.
  Widget _buildSearchResultItem(Map<String, dynamic> item) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Container(
        width: 50,
        height: 50,
        decoration: BoxDecoration(
          color: AppColors.primary.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(
          Icons.restaurant,
          color: AppColors.primary,
          size: 24,
        ),
      ),
      title: Text(
        item['title'] as String,
        style: AppTextStyles.bodyMedium.copyWith(
          fontWeight: FontWeight.w600,
          color: AppColors.textPrimary,
        ),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            item['shop'] as String,
            style: AppTextStyles.labelSmall.copyWith(
              color: AppColors.textSecondary,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          Row(
            children: [
              Text(
                '€${item['price'].toStringAsFixed(2)}',
                style: AppTextStyles.labelSmall.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(width: AppDimensions.spacingM),
              Icon(
                Icons.location_on,
                size: 12,
                color: AppColors.textSecondary,
              ),
              const SizedBox(width: 2),
              Text(
                '${item['distance']} km',
                style: AppTextStyles.labelSmall.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ],
      ),
      onTap: () {
        _performSearch(item['title'] as String);
      },
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
    );
  }

  /// Construit l'état "aucun résultat".
  Widget _buildNoResults() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(AppDimensions.spacingL),
            decoration: BoxDecoration(
              color: AppColors.surfaceLight,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.search_off,
              color: AppColors.textSecondary,
              size: 32,
            ),
          ),
          const SizedBox(height: AppDimensions.spacingM),
          Text(
            'Aucun résultat trouvé',
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.textSecondary,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Essayez avec d\'autres mots-clés',
            style: AppTextStyles.labelSmall.copyWith(
              color: AppColors.textSecondary.withValues(alpha: 0.7),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  /// Construit les suggestions rapides.
  Widget _buildSuggestions() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Suggestions populaires',
          style: AppTextStyles.bodyMedium.copyWith(
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: AppDimensions.spacingM),
        Wrap(
          spacing: AppDimensions.spacingS,
          runSpacing: AppDimensions.spacingS,
          children: ['Boulangerie', 'Fruits & légumes', 'Bio', 'Végétarien', 'Dernière chance']
              .map((suggestion) => _buildSuggestionChip(suggestion))
              .toList(),
        ),
      ],
    );
  }

  /// Construit un chip de suggestion.
  Widget _buildSuggestionChip(String suggestion) {
    return InkWell(
      onTap: () {
        _searchController.text = suggestion;
        _performSearch(suggestion);
      },
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppDimensions.spacingM,
          vertical: AppDimensions.spacingS,
        ),
        decoration: BoxDecoration(
          color: AppColors.primary.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: AppColors.primary.withValues(alpha: 0.3),
            width: 1,
          ),
        ),
        child: Text(
          suggestion,
          style: AppTextStyles.labelMedium.copyWith(
            color: AppColors.primary,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  /// Effectue la recherche avec le terme donné.
  void _performSearch(String searchTerm) {
    if (searchTerm.trim().isEmpty) return;

    Navigator.of(context).pop();

    // Afficher les résultats de recherche dans un snackbar temporaire
    // TODO: Implémenter une vraie page de résultats de recherche
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(Icons.search, color: AppColors.textOnDark, size: 20),
            const SizedBox(width: 12),
            Expanded(
              child: Text('Recherche: "$searchTerm"'),
            ),
          ],
        ),
        backgroundColor: AppColors.primary,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        duration: const Duration(seconds: 3),
        action: SnackBarAction(
          label: 'Voir résultats',
          textColor: AppColors.textOnDark,
          onPressed: () {
            // TODO: Naviguer vers la page de résultats de recherche
            _showSearchResults(searchTerm);
          },
        ),
      ),
    );
  }

  /// Affiche les résultats de recherche simulés.
  void _showSearchResults(String searchTerm) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('📋 Résultats pour "$searchTerm" (simulation)'),
        backgroundColor: AppColors.success,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }
}

/// Affiche le dialogue de recherche.
void showSearchDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (context) => const SearchDialog(),
  );
}