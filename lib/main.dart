import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:foodsave_app/core/constants/app_constants.dart';
import 'package:foodsave_app/core/constants/app_colors.dart';
import 'package:foodsave_app/core/constants/app_dimensions.dart';
import 'package:foodsave_app/core/constants/app_text_styles.dart';
import 'package:foodsave_app/core/routes/app_routes.dart';
import 'package:foodsave_app/config/supabase_config.dart';

// Services
// import 'package:foodsave_app/services/supabase_service.dart'; // Utilisé via les méthodes statiques

// Domain
import 'package:foodsave_app/domain/usecases/auth/login_usecase.dart';
import 'package:foodsave_app/domain/usecases/auth/register_usecase.dart';
import 'package:foodsave_app/domain/usecases/auth/logout_usecase.dart';
import 'package:foodsave_app/domain/repositories/auth_repository.dart';

// Data
import 'package:foodsave_app/data/repositories/auth_repository_impl.dart';
import 'package:foodsave_app/data/datasources/remote/auth_remote_data_source.dart';
import 'package:foodsave_app/data/datasources/remote/auth_remote_data_source_impl.dart';

// Presentation
import 'package:foodsave_app/presentation/bloc/auth/auth_bloc.dart';
import 'package:foodsave_app/presentation/blocs/basket/basket_bloc.dart';
import 'package:foodsave_app/domain/usecases/get_available_baskets.dart';
import 'package:foodsave_app/domain/usecases/search_baskets.dart' as basket_usecases;
import 'package:foodsave_app/domain/repositories/basket_repository.dart';
import 'package:foodsave_app/data/datasources/remote/basket_remote_data_source.dart';
import 'package:foodsave_app/data/datasources/remote/basket_remote_data_source_impl.dart';
import 'package:foodsave_app/data/repositories/basket_repository_impl.dart';

/// Point d'entrée principal de l'application FoodSave.
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialiser Supabase
  await Supabase.initialize(
    url: SupabaseConfig.supabaseUrl,
    anonKey: SupabaseConfig.supabaseAnonKey,
  );
  
  // Initialiser les dépendances une seule fois au démarrage
  DependencyInjection.initialize();
  
  runApp(const FoodSaveApp());
}

/// Configuration de l'injection de dépendances.
/// 
/// Centralise la création et la gestion des dépendances de l'application.
class DependencyInjection {
  // Note: SupabaseService utilise des méthodes statiques,
  // donc pas besoin d'instanciation
  
  // Data Sources
  static late final AuthRemoteDataSource _authRemoteDataSource;
  
  // Repositories
  static late final AuthRepository _authRepository;
  static late final BasketRepository _basketRepository;
  
  // Use Cases
  static late final LoginUseCase _loginUseCase;
  static late final RegisterUseCase _registerUseCase;
  static late final LogoutUseCase _logoutUseCase;
  static late final GetAvailableBaskets _getAvailableBaskets;
  static late final basket_usecases.SearchBaskets _searchBaskets;
  
  // Data sources
  static late final BasketRemoteDataSource _basketRemoteDataSource;
  
  /// Initialise toutes les dépendances.
  static void initialize() {
    // Data Sources
    _authRemoteDataSource = AuthRemoteDataSourceImpl();
    _basketRemoteDataSource = BasketRemoteDataSourceImpl();
    
    // Repositories
    _authRepository = AuthRepositoryImpl(
      remoteDataSource: _authRemoteDataSource,
    );
    _basketRepository = BasketRepositoryImpl(
      remoteDataSource: _basketRemoteDataSource,
    );
    
    // Use Cases
    _loginUseCase = LoginUseCase(_authRepository);
    _registerUseCase = RegisterUseCase(_authRepository);
    _logoutUseCase = LogoutUseCase(_authRepository);
    _getAvailableBaskets = GetAvailableBaskets(_basketRepository);
    _searchBaskets = basket_usecases.SearchBaskets(_basketRepository);
  }
  
