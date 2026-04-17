% #------------------------------------------
% NOM DU SCRIPT / FONCTION :
%   QuestionW4_A
%
% AUTEUR :
%   G2D
%
% DATE :
%   17 Avril 2026
%
% DESCRIPTION :
%   Données et questions de la semaine 4 — Partie A.
%   Génération et analyse du signal d'entrée.
%
% ENTREES :
%      Aucune (script autonome)
%
% SORTIES :
%      Variables dans le workspace MATLAB
%
% MODIFICATIONS :
%   Aucune
% #------------------------------------------

clear all
close all
clc

%% ----- Q1 - INPUT SIGNAL
% ----- Load signal
% [x,Fe] = audioread('RavelSi.wav');
[x,Fe] = audioread('GardeMontante.wav');

[N,c]   = size(x);
x       = -- to be completed ;          % Stereo -> mono
Te      = 1/Fe;
t       = (0:N-1)*Te;


% ---- Compute DSP 
[f,xfm,dsp_db] = myDSPEstimation(x,Fe,[]);

% ---- Display

fid = figure;
subplot(4,2,1);
plot(t,x);
grid on;
title 'Signal x - time domain'
xlabel 't (s)'
ylabel 'V'

subplot(4,2,2);
plot(f/1000,dsp_db);
grid on;
title 'Signal x - Fourier domain'
xlabel 'f (KHz)'
ylabel 'dB'
ax = axis();

% sound(x,Fe);

%% ---- Q2 - Interpolation without anti anliasing filter

Fe2     = 4000;
Te2     = -- to be completed;
t2      = 0:Te2:t(end);
xl2     = interp1(-- to be completed);
[f2,~,dsp2_db] = myDSPEstimation(xl2,Fe2,[]);

subplot(4,2,3);
plot(t2,xl2);
grid on;
title 'Signal x2 (decimation without filtering) - time domain'
xlabel 't2 (s)'
ylabel 'V'

subplot(4,2,4);
plot(f2/1000,dsp2_db);
ax2 = ax;ax2(2) = Fe2/1000;axis(ax2);
grid on;
title 'Signal x2 (decimation without filtering) - Fourier domain'
xlabel 'f (KHz)'
ylabel 'dB'

% sound(xl2,Fe2);

%% ---- Q3-4 - Interpolation with anti anliasing filter

% ----- Anti-aliasing filter
load 'xxx.mat'
xl3 = filter(-- to be completed);
[~,xfm3,dsp3_db] = myDSPEstimation(xl3,Fe,[]);

subplot(4,2,5);
plot(t,xl3);
grid on;
title 'Signal x3 (filtered signal) - time domain'
xlabel 't (s)'
ylabel 'V'

subplot(4,2,6);
plot(f/1000,dsp3_db);
grid on;
title 'Signal x3 (filtered signal) - Fourier domain'
xlabel 'f (KHz)'
ylabel 'dB'
axis(ax);

% sound(xl3,Fe);

% ---- Interpolation
xl4 = interp1(-- to be completed);
[~,~,dsp4_db] = myDSPEstimation(xl4,Fe2,[]);

subplot(4,2,7);
plot(t2,xl4);
grid on;
title 'Signal x4 (decimation with antialiasing filtering)- time domain'
xlabel 't2 (s)'
ylabel 'V'

subplot(4,2,8);
plot(f2/1000,dsp4_db);
axis(ax2);
grid on;
title 'Signal x4 (decimation with antialiasing filtering)- Fourier domain'
xlabel 'f (KHz)'
ylabel 'dB'

%%  ----  Listen 
% sound(x,Fe);
% sound(xl2,Fe2);
% sound(xl4,Fe2);
% sound(xl2,Fe2);

