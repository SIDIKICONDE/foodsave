import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

import '../../models/meal.dart';
import '../common/custom_button.dart';
import '../common/loading_widget.dart';

/// Écran pour publier un nouveau repas par les commerçants
/// Respecte les standards NYTH - Zero Compromise
class PostMealScreen extends ConsumerStatefulWidget {
  const PostMealScreen({super.key});

  @override
  ConsumerState<PostMealScreen> createState() => _PostMealScreenState();
}

class _PostMealScreenState extends ConsumerState<PostMealScreen>
    with TickerProviderStateMixin {
  
  final _formKey = GlobalKey<FormState>();
  final _pageController = PageController();
  
  // Contrôleurs des champs
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _originalPriceController = TextEditingController();
  final _discountedPriceController = TextEditingController();
  final _quantityController = TextEditingController();
  final _ingredientsController = TextEditingController();
  final _allergensController = TextEditingController();
  
  // Animation
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  
  // État du formulaire
  int _currentStep = 0;
  bool _isLoading = false;
  String? _errorMessage;
  
  // Données du repas
  MealCategory _selectedCategory = MealCategory.mainCourse;
  DateTime? _availableFrom;
  DateTime? _availableUntil;
  List<File> _selectedImages = [];
  bool _isVegetarian = false;
  bool _isVegan = false;
  bool _isGlutenFree = false;
  bool _isHalal = false;
  
  // Services
  final _imagePicker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
    _animationController.forward();
    
    // Initialiser les dates par défaut
    _availableFrom = DateTime.now();
    _availableUntil = DateTime.now().add(const Duration(hours: 4));
  }

  @override
  void dispose() {
    _animationController.dispose();
    _pageController.dispose();
    _titleController.dispose();
    _descriptionController.dispose();
    _originalPriceController.dispose();
    _discountedPriceController.dispose();
    _quantityController.dispose();
    _ingredientsController.dispose();
    _allergensController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: _buildBody(),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      title: const Text(
        'Publier un repas',
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      actions: [
        TextButton(
          onPressed: _currentStep > 0 ? () => _previousStep() : null,
          child: const Text('Précédent'),
        ),
      ],
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const LoadingWidget(message: 'Publication en cours...');
    }

    return Column(
      children: [
        // Indicateur de progression
        _buildProgressIndicator(),
        
        // Contenu principal
        Expanded(
          child: PageView(
            controller: _pageController,
            physics: const NeverScrollableScrollPhysics(),
            children: [
              _buildBasicInfoStep(),
              _buildPricingStep(),
              _buildImagesStep(),
              _buildDetailsStep(),
              _buildScheduleStep(),
            ],
          ),
        ),
        
        // Boutons de navigation
        _buildNavigationButtons(),
      ],
    );
  }

  Widget _buildProgressIndicator() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: List.generate(5, (index) {
          final isActive = index <= _currentStep;
          
          return Expanded(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 2),
              height: 4,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(2),
                color: isActive 
                    ? Theme.of(context).primaryColor
                    : Colors.grey[300],
              ),
            ),
          );
        }),
      ),
    );
  }

  // Étape 1: Informations de base
  Widget _buildBasicInfoStep() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Informations de base',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Décrivez votre repas en quelques mots',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
              ),
            ),
            
            const SizedBox(height: 32),
            
            // Nom du repas
            TextFormField(
              controller: _titleController,
              decoration: const InputDecoration(
                labelText: 'Nom du repas *',
                hintText: 'Ex: Pizza Margherita, Salade César...',
                prefixIcon: Icon(Icons.restaurant_menu),
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Le nom du repas est obligatoire';
                }
                if (value.trim().length < 3) {
                  return 'Le nom doit contenir au moins 3 caractères';
                }
                return null;
              },
              textCapitalization: TextCapitalization.words,
            ),
            
            const SizedBox(height: 24),
            
            // Description
            TextFormField(
              controller: _descriptionController,
              decoration: const InputDecoration(
                labelText: 'Description *',
                hintText: 'Décrivez les ingrédients, le goût, la préparation...',
                prefixIcon: Icon(Icons.description),
                border: OutlineInputBorder(),
              ),
              maxLines: 4,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'La description est obligatoire';
                }
                if (value.trim().length < 10) {
                  return 'La description doit contenir au moins 10 caractères';
                }
                return null;
              },
            ),
            
            const SizedBox(height: 24),
            
            // Catégorie
            const Text(
              'Catégorie *',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 12),
            
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: MealCategory.values.map((category) {
                final isSelected = _selectedCategory == category;
                return FilterChip(
                  selected: isSelected,
                  label: Text(_getCategoryText(category)),
                  onSelected: (selected) {
                    setState(() {
                      _selectedCategory = category;
                    });
                  },
                  selectedColor: Theme.of(context).primaryColor.withOpacity(0.2),
                  checkmarkColor: Theme.of(context).primaryColor,
                );
              }).toList(),
            ),
            
            const SizedBox(height: 32),
            
            // Tags alimentaires
            const Text(
              'Régimes alimentaires',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 12),
            
            Column(
              children: [
                CheckboxListTile(
                  title: const Text('Végétarien'),
                  subtitle: const Text('Contient des produits laitiers/œufs'),
                  value: _isVegetarian,
                  onChanged: (value) {
                    setState(() {
                      _isVegetarian = value ?? false;
                      if (!_isVegetarian) _isVegan = false;
                    });
                  },
                  controlAffinity: ListTileControlAffinity.leading,
                ),
                CheckboxListTile(
                  title: const Text('Végétalien'),
                  subtitle: const Text('100% végétal'),
                  value: _isVegan,
                  onChanged: (value) {
                    setState(() {
                      _isVegan = value ?? false;
                      if (_isVegan) _isVegetarian = true;
                    });
                  },
                  controlAffinity: ListTileControlAffinity.leading,
                ),
                CheckboxListTile(
                  title: const Text('Sans gluten'),
                  subtitle: const Text('Ne contient pas de gluten'),
                  value: _isGlutenFree,
                  onChanged: (value) {
                    setState(() {
                      _isGlutenFree = value ?? false;
                    });
                  },
                  controlAffinity: ListTileControlAffinity.leading,
                ),
                CheckboxListTile(
                  title: const Text('Halal'),
                  subtitle: const Text('Conforme aux règles halal'),
                  value: _isHalal,
                  onChanged: (value) {
                    setState(() {
                      _isHalal = value ?? false;
                    });
                  },
                  controlAffinity: ListTileControlAffinity.leading,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Étape 2: Prix et quantité
  Widget _buildPricingStep() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Prix et quantité',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Définissez le prix et la quantité disponible',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[600],
            ),
          ),
          
          const SizedBox(height: 32),
          
          // Prix original
          TextFormField(
            controller: _originalPriceController,
            decoration: const InputDecoration(
              labelText: 'Prix original (€) *',
              hintText: '12.50',
              prefixIcon: Icon(Icons.euro),
              border: OutlineInputBorder(),
              helperText: 'Le prix habituel de ce repas',
            ),
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
            ],
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Le prix original est obligatoire';
              }
              final price = double.tryParse(value);
              if (price == null || price <= 0) {
                return 'Veuillez entrer un prix valide';
              }
              if (price > 100) {
                return 'Le prix ne peut pas dépasser 100€';
              }
              return null;
            },
            onChanged: _updateDiscountInfo,
          ),
          
          const SizedBox(height: 24),
          
          // Prix réduit
          TextFormField(
            controller: _discountedPriceController,
            decoration: const InputDecoration(
              labelText: 'Prix réduit (€) *',
              hintText: '8.00',
              prefixIcon: Icon(Icons.local_offer),
              border: OutlineInputBorder(),
              helperText: 'Le prix de vente sur FoodSave',
            ),
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
            ],
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Le prix réduit est obligatoire';
              }
              final discountedPrice = double.tryParse(value);
              if (discountedPrice == null || discountedPrice <= 0) {
                return 'Veuillez entrer un prix valide';
              }
              
              final originalPrice = double.tryParse(_originalPriceController.text);
              if (originalPrice != null && discountedPrice >= originalPrice) {
                return 'Le prix réduit doit être inférieur au prix original';
              }
              
              return null;
            },
            onChanged: _updateDiscountInfo,
          ),
          
          // Affichage du pourcentage de réduction
          if (_originalPriceController.text.isNotEmpty && 
              _discountedPriceController.text.isNotEmpty)
            _buildDiscountInfo(),
          
          const SizedBox(height: 24),
          
          // Quantité
          TextFormField(
            controller: _quantityController,
            decoration: const InputDecoration(
              labelText: 'Quantité disponible *',
              hintText: '5',
              prefixIcon: Icon(Icons.inventory),
              border: OutlineInputBorder(),
              helperText: 'Nombre de portions disponibles',
            ),
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'La quantité est obligatoire';
              }
              final quantity = int.tryParse(value);
              if (quantity == null || quantity <= 0) {
                return 'Veuillez entrer une quantité valide';
              }
              if (quantity > 50) {
                return 'La quantité ne peut pas dépasser 50 portions';
              }
              return null;
            },
          ),
          
          const SizedBox(height: 32),
          
          // Conseils de pricing
          Card(
            color: Colors.blue[50],
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.lightbulb_outline, color: Colors.blue[700]),
                      const SizedBox(width: 8),
                      Text(
                        'Conseils de prix',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.blue[700],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '• Proposez une réduction d\'au moins 30% pour attirer les étudiants\n'
                    '• Les repas à moins de 5€ se vendent plus rapidement\n'
                    '• Adaptez vos prix selon l\'heure (plus cher le midi, moins cher le soir)',
                    style: TextStyle(color: Colors.blue[700]),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Étape 3: Photos
  Widget _buildImagesStep() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Photos du repas',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Ajoutez des photos appétissantes de votre repas',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[600],
            ),
          ),
          
          const SizedBox(height: 32),
          
          // Grille des images
          if (_selectedImages.isEmpty)
            _buildEmptyImageState()
          else
            _buildImageGrid(),
          
          const SizedBox(height: 24),
          
          // Boutons d'ajout d'images
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () => _pickImage(ImageSource.camera),
                  icon: const Icon(Icons.camera_alt),
                  label: const Text('Prendre une photo'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () => _pickImage(ImageSource.gallery),
                  icon: const Icon(Icons.photo_library),
                  label: const Text('Galerie'),
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 32),
          
          // Conseils photo
          Card(
            color: Colors.green[50],
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.camera_alt, color: Colors.green[700]),
                      const SizedBox(width: 8),
                      Text(
                        'Conseils photo',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.green[700],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '• Prenez des photos avec un bon éclairage naturel\n'
                    '• Montrez le repas sous son meilleur angle\n'
                    '• Évitez les photos floues ou trop sombres\n'
                    '• Une seule photo suffit, mais vous pouvez en ajouter jusqu\'à 5',
                    style: TextStyle(color: Colors.green[700]),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Étape 4: Détails (ingrédients, allergènes)
  Widget _buildDetailsStep() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Détails et ingrédients',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Informations détaillées sur le repas',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[600],
            ),
          ),
          
          const SizedBox(height: 32),
          
          // Ingrédients
          TextFormField(
            controller: _ingredientsController,
            decoration: const InputDecoration(
              labelText: 'Ingrédients principaux',
              hintText: 'Tomates, mozzarella, basilic, pâte...',
              prefixIcon: Icon(Icons.list),
              border: OutlineInputBorder(),
              helperText: 'Listez les ingrédients séparés par des virgules',
            ),
            maxLines: 3,
          ),
          
          const SizedBox(height: 24),
          
          // Allergènes
          TextFormField(
            controller: _allergensController,
            decoration: const InputDecoration(
              labelText: 'Allergènes',
              hintText: 'Gluten, lait, œufs, fruits à coque...',
              prefixIcon: Icon(Icons.warning_amber),
              border: OutlineInputBorder(),
              helperText: 'Indiquez tous les allergènes présents',
            ),
            maxLines: 2,
          ),
          
          const SizedBox(height: 32),
          
          // Informations allergènes
          Card(
            color: Colors.orange[50],
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.info_outline, color: Colors.orange[700]),
                      const SizedBox(width: 8),
                      Text(
                        'Information importante',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.orange[700],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Il est obligatoire d\'indiquer tous les allergènes présents dans vos repas. '
                    'Cela aide les clients à faire des choix éclairés et évite les risques de santé.',
                    style: TextStyle(color: Colors.orange[700]),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Étape 5: Planification (horaires de disponibilité)
  Widget _buildScheduleStep() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Disponibilité',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Quand ce repas sera-t-il disponible ?',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[600],
            ),
          ),
          
          const SizedBox(height: 32),
          
          // Disponible à partir de
          Card(
            child: ListTile(
              leading: Icon(Icons.schedule, color: Theme.of(context).primaryColor),
              title: const Text('Disponible à partir de'),
              subtitle: Text(_formatDateTime(_availableFrom!)),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () => _selectDateTime(true),
            ),
          ),
          
          const SizedBox(height: 16),
          
          // Disponible jusqu'à
          Card(
            child: ListTile(
              leading: Icon(Icons.schedule_outlined, color: Theme.of(context).primaryColor),
              title: const Text('Disponible jusqu\'à'),
              subtitle: Text(_formatDateTime(_availableUntil!)),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () => _selectDateTime(false),
            ),
          ),
          
          const SizedBox(height: 24),
          
          // Durée de disponibilité
          if (_availableFrom != null && _availableUntil != null)
            _buildAvailabilityInfo(),
          
          const SizedBox(height: 32),
          
          // Conseils de timing
          Card(
            color: Colors.purple[50],
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.access_time, color: Colors.purple[700]),
                      const SizedBox(width: 8),
                      Text(
                        'Conseils de timing',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.purple[700],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '• Publiez vos repas du midi avant 11h30\n'
                    '• Les repas du soir peuvent être disponibles jusqu\'à 20h\n'
                    '• Prévoyez au moins 2h de disponibilité\n'
                    '• Les étudiants commandent souvent à la dernière minute',
                    style: TextStyle(color: Colors.purple[700]),
                  ),
                ],
              ),
            ),
          ),
          
          const SizedBox(height: 32),
          
          // Résumé final
          _buildFinalSummary(),
        ],
      ),
    );
  }

  Widget _buildDiscountInfo() {
    final originalPrice = double.tryParse(_originalPriceController.text) ?? 0;
    final discountedPrice = double.tryParse(_discountedPriceController.text) ?? 0;
    
    if (originalPrice > 0 && discountedPrice > 0) {
      final discount = ((originalPrice - discountedPrice) / originalPrice * 100).round();
      final savings = originalPrice - discountedPrice;
      
      return Container(
        margin: const EdgeInsets.only(top: 16),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.green[50],
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.green[200]!),
        ),
        child: Row(
          children: [
            Icon(Icons.trending_down, color: Colors.green[700], size: 20),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                'Réduction de $discount% • Économie de ${savings.toStringAsFixed(2)}€',
                style: TextStyle(
                  color: Colors.green[700],
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      );
    }
    return const SizedBox.shrink();
  }

  Widget _buildEmptyImageState() {
    return Container(
      height: 200,
      width: double.infinity,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[300]!, width: 2, style: BorderStyle.solid),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.add_a_photo,
            size: 48,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            'Ajoutez des photos de votre repas',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Les repas avec photos se vendent 3x plus !',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[500],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImageGrid() {
    return Column(
      children: [
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 8,
            mainAxisSpacing: 8,
          ),
          itemCount: _selectedImages.length + (_selectedImages.length < 5 ? 1 : 0),
          itemBuilder: (context, index) {
            if (index == _selectedImages.length) {
              // Bouton d'ajout
              return GestureDetector(
                onTap: () => _showImagePickerDialog(),
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey[300]!),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.add, color: Colors.grey[600]),
                      const SizedBox(height: 4),
                      Text(
                        'Ajouter',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }
            
            // Image existante
            return Stack(
              children: [
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    image: DecorationImage(
                      image: FileImage(_selectedImages[index]),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Positioned(
                  top: 4,
                  right: 4,
                  child: GestureDetector(
                    onTap: () => _removeImage(index),
                    child: Container(
                      decoration: const BoxDecoration(
                        color: Colors.red,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.close,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                  ),
                ),
                if (index == 0)
                  Positioned(
                    bottom: 4,
                    left: 4,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: const BoxDecoration(
                        color: Colors.blue,
                        borderRadius: BorderRadius.all(Radius.circular(4)),
                      ),
                      child: const Text(
                        'Principal',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
              ],
            );
          },
        ),
      ],
    );
  }

  Widget _buildAvailabilityInfo() {
    final duration = _availableUntil!.difference(_availableFrom!);
    final hours = duration.inHours;
    final minutes = duration.inMinutes % 60;
    
    String durationText = '';
    if (hours > 0) {
      durationText += '${hours}h';
      if (minutes > 0) durationText += ' ${minutes}min';
    } else {
      durationText = '${minutes}min';
    }
    
    final isValidDuration = duration.inMinutes >= 30;
    
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isValidDuration ? Colors.green[50] : Colors.red[50],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: isValidDuration ? Colors.green[200]! : Colors.red[200]!,
        ),
      ),
      child: Row(
        children: [
          Icon(
            isValidDuration ? Icons.check_circle : Icons.error,
            color: isValidDuration ? Colors.green[700] : Colors.red[700],
            size: 20,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              isValidDuration 
                  ? 'Durée de disponibilité: $durationText'
                  : 'Durée trop courte! Minimum 30 minutes requis',
              style: TextStyle(
                color: isValidDuration ? Colors.green[700] : Colors.red[700],
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFinalSummary() {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Résumé de votre repas',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            
            if (_titleController.text.isNotEmpty) ...[
              _buildSummaryRow('Nom', _titleController.text),
              const SizedBox(height: 8),
            ],
            
            _buildSummaryRow('Catégorie', _getCategoryText(_selectedCategory)),
            const SizedBox(height: 8),
            
            if (_originalPriceController.text.isNotEmpty && _discountedPriceController.text.isNotEmpty) ...[
              _buildSummaryRow(
                'Prix',
                '${_discountedPriceController.text}€ (au lieu de ${_originalPriceController.text}€)',
              ),
              const SizedBox(height: 8),
            ],
            
            if (_quantityController.text.isNotEmpty) ...[
              _buildSummaryRow('Quantité', '${_quantityController.text} portions'),
              const SizedBox(height: 8),
            ],
            
            _buildSummaryRow('Photos', '${_selectedImages.length} ajoutée(s)'),
            const SizedBox(height: 8),
            
            if (_availableFrom != null && _availableUntil != null) ...[
              _buildSummaryRow(
                'Disponibilité',
                '${_formatTime(_availableFrom!)} - ${_formatTime(_availableUntil!)}',
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 100,
          child: Text(
            '$label:',
            style: TextStyle(
              fontWeight: FontWeight.w500,
              color: Colors.grey[700],
            ),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(fontWeight: FontWeight.w500),
          ),
        ),
      ],
    );
  }

  Widget _buildNavigationButtons() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            blurRadius: 4,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        children: [
          if (_currentStep > 0)
            Expanded(
              child: OutlinedButton(
                onPressed: _previousStep,
                child: const Text('Précédent'),
              ),
            ),
          
          if (_currentStep > 0) const SizedBox(width: 16),
          
          Expanded(
            child: _currentStep == 4
                ? CustomButton(
                    text: 'Publier le repas',
                    onPressed: _publishMeal,
                    icon: Icons.publish,
                  )
                : ElevatedButton(
                    onPressed: _nextStep,
                    child: const Text('Suivant'),
                  ),
          ),
        ],
      ),
    );
  }

  // Méthodes utilitaires

  void _updateDiscountInfo([String? value]) {
    setState(() {}); // Rebuild pour mettre à jour l'affichage du discount
  }

  Future<void> _pickImage(ImageSource source) async {
    try {
      final XFile? image = await _imagePicker.pickImage(
        source: source,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 80,
      );
      
      if (image != null) {
        setState(() {
          _selectedImages.add(File(image.path));
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erreur lors de la sélection de l\'image: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _showImagePickerDialog() {
    showModalBottomSheet(
      context: context,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text('Prendre une photo'),
              onTap: () {
                Navigator.of(context).pop();
                _pickImage(ImageSource.camera);
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('Choisir depuis la galerie'),
              onTap: () {
                Navigator.of(context).pop();
                _pickImage(ImageSource.gallery);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _removeImage(int index) {
    setState(() {
      _selectedImages.removeAt(index);
    });
  }

  Future<void> _selectDateTime(bool isStartTime) async {
    final now = DateTime.now();
    final initialDate = isStartTime ? _availableFrom! : _availableUntil!;
    
    final date = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: now,
      lastDate: now.add(const Duration(days: 7)),
    );
    
    if (date != null && mounted) {
      final time = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(initialDate),
      );
      
      if (time != null) {
        final newDateTime = DateTime(
          date.year,
          date.month,
          date.day,
          time.hour,
          time.minute,
        );
        
        setState(() {
          if (isStartTime) {
            _availableFrom = newDateTime;
            // Ajuster automatiquement la fin si elle est avant le début
            if (_availableUntil!.isBefore(newDateTime)) {
              _availableUntil = newDateTime.add(const Duration(hours: 2));
            }
          } else {
            _availableUntil = newDateTime;
          }
        });
      }
    }
  }

  void _nextStep() {
    if (_validateCurrentStep()) {
      if (_currentStep < 4) {
        setState(() {
          _currentStep++;
        });
        _pageController.nextPage(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      }
    }
  }

  void _previousStep() {
    if (_currentStep > 0) {
      setState(() {
        _currentStep--;
      });
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  bool _validateCurrentStep() {
    switch (_currentStep) {
      case 0:
        return _formKey.currentState?.validate() ?? false;
      case 1:
        return _originalPriceController.text.isNotEmpty &&
               _discountedPriceController.text.isNotEmpty &&
               _quantityController.text.isNotEmpty;
      case 2:
        if (_selectedImages.isEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Ajoutez au moins une photo de votre repas'),
              backgroundColor: Colors.orange,
            ),
          );
          return false;
        }
        return true;
      case 3:
        return true; // Les détails sont optionnels
      case 4:
        final duration = _availableUntil!.difference(_availableFrom!);
        if (duration.inMinutes < 30) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('La durée de disponibilité doit être d\'au moins 30 minutes'),
              backgroundColor: Colors.red,
            ),
          );
          return false;
        }
        return true;
      default:
        return true;
    }
  }

  Future<void> _publishMeal() async {
    if (!_validateCurrentStep()) return;

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      // TODO: Implémenter la publication du repas avec Supabase
      // Simulation pour la démo
      await Future.delayed(const Duration(seconds: 2));

      if (mounted) {
        // Succès
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => AlertDialog(
            title: Row(
              children: [
                Icon(Icons.check_circle, color: Colors.green[600]),
                const SizedBox(width: 8),
                const Text('Repas publié !'),
              ],
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Votre repas a été publié avec succès sur FoodSave !'),
                const SizedBox(height: 16),
                Text(
                  'Résumé:',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[700],
                  ),
                ),
                const SizedBox(height: 8),
                Text('• ${_titleController.text}'),
                Text('• ${_quantityController.text} portions à ${_discountedPriceController.text}€'),
                Text('• Disponible de ${_formatTime(_availableFrom!)} à ${_formatTime(_availableUntil!)}'),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  context.go('/merchant/orders');
                },
                child: const Text('Voir mes repas'),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  context.pop();
                },
                child: const Text('Retour'),
              ),
            ],
          ),
        );
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Erreur lors de la publication: $e';
      });
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

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
        return 'Collation';
      case MealCategory.bakery:
        return 'Boulangerie';
      case MealCategory.other:
        return 'Autre';
    }
  }

  String _formatDateTime(DateTime dateTime) {
    return '${_formatDate(dateTime)} à ${_formatTime(dateTime)}';
  }

  String _formatDate(DateTime dateTime) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final date = DateTime(dateTime.year, dateTime.month, dateTime.day);
    
    if (date == today) {
      return 'Aujourd\'hui';
    } else if (date == today.add(const Duration(days: 1))) {
      return 'Demain';
    } else {
      final months = [
        '', 'jan', 'fév', 'mar', 'avr', 'mai', 'juin',
        'juil', 'aoû', 'sep', 'oct', 'nov', 'déc'
      ];
      return '${dateTime.day} ${months[dateTime.month]}';
    }
  }

  String _formatTime(DateTime dateTime) {
    return '${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
  }
}