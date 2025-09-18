import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:foodsave_app/core/error/failures.dart';
import 'package:foodsave_app/domain/entities/user.dart';
import 'package:foodsave_app/presentation/bloc/onboarding/onboarding_event.dart';
import 'package:foodsave_app/presentation/bloc/onboarding/onboarding_state.dart';

/// BLoC responsable de la gestion de l'état pendant le processus d'onboarding.
/// 
/// Ce BLoC gère la navigation entre les pages d'onboarding, la collecte
/// des informations utilisateur et la création du profil utilisateur.
class OnboardingBloc extends Bloc<OnboardingEvent, OnboardingState> {
  /// Crée une nouvelle instance d'[OnboardingBloc].
  OnboardingBloc() : super(const OnboardingInitial()) {
    on<OnboardingStarted>(_onOnboardingStarted);
    on<OnboardingNextPage>(_onOnboardingNextPage);
    on<OnboardingPreviousPage>(_onOnboardingPreviousPage);
    on<OnboardingAccountTypeSelected>(_onAccountTypeSelected);
    on<OnboardingPreferencesSelected>(_onPreferencesSelected);
    on<OnboardingCompletedEvent>(_onOnboardingCompleted);
    on<OnboardingGuestModeSelected>(_onGuestModeSelected);
  }

  /// Nombre total de pages dans l'onboarding.
  static const int totalPages = 4;

  /// Gère le démarrage de l'onboarding.
  Future<void> _onOnboardingStarted(
    OnboardingStarted event,
    Emitter<OnboardingState> emit,
  ) async {
    try {
      emit(const OnboardingLoading());
      // Simulation d'une initialisation
      await Future.delayed(const Duration(milliseconds: 500));
      emit(const OnboardingInProgress(currentPage: 0));
    } catch (e) {
      emit(OnboardingError(
        failure: ValidationFailure(
          message: 'Erreur lors du démarrage de l\'onboarding: $e',
        ),
      ));
    }
  }

  /// Gère le passage à la page suivante.
  Future<void> _onOnboardingNextPage(
    OnboardingNextPage event,
    Emitter<OnboardingState> emit,
  ) async {
    try {
      final currentState = state;
      if (currentState is OnboardingInProgress) {
        final int nextPage = currentState.currentPage + 1;
        
        if (nextPage < totalPages) {
          emit(currentState.copyWith(currentPage: nextPage));
        }
      }
    } catch (e) {
      emit(OnboardingError(
        failure: ValidationFailure(
          message: 'Erreur lors de la navigation: $e',
        ),
      ));
    }
  }

  /// Gère le retour à la page précédente.
  Future<void> _onOnboardingPreviousPage(
    OnboardingPreviousPage event,
    Emitter<OnboardingState> emit,
  ) async {
    try {
      final currentState = state;
      if (currentState is OnboardingInProgress) {
        final int previousPage = currentState.currentPage - 1;
        
        if (previousPage >= 0) {
          emit(currentState.copyWith(currentPage: previousPage));
        }
      }
    } catch (e) {
      emit(OnboardingError(
        failure: ValidationFailure(
          message: 'Erreur lors de la navigation: $e',
        ),
      ));
    }
  }

  /// Gère la sélection du type de compte.
  Future<void> _onAccountTypeSelected(
    OnboardingAccountTypeSelected event,
    Emitter<OnboardingState> emit,
  ) async {
    try {
      final currentState = state;
      if (currentState is OnboardingInProgress) {
        emit(currentState.copyWith(selectedUserType: event.userType));
      }
    } catch (e) {
      emit(OnboardingError(
        failure: ValidationFailure(
          message: 'Erreur lors de la sélection du type de compte: $e',
        ),
      ));
    }
  }

  /// Gère la sélection des préférences alimentaires.
  Future<void> _onPreferencesSelected(
    OnboardingPreferencesSelected event,
    Emitter<OnboardingState> emit,
  ) async {
    try {
      final currentState = state;
      if (currentState is OnboardingInProgress) {
        emit(currentState.copyWith(
          preferences: event.preferences,
          allergies: event.allergies,
        ));
      }
    } catch (e) {
      emit(OnboardingError(
        failure: ValidationFailure(
          message: 'Erreur lors de la sélection des préférences: $e',
        ),
      ));
    }
  }

  /// Gère la finalisation de l'onboarding.
  Future<void> _onOnboardingCompleted(
    OnboardingCompletedEvent event,
    Emitter<OnboardingState> emit,
  ) async {
    try {
      emit(const OnboardingLoading());
      
      // Récupérer les données précédemment saisies depuis le state
      UserType userType = UserType.consumer;
      List<String> preferences = [];
      List<String> allergies = [];
      
      // Si on a un état en cours, récupérer les données
      final previousState = state;
      if (previousState is OnboardingLoading) {
        // On aurait besoin d'une autre façon de récupérer l'état précédent
        // Pour l'instant, utilisons les valeurs par défaut
      }

      final User user = User(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        email: event.email,
        name: event.name,
        userType: userType,
        createdAt: DateTime.now(),
        preferences: UserPreferences(
          dietary: preferences,
          allergens: allergies,
          notifications: true, // Valeur par défaut
        ),
      );

      // Simulation de la sauvegarde
      await Future.delayed(const Duration(seconds: 1));
      
      emit(OnboardingCompleted(user: user));
    } catch (e) {
      emit(OnboardingError(
        failure: ServerFailure(
          message: 'Erreur lors de la création du compte: $e',
        ),
      ));
    }
  }

  /// Gère la sélection du mode invité.
  Future<void> _onGuestModeSelected(
    OnboardingGuestModeSelected event,
    Emitter<OnboardingState> emit,
  ) async {
    try {
      emit(const OnboardingLoading());
      
      // Simulation de la configuration du mode invité
      await Future.delayed(const Duration(milliseconds: 500));
      
      emit(const OnboardingGuestMode());
    } catch (e) {
      emit(OnboardingError(
        failure: ValidationFailure(
          message: 'Erreur lors de l\'activation du mode invité: $e',
        ),
      ));
    }
  }
}