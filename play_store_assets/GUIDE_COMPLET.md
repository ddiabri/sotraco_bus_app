# 🚀 Guide complet de publication sur Google Play Store

## 📦 Fichiers créés pour vous

Tous les assets se trouvent dans le dossier `play_store_assets/`

### 1. Fichiers graphiques sources
- ✅ `app_icon.svg` - Icône de l'application (source)
- ✅ `feature_graphic.svg` - Bannière de fonctionnalité (source)
- ✅ `svg_to_png_converter.html` - Outil de conversion SVG → PNG

### 2. Fichier de build
- ✅ `build\app\outputs\bundle\release\app-release.aab` - App bundle signé

### 3. Configuration
- ✅ `android/upload-keystore.jks` - Clé de signature (⚠️ À CONSERVER PRÉCIEUSEMENT)
- ✅ `android/key.properties` - Configuration de signature
- ✅ `flutter_launcher_icons.yaml` - Configuration de l'icône

---

## 🎨 ÉTAPE 1 : Créer les images PNG

### A. Convertir les fichiers SVG

1. **Ouvrez le convertisseur** :
   - Double-cliquez sur `play_store_assets/svg_to_png_converter.html`
   - Il s'ouvrira dans votre navigateur

2. **Convertir l'icône d'application** :
   - Section "Icône d'application"
   - Cliquez sur "Choisir un fichier" → sélectionnez `app_icon.svg`
   - Cliquez sur "Convertir en PNG 512x512"
   - Le fichier `app_icon_512.png` sera téléchargé automatiquement

3. **Convertir l'icône de fonctionnalité** :
   - Section "Icône de fonctionnalité"
   - Cliquez sur "Choisir un fichier" → sélectionnez `feature_graphic.svg`
   - Cliquez sur "Convertir en PNG 1024x500"
   - Le fichier `feature_graphic_1024x500.png` sera téléchargé automatiquement

4. **Déplacer les fichiers** :
   - Déplacez `app_icon_512.png` dans `play_store_assets/`
   - Déplacez `feature_graphic_1024x500.png` dans `play_store_assets/`

---

## 📸 ÉTAPE 2 : Prendre des captures d'écran

### Option 1 : Via le navigateur (RECOMMANDÉ)

L'application tourne actuellement sur **http://localhost:8080**

1. **Ouvrez Chrome** et allez sur http://localhost:8080
2. **Ouvrez les DevTools** : Appuyez sur `F12`
3. **Mode mobile** : Cliquez sur l'icône de téléphone (Toggle device toolbar)
4. **Sélectionnez un appareil** : "Pixel 5" ou "Galaxy S20" (résolution 1080x2340)

5. **Capturez ces écrans** :

   📱 **Écran 1 - Accueil** :
   - L'écran principal avec la liste des lignes de bus
   - Faites un clic droit → "Capture screenshot" → Nommez `screenshot_1_home.png`

   📱 **Écran 2 - Recherche d'itinéraire** :
   - Cliquez sur l'icône de recherche (en haut à droite)
   - Capturez le formulaire de recherche → `screenshot_2_search.png`

   📱 **Écran 3 - Résultats** :
   - Dans la recherche, tapez "Gare" dans "Départ" et "Université" dans "Arrivée"
   - Cliquez sur "Rechercher un itinéraire"
   - Capturez les résultats → `screenshot_3_results.png`

   📱 **Écran 4 - Détails d'une ligne** :
   - Revenez en arrière et cliquez sur une ligne de bus
   - Capturez la liste des arrêts → `screenshot_4_details.png`

   📱 **Écran 5 - Informations** (Optionnel) :
   - Cliquez sur le menu (☰) → "Informations"
   - Capturez la page d'info → `screenshot_5_info.png`

6. **Sauvegardez** les captures dans `play_store_assets/screenshots/`

### Option 2 : Émulateur Android

Si vous avez Android Studio :
```bash
flutter run
```
Puis utilisez l'icône caméra dans l'émulateur.

---

## 🎯 ÉTAPE 3 : Mettre à jour l'icône de l'application

Une fois `app_icon_512.png` créé :

```bash
flutter pub get
flutter pub run flutter_launcher_icons
```

Cela mettra à jour l'icône dans l'application Android.

---

## 🌐 ÉTAPE 4 : Créer un compte Google Play Console

1. **Visitez** : https://play.google.com/console
2. **Inscrivez-vous** (25 USD, paiement unique)
3. **Créez un compte développeur**

---

## 📝 ÉTAPE 5 : Créer l'application sur Play Console

### A. Informations de base

1. Cliquez sur **"Créer une application"**
2. Remplissez :
   - **Nom** : SOTRACO Bus
   - **Langue par défaut** : Français (France)
   - **Type** : Application
   - **Gratuite/payante** : Gratuite

### B. Configuration du Store listing

Dans **Store listing**, remplissez :

**Description courte** (80 caractères max) :
```
Naviguez facilement les bus SOTRACO à Ouagadougou, Burkina Faso
```

**Description complète** :
```
SOTRACO Bus est une application non-officielle pour naviguer le réseau de bus SOTRACO à Ouagadougou, Burkina Faso.

🚌 FONCTIONNALITÉS :

• Recherche d'itinéraires entre arrêts
  Trouvez le meilleur chemin entre deux points du réseau

• Support des correspondances multiples
  L'application trouve automatiquement les trajets avec jusqu'à 3 transferts

• Calcul intelligent des distances
  Utilise les coordonnées géographiques réelles pour optimiser les parcours

• Interface en français
  Application entièrement localisée pour les utilisateurs burkinabés

• Informations complètes
  Consultez les tarifs, horaires et contacts SOTRACO

📍 RÉSEAU COUVERT :

• Lignes régulières
• Lignes étudiantes
• Lignes intercommunales
• Plus de 85 arrêts à Ouagadougou

⚡ RAPIDE ET HORS-LIGNE :

L'application fonctionne entièrement hors-ligne, idéale pour économiser vos données mobiles.

Note : Cette application est non-officielle et développée de manière indépendante pour faciliter l'utilisation du réseau SOTRACO.
```