  // Getters pour accéder aux dépendances
  // SupabaseService utilise des méthodes statiques, accessible directement
  static AuthRepository get authRepository => _authRepository;
  static LoginUseCase get loginUseCase => _loginUseCase;
  static RegisterUseCase get registerUseCase => _registerUseCase;
  static LogoutUseCase get logoutUseCase => _logoutUseCase;
  static BasketRepository get basketRepository => _basketRepository;
  static GetAvailableBaskets get getAvailableBaskets => _getAvailableBaskets;
  static basket_usecases.SearchBaskets get searchBaskets => _searchBaskets;
}

/// Application FoodSave - Lutte contre le gaspillage alimentaire.
/// 
/// Cette application permet aux consommateurs de découvrir des paniers
/// anti-gaspi près de chez eux et aux commerçants de proposer leurs invendus.
class FoodSaveApp extends StatelessWidget {
  /// Crée une nouvelle instance de [FoodSaveApp].
  const FoodSaveApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>(
          create: (context) => AuthBloc(),
        ),
        BlocProvider<BasketBloc>(
          create: (context) => BasketBloc(
            getAvailableBaskets: DependencyInjection.getAvailableBaskets,
            searchBaskets: DependencyInjection.searchBaskets,
            basketRepository: DependencyInjection.basketRepository,
          ),
        ),
      ],
      child: MaterialApp(
        title: AppConstants.appName,
        debugShowCheckedModeBanner: false,
        theme: _buildTheme(),
        initialRoute: AppRoutes.initial,
        onGenerateRoute: AppRoutes.generateRoute,
      ),
    );
  }

  /// Construit le thème de l'application.
  ThemeData _buildTheme() {
    return ThemeData(
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.primary,
        brightness: Brightness.light,
        primary: AppColors.primary,
        secondary: AppColors.secondary,
        error: AppColors.error,
        surface: AppColors.surface,
        // background: AppColors.background, // Deprecated
      ),
      useMaterial3: true,
      textTheme: AppTextStyles.createTextTheme(),
      appBarTheme: AppBarTheme(
        centerTitle: true,
        elevation: 0,
        backgroundColor: AppColors.surface,
        foregroundColor: AppColors.textPrimary,
        titleTextStyle: AppTextStyles.headline6,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.textOnDark,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppDimensions.radiusL),
          ),
          padding: const EdgeInsets.symmetric(
            horizontal: AppDimensions.spacingXL,
            vertical: AppDimensions.spacingM,
          ),
          minimumSize: const Size(0, AppDimensions.buttonMinHeight),
          textStyle: AppTextStyles.buttonPrimary,
          elevation: AppDimensions.elevationCard,
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.primary,
          side: const BorderSide(color: AppColors.border),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppDimensions.radiusL),
          ),
          padding: const EdgeInsets.symmetric(
            horizontal: AppDimensions.spacingXL,
            vertical: AppDimensions.spacingM,
          ),
          minimumSize: const Size(0, AppDimensions.buttonMinHeight),
          textStyle: AppTextStyles.buttonSecondary,
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radiusL),
          borderSide: const BorderSide(color: AppColors.border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radiusL),
          borderSide: const BorderSide(color: AppColors.border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radiusL),
          borderSide: const BorderSide(color: AppColors.primary, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radiusL),
          borderSide: const BorderSide(color: AppColors.error),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppDimensions.spacingL,
          vertical: AppDimensions.spacingL,
        ),
        fillColor: AppColors.surface,
        filled: true,
        labelStyle: AppTextStyles.bodyMedium,
        hintStyle: AppTextStyles.withColor(AppTextStyles.bodyMedium, AppColors.textSecondary),
      ),
      cardTheme: CardThemeData(
        color: AppColors.surface,
        elevation: AppDimensions.elevationCard,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radiusL),
        ),
        margin: const EdgeInsets.all(AppDimensions.spacingS),
      ),
      dividerTheme: const DividerThemeData(
        color: AppColors.divider,
        thickness: 1,
        space: 1,
      ),
    );
  }
}
