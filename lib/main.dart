import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'routes/app_routes.dart';
import 'services/supabase_service.dart';
import 'services/supabase_notification_service.dart';

/// Point d'entrée de l'application FoodSave
/// Respecte les standards NYTH - Zero Compromise
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Charger les variables d'environnement
  await dotenv.load(fileName: '.env');

  // Choisir l'URL et la clé selon l'environnement
  final isDev =
      dotenv.get('ENVIRONMENT', fallback: 'development') == 'development';
  final supabaseUrl = isDev
      ? dotenv.get('SUPABASE_URL_LOCAL', fallback: 'http://localhost:54321')
      : dotenv.get('SUPABASE_URL');
  final supabaseAnonKey = isDev
      ? dotenv.get('SUPABASE_ANON_KEY_LOCAL')
      : dotenv.get('SUPABASE_ANON_KEY');

  // Initialiser Supabase
  await Supabase.initialize(
    url: supabaseUrl,
    anonKey: supabaseAnonKey,
    authOptions: const FlutterAuthClientOptions(
      autoRefreshToken: true,
      // flowType: AuthFlowType.implicit, // optionnel selon votre config
    ),
  );

  // Initialiser le service applicatif
  await SupabaseService.initialize(
    url: supabaseUrl,
    anonKey: supabaseAnonKey,
  );

  // Initialiser le service de notifications
  await SupabaseNotificationService.instance.init();
  await SupabaseNotificationService.instance.registerDeviceToken();

  runApp(
    const ProviderScope(
      child: FoodSaveApp(),
    ),
  );
}

/// Application principale FoodSave
class FoodSaveApp extends ConsumerWidget {
  /// Constructeur de l'application
  const FoodSaveApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp.router(
      title: 'FoodSave',
      debugShowCheckedModeBanner: false,
      theme: _buildTheme(),
      routerConfig: AppRoutes.createRouter(ref),
    );
  }

  /// Configuration du thème de l'application
  ThemeData _buildTheme() {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: Colors.green,
        brightness: Brightness.light,
      ),
      appBarTheme: const AppBarTheme(
        centerTitle: true,
        elevation: 0,
      ),
      cardTheme: CardTheme(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          padding: const EdgeInsets.symmetric(
            horizontal: 24,
            vertical: 12,
          ),
        ),
      ),
    );
  }
}
