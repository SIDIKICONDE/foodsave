import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:foodsave_app/core/constants/app_constants.dart';
import 'package:foodsave_app/core/constants/app_colors.dart';
import 'package:foodsave_app/core/constants/app_dimensions.dart';
import 'package:foodsave_app/core/constants/app_text_styles.dart';
import 'package:foodsave_app/domain/entities/user.dart';
import 'package:foodsave_app/presentation/bloc/onboarding/onboarding_bloc.dart';
import 'package:foodsave_app/presentation/bloc/onboarding/onboarding_event.dart';
import 'package:foodsave_app/presentation/bloc/onboarding/onboarding_state.dart';
import 'package:foodsave_app/presentation/pages/home/main_page.dart';

/// Page principale de l'onboarding de FoodSave.
class OnboardingPage extends StatelessWidget {
  /// Crée une nouvelle instance d'[OnboardingPage].
  const OnboardingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => OnboardingBloc()..add(const OnboardingStarted()),
      child: const OnboardingView(),
    );
  }
}

/// Vue interne de la page d'onboarding.
class OnboardingView extends StatelessWidget {
  /// Crée une nouvelle instance de [OnboardingView].
  const OnboardingView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<OnboardingBloc, OnboardingState>(
        listener: (context, state) {
          if (state is OnboardingError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.failure.message),
                backgroundColor: Colors.red,
              ),
            );
          } else if (state is OnboardingCompleted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Bienvenue ${state.user.name} !'),
                backgroundColor: Colors.green,
              ),
            );
            // Navigation vers la page principale après l'onboarding
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (context) => const MainPage(),
              ),
            );
          } else if (state is OnboardingGuestMode) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Mode invité activé'),
                backgroundColor: Colors.blue,
              ),
            );
            // Navigation vers la page principale en mode invité
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (context) => const MainPage(),
              ),
            );
          }
        },
        builder: (context, state) {
          if (state is OnboardingLoading) {
            return const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
              ),
            );
          }
          
          if (state is OnboardingInProgress) {
            return SafeArea(
              child: Column(
                children: [
                  _buildProgressIndicator(context, state),
                  Expanded(
                    child: _buildCurrentStep(context, state),
                  ),
                  _buildNavigationButtons(context, state),
                ],
              ),
            );
          }
          
          return const Center(
            child: Text('Initialisation...'),
          );
        },
      ),
    );
  }

  /// Construit l'indicateur de progression.
  Widget _buildProgressIndicator(BuildContext context, OnboardingInProgress state) {
    final double progress = (state.currentPage + 1) / OnboardingBloc.totalPages;
    
    return Padding(
      padding: const EdgeInsets.all(AppDimensions.spacingL),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                AppConstants.appName,
                style: AppTextStyles.headline5.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                ),
              ),
              Text(
                '${state.currentPage + 1}/${OnboardingBloc.totalPages}',
                style: AppTextStyles.bodyMedium,
              ),
            ],
          ),
          const SizedBox(height: AppDimensions.spacingL),
          LinearProgressIndicator(
            value: progress,
            backgroundColor: AppColors.border,
            valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primary),
          ),
        ],
      ),
    );
  }

  /// Construit l'étape actuelle de l'onboarding.
  Widget _buildCurrentStep(BuildContext context, OnboardingInProgress state) {
    switch (state.currentPage) {
      case 0:
        return _buildWelcomeStep(context);
      case 1:
        return _buildAccountTypeStep(context, state);
      case 2:
        return _buildPreferencesStep(context, state);
      case 3:
        return _buildCompletionStep(context);
      default:
        return const SizedBox.shrink();
    }
  }

  /// Construit la page de bienvenue.
  Widget _buildWelcomeStep(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppDimensions.spacingXL),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: AppDimensions.avatarXl + AppDimensions.spacingXL,
            height: AppDimensions.avatarXl + AppDimensions.spacingXL,
            decoration: BoxDecoration(
              color: AppColors.lighten(AppColors.primary, 0.8),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.eco,
              size: AppDimensions.iconGiant + AppDimensions.spacingM,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(height: AppDimensions.spacingXxl),
          Text(
            AppConstants.welcomeTitle,
            style: AppTextStyles.headline2.copyWith(
              color: AppColors.primary,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppDimensions.spacingL),
          Text(
            AppConstants.appSlogan,
            style: AppTextStyles.headline6.copyWith(
              color: AppColors.primaryDark,
              fontStyle: FontStyle.italic,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppDimensions.spacingXL),
          Text(
            AppConstants.welcomeDescription,
            style: AppTextStyles.bodyLarge.copyWith(
              color: AppColors.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  /// Construit la page de sélection du type de compte.
  Widget _buildAccountTypeStep(BuildContext context, OnboardingInProgress state) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppDimensions.spacingXL),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            AppConstants.accountTypeTitle,
            style: AppTextStyles.headline3,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppDimensions.spacingGiant),
          // Bouton Consommateur
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                context.read<OnboardingBloc>().add(
                  const OnboardingAccountTypeSelected(userType: UserType.consumer),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: AppColors.textOnDark,
                padding: const EdgeInsets.all(AppDimensions.spacingL + AppDimensions.spacingXs),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppDimensions.radiusL),
                ),
              ),
              child: Text(
                'Je suis consommateur',
                style: AppTextStyles.buttonPrimary,
              ),
            ),
          ),
          const SizedBox(height: AppDimensions.spacingL),
          // Bouton Commerçant
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                context.read<OnboardingBloc>().add(
                  const OnboardingAccountTypeSelected(userType: UserType.merchant),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.secondary,
                foregroundColor: AppColors.textOnDark,
                padding: const EdgeInsets.all(AppDimensions.spacingL + AppDimensions.spacingXs),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppDimensions.radiusL),
                ),
              ),
              child: Text(
                'Je suis commerçant',
                style: AppTextStyles.buttonPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Construit la page des préférences.
  Widget _buildPreferencesStep(BuildContext context, OnboardingInProgress state) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppDimensions.spacingXL),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Personnalisez votre expérience',
            style: AppTextStyles.headline3,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppDimensions.spacingXL),
          Text(
            'Ces informations nous aideront à vous proposer des paniers adaptés',
            style: AppTextStyles.bodyLarge.copyWith(
              color: AppColors.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppDimensions.spacingGiant),
          ElevatedButton(
            onPressed: () {
              context.read<OnboardingBloc>().add(
                const OnboardingPreferencesSelected(
                  preferences: [],
                  allergies: [],
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.info,
              foregroundColor: AppColors.textOnDark,
            ),
            child: Text(
              'Configurer plus tard',
              style: AppTextStyles.buttonPrimary,
            ),
          ),
        ],
      ),
    );
  }

  /// Construit la page de finalisation.
  Widget _buildCompletionStep(BuildContext context) {
    final TextEditingController nameController = TextEditingController();
    final TextEditingController emailController = TextEditingController();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppDimensions.spacingXL),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Dernière étape !',
            style: AppTextStyles.headline3.copyWith(
              color: AppColors.success,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppDimensions.spacingGiant),
          TextField(
            controller: nameController,
            style: AppTextStyles.bodyMedium,
            decoration: InputDecoration(
              labelText: 'Nom complet',
              labelStyle: AppTextStyles.labelMedium,
              hintText: 'Entrez votre nom et prénom',
              hintStyle: AppTextStyles.withColor(AppTextStyles.bodyMedium, AppColors.textSecondary),
              prefixIcon: Icon(
                Icons.person,
                color: AppColors.primary,
                size: AppDimensions.iconL,
              ),
            ),
          ),
          const SizedBox(height: AppDimensions.spacingL),
          TextField(
            controller: emailController,
            keyboardType: TextInputType.emailAddress,
            style: AppTextStyles.bodyMedium,
            decoration: InputDecoration(
              labelText: 'Adresse email',
              labelStyle: AppTextStyles.labelMedium,
              hintText: 'votre@email.com',
              hintStyle: AppTextStyles.withColor(AppTextStyles.bodyMedium, AppColors.textSecondary),
              prefixIcon: Icon(
                Icons.email,
                color: AppColors.primary,
                size: AppDimensions.iconL,
              ),
            ),
          ),
          const SizedBox(height: AppDimensions.spacingXxl),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                if (nameController.text.isNotEmpty && emailController.text.isNotEmpty) {
                  context.read<OnboardingBloc>().add(
                    OnboardingCompletedEvent(
                      name: nameController.text,
                      email: emailController.text,
                    ),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.success,
                foregroundColor: AppColors.textOnDark,
                padding: const EdgeInsets.all(AppDimensions.spacingL),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppDimensions.radiusL),
                ),
              ),
              child: Text(
                'Créer mon compte',
                style: AppTextStyles.buttonPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Construit les boutons de navigation.
  Widget _buildNavigationButtons(BuildContext context, OnboardingInProgress state) {
    final bool canGoBack = state.currentPage > 0;
    final bool canGoForward = state.currentPage < OnboardingBloc.totalPages - 1;
    final bool showGuestMode = state.currentPage == 0;

    return Padding(
      padding: const EdgeInsets.all(AppDimensions.spacingL),
      child: Column(
        children: [
          if (showGuestMode) ...[
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: () {
                  context.read<OnboardingBloc>().add(
                    const OnboardingGuestModeSelected(),
                  );
                },
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.info,
                  side: BorderSide(color: AppColors.info, width: AppDimensions.borderWidth),
                ),
                child: Text(
                  'Continuer en mode invité',
                  style: AppTextStyles.buttonSecondary.copyWith(
                    color: AppColors.info,
                  ),
                ),
              ),
            ),
            const SizedBox(height: AppDimensions.spacingM),
          ],
          Row(
            children: [
              if (canGoBack)
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      context.read<OnboardingBloc>().add(
                        const OnboardingPreviousPage(),
                      );
                    },
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.textSecondary,
                      side: const BorderSide(color: AppColors.border),
                    ),
                    child: Text(
                      'Précédent',
                      style: AppTextStyles.buttonSecondary.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ),
                ),
              if (canGoBack && canGoForward) const SizedBox(width: AppDimensions.spacingL),
              if (canGoForward)
                Expanded(
                  child: ElevatedButton(
                    onPressed: _canProceed(state) 
                        ? () {
                            context.read<OnboardingBloc>().add(
                              const OnboardingNextPage(),
                            );
                          }
                        : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _canProceed(state) ? AppColors.primary : AppColors.textDisabled,
                      foregroundColor: AppColors.textOnDark,
                    ),
                    child: Text(
                      'Suivant',
                      style: AppTextStyles.buttonPrimary,
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  /// Détermine si l'utilisateur peut passer à l'étape suivante.
  bool _canProceed(OnboardingInProgress state) {
    switch (state.currentPage) {
      case 0: // Page de bienvenue
        return true;
      case 1: // Sélection du type de compte
        return state.selectedUserType != null;
      case 2: // Préférences alimentaires
        return true;
      case 3: // Finalisation
        return false; // Géré par le bouton interne de l'étape
      default:
        return false;
    }
  }
}