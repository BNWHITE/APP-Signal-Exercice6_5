% #------------------------------------------
% NOM DU SCRIPT / FONCTION :
%   exercice_6_5
%
% AUTEUR :
%   G2D
%
% DATE :
%   17 Avril 2026
%
% DESCRIPTION :
%   Exercice 6.5 — Sous-échantillonnage et filtre
%   anti-repliement. Analyse spectrale, repliement,
%   conception d'un filtre FIR par fenêtre de Kaiser.
%
% ENTREES :
%      Aucune (script, charge les données en interne)
%
% SORTIES :
%      Aucune (figures + filtre_anti_repliement.mat)
%
% MODIFICATIONS :
%   Aucune
% #------------------------------------------

clear all; close all; clc;

%% ----- Q1 - CHARGEMENT ET AFFICHAGE DU SIGNAL ----------------------
% Charger le signal audio (choisir l'un ou l'autre)
% [x, Fe] = audioread('RavelSi.wav');
[x, Fe] = audioread('GardeMontante.wav');

[N, c] = size(x);
x      = mean(x, 2);          % Stereo -> mono (moyenne des canaux)
Te     = 1 / Fe;
t      = (0:N-1) * Te;

% Calcul de la DSP
[f, xfm, dsp_db] = myDSPEstimation(x, Fe, []);

% Affichage
fid = figure('Name', 'Exercice 6.5 - Sous-échantillonnage', 'Position', [50 50 1200 800]);

subplot(4,2,1);
plot(t, x);
grid on;
title('Signal x - domaine temporel');
xlabel('t (s)'); ylabel('V');

subplot(4,2,2);
plot(f/1000, dsp_db);
grid on;
title('Signal x - domaine fréquentiel');
xlabel('f (kHz)'); ylabel('dB');
ax = axis();

% sound(x, Fe);  % Décommenter pour écouter le signal original

%% ----- Q2 - DECIMATION SANS FILTRE ANTI-REPLIEMENT -----------------
% Nouvelle fréquence d'échantillonnage
Fe2 = 4000;                        % Fe' = 4 kHz
Te2 = 1 / Fe2;                     % Nouvelle période d'échantillonnage
t2  = 0 : Te2 : t(end);           % Nouveau vecteur temps

% Interpolation (= rééchantillonnage) directe sans filtrage
xl2 = interp1(t, x, t2, 'linear');

% DSP du signal décimé
[f2, ~, dsp2_db] = myDSPEstimation(xl2, Fe2, []);

subplot(4,2,3);
plot(t2, xl2);
grid on;
title('Signal x2 (décimation SANS filtrage) - temps');
xlabel('t2 (s)'); ylabel('V');

subplot(4,2,4);
plot(f2/1000, dsp2_db);
ax2 = ax; ax2(2) = Fe2/2000; axis(ax2);
grid on;
title('Signal x2 (décimation SANS filtrage) - fréquence');
xlabel('f (kHz)'); ylabel('dB');

% sound(xl2, Fe2);  % Décommenter pour écouter → on entend du repliement