**Coordonnées de l'application** :
- Email : [votre email]
- Politique de confidentialité : [URL à créer - voir section suivante]

**Catégorie** :
- Catégorie : Cartes et navigation

**Icône de l'application** :
- Uploadez `app_icon_512.png`

**Icône de fonctionnalité** :
- Uploadez `feature_graphic_1024x500.png`

**Captures d'écran** :
- Uploadez au moins 2 captures (recommandé : toutes les 5)
- Format : Téléphone (Portrait)

---

## 🔒 ÉTAPE 6 : Politique de confidentialité (OBLIGATOIRE)

Google Play exige une politique de confidentialité. Voici un modèle simple :

### Créez un fichier `privacy_policy.html` :

```html
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <title>Politique de confidentialité - SOTRACO Bus</title>
</head>
<body>
    <h1>Politique de confidentialité - SOTRACO Bus</h1>
    <p><em>Dernière mise à jour : [DATE]</em></p>

    <h2>Collecte de données</h2>
    <p>SOTRACO Bus ne collecte, ne stocke et ne partage AUCUNE donnée personnelle. L'application fonctionne entièrement hors-ligne et n'accède à aucune information de l'utilisateur.</p>

    <h2>Données utilisées</h2>
    <p>L'application utilise uniquement des données publiques concernant les lignes de bus SOTRACO à Ouagadougou. Aucune donnée n'est transmise à des serveurs externes.</p>

    <h2>Permissions</h2>
    <p>L'application ne demande aucune permission spéciale sur votre appareil.</p>

    <h2>Contact</h2>
    <p>Pour toute question concernant cette politique, contactez : [VOTRE EMAIL]</p>
</body>
</html>
```

Hébergez ce fichier sur :
- GitHub Pages (gratuit)
- Google Sites (gratuit)
- Votre propre site web

Notez l'URL pour la Play Console.

---

## 📤 ÉTAPE 7 : Uploader l'app bundle

1. Dans Play Console, allez à **"Production"**
2. Cliquez sur **"Créer une nouvelle version"**
3. Cliquez sur **"Importer"** et sélectionnez :
   ```
   C:\Users\ddiab\sotraco_bus_app\build\app\outputs\bundle\release\app-release.aab
   ```

4. **Notes de version** (en français) :
```
Version 1.0.0 - Version initiale

• Recherche d'itinéraires entre arrêts
• Support des trajets avec correspondances
• Calcul des distances en temps réel
• Interface en français
• Plus de 85 arrêts couverts
• Fonctionnement hors-ligne
```

---

## ✅ ÉTAPE 8 : Compléter le questionnaire de contenu

Dans Play Console, complétez :

### A. Évaluation du contenu
- Public cible : Tous les âges
- Contient des publicités : Non
- Achats intégrés : Non

### B. Sélection du public cible
- Âge cible : 13 ans et plus

### C. Questionnaire sur les données
- L'app collecte des données : Non
- L'app partage des données : Non

---

## 🚀 ÉTAPE 9 : Soumettre pour révision

1. Vérifiez que toutes les sections ont une coche verte ✓
2. Cliquez sur **"Envoyer pour révision"**
3. **Délai de révision** : 1-3 jours généralement

---

## 📊 CHECKLIST FINALE

Avant de soumettre, vérifiez :

- [ ] App bundle uploadé (`app-release.aab`)
- [ ] Icône d'application 512x512 px
- [ ] Icône de fonctionnalité 1024x500 px
- [ ] Au moins 2 captures d'écran (recommandé 4-8)
- [ ] Description courte (max 80 caractères)
- [ ] Description complète
- [ ] Politique de confidentialité (URL)
- [ ] Catégorie sélectionnée
- [ ] Évaluation du contenu complétée
- [ ] Email de contact valide
- [ ] Frais de développeur payés (25 USD)

---

## 🔄 FUTURES MISES À JOUR

Pour publier une mise à jour :

1. **Modifiez le code** de l'application
2. **Mettez à jour la version** dans `pubspec.yaml` :
   ```yaml
   version: 1.0.1+2  # Incrémentez le build number
   ```
3. **Reconstruisez** :
   ```bash
   flutter build appbundle
   ```
4. **Uploadez** le nouveau `.aab` dans Play Console
5. **Ajoutez des notes** de version

---

## ⚠️ FICHIERS CRITIQUES À SAUVEGARDER

**NE PERDEZ JAMAIS CES FICHIERS** :

```
📁 android/
  ├── upload-keystore.jks         ⚠️ CRITIQUE
  └── key.properties               ⚠️ CRITIQUE
```

**Informations de signature :**
- Mot de passe : `sotraco2024`
- Alias : `upload`
- Application ID : `com.sotraco.busapp`

💡 **Conseil** : Faites une sauvegarde de ces fichiers sur un disque externe ou cloud sécurisé !

---

## 📞 SUPPORT

**Questions sur Play Console :**
- https://support.google.com/googleplay/android-developer

**Documentation Flutter :**
- https://docs.flutter.dev/deployment/android

**Email de support pour l'app :**
- [Votre email]

---

## 🎉 C'EST PRÊT !

Votre application SOTRACO Bus est maintenant prête à être publiée sur Google Play Store. Suivez les étapes ci-dessus dans l'ordre et vous devriez pouvoir soumettre votre application avec succès.

Bonne chance ! 🚀
