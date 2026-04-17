# Rendu Exercice 6.5 – Sous-échantillonnage et filtre anti-repliement

**Composante Signal – APP A1 – ISEP 2025-2026**

---

## 1. Objectif

Pour une application bas débit, on souhaite descendre la fréquence d'échantillonnage d'un signal audio de $F_e = 44100\,\text{Hz}$ à $F_e' = 4000\,\text{Hz}$, avec un rapport signal à bruit supérieur à 40 dB.

---

## 2. Question 1 – Chargement et affichage du signal

- Chargement de `GardeMontante.wav` via `audioread`
- Conversion stéréo → mono : `x = mean(x, 2)`
- Affichage temporel et fréquentiel (DSP estimée via FFT)
- **Observation** : le signal possède un contenu spectral qui s'étend au-delà de 2 kHz (= $F_e'/2$)

---

## 3. Question 2 – Décimation sans filtre anti-repliement

- Facteur de décimation : $D = F_e / F_e' = 44100 / 4000 \approx 11$
- Rééchantillonnage à 4 kHz via `interp1(t, x, t2, 'linear')`
- **Observation** : on constate du **repliement spectral** (aliasing) sur la DSP du signal décimé. À l'écoute, le signal est dégradé par des artefacts audibles.
- **Explication** : les composantes fréquentielles au-dessus de $F_e'/2 = 2000\,\text{Hz}$ se replient dans la bande $[0, 2000]\,\text{Hz}$ (violation du théorème de Shannon).

---

## 4. Question 3 – Conception du filtre anti-repliement

### Gabarit du filtre

| Paramètre | Valeur | Justification |
|-----------|--------|---------------|
| Type | Passe-bas FIR Equiripple | Réponse en phase linéaire |
| $F_s$ | 44100 Hz | Fréquence d'échantillonnage du signal original |
| $F_{pass}$ | 1800 Hz | Bande utile à conserver |
| $F_{stop}$ | 2000 Hz | $= F_e'/2$, au-delà → repliement |
| $A_{stop}$ | 40 dB | Imposé par le cahier des charges (SNR > 40 dB) |
| $A_{pass}$ | 0.1 dB | Ondulation minimale en bande passante ($\delta_1 \approx \delta_2$) |

### Méthode

- Conception programmatique via `firpm` (algorithme de Parks-McClellan)
- Estimation de l'ordre par la formule de Kaiser
- Vérification de la réponse en fréquence : atténuation > 40 dB au-delà de 2 kHz ✅

---

## 5. Question 4 – Filtrage du signal

- Application du filtre : `xl3 = filter(h, 1, x)`
- **Observation** : la DSP du signal filtré montre que les composantes au-dessus de 2 kHz sont atténuées de plus de 40 dB.
- À l'écoute, le signal est légèrement plus sourd (perte des hautes fréquences) mais sans artefacts.

---

## 6. Question 5 – Décimation du signal filtré

- Rééchantillonnage du signal filtré : `xl4 = interp1(t, xl3, t2, 'linear')`
- **Observation** : la DSP du signal décimé ne présente **plus de repliement**. Le spectre est propre dans la bande $[0, 2000]\,\text{Hz}$.
- À l'écoute, le signal est de bonne qualité malgré la bande passante réduite.

---

## 7. Comparaison et conclusion

| Signal | Qualité | Repliement |
|--------|---------|------------|
| Original ($F_e = 44100$ Hz) | Excellente | Non |
| Décimé sans filtre ($F_e' = 4000$ Hz) | Dégradée | **Oui** |
| Décimé avec filtre ($F_e' = 4000$ Hz) | Bonne (bande limitée) | **Non** |

**Conclusion** : le filtre anti-repliement est **indispensable** avant toute opération de sous-échantillonnage. Il supprime les composantes spectrales au-delà de $F_e'/2$ et garantit le respect du théorème de Shannon, préservant ainsi un SNR > 40 dB.

---

## Fichiers

- `main.m` — Script principal (à la racine de `Documents/ISEP/`)
- `scripts/exercice_6_5.m` — Code complet des questions 1 à 5
- `scripts/myDSPEstimation.m` — Fonction d'estimation de la DSP
- `data/GardeMontante.wav`, `data/RavelSi.wav` — Signaux audio