%% ----- Q3 - CONCEPTION DU FILTRE ANTI-REPLIEMENT -------------------
% Paramètres du gabarit :
%   - Type          : passe-bas (FIR Equiripple, ordre minimum)
%   - Fs            : 44100 Hz  (fréquence du signal à filtrer)
%   - Fpass         : 2000 Hz   (Fe'/2 = 2000 Hz, on garde le contenu utile)
%   - Fstop         : Fe' - Fpass = 2000 Hz → un peu au-dessus → 2100 Hz
%                     (pour éviter le repliement au-delà de Fe'/2)
%   - Astop         : 40 dB     (SNR requis > 40 dB)
%   - Apass         : 0.1 dB    (ondulation en bande passante, δ1 ≈ δ2)
%
% ---- Méthode 1 : via Filter Designer (interface graphique)
%   >> filterDesigner
%   Configurer le gabarit comme indiqué ci-dessus, puis exporter
%   les coefficients dans un fichier .mat (ex: filtre_anti_repliement.mat)
%
% ---- Méthode 2 : conception programmatique (firpm / firls / fir1)
%   On utilise ici firpm (Parks-McClellan = equiripple) :

Fpass = 1800;    % fréquence de fin de bande passante (Hz)
Fstop = 2000;    % fréquence de début de bande atténuée (Hz)
Astop = 40;      % atténuation en bande coupée (dB)
Apass = 0.1;     % ondulation en bande passante (dB)

% Conception du filtre FIR par méthode de fenêtrage (sinc + Kaiser)
% (ne nécessite PAS la Signal Processing Toolbox)

delta_s = 10^(-Astop/20);                         % déviation en bande coupée
fc      = (Fpass + Fstop) / 2 / Fe;               % fréquence de coupure normalisée

% Estimation de l'ordre via la formule de Kaiser
df    = (Fstop - Fpass) / Fe;                      % bande de transition normalisée
A     = Astop;                                     % atténuation souhaitée (dB)
if A > 50
    beta = 0.1102 * (A - 8.7);
elseif A >= 21
    beta = 0.5842 * (A - 21)^0.4 + 0.07886 * (A - 21);
else
    beta = 0;
end
Nfilt = ceil((A - 7.95) / (2.285 * 2 * pi * df));
if mod(Nfilt, 2) == 1
    Nfilt = Nfilt + 1;                             % ordre pair pour Type I
end
fprintf('Ordre du filtre estimé : %d\n', Nfilt);

% Fenêtre de Kaiser (implémentation manuelle)
n_kaiser = (0:Nfilt)' - Nfilt/2;
% Fonction de Bessel I0 approchée par série
besseli0 = @(x) sum(((x/2).^(0:20) ./ factorial(0:20)).^2);
w_kaiser = arrayfun(@(n) besseli0(beta * sqrt(1 - (2*n/Nfilt)^2)) / besseli0(beta), (0:Nfilt)');

% Réponse impulsionnelle idéale (sinc) fenêtrée
arg_sinc = 2 * fc * n_kaiser;
h_ideal  = 2 * fc * sin(pi * arg_sinc) ./ (pi * arg_sinc);
h_ideal(arg_sinc == 0) = 2 * fc;                         % sinc(0) = 1
h       = (h_ideal .* w_kaiser)';                   % filtre FIR fenêtré
h       = h / sum(h);                               % normalisation (gain = 1 en DC)

% Sauvegarde des coefficients (compatible avec le template original)
save('filtre_anti_repliement.mat', 'h');
fprintf('Coefficients du filtre sauvegardés dans filtre_anti_repliement.mat\n');

% Vérification : réponse en fréquence du filtre (sans freqz)
figure('Name', 'Réponse en fréquence du filtre anti-repliement');
Nfft_resp = 4096;
f_resp    = (0:Nfft_resp-1) * Fe / Nfft_resp;
H_resp    = fft(h, Nfft_resp);
f_resp    = f_resp(1:Nfft_resp/2+1);
H_resp    = H_resp(1:Nfft_resp/2+1);

subplot(2,1,1);
plot(f_resp/1000, 20*log10(abs(H_resp) + eps));
grid on;
title('Réponse en fréquence du filtre anti-repliement');
xlabel('f (kHz)'); ylabel('|H(f)| (dB)');
yline(-Astop, 'r--', sprintf('-%d dB', Astop));
xline(Fpass/1000, 'g--', 'Fpass'); xline(Fstop/1000, 'r--', 'Fstop');

subplot(2,1,2);
plot(f_resp/1000, unwrap(angle(H_resp))*180/pi);
grid on;
xlabel('f (kHz)'); ylabel('Phase (°)');
title('Phase du filtre');

%% ----- Q4 - FILTRAGE DU SIGNAL ------------------------------------
% Charger les coefficients (si conçus via Filter Designer) :
% load('filtre_anti_repliement.mat');   % charge le vecteur h

xl3 = filter(h, 1, x);                  % filtrage FIR : y = h * x

[~, xfm3, dsp3_db] = myDSPEstimation(xl3, Fe, []);

figure(fid);  % revenir à la figure principale
subplot(4,2,5);
plot(t, xl3);
grid on;
title('Signal x3 (filtré, avant décimation) - temps');
xlabel('t (s)'); ylabel('V');

subplot(4,2,6);
plot(f/1000, dsp3_db);
grid on;
title('Signal x3 (filtré, avant décimation) - fréquence');
xlabel('f (kHz)'); ylabel('dB');
axis(ax);

% sound(xl3, Fe);  % Décommenter pour écouter le signal filtré

%% ----- Q5 - DECIMATION DU SIGNAL FILTRE ----------------------------
xl4 = interp1(t, xl3, t2, 'linear');    % rééchantillonnage à Fe2

[~, ~, dsp4_db] = myDSPEstimation(xl4, Fe2, []);

subplot(4,2,7);
plot(t2, xl4);
grid on;
title('Signal x4 (décimation AVEC filtre anti-repliement) - temps');
xlabel('t2 (s)'); ylabel('V');

subplot(4,2,8);
plot(f2/1000, dsp4_db);
axis(ax2);
grid on;
title('Signal x4 (décimation AVEC filtre anti-repliement) - fréquence');
xlabel('f (kHz)'); ylabel('dB');

%% ----- ECOUTE COMPARATIVE -------------------------------------------
fprintf('\n=== Écoute comparative ===\n');
fprintf('Décommentez les lignes sound() pour comparer :\n');
fprintf('  1. Signal original (Fe = %d Hz)\n', Fe);
fprintf('  2. Signal décimé SANS filtre (Fe2 = %d Hz) → repliement audible\n', Fe2);
fprintf('  3. Signal décimé AVEC filtre (Fe2 = %d Hz) → qualité préservée\n', Fe2);

% sound(x,   Fe);   pause(length(x)/Fe + 1);
% sound(xl2, Fe2);  pause(length(xl2)/Fe2 + 1);
% sound(xl4, Fe2);
