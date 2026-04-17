% #------------------------------------------
% NOM DU SCRIPT / FONCTION :
%   myDSPEstimation
%
% AUTEUR :
%   G2D
%
% DATE :
%   17 Avril 2026
%
% DESCRIPTION :
%   Estimation de la densité spectrale de puissance (DSP)
%   d'un signal par FFT.
%
% ENTREES :
%      - x  : vecteur (double) — Signal d'entrée
%   - Fe : scalaire (double) — Fréquence d'échantillonnage (Hz)
%
% SORTIES :
%      - f      : vecteur (double) — Axe fréquentiel (Hz)
%   - xfm    : vecteur (double) — Module FFT normalisé
%   - dsp_db : vecteur (double) — DSP en dB
%
% MODIFICATIONS :
%   Aucune
% #------------------------------------------

function [f, xfm, dsp_db] = myDSPEstimation(x, Fe, ~)
% myDSPEstimation  Estimation de la densité spectrale de puissance (DSP)
%   [f, xfm, dsp_db] = myDSPEstimation(x, Fe, [])
%
%   Entrées :
%       x   - signal temporel (vecteur colonne ou ligne)
%       Fe  - fréquence d'échantillonnage (Hz)
%
%   Sorties :
%       f      - vecteur de fréquences (Hz), de 0 à Fe/2
%       xfm    - module de la FFT (normalisé)
%       dsp_db - DSP en dB (10*log10)

N   = length(x);
X   = fft(x);
xfm = abs(X(1:floor(N/2)+1)) / N;      % module normalisé
xfm(2:end-1) = 2 * xfm(2:end-1);       % facteur 2 pour fréquences positives

dsp    = xfm.^2;                         % densité spectrale de puissance
dsp_db = 10*log10(dsp + eps);            % en dB (eps évite log(0))

f = (0:floor(N/2)) * Fe / N;            % axe fréquentiel

% Transposer en vecteur ligne si nécessaire pour cohérence avec le template
if iscolumn(f),      f = f';           end
if iscolumn(xfm),    xfm = xfm';      end
if iscolumn(dsp_db), dsp_db = dsp_db'; end
end
