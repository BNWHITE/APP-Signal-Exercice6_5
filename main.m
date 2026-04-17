% #------------------------------------------
% NOM DU SCRIPT / FONCTION :
%   main
%
% AUTEUR :
%   G2D
%
% DATE :
%   17 Avril 2026
%
% DESCRIPTION :
%   Script principal — lance l'exercice 6.5 sur le
%   sous-echantillonnage et le filtre anti-repliement.
%
% ENTREES :
%      Aucune (script autonome)
%
% SORTIES :
%      Aucune (affichages graphiques + sauvegarde .mat)
%
% MODIFICATIONS :
%   Aucune
% #------------------------------------------

clear all; close all;
clc;

% Ajouter les sous-dossiers au path MATLAB
rootDir = fileparts(mfilename('fullpath'));
addpath(fullfile(rootDir, 'fonctions'));
addpath(fullfile(rootDir, 'scripts'));
addpath(fullfile(rootDir, 'data'));
addpath(fullfile(rootDir, 'tests'));

% Lancer l'exercice
exercice_6_5;
