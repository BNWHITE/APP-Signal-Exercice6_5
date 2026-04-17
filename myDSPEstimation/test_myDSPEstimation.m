% #------------------------------------------
% NOM DU SCRIPT / FONCTION :
%   test_myDSPEstimation
%
% AUTEUR :
%   G2D
%
% DATE :
%   17 Avril 2026
%
% DESCRIPTION :
%   10 cas de test unitaires pour la fonction myDSPEstimation.
%   Vérifie les dimensions, valeurs, cas limites.
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
fprintf('=== Tests unitaires : myDSPEstimation ===\n\n');
nb_pass = 0; nb_fail = 0;

% --- Fonction utilitaire ---
    function assert_test(name, cond)
        if cond
            fprintf('  [PASS] %s\n', name);
        else
            fprintf('  [FAIL] %s\n', name);
        end
    end

% ---- TEST 1 : Signal sinusoïdal pur — pic au bon endroit ----
Fe = 1000; f0 = 100; N = 1000;
t = (0:N-1)/Fe;
x = sin(2*pi*f0*t);
[f, xfm, dsp_db] = myDSPEstimation(x, Fe, []);
[~, idx] = max(xfm);
cond = abs(f(idx) - f0) < Fe/N;
if cond, nb_pass=nb_pass+1; else, nb_fail=nb_fail+1; end
assert_test('T1 - Pic fréquentiel sinusoïde 100 Hz', cond);

% ---- TEST 2 : Dimensions de sortie correctes ----
cond = length(f) == floor(N/2)+1 && length(xfm) == floor(N/2)+1 && length(dsp_db) == floor(N/2)+1;
if cond, nb_pass=nb_pass+1; else, nb_fail=nb_fail+1; end
assert_test('T2 - Dimensions des sorties (N/2+1)', cond);

% ---- TEST 3 : Axe fréquentiel commence à 0 et finit à Fe/2 ----
cond = f(1) == 0 && abs(f(end) - Fe/2) < Fe/N;
if cond, nb_pass=nb_pass+1; else, nb_fail=nb_fail+1; end
assert_test('T3 - Axe f : 0 à Fe/2', cond);

% ---- TEST 4 : Signal nul — DSP très faible ----
x_zero = zeros(1, 512);
[~, ~, dsp_zero] = myDSPEstimation(x_zero, Fe, []);
cond = max(dsp_zero) < -200;
if cond, nb_pass=nb_pass+1; else, nb_fail=nb_fail+1; end
assert_test('T4 - Signal nul → DSP < -200 dB', cond);

% ---- TEST 5 : Signal constant — énergie concentrée en DC ----
x_dc = ones(1, 256) * 3;
[f5, xfm5, ~] = myDSPEstimation(x_dc, Fe, []);
cond = xfm5(1) > 0.9 * max(xfm5);
if cond, nb_pass=nb_pass+1; else, nb_fail=nb_fail+1; end
assert_test('T5 - Signal DC → pic en f=0', cond);

% ---- TEST 6 : Vecteur colonne en entrée ----
x_col = sin(2*pi*50*(0:511)/Fe)';
[f6, xfm6, dsp6] = myDSPEstimation(x_col, Fe, []);
cond = isrow(f6) && isrow(xfm6) && isrow(dsp6);
if cond, nb_pass=nb_pass+1; else, nb_fail=nb_fail+1; end
assert_test('T6 - Entrée colonne → sorties en ligne', cond);

% ---- TEST 7 : Deux sinusoïdes — deux pics ----
x2 = sin(2*pi*100*t) + sin(2*pi*300*t);
[f7, xfm7, ~] = myDSPEstimation(x2, Fe, []);
[pks, locs] = findpeaks(xfm7, 'MinPeakHeight', 0.5*max(xfm7));
freqs_pic = f7(locs);
cond = any(abs(freqs_pic - 100) < 5) && any(abs(freqs_pic - 300) < 5);
if cond, nb_pass=nb_pass+1; else, nb_fail=nb_fail+1; end
assert_test('T7 - Deux sinusoïdes → deux pics', cond);

% ---- TEST 8 : DSP en dB est bien 10*log10 du module² ----
[~, xfm8, dsp8] = myDSPEstimation(sin(2*pi*200*t), Fe, []);
expected = 10*log10(xfm8.^2 + eps);
cond = max(abs(dsp8 - expected)) < 1e-10;
if cond, nb_pass=nb_pass+1; else, nb_fail=nb_fail+1; end
assert_test('T8 - Cohérence dsp_db = 10*log10(xfm²)', cond);

% ---- TEST 9 : N impair ----
x_odd = sin(2*pi*100*(0:998)/Fe);
[f9, xfm9, ~] = myDSPEstimation(x_odd, Fe, []);
cond = length(f9) == floor(999/2)+1;
if cond, nb_pass=nb_pass+1; else, nb_fail=nb_fail+1; end
assert_test('T9 - N impair → dimensions correctes', cond);

% ---- TEST 10 : Fe différente — axe fréquentiel cohérent ----
Fe10 = 8000;
x10 = sin(2*pi*2000*(0:7999)/Fe10);
[f10, xfm10, ~] = myDSPEstimation(x10, Fe10, []);
[~, idx10] = max(xfm10);
cond = abs(f10(idx10) - 2000) < Fe10/length(x10);
if cond, nb_pass=nb_pass+1; else, nb_fail=nb_fail+1; end
assert_test('T10 - Fe=8kHz, sinusoïde 2kHz', cond);

% ---- BILAN ----
fprintf('\n=== Bilan : %d / %d tests passés ===\n', nb_pass, nb_pass+nb_fail);
