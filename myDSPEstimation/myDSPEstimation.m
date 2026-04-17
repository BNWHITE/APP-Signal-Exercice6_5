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
%   d'un signal par FFT. Retourne l'axe fréquentiel,
%   le module normalisé et la DSP en dB.
%
% ENTREES :
%   - x  : vecteur (double) — Signal d'entrée
%   - Fe : scalaire (double) — Fréquence d'échantillonnage (Hz)
%
% SORTIES :
%   - f      : vecteur (double) — Axe fréquentiel 0..Fe/2 (Hz)
%   - xfm    : vecteur (double) — Module FFT normalisé
%   - dsp_db : vecteur (double) — DSP en dB
%
% MODIFICATIONS :
%   Aucune
% #------------------------------------------

function [f, xfm, dsp_db] = myDSPEstimation(x, Fe, ~)

N   = length(x);
X   = fft(x);
xfm = abs(X(1:floor(N/2)+1)) / N;
xfm(2:end-1) = 2 * xfm(2:end-1);

dsp    = xfm.^2;
dsp_db = 10*log10(dsp + eps);

f = (0:floor(N/2)) * Fe / N;

if iscolumn(f),      f = f';           end
if iscolumn(xfm),    xfm = xfm';      end
if iscolumn(dsp_db), dsp_db = dsp_db'; end
end
