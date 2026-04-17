% #------------------------------------------
% NOM DU SCRIPT / FONCTION :
%   myDecimation
%
% AUTEUR :
%   G2D
%
% DATE :
%   17 Avril 2026
%
% DESCRIPTION :
%   Décimation d'un signal avec ou sans filtre anti-repliement.
%   Rééchantillonne le signal à une fréquence Fe2 < Fe.
%
% ENTREES :
%   - x    : vecteur (double) — Signal d'entrée
%   - Fe   : scalaire (double) — Fréquence d'échantillonnage originale (Hz)
%   - Fe2  : scalaire (double) — Nouvelle fréquence d'échantillonnage (Hz)
%   - h    : vecteur (double) — Coefficients du filtre anti-repliement
%            (vide [] pour décimation sans filtrage)
%
% SORTIES :
%   - y    : vecteur (double) — Signal décimé
%   - t2   : vecteur (double) — Nouveau vecteur temps (s)
%
% MODIFICATIONS :
%   Aucune
% #------------------------------------------

function [y, t2] = myDecimation(x, Fe, Fe2, h)

N   = length(x);
Te  = 1 / Fe;
t   = (0:N-1) * Te;
Te2 = 1 / Fe2;
t2  = 0 : Te2 : t(end);

% Filtrage optionnel
if ~isempty(h)
    x_filt = filter(h, 1, x);
else
    x_filt = x;
end

% Rééchantillonnage par interpolation linéaire
y = interp1(t, x_filt, t2, 'linear');
end
