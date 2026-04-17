% #------------------------------------------
% NOM DU SCRIPT / FONCTION :
%   test_myDecimation
%
% AUTEUR :
%   G2D
%
% DATE :
%   17 Avril 2026
%
% DESCRIPTION :
%   10 cas de test unitaires pour la fonction myDecimation.
%   Vérifie la décimation avec et sans filtre.
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
fprintf('=== Tests unitaires : myDecimation ===\n\n');
nb_pass = 0; nb_fail = 0;

    function assert_test(name, cond)
        if cond
            fprintf('  [PASS] %s\n', name);
        else
            fprintf('  [FAIL] %s\n', name);
        end
    end

Fe = 44100; Fe2 = 4000;
N = 44100;  % 1 seconde
t = (0:N-1)/Fe;

% ---- TEST 1 : Sortie non vide (sans filtre) ----
x = sin(2*pi*100*t);
[y, t2] = myDecimation(x, Fe, Fe2, []);
cond = ~isempty(y) && ~isempty(t2);
if cond, nb_pass=nb_pass+1; else, nb_fail=nb_fail+1; end
assert_test('T1 - Sortie non vide (sans filtre)', cond);

% ---- TEST 2 : Longueur cohérente avec Fe2 ----
expected_len = floor(t(end) * Fe2) + 1;
cond = abs(length(y) - expected_len) <= 1;
if cond, nb_pass=nb_pass+1; else, nb_fail=nb_fail+1; end
assert_test('T2 - Longueur ≈ durée × Fe2', cond);

% ---- TEST 3 : Pas temporel correct ----
dt2 = diff(t2);
cond = max(abs(dt2 - 1/Fe2)) < 1e-12;
if cond, nb_pass=nb_pass+1; else, nb_fail=nb_fail+1; end
assert_test('T3 - Pas temporel = 1/Fe2', cond);

% ---- TEST 4 : Signal DC préservé ----
x_dc = ones(1, N) * 5;
[y_dc, ~] = myDecimation(x_dc, Fe, Fe2, []);
cond = max(abs(y_dc - 5)) < 1e-10;
if cond, nb_pass=nb_pass+1; else, nb_fail=nb_fail+1; end
assert_test('T4 - Signal DC=5 préservé', cond);

% ---- TEST 5 : Sortie non vide (avec filtre) ----
[h, ~] = myKaiserFilter(Fe, 1800, 2000, 40);
[y_f, ~] = myDecimation(x, Fe, Fe2, h);
cond = ~isempty(y_f);
if cond, nb_pass=nb_pass+1; else, nb_fail=nb_fail+1; end
assert_test('T5 - Sortie non vide (avec filtre)', cond);

% ---- TEST 6 : Filtre atténue les hautes fréquences ----
x_hf = sin(2*pi*100*t) + sin(2*pi*3000*t);
[y_nf, ~] = myDecimation(x_hf, Fe, Fe2, []);
[y_wf, ~] = myDecimation(x_hf, Fe, Fe2, h);
energy_nf = sum(y_nf.^2);
energy_wf = sum(y_wf.^2);
cond = energy_wf < energy_nf;
if cond, nb_pass=nb_pass+1; else, nb_fail=nb_fail+1; end
assert_test('T6 - Filtrage réduit l''énergie (HF supprimées)', cond);

% ---- TEST 7 : t2 commence à 0 ----
cond = t2(1) == 0;
if cond, nb_pass=nb_pass+1; else, nb_fail=nb_fail+1; end
assert_test('T7 - t2 commence à 0', cond);

% ---- TEST 8 : t2 finit ≈ t(end) ----
cond = abs(t2(end) - t(end)) < 1/Fe2;
if cond, nb_pass=nb_pass+1; else, nb_fail=nb_fail+1; end
assert_test('T8 - t2 finit ≈ durée du signal', cond);

% ---- TEST 9 : Fe2 > Fe → plus d'échantillons (suréchantillonnage) ----
[y_up, t2_up] = myDecimation(x, Fe, 88200, []);
cond = length(y_up) > N;
if cond, nb_pass=nb_pass+1; else, nb_fail=nb_fail+1; end
assert_test('T9 - Fe2=88200 → suréchantillonnage OK', cond);

% ---- TEST 10 : Signal nul reste nul ----
x_z = zeros(1, N);
[y_z, ~] = myDecimation(x_z, Fe, Fe2, []);
cond = max(abs(y_z)) < 1e-15;
if cond, nb_pass=nb_pass+1; else, nb_fail=nb_fail+1; end
assert_test('T10 - Signal nul → sortie nulle', cond);

% ---- BILAN ----
fprintf('\n=== Bilan : %d / %d tests passés ===\n', nb_pass, nb_pass+nb_fail);
