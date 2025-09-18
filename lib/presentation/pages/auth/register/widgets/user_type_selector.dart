import 'package:flutter/material.dart';
import 'package:foodsave_app/core/constants/app_colors.dart';
import 'package:foodsave_app/core/constants/app_dimensions.dart';
import 'package:foodsave_app/core/constants/app_text_styles.dart';
import 'package:foodsave_app/domain/entities/user.dart';
import 'package:foodsave_app/presentation/pages/auth/register/constants/register_constants.dart';

/// Widget pour le sélecteur de type d'utilisateur.
///
/// Permet de choisir entre consommateur et commerçant avec des RadioListTile.
class UserTypeSelector extends StatelessWidget {
  /// Le type d'utilisateur actuellement sélectionné.
  final UserType selectedUserType;

  /// Callback appelé lorsque le type d'utilisateur change.
  final ValueChanged<UserType?> onUserTypeChanged;

  /// Crée un sélecteur de type d'utilisateur.
  const UserTypeSelector({
    super.key,
    required this.selectedUserType,
    required this.onUserTypeChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.border),
        borderRadius: BorderRadius.circular(AppDimensions.radiusM),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          // Titre de la section
          Padding(
            padding: const EdgeInsets.all(AppDimensions.spacingM),
            child: Text(
              RegisterConstants.userTypeSectionTitle,
              style: AppTextStyles.labelMedium.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
          ),

          // Options de type d'utilisateur
          RadioGroup<UserType>(
            groupValue: selectedUserType,
            onChanged: onUserTypeChanged,
            child: Column(
              children: <Widget>[
                // Option Consommateur
                RadioListTile<UserType>(
                  title: Text(
                    RegisterConstants.consumerTitle,
                    style: AppTextStyles.bodyMedium,
                  ),
                  subtitle: Text(
                    RegisterConstants.consumerSubtitle,
                    style: AppTextStyles.bodySmall.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                  value: UserType.consumer,
                  activeColor: AppColors.primary,
                  groupValue: selectedUserType,
                  onChanged: onUserTypeChanged,
                ),

                const Divider(height: 1),

                // Option Commerçant
                RadioListTile<UserType>(
                  title: Text(
                    RegisterConstants.merchantTitle,
                    style: AppTextStyles.bodyMedium,
                  ),
                  subtitle: Text(
                    RegisterConstants.merchantSubtitle,
                    style: AppTextStyles.bodySmall.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                  value: UserType.merchant,
                  activeColor: AppColors.secondary,
                  groupValue: selectedUserType,
                  onChanged: onUserTypeChanged,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Widget utilitaire pour grouper les RadioListTile.
///
/// Permet de gérer un groupe de boutons radio avec une valeur commune.
class RadioGroup<T> extends InheritedWidget {
  /// La valeur actuellement sélectionnée dans le groupe.
  final T groupValue;

  /// Callback appelé lorsque la valeur change.
  final ValueChanged<T?> onChanged;

  /// Crée un groupe de boutons radio.
  const RadioGroup({
    super.key,
    required this.groupValue,
    required this.onChanged,
    required super.child,
  });

  /// Accède au RadioGroup depuis le contexte.
  static RadioGroup<T>? of<T>(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<RadioGroup<T>>();
  }

  @override
  bool updateShouldNotify(RadioGroup<T> oldWidget) {
    return oldWidget.groupValue != groupValue;
  }
}
