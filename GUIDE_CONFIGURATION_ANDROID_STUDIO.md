# 🚀 GUIDE DE CONFIGURATION ANDROID STUDIO - FOODSAVE

## ⚡ PROJET NYTH - ZERO COMPROMISE

### ✅ ÉTAPES TERMINÉES
- [x] Téléchargement et installation d'Android Studio 2024.2.1
- [x] Configuration des variables d'environnement Android
- [x] Lancement d'Android Studio

### 🔧 CONFIGURATION MANUELLE REQUISE

#### 1. Assistant de Configuration Initiale
Lors du premier lancement d'Android Studio :
1. **Sélectionnez "Do not import settings"** (première installation)
2. **Choisissez le thème** (Dark/Light selon préférence)
3. **Acceptez les termes de licence**
4. **Cliquez sur "Next"** pour continuer

#### 2. Installation des Composants SDK
Dans l'assistant de configuration :
1. **SDK Components Setup** :
   - ✅ Android SDK
   - ✅ Android SDK Platform
   - ✅ Android Virtual Device
   - ✅ Performance (Intel HAXM) - si disponible

2. **SDK Location** :
   - Chemin par défaut : `~/Library/Android/sdk`
   - **Ne pas modifier** ce chemin

3. **Cliquez sur "Next"** et attendez le téléchargement

#### 3. Configuration Flutter (Important !)
1. **Ouvrez Android Studio**
2. **Allez dans File > Settings** (ou Android Studio > Preferences sur macOS)
3. **Naviguez vers Plugins**
4. **Recherchez "Flutter"** et installez le plugin
5. **Installez aussi le plugin "Dart"** (suggéré automatiquement)
6. **Redémarrez Android Studio**

#### 4. Vérification de l'Installation
Après configuration, exécutez dans le terminal :
```bash
source ~/.zshrc
flutter doctor
```

### 📱 CRÉATION D'UN ÉMULATEUR ANDROID

#### 1. Ouvrir AVD Manager
- **Tools > AVD Manager** dans Android Studio
- Ou cliquez sur l'icône d'émulateur dans la barre d'outils

#### 2. Créer un Nouvel AVD
1. **Cliquez sur "Create Virtual Device"**
2. **Sélectionnez un appareil** (ex: Pixel 7)
3. **Choisissez une image système** :
   - API Level 34 (Android 14) - **Recommandé**
   - Téléchargez si nécessaire
4. **Configurez l'AVD** :
   - Nom : "FoodSave_Emulator"
   - RAM : 4GB minimum
   - Stockage : 8GB minimum
5. **Cliquez sur "Finish"**

#### 3. Lancer l'Émulateur
- **Sélectionnez votre AVD** dans la liste
- **Cliquez sur le bouton Play** (▶️)

### 🎯 VÉRIFICATION FINALE

#### Commandes de Vérification
```bash
# Vérifier Flutter
flutter doctor

# Vérifier les appareils connectés
flutter devices

# Tester l'application FoodSave
cd /Users/m1/Desktop/FoodSave
flutter run
```

#### Résultat Attendu de `flutter doctor`
```
[✓] Flutter (Channel stable, 3.24.5)
[✓] Android toolchain - develop for Android devices
[✓] Xcode - develop for iOS and macOS
[✓] Chrome - develop for the web
[✓] Android Studio (version 2024.2.1)
[✓] Connected device (1 available)
```

### 🚨 RÉSOLUTION DE PROBLÈMES

#### Problème : "Unable to locate Android SDK"
```bash
# Configurer manuellement le SDK
flutter config --android-sdk ~/Library/Android/sdk
```

#### Problème : "CocoaPods not installed"
```bash
# Installer CocoaPods (nécessite sudo)
sudo gem install cocoapods
```

#### Problème : "Chrome not found"
```bash
# Installer Chrome ou configurer un autre navigateur
flutter config --enable-web
```

### 📋 CHECKLIST FINALE
- [ ] Android Studio configuré et fonctionnel
- [ ] SDK Android installé (API 34)
- [ ] Plugin Flutter installé
- [ ] Émulateur Android créé et fonctionnel
- [ ] `flutter doctor` sans erreurs critiques
- [ ] Application FoodSave peut être lancée

### 🎯 PROCHAINES ÉTAPES
1. **Développement** : Utiliser Android Studio pour le développement Flutter
2. **Tests** : Tester sur l'émulateur Android
3. **Déploiement** : Construire l'APK pour distribution

---

**⚡ EXCELLENCE OBLIGATOIRE - PROJET NYTH**
*Configuration conforme aux standards de qualité maximale*
