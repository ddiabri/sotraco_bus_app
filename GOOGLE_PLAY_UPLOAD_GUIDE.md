# Guide de Publication sur Google Play Store

## ✓ Étape 1 : Fichiers Prêts

Vous avez déjà tous les fichiers nécessaires :

### App Bundle (fichier à uploader)
- **Localisation** : `build\app\outputs\bundle\release\app-release.aab`
- **Taille** : 19.5 MB
- **Statut** : ✓ Prêt

### Assets Graphiques
- ✓ **Icône de l'application** : `play_store_assets/app_icon_512.png` (512x512)
- ✓ **Feature Graphic** : `play_store_assets/feature_graphic_1024x500.png` (1024x500)

### À Préparer
- ⚠️ **Captures d'écran** : Minimum 2 requises (recommandé 4-8)
- ⚠️ **Description de l'app** : Texte court et long
- ⚠️ **Politique de confidentialité** : URL requise

---

## Étape 2 : Créer un Compte Google Play Console

1. Allez sur https://play.google.com/console
2. Connectez-vous avec votre compte Google (ddiabri.dd@gmail.com)
3. **Frais d'inscription unique : 25 USD** (paiement par carte bancaire)
4. Acceptez les conditions de service

---

## Étape 3 : Créer une Nouvelle Application

1. Dans Play Console, cliquez sur **"Créer une application"**
2. Remplissez :
   - **Nom de l'application** : `SOTRACO - Itinéraires des bus`
   - **Langue par défaut** : Français
   - **Type** : Application
   - **Gratuite ou payante** : Gratuite
3. Acceptez les déclarations de conformité
4. Cliquez sur **"Créer l'application"**

---

## Étape 4 : Configurer la Fiche du Store

### 4.1 Fiche du Store (Menu : Présence sur le Play Store → Fiche du Store principale)

#### Description courte (80 caractères max)
```
Trouvez votre itinéraire de bus SOTRACO à Ouagadougou facilement
```

#### Description complète (4000 caractères max)
```
🚌 SOTRACO - Itinéraires des bus de Ouagadougou

Trouvez facilement votre itinéraire de bus SOTRACO à Ouagadougou ! Cette application non officielle vous aide à naviguer le réseau de transport en commun de la capitale du Burkina Faso.

✨ FONCTIONNALITÉS

• Recherche d'itinéraire intelligente
  Entrez votre point de départ et d'arrivée pour trouver les meilleurs itinéraires

• Support des correspondances
  Trouvez des trajets avec jusqu'à 3 correspondances pour atteindre votre destination

• Toutes les lignes SOTRACO
  - Lignes régulières
  - Lignes étudiantes
  - Lignes intercommunales (Koubri, Ziniaré, Pabré)

• Informations détaillées
  - Liste complète des arrêts pour chaque ligne
  - Distances calculées avec précision
  - Grille tarifaire complète
  - Contact SOTRACO

• Interface en français
  Application entièrement localisée pour les utilisateurs burkinabés

🗺️ COMMENT ÇA MARCHE

1. Recherchez votre itinéraire en entrant le départ et l'arrivée
2. Consultez les lignes directes ou avec correspondances
3. Visualisez tous les arrêts de votre trajet
4. Accédez aux tarifs et horaires

📍 COUVERTURE

• Ouagadougou centre
• Zones périphériques
• Lignes intercommunales vers Koubri, Ziniaré et Pabré

💰 TARIFS SOTRACO

• Ticket à la course : 200 FCFA
• Abonnement étudiant mensuel : 3 000 FCFA
• Abonnement mensuel : 7 000 FCFA
• Tarifs spéciaux pour lignes intercommunales

ℹ️ NOTE IMPORTANTE

Cette application est NON OFFICIELLE et a été créée pour faciliter l'utilisation du réseau SOTRACO. Les données sont fournies à titre indicatif.

Pour les horaires officiels et informations à jour, contactez directement SOTRACO :
☎️ +226 25 35 55 55
📱 +226 52 50 18 18

🆓 GRATUIT ET SANS PUBLICITÉ

Application 100% gratuite, sans publicité, créée pour servir la communauté.
```

#### Icône de l'application
- Upload : `play_store_assets/app_icon_512.png`

#### Feature Graphic
- Upload : `play_store_assets/feature_graphic_1024x500.png`

#### Captures d'écran
Vous devez prendre au minimum 2 captures d'écran. Voici comment :

**Option 1 : Utiliser l'émulateur Android**
```bash
# Lancer l'émulateur
flutter emulators --launch <nom_emulateur>

# Lancer l'app
flutter run

# Dans l'émulateur, utilisez l'icône caméra pour capturer :
# 1. Écran d'accueil (liste des lignes)
# 2. Recherche d'itinéraire
# 3. Résultats de recherche
# 4. Détails d'une ligne
```

**Option 2 : Utiliser un appareil physique**
```bash
# Branchez votre téléphone Android
flutter run

# Prenez des captures avec Power + Volume Bas
# Transférez les fichiers sur PC
```

**Écrans recommandés à capturer :**
1. Page d'accueil avec liste des lignes
2. Interface de recherche d'itinéraire
3. Résultats de recherche montrant les correspondances
4. Détails d'une ligne avec tous les arrêts
5. Page d'informations (tarifs)

---

### 4.2 Catégorisation de l'Application

- **Catégorie** : Cartes et navigation
- **Tags** : transport, bus, ouagadougou, burkina faso, sotraco

---

### 4.3 Coordonnées

- **Adresse e-mail** : ddiabri.dd@gmail.com
- **Site web** : (Optionnel - laissez vide si pas de site)
- **Numéro de téléphone** : (Optionnel)

