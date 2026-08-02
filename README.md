# NoReelInsta

[![License: GPL v3](https://img.shields.io/badge/License-GPLv3-blue.svg)](https://www.gnu.org/licenses/gpl-3.0)
[![Theos](https://img.shields.io/badge/Built%20with-Theos-blue)](https://theos.dev)
[![Instagram 440.0.0](https://img.shields.io/badge/Instagram-440.0.0-purple)](https://apps.apple.com/us/app/instagram/id389801252)

**Tweak ultra-minimaliste pour Instagram iOS** qui ne fait **que** :
1. ✅ **Supprimer l'onglet Reels** de la barre de navigation
2. ✅ **Empêcher le défilement automatique** vers de nouveaux Reels ("doomscrolling")
3. ✅ **Corriger la surbrillance** des onglets après suppression de Reels

---

## 🎯 Pourquoi NoReelInsta ?
- **Ultra-minimaliste** : Seulement **4 hooks** (contre 100+ dans SCInsta)
- **Stable** : Moins de code = moins de risques de conflits avec les MAJ Instagram
- **Facile à maintenir** : Si Instagram change, il n'y a que **2 fonctionnalités** à vérifier
- **Pas de settings** : Tout est activé par défaut
- **Sécurisé** : Aucun risque de ban (ne modifie pas le comportement métiers)

---

## 📥 Prérequis
1. **Theos** : Outil de compilation pour tweaks iOS ([guide d'installation](https://theos.dev/docs/installation))
2. **IPA d'Instagram décryptée** : À placer dans `NoReelInsta/packages/com.burbn.instagram.ipa`
   - Télécharge depuis [iOS Ninja](https://iosninja.io) ou [iPA Store](https://ipastore.me)
3. **Outils** :
   - `cyan` : `pip install pyzule-rw` (intégration du tweak dans l'IPA)
   - `ipapatch` : Télécharger depuis [ipapatch releases](https://github.com/asdfzxcvbn/ipapatch/releases) (patching pour sideloading)
4. **Mac** : macOS avec Xcode Command Line Tools (`xcode-select --install`)

---

## 🚀 Installation

### 1️⃣ Placer l'IPA d'Instagram
Télécharge la **dernière version décryptée** d'Instagram (fichier `.ipa`) et place-la ici :
```bash
NoReelInsta/packages/com.burbn.instagram.ipa
```

### 2️⃣ Compiler le tweak
```bash
cd NoReelInsta
chmod +x build.sh
./build.sh sideload
```

### 3️⃣ Installer sur l'iPhone
- L'IPA finale sera générée ici : `NoReelInsta/packages/NoReelInsta-sideloaded.ipa`
- Installe-la avec **AltStore** ou **Sideloadly**

---

## 🔄 Mise à jour d'Instagram

Si Instagram est mis à jour via l'App Store :
1. **Supprime** l'ancienne version modifiée de ton iPhone
2. **Télécharge** la nouvelle version décryptée d'Instagram (`.ipa`)
3. **Remplace** `com.burbn.instagram.ipa` dans `NoReelInsta/packages/`
4. **Recompile** avec `cd NoReelInsta && ./build.sh sideload`
5. **Réinstalle** l'IPA générée (`NoReelInsta/packages/NoReelInsta-sideloaded.ipa`)

---

## 📌 Où trouver les IPA décryptées ?

### Méthode 1 : Sites de téléchargement (recommandé pour débutants)
| Site | Lien | Notes |
|------|------|-------|
| iOS Ninja | [https://iosninja.io](https://iosninja.io) | IPA officielles, mises à jour régulièrement |
| iPA Store | [https://ipastore.me](https://ipastore.me) | Large bibliothèque d'IPA |
| AppDB | [https://appdb.to](https://appdb.to) | Nécessite un compte gratuit |

⚠️ **Attention** : Télécharge **uniquement** la version **officielle** d'Instagram (pas de versions modifiées).

### Méthode 2 : Décrypter toi-même l'IPA (avancé)
1. Télécharge Instagram depuis l'App Store avec **iTunes** (Mac) ou **Apple Configurator 2**
2. Utilise un outil comme **dumpdecrypted** (nécessite un jailbreak) ou **Frida** pour décrypter
3. Place le résultat dans `NoReelInsta/packages/com.burbn.instagram.ipa`

---

## ❓ Problèmes courants

### L'IPA ne compile pas
- **Erreur** : `com.burbn.instagram.ipa not found`
  **Solution** : Vérifie que le fichier est bien dans `NoReelInsta/packages/` et qu'il s'appelle exactement `com.burbn.instagram.ipa`

### Le tweak ne fonctionne pas après mise à jour
- **Cause** : Instagram a changé les noms de classes (ex: `IGTabBarController` → autre nom)
  **Solution** : 
  1. Vérifie les noms de classes avec **Frida** ou **Cycript**
  2. Mets à jour `InstagramHeaders.h` avec les nouveaux noms
  3. Recompile

### L'onglet Reels réapparaît
- **Cause** : L'IPA n'a pas été correctement patchée
  **Solution** : 
  1. Supprime l'app de ton iPhone
  2. Réinstalle l'IPA générée (`NoReelInsta/packages/NoReelInsta-sideloaded.ipa`)

---

## 🛠️ Personnalisation

Pour **désactiver** une fonctionnalité, modifie ces lignes dans `Tweak.x` :
```c
#define ALWAYS_HIDE_REELS_TAB NO   // Désactive la suppression de l'onglet
#define ALWAYS_DISABLE_SCROLLING NO // Désactive le blocage du scroll
```

---

## 📦 Structure du projet
```
NoReelInsta/
├── Makefile              # Configuration Theos
├── Tweak.x               # Code principal (4 hooks)
├── Tweak.h               # Déclarations
├── Utils.h/.m            # Fonctions utilitaires (accès aux ivars)
├── InstagramHeaders.h    # Déclarations des classes Instagram
├── build.sh              # Script de build
├── control               # Métadonnées du package
├── LICENSE               # Licence GPLv3
├── CHANGELOG.md          # Historique des versions
├── VERSION               # Version actuelle
├── README.md             # Documentation
└── packages/             # Dossier pour les IPA
    ├── com.burbn.instagram.ipa      # IPA originale (à placer ici)
    └── NoReelInsta-sideloaded.ipa   # IPA finale (générée)
```

---

## 💡 Astuce pour les mises à jour futures
- **Garde une copie** de `InstagramHeaders.h` d'origine
- **Note les versions** compatibles dans `CHANGELOG.md`
- **Vérifie les logs** : Utilise **Console.app** (Mac) ou **CrashReporter** (iPhone jailbreaké) en cas de crash

---

## 🤝 Contribuer
Les contributions sont les bienvenues ! Ouvre une **Pull Request** pour :
- Ajouter le support pour de nouvelles versions d'Instagram
- Corriger des bugs
- Améliorer la documentation

## 📜 Licence
Ce projet est sous licence **GPLv3** - voir [LICENSE](LICENSE) pour plus de détails.

## 🙏 Remerciements
- [SoCuul](https://github.com/SoCuul) pour [SCInsta](https://github.com/SoCuul/SCInsta), dont ce projet s'inspire (et dont la licence GPLv3 est héritée)
- La communauté Theos pour les outils de développement
- Tous les contributeurs et testeurs
