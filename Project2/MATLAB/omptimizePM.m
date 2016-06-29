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

% Young's modulus of balsawood (MPa): 
E = 2000;

% Density of balsawood (kg/m^3)
DENSITY = 100;

% Total mass of all pins in the bridge;
PINMASS = 6 * massperpin;

% Ultimate tensile strength of balsa (MPa)
ULTIMATE_STRENGTH = 0.4;

% ---------------------------------------------------------------------- %
% Load data from text files:
% ---------------------------------------------------------------------- %

NODES = load(strcat(DATAFOLDER,'/nodes.txt'));
SCTR = load(strcat(DATAFOLDER,'/sctr.txt'));

% ---------------------------------------------------------------------- %
% Calculate trivial values for future steps:
% ---------------------------------------------------------------------- %

% Calculate length based on pythagorean theorem         
length = sqrt((NODES(SCTR(:, 1), 1) - NODES(SCTR(:, 2), 1)).^2 ...
            + (NODES(SCTR(:, 1), 2) - NODES(SCTR(:, 2), 2)).^2);

% ---------------------------------------------------------------------- %
% Calculate PMs for an array of gemoetric constraints :
% ---------------------------------------------------------------------- %
numElements = size(SCTR,1);
a = 1; % initial guess
sctrIndex = 1; %TODO: fix this
[criticalForces, appliedLoad] = getCriticalForces(a, sctrIndex, SCTR, TRUSSRATIO); 

drivingDimensions = zeros(numElements);

for x = 1:1:numElements
    drivingDimensions(x) = getMemberDimension(criticalForces(x), E, ULTIMATE_STRENGTH);
end

% Calculate area of each member

% Calculate total mass of bridge 
mass = length.*area.*DENSITY + PINMASS;

% Calculate PM
pm = (5/6) * appliedLoad .* mass.^(1.2/(1.2*1.3));

% ---------------------------------------------------------------------- %
% Plot Data:
% ---------------------------------------------------------------------- %


