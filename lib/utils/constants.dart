/// Constantes de l'application FoodSave
/// Respecte les standards NYTH - Zero Compromise
class AppConstants {
  // Configuration de l'application
  static const String appName = 'FoodSave';
  static const String appVersion = '1.0.0';
  
  // API Configuration
  static const String baseUrl = 'https://api.foodsave.com';
  static const int timeoutDuration = 30000; // 30 secondes
  
  // Storage Keys
  static const String userTokenKey = 'user_token';
  static const String userDataKey = 'user_data';
  static const String settingsKey = 'app_settings';
  
  // UI Constants
  static const double defaultPadding = 16.0;
  static const double defaultRadius = 8.0;
  static const double defaultElevation = 2.0;
  
  // Validation
  static const int minPasswordLength = 8;
  static const int maxUsernameLength = 50;
  
  // Messages d'erreur
  static const String networkErrorMessage = 'Erreur de connexion réseau';
  static const String serverErrorMessage = 'Erreur du serveur';
  static const String unknownErrorMessage = 'Erreur inconnue';
  
  // Privé pour empêcher l'instanciation
  AppConstants._();
}