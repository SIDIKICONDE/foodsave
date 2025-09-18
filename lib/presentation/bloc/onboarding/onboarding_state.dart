import 'package:equatable/equatable.dart';
import 'package:foodsave_app/core/error/failures.dart';
import 'package:foodsave_app/domain/entities/user.dart';

/// Classe de base abstraite pour tous les états de l'onboarding.
/// 
/// Utilise [Equatable] pour permettre la comparaison des états.
abstract class OnboardingState extends Equatable {
  /// Crée un nouvel état d'onboarding.
  const OnboardingState();

  @override
  List<Object?> get props => [];
}

/// État initial de l'onboarding.
class OnboardingInitial extends OnboardingState {
  /// Crée un état [OnboardingInitial].
  const OnboardingInitial();
}

/// État de chargement pendant l'onboarding.
class OnboardingLoading extends OnboardingState {
  /// Crée un état [OnboardingLoading].
  const OnboardingLoading();
}

/// État pendant la progression de l'onboarding.
class OnboardingInProgress extends OnboardingState {
  /// Crée un état [OnboardingInProgress].
  /// 
  /// [currentPage] : Page actuelle de l'onboarding.
  /// [selectedUserType] : Type de compte sélectionné (optionnel).
  /// [preferences] : Préférences alimentaires sélectionnées.
  /// [allergies] : Allergies déclarées.
  const OnboardingInProgress({
    required this.currentPage,
    this.selectedUserType,
    this.preferences = const [],
    this.allergies = const [],
  });

  /// Page actuelle de l'onboarding (0-indexé).
  final int currentPage;

  /// Type de compte sélectionné.
  final UserType? selectedUserType;

  /// Préférences alimentaires sélectionnées.
  final List<String> preferences;

  /// Allergies déclarées.
  final List<String> allergies;

  /// Crée une copie de l'état avec des valeurs modifiées.
  OnboardingInProgress copyWith({
    int? currentPage,
    UserType? selectedUserType,
    List<String>? preferences,
    List<String>? allergies,
  }) {
    return OnboardingInProgress(
      currentPage: currentPage ?? this.currentPage,
      selectedUserType: selectedUserType ?? this.selectedUserType,
      preferences: preferences ?? this.preferences,
      allergies: allergies ?? this.allergies,
    );
  }

  @override
  List<Object?> get props => [
        currentPage,
        selectedUserType,
        preferences,
        allergies,
      ];
}

/// État d'onboarding terminé avec succès.
class OnboardingCompleted extends OnboardingState {
  /// Crée un état [OnboardingCompleted].
  /// 
  /// [user] : Utilisateur créé après l'onboarding.
  const OnboardingCompleted({
    required this.user,
  });

  /// Utilisateur créé.
  final User user;

  @override
  List<Object?> get props => [user];
}

/// État de mode invité sélectionné.
class OnboardingGuestMode extends OnboardingState {
  /// Crée un état [OnboardingGuestMode].
  const OnboardingGuestMode();
}

/// État d'erreur pendant l'onboarding.
class OnboardingError extends OnboardingState {
  /// Crée un état [OnboardingError].
  /// 
  /// [failure] : Détails de l'erreur survenue.
  const OnboardingError({
    required this.failure,
  });

  /// Détails de l'erreur.
  final Failure failure;

  @override
  List<Object?> get props => [failure];
}