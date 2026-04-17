# Exercice 6.5 — Sous-échantillonnage et Filtre Anti-Repliement

**APP Signal — ISEP 2025-2026 — Groupe G2D**

## Objectif

Sous-échantillonner un signal audio de **44 100 Hz** à **4 000 Hz** avec un SNR > 40 dB, en concevant un filtre anti-repliement FIR par fenêtrage de Kaiser (sans Signal Processing Toolbox).

## Structure

```
├── main.m                      Point d'entrée
├── fonctions/
│   ├── myDSPEstimation.m       Estimation DSP (FFT)
│   ├── myKaiserFilter.m        Filtre FIR passe-bas (Kaiser)
│   └── myDecimation.m          Décimation avec/sans filtre
├── scripts/
│   └── exercice_6_5.m          Script complet (Q1–Q5)
├── tests/
│   ├── test_myDSPEstimation.m  10 tests unitaires
│   ├── test_myKaiserFilter.m   10 tests unitaires
│   └── test_myDecimation.m     10 tests unitaires
├── data/
│   ├── GardeMontante.wav       Signal audio
│   └── RavelSi.wav             Signal audio
├── docs/                       Sujet PDF + template original
└── rapport/
    └── rapport_Exercice6_5.tex Rapport LaTeX
```

## Utilisation

```matlab
cd('/chemin/vers/APP-Signal-Exercice6_5')
main
```

## Prérequis

- MATLAB R2020a+
- Aucune toolbox requise
