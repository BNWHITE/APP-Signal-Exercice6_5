% #------------------------------------------
% NOM DU SCRIPT / FONCTION :
%   myKaiserFilter
%
% AUTEUR :
%   G2D
%
% DATE :
%   17 Avril 2026
%
% DESCRIPTION :
%   Conception d'un filtre FIR passe-bas par fenêtrage
%   de Kaiser (sans Signal Processing Toolbox).
%   Retourne les coefficients et l'ordre du filtre.
%
% ENTREES :
%   - Fe    : scalaire (double) — Fréquence d'échantillonnage (Hz)
%   - Fpass : scalaire (double) — Fin de bande passante (Hz)
%   - Fstop : scalaire (double) — Début de bande atténuée (Hz)
%   - Astop : scalaire (double) — Atténuation en bande coupée (dB)
%
% SORTIES :
%   - h     : vecteur (double) — Coefficients du filtre FIR
%   - Nfilt : scalaire (int)   — Ordre du filtre
%
% MODIFICATIONS :
%   Aucune
% #------------------------------------------

function [h, Nfilt] = myKaiserFilter(Fe, Fpass, Fstop, Astop)

fc = (Fpass + Fstop) / 2 / Fe;            % fréquence de coupure normalisée
df = (Fstop - Fpass) / Fe;                % bande de transition normalisée
A  = Astop;

% Paramètre beta de Kaiser
if A > 50
    beta = 0.1102 * (A - 8.7);
elseif A >= 21
    beta = 0.5842 * (A - 21)^0.4 + 0.07886 * (A - 21);
else
    beta = 0;
end

% Estimation de l'ordre
Nfilt = ceil((A - 7.95) / (2.285 * 2 * pi * df));
if mod(Nfilt, 2) == 1
    Nfilt = Nfilt + 1;
end

% Fenêtre de Kaiser manuelle
n_kaiser = (0:Nfilt)' - Nfilt/2;
besseli0 = @(x) sum(((x/2).^(0:20) ./ factorial(0:20)).^2);
w_kaiser = arrayfun(@(n) besseli0(beta * sqrt(1 - (2*n/Nfilt)^2)) / besseli0(beta), (0:Nfilt)');

% Réponse impulsionnelle idéale fenêtrée
arg_sinc = 2 * fc * n_kaiser;
h_ideal  = 2 * fc * sin(pi * arg_sinc) ./ (pi * arg_sinc);
h_ideal(arg_sinc == 0) = 2 * fc;

h = (h_ideal .* w_kaiser)';
h = h / sum(h);                            % normalisation DC = 1
end