---

## Étape 5 : Politique de Confidentialité

Google Play **EXIGE** une URL de politique de confidentialité. Vous avez 2 options :

### Option A : Hébergement gratuit

1. Créez un compte sur https://www.privacypolicies.com (gratuit)
2. Générez une politique pour une app mobile gratuite
3. Copiez l'URL générée

### Option B : Hébergement sur GitHub Pages (gratuit)

Créez un fichier `privacy-policy.html` et hébergez-le gratuitement :

```html
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Politique de Confidentialité - SOTRACO Bus</title>
</head>
<body>
    <h1>Politique de Confidentialité</h1>
    <p>Dernière mise à jour : [DATE]</p>

    <h2>Collecte de données</h2>
    <p>Cette application ne collecte, ne stocke et ne partage AUCUNE donnée personnelle.</p>

    <h2>Données de localisation</h2>
    <p>L'application n'accède pas à votre localisation.</p>

    <h2>Données stockées localement</h2>
    <p>Toutes les informations sur les itinéraires de bus sont stockées localement
    sur votre appareil et ne sont jamais transmises à des serveurs externes.</p>

    <h2>Contact</h2>
    <p>Pour toute question : ddiabri.dd@gmail.com</p>
</body>
</html>
```

Hébergez sur GitHub Pages :
1. Créez un repo `sotraco-privacy-policy`
2. Activez GitHub Pages
3. URL : `https://[votre-username].github.io/sotraco-privacy-policy/`

---

## Étape 6 : Classification du Contenu

1. Allez dans **Contenu de l'application → Classification du contenu**
2. Répondez au questionnaire :
   - **Violence** : Non
   - **Contenu sexuel** : Non
   - **Langage grossier** : Non
   - **Substances contrôlées** : Non
   - **Jeux d'argent** : Non

3. **Public cible** : Tous (G - General Audience)

---

## Étape 7 : Informations sur l'Application

### Public cible
- **Groupe d'âge principal** : 18+ (adultes)
- **Appel aux enfants** : Non

### Pays disponibles
- Sélectionnez : **Burkina Faso** (ou tous les pays)

---

## Étape 8 : Upload de l'App Bundle

1. Allez dans **Diffusion → Tests → Tests internes**
2. Créez une version de test interne
3. Cliquez sur **"Créer une version"**
4. **Uploadez le fichier** : `build\app\outputs\bundle\release\app-release.aab`
5. Donnez un nom à la version : `1.0.0 (1)` - Version initiale
6. Notes de version (français) :
```
Version initiale de l'application SOTRACO Bus.

Fonctionnalités :
• Recherche d'itinéraires entre arrêts
• Support des correspondances (jusqu'à 3 transferts)
• Toutes les lignes SOTRACO (régulières, étudiantes, intercommunales)
• Informations tarifaires
• Interface entièrement en français
```

7. Cliquez sur **"Enregistrer"** puis **"Examiner la version"**
8. Cliquez sur **"Déployer la version"**

---

## Étape 9 : Tests Internes (Optionnel mais Recommandé)

1. Ajoutez des testeurs (emails)
2. Ils recevront un lien pour tester l'app avant publication
3. Testez pendant quelques jours
4. Corrigez les bugs éventuels

---

## Étape 10 : Passer en Production

Une fois les tests internes validés :

1. Allez dans **Diffusion → Production**
2. Cliquez sur **"Créer une version"**
3. Sélectionnez la version testée
4. Ajoutez les mêmes notes de version
5. Cliquez sur **"Enregistrer"** puis **"Examiner la version"**
6. Cliquez sur **"Déployer en production"**

---

## Étape 11 : Examen par Google

- **Délai** : 1 à 7 jours (généralement 1-2 jours)
- **Notification** : Vous recevrez un email
- **Statut** : Vérifiez dans Play Console

### Raisons de rejet possibles :
- ❌ Politique de confidentialité manquante/invalide
- ❌ Captures d'écran manquantes
- ❌ Description trompeuse
- ❌ Problèmes de contenu

---

## Checklist Finale Avant Soumission

- [ ] App Bundle uploadé (app-release.aab)
- [ ] Icône 512x512 uploadée
- [ ] Feature graphic 1024x500 uploadée
- [ ] Minimum 2 captures d'écran (4-8 recommandé)
- [ ] Description courte rédigée
- [ ] Description complète rédigée
- [ ] Politique de confidentialité (URL valide)
- [ ] Catégorie sélectionnée
- [ ] Classification du contenu complétée
- [ ] Public cible défini
- [ ] Notes de version rédigées

---

## Après la Publication

### Suivi des Performances
- Consultez les statistiques dans Play Console
- Répondez aux avis des utilisateurs
- Surveillez les rapports de crash

### Mises à Jour Futures

Pour publier une mise à jour :

1. Modifiez le code
2. Mettez à jour `pubspec.yaml` :
```yaml
version: 1.0.1+2  # Incrémentez version et build number
```

3. Reconstruisez :
```bash
flutter build appbundle --release
```

4. Uploadez la nouvelle version dans Play Console

---

## Support et Ressources

- **Documentation officielle** : https://support.google.com/googleplay/android-developer
- **Play Console** : https://play.google.com/console
- **Frais uniques** : 25 USD
- **Publication gratuite** : Pas de frais récurrents

---

## Résumé des Coûts

- **Inscription développeur Google Play** : 25 USD (une seule fois)
- **Publication de l'app** : Gratuit
- **Mises à jour** : Gratuites
- **Total** : 25 USD

---

Bonne chance avec votre publication ! 🚀
