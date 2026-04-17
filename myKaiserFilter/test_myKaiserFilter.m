% #------------------------------------------
% NOM DU SCRIPT / FONCTION :
%   test_myKaiserFilter
%
% AUTEUR :
%   G2D
%
% DATE :
%   17 Avril 2026
%
% DESCRIPTION :
%   10 cas de test unitaires pour la fonction myKaiserFilter.
%   Vérifie l'ordre, le gain DC, l'atténuation, la symétrie.
%
% ENTREES :
%   Aucune (script de test autonome)
%
% SORTIES :
%   Affichage console : PASS / FAIL pour chaque test
%
% MODIFICATIONS :
%   Aucune
% #------------------------------------------

clear all; close all; clc;
fprintf('=== Tests unitaires : myKaiserFilter ===\n\n');
nb_pass = 0; nb_fail = 0;

% --- Fonction utilitaire ---
    function assert_test(name, cond)
        if cond
            fprintf('  [PASS] %s\n', name);
        else
            fprintf('  [FAIL] %s\n', name);
        end
    end

% Paramètres de référence
Fe = 44100; Fpass = 1800; Fstop = 2000; Astop = 40;
[h, Nfilt] = myKaiserFilter(Fe, Fpass, Fstop, Astop);

% ---- TEST 1 : Le filtre retourne un vecteur non vide ----
cond = ~isempty(h) && length(h) > 1;
if cond, nb_pass=nb_pass+1; else, nb_fail=nb_fail+1; end
assert_test('T1 - Vecteur h non vide', cond);

% ---- TEST 2 : Ordre pair (Type I FIR) ----
cond = mod(Nfilt, 2) == 0;
if cond, nb_pass=nb_pass+1; else, nb_fail=nb_fail+1; end
assert_test('T2 - Ordre pair', cond);

% ---- TEST 3 : Longueur h = Nfilt + 1 ----
cond = length(h) == Nfilt + 1;
if cond, nb_pass=nb_pass+1; else, nb_fail=nb_fail+1; end
assert_test('T3 - length(h) == Nfilt+1', cond);

% ---- TEST 4 : Gain DC = 1 (somme des coefficients) ----
cond = abs(sum(h) - 1) < 1e-10;
if cond, nb_pass=nb_pass+1; else, nb_fail=nb_fail+1; end
assert_test('T4 - Gain DC = 1 (sum(h) ≈ 1)', cond);

% ---- TEST 5 : Symétrie des coefficients (phase linéaire) ----
cond = max(abs(h - fliplr(h))) < 1e-12;
if cond, nb_pass=nb_pass+1; else, nb_fail=nb_fail+1; end
assert_test('T5 - Coefficients symétriques (phase linéaire)', cond);

% ---- TEST 6 : Atténuation suffisante en bande coupée ----
Nfft = 4096;
H = fft(h, Nfft);
f_ax = (0:Nfft-1) * Fe / Nfft;
idx_stop = find(f_ax >= Fstop & f_ax <= Fe/2);
att_db = 20*log10(abs(H(idx_stop)) + eps);
cond = max(att_db) < -Astop + 5;   % tolérance 5 dB
if cond, nb_pass=nb_pass+1; else, nb_fail=nb_fail+1; end
assert_test('T6 - Atténuation ≥ 35 dB en bande coupée', cond);

% ---- TEST 7 : Gain ≈ 0 dB en bande passante ----
idx_pass = find(f_ax <= Fpass);
gain_pass = 20*log10(abs(H(idx_pass)) + eps);
cond = max(abs(gain_pass)) < 1;    % < 1 dB d'ondulation
if cond, nb_pass=nb_pass+1; else, nb_fail=nb_fail+1; end
assert_test('T7 - Gain ≈ 0 dB en bande passante (< 1 dB)', cond);

% ---- TEST 8 : Atténuation plus forte → ordre plus élevé ----
[~, N60] = myKaiserFilter(Fe, Fpass, Fstop, 60);
cond = N60 > Nfilt;
if cond, nb_pass=nb_pass+1; else, nb_fail=nb_fail+1; end
assert_test('T8 - Astop=60 dB → ordre > Astop=40 dB', cond);

% ---- TEST 9 : Bande de transition plus étroite → ordre plus élevé ----
[~, N_narrow] = myKaiserFilter(Fe, 1900, 2000, Astop);
[~, N_wide]   = myKaiserFilter(Fe, 1500, 2000, Astop);
cond = N_narrow > N_wide;
if cond, nb_pass=nb_pass+1; else, nb_fail=nb_fail+1; end
assert_test('T9 - Transition étroite → ordre plus élevé', cond);

% ---- TEST 10 : Coefficients réels ----
cond = isreal(h);
if cond, nb_pass=nb_pass+1; else, nb_fail=nb_fail+1; end
assert_test('T10 - Coefficients réels', cond);

% ---- BILAN ----
fprintf('\n=== Bilan : %d / %d tests passés ===\n', nb_pass, nb_pass+nb_fail);
