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
% Load data from text files:
% ---------------------------------------------------------------------- %

DATA_FOLDER = 'tacoma';

NODES = load(strcat(DATA_FOLDER,'/nodes.txt'));
SCTR = load(strcat(DATA_FOLDER,'/sctr.txt'));

% ---------------------------------------------------------------------- %
% Constants:
% ---------------------------------------------------------------------- %

% Range of values for driving dimention for which to calculate PM
DRIVING_DIM = 1 %0.5:0.1:5; 

% Index of element for the driving dimention 
DRIVING_DIM_INDEX = 1; 

% trussRatio maps the applied load to the force in a given member
TRUSS_RATIO = [ -0.7742;
                1.0606;
               -0.8809;
               -1.0057;
                0.9229 ];

% Young's modulus of balsawood (MPa): 
E = 2000;

% Density of balsawood (g/mm^3)
DENSITY = 0.0001;

% Total mass of all pins in the bridge (g);
PINMASS = 6 * 0.4576; % 6 pins * 0.4576g/pin

% Ultimate tensile strength of balsa (MPa)
ULTIMATE_STRENGTH = 0.4;

% Calculate length based on pythagorean theorem         
length = sqrt((NODES(SCTR(:, 1), 1) - NODES(SCTR(:, 2), 1)).^2 ...
            + (NODES(SCTR(:, 1), 2) - NODES(SCTR(:, 2), 2)).^2);

numElements = size(SCTR,1);

% ---------------------------------------------------------------------- %
% Calculate PMs for an array of gemoetric constraints :
% ---------------------------------------------------------------------- %

[criticalForces, appliedLoad] = getCriticalForces(DRIVING_DIM, DRIVING_DIM_INDEX,  E, length, ULTIMATE_STRENGTH, TRUSS_RATIO); 

drivingDimensions = zeros(numElements,1);
areas = zeros(numElements,1);

for x = 1:1:numElements
    [drivingDimensions(x), areas(x)] = getMemberDimension(criticalForces(x), E, length(x), ULTIMATE_STRENGTH);
end

% Calculate total mass of bridge 
mass = length.*areas.*DENSITY + PINMASS;

% Calculate PM
pm = (5/6) * abs(appliedLoad)*1000/9.81 * sum(mass)^(1.2/(1.2*1.3));

% ---------------------------------------------------------------------- %
% Plot Data:
% ---------------------------------------------------------------------- %


