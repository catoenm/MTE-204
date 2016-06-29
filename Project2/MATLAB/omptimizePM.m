 % ---------------------------------------------------------------------- %
%
% PROJECT 2 - omptimizePM.m
% 
% Group 16
% Authors: David Ferris, Devon Copeland
%
%
% ---------------------------------------------------------------------- %

clc;
clear all;
close all;

% ---------------------------------------------------------------------- %
% Nomenclature:
% ---------------------------------------------------------------------- %
% 
% Standard Units: 
%     - force: N
%     - stress/young's modulus : MPa
%     - displacement/length: mm
% 
% General Notes:
%     - Vectors contain values corresponding to an element are ordered based 
%       on the sctr matrix where the i'th the 2 nodes of the i'th element. 

% ---------------------------------------------------------------------- %
% Constants:
% ---------------------------------------------------------------------- %

DATAFOLDER = 'tacoma';

% trussRatio maps the applied load to the force in a given member
TRUSSRATIO = [ -0.7742;
                1.0606;
               -0.8809;
               -1.0057;
                0.9229 ];

% Young's modulus of balsawood (mPa): 
E = 2000;

% Density of balsawood (Kg/m^3)
DENSITY = 100;

% ---------------------------------------------------------------------- %
% Load data from text files:
% ---------------------------------------------------------------------- %

nodes = load(strcat(DATAFOLDER,'/nodes.txt'));
sctr = load(strcat(DATAFOLDER,'/sctr.txt'));

% ---------------------------------------------------------------------- %
% Calculate trivial values for future steps:
% ---------------------------------------------------------------------- %

% Calculate length based on pythagorean theorem         
length = sqrt((nodes(sctr(:, 1), 1) - nodes(sctr(:, 2), 1)).^2 ...
            + (nodes(sctr(:, 1), 2) - nodes(sctr(:, 2), 2)).^2);

% ---------------------------------------------------------------------- %
% Calculate PMs for an array of gemoetric constraints :
% ---------------------------------------------------------------------- %

% Calculate total mass of bridge 

mass = length.*area.*DENSITY;

% Calcualate load

pm = (5/6) .* load .* mass.^(1.2/(1.2*1.3));

% ---------------------------------------------------------------------- %
% Plot Data:
% ---------------------------------------------------------------------- %


