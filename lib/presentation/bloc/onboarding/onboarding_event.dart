import 'package:equatable/equatable.dart';
import 'package:foodsave_app/domain/entities/user.dart';

/// Classe de base abstraite pour tous les événements de l'onboarding.
/// 
/// Utilise [Equatable] pour permettre la comparaison des événements.
abstract class OnboardingEvent extends Equatable {
  /// Crée un nouvel événement d'onboarding.
  const OnboardingEvent();

  @override
  List<Object?> get props => [];
}

/// Événement déclenché lors du démarrage de l'onboarding.
class OnboardingStarted extends OnboardingEvent {
  /// Crée un événement [OnboardingStarted].
  const OnboardingStarted();
}

/// Événement déclenché lors du passage à la page suivante.
class OnboardingNextPage extends OnboardingEvent {
  /// Crée un événement [OnboardingNextPage].
  const OnboardingNextPage();
}

/// Événement déclenché lors du retour à la page précédente.
class OnboardingPreviousPage extends OnboardingEvent {
  /// Crée un événement [OnboardingPreviousPage].
  const OnboardingPreviousPage();
}

/// Événement déclenché lors de la sélection du type de compte.
class OnboardingAccountTypeSelected extends OnboardingEvent {
  /// Crée un événement [OnboardingAccountTypeSelected].
  /// 
  /// [userType] : Type de compte sélectionné par l'utilisateur.
  const OnboardingAccountTypeSelected({
    required this.userType,
  });

  /// Type de compte sélectionné.
  final UserType userType;

  @override
  List<Object?> get props => [userType];
}

/// Événement déclenché lors de la sélection des préférences alimentaires.
class OnboardingPreferencesSelected extends OnboardingEvent {
  /// Crée un événement [OnboardingPreferencesSelected].
  /// 
  /// [preferences] : Liste des préférences alimentaires sélectionnées.
  /// [allergies] : Liste des allergies déclarées.
  const OnboardingPreferencesSelected({
    required this.preferences,
    required this.allergies,
  });

  /// Préférences alimentaires sélectionnées.
  final List<String> preferences;

  /// Allergies déclarées.
  final List<String> allergies;

  @override
  List<Object?> get props => [preferences, allergies];
}

/// Événement déclenché pour terminer l'onboarding.
class OnboardingCompletedEvent extends OnboardingEvent {
  /// Crée un événement [OnboardingCompletedEvent].
  /// 
  /// [name] : Nom de l'utilisateur.
  /// [email] : Email de l'utilisateur.
  const OnboardingCompletedEvent({
    required this.name,
    required this.email,
  });

  /// Nom de l'utilisateur.
  final String name;

  /// Email de l'utilisateur.
  final String email;

  @override
  List<Object?> get props => [name, email];
}

/// Événement déclenché pour passer en mode invité.
class OnboardingGuestModeSelected extends OnboardingEvent {
  /// Crée un événement [OnboardingGuestModeSelected].
  const OnboardingGuestModeSelected();
}