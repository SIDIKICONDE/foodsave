/// Classe utilitaire pour la validation des formulaires
/// Respecte les standards NYTH - Zero Compromise
class Validators {
  /// Constructeur privé pour empêcher l'instanciation
  Validators._();

  /// Valide une adresse email
  static String? email(String? value) {
    if (value == null || value.isEmpty) {
      return 'L\'email est requis';
    }
    
    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );
    
    if (!emailRegex.hasMatch(value)) {
      return 'Veuillez entrer un email valide';
    }
    
    return null;
  }

  /// Valide un mot de passe
  static String? password(String? value) {
    if (value == null || value.isEmpty) {
      return 'Le mot de passe est requis';
    }
    
    if (value.length < 8) {
      return 'Le mot de passe doit contenir au moins 8 caractères';
    }
    
    // Vérifier la présence d'au moins une lettre majuscule
    if (!value.contains(RegExp(r'[A-Z]'))) {
      return 'Le mot de passe doit contenir au moins une majuscule';
    }
    
    // Vérifier la présence d'au moins une lettre minuscule
    if (!value.contains(RegExp(r'[a-z]'))) {
      return 'Le mot de passe doit contenir au moins une minuscule';
    }
    
    // Vérifier la présence d'au moins un chiffre
    if (!value.contains(RegExp(r'[0-9]'))) {
      return 'Le mot de passe doit contenir au moins un chiffre';
    }
    
    return null;
  }

  /// Valide la confirmation d'un mot de passe
  static String? confirmPassword(String? value, String originalPassword) {
    if (value == null || value.isEmpty) {
      return 'La confirmation du mot de passe est requise';
    }
    
    if (value != originalPassword) {
      return 'Les mots de passe ne correspondent pas';
    }
    
    return null;
  }

  /// Valide un nom d'utilisateur
  static String? username(String? value) {
    if (value == null || value.isEmpty) {
      return 'Le nom d\'utilisateur est requis';
    }
    
    if (value.length < 3) {
      return 'Le nom d\'utilisateur doit contenir au moins 3 caractères';
    }
    
    if (value.length > 50) {
      return 'Le nom d\'utilisateur ne peut pas dépasser 50 caractères';
    }
    
    // Vérifier que le nom d'utilisateur ne contient que des caractères autorisés
    final usernameRegex = RegExp(r'^[a-zA-Z0-9._-]+$');
    if (!usernameRegex.hasMatch(value)) {
      return 'Le nom d\'utilisateur ne peut contenir que des lettres, chiffres, points, traits d\'union et underscores';
    }
    
    return null;
  }

  /// Valide un prénom ou nom de famille
  static String? name(String? value) {
    if (value == null || value.isEmpty) {
      return null; // Les noms sont généralement optionnels
    }
    
    if (value.length < 2) {
      return 'Le nom doit contenir au moins 2 caractères';
    }
    
    if (value.length > 50) {
      return 'Le nom ne peut pas dépasser 50 caractères';
    }
    
    // Vérifier que le nom ne contient que des lettres, espaces, apostrophes et traits d'union
    final nameRegex = RegExp(r"^[a-zA-ZÀ-ÿ\s'\-]+$");
    if (!nameRegex.hasMatch(value)) {
      return 'Le nom ne peut contenir que des lettres';
    }
    
    return null;
  }

  /// Valide un numéro de téléphone
  static String? phone(String? value) {
    if (value == null || value.isEmpty) {
      return null; // Le téléphone est généralement optionnel
    }
    
    // Supprimer tous les espaces et caractères spéciaux sauf les chiffres et le +
    final cleanedValue = value.replaceAll(RegExp(r'[^\d+]'), '');
    
    if (cleanedValue.length < 10) {
      return 'Le numéro de téléphone doit contenir au moins 10 chiffres';
    }
    
    // Vérifier le format français (+33 ou 0...)
    final phoneRegex = RegExp(r'^(\+33|0)[1-9](\d{8})$');
    if (!phoneRegex.hasMatch(cleanedValue)) {
      return 'Veuillez entrer un numéro de téléphone valide';
    }
    
    return null;
  }

  /// Valide un code postal
  static String? postalCode(String? value) {
    if (value == null || value.isEmpty) {
      return null; // Le code postal est généralement optionnel
    }
    
    // Code postal français (5 chiffres)
    final postalCodeRegex = RegExp(r'^\d{5}$');
    if (!postalCodeRegex.hasMatch(value)) {
      return 'Le code postal doit contenir 5 chiffres';
    }
    
    return null;
  }

  /// Valide une adresse
  static String? address(String? value) {
    if (value == null || value.isEmpty) {
      return null; // L'adresse est généralement optionnelle
    }
    
    if (value.length < 5) {
      return 'L\'adresse doit contenir au moins 5 caractères';
    }
    
    if (value.length > 200) {
      return 'L\'adresse ne peut pas dépasser 200 caractères';
    }
    
    return null;
  }

  /// Valide un prix
  static String? price(String? value) {
    if (value == null || value.isEmpty) {
      return 'Le prix est requis';
    }
    
    final price = double.tryParse(value.replaceAll(',', '.'));
    if (price == null) {
      return 'Veuillez entrer un prix valide';
    }
    
    if (price < 0) {
      return 'Le prix ne peut pas être négatif';
    }
    
    if (price > 999.99) {
      return 'Le prix ne peut pas dépasser 999,99 €';
    }
    
    return null;
  }

  /// Valide une quantité
  static String? quantity(String? value) {
    if (value == null || value.isEmpty) {
      return 'La quantité est requise';
    }
    
    final quantity = int.tryParse(value);
    if (quantity == null) {
      return 'Veuillez entrer une quantité valide';
    }
    
    if (quantity <= 0) {
      return 'La quantité doit être supérieure à 0';
    }
    
    if (quantity > 100) {
      return 'La quantité ne peut pas dépasser 100';
    }
    
    return null;
  }

  /// Valide un titre de repas
  static String? mealTitle(String? value) {
    if (value == null || value.isEmpty) {
      return 'Le titre du repas est requis';
    }
    
    if (value.length < 3) {
      return 'Le titre doit contenir au moins 3 caractères';
    }
    
    if (value.length > 100) {
      return 'Le titre ne peut pas dépasser 100 caractères';
    }
    
    return null;
  }

  /// Valide une description
  static String? description(String? value) {
    if (value == null || value.isEmpty) {
      return 'La description est requise';
    }
    
    if (value.length < 10) {
      return 'La description doit contenir au moins 10 caractères';
    }
    
    if (value.length > 500) {
      return 'La description ne peut pas dépasser 500 caractères';
    }
    
    return null;
  }

  /// Valide un nom de restaurant
  static String? restaurantName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Le nom du restaurant est requis';
    }
    
    if (value.length < 2) {
      return 'Le nom doit contenir au moins 2 caractères';
    }
    
    if (value.length > 100) {
      return 'Le nom ne peut pas dépasser 100 caractères';
    }
    
    return null;
  }

  /// Valide un code OTP
  static String? otpCode(String? value) {
    if (value == null || value.isEmpty) {
      return 'Le code OTP est requis';
    }
    
    if (value.length != 6) {
      return 'Le code OTP doit contenir 6 chiffres';
    }
    
    final otpRegex = RegExp(r'^\d{6}$');
    if (!otpRegex.hasMatch(value)) {
      return 'Le code OTP ne peut contenir que des chiffres';
    }
    
    return null;
  }

  /// Alias pour la validation du numéro de téléphone
  static String? phoneNumber(String? value) => phone(value);

  /// Valide un champ obligatoire générique
  static String? required(String? value, String fieldName) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName est requis';
    }
    return null;
  }

  /// Valide une longueur minimale
  static String? minLength(String? value, int minLength, String fieldName) {
    if (value == null || value.isEmpty) {
      return null; // Laisse la validation obligatoire à required()
    }
    
    if (value.length < minLength) {
      return '$fieldName doit contenir au moins $minLength caractères';
    }
    
    return null;
  }

  /// Valide une longueur maximale
  static String? maxLength(String? value, int maxLength, String fieldName) {
    if (value == null || value.isEmpty) {
      return null;
    }
    
    if (value.length > maxLength) {
      return '$fieldName ne peut pas dépasser $maxLength caractères';
    }
    
    return null;
  }
}