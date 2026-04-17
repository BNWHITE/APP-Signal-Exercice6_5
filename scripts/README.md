# Exercice 6.5 – Sous-échantillonnage et filtre anti-repliement

## Structure du projet

```
scripts/
├── exercice_6_5.m          ← Script principal (toutes les questions)
├── myDSPEstimation.m       ← Fonction utilitaire (estimation DSP)
└── README.md               ← Ce fichier
data/
├── GardeMontante.wav       ← Signal audio fourni
├── RavelSi.wav             ← Signal audio fourni
└── QuestionW4_A.m          ← Template original (référence)
docs/
└── APP-A1Composante-Signal-2025-2026 - V3.pdf
```

## Comment utiliser dans MATLAB

1. Ouvrir MATLAB
2. Naviguer vers le dossier `scripts/` :
   ```matlab
   cd('/Users/s.sy/Documents/ISEP/APP SIgnal/Exercice_6_5/scripts')
   ```
3. Copier les fichiers `.wav` dans le dossier courant (ou ajouter `data/` au path) :
   ```matlab
   addpath('../data')
   ```
4. Exécuter le script :
   ```matlab
   exercice_6_5
   ```

## Questions traitées

| # | Description | Fichier |
|---|-------------|---------|
| Q1 | Chargement du signal, affichage temps/fréquence | `exercice_6_5.m` §1 |
| Q2 | Décimation sans filtre anti-repliement (interp1) | `exercice_6_5.m` §2 |
| Q3 | Conception du filtre anti-repliement (FIR equiripple) | `exercice_6_5.m` §3 |
| Q4 | Filtrage du signal original | `exercice_6_5.m` §4 |
| Q5 | Décimation du signal filtré | `exercice_6_5.m` §5 |

## Paramètres du filtre anti-repliement

- **Type** : Passe-bas FIR (equiripple / Parks-McClellan)
- **Fe** : 44100 Hz
- **Fe'** : 4000 Hz
- **Fpass** : 1800 Hz
- **Fstop** : 2000 Hz (= Fe'/2)
- **Astop** : 40 dB (SNR requis)
- **Apass** : 0.1 dB

### Justification
- Fstop = Fe'/2 = 2000 Hz → au-delà de cette fréquence, le repliement spectral apparaît lors de la décimation
- Astop = 40 dB → imposé par le cahier des charges (SNR > 40 dB)
- Fpass légèrement inférieur à Fstop → bande de transition étroite pour préserver le maximum de signal utile

## Pour utiliser Filter Designer (méthode graphique)

```matlab
filterDesigner
```
Configurer : Response Type = Lowpass, FIR Equiripple, Minimum Order, Fs = 44100, Fpass = 1800, Fstop = 2000, Apass = 0.1, Astop = 40. Puis File → Export → sauvegarder en `.mat`.
