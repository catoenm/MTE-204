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

nodes = load(strcat(DATA_FOLDER,'/nodes.txt'));
SCTR = load(strcat(DATA_FOLDER,'/sctr.txt'));

% ---------------------------------------------------------------------- %
% Constants:
% ---------------------------------------------------------------------- %

% Range of values for driving dimention for which to calculate PM
DRIVING_DIM = 0:0.1:4; 

X = [10,50,100];

Y = [-50:1:100];

% Index of element for the driving dimention 
DRIVING_DIM_INDEX = 1; 

% trussRatio maps the applied load to the force in a given member
% trussRatio = [ -0.7742;
%                 1.0606;
%                -0.8809;
%                -1.0057;
%                 0.9229 ];

% Young's modulus of balsawood (MPa): 
E = 2000;

% Density of balsawood (g/mm^3)
DENSITY = 0.0001;

% Total mass of all pins in the bridge (g);
PINMASS = 6 * 0.4576; % 6 pins * 0.4576g/pin

% Ultimate tensile strength of balsa (MPa)
ULTIMATE_STRENGTH = 10;

numElements = size(SCTR,1);

% ---------------------------------------------------------------------- %
% Calculate PMs for an array of gemoetric constraints :
% ---------------------------------------------------------------------- %
for x = 1:size(X,2)
    nodes(4,1) = X(x);
    for y = 1:size(Y,2)
        nodes(2,2) = Y(y);
        nodes(4,2) = Y(y)-84.4097;

        trussRatio = getTrussRatio(nodes);

        % Calculate length based on pythagorean theorem         
        length = sqrt((nodes(SCTR(:, 1), 1) - nodes(SCTR(:, 2), 1)).^2 ...
                    + (nodes(SCTR(:, 1), 2) - nodes(SCTR(:, 2), 2)).^2);


        for a = 1:size(DRIVING_DIM,2)
            [criticalForces, appliedLoad] = getCriticalForces(DRIVING_DIM(a), DRIVING_DIM_INDEX,  E, length, ULTIMATE_STRENGTH, trussRatio); 

            drivingDimensions = zeros(numElements,1);
            areas = zeros(numElements,1);

            for e = 1:1:numElements
                [drivingDimensions(e), areas(e)] = getMemberDimension(criticalForces(e), E, length(e), ULTIMATE_STRENGTH);
            end

            % Calculate total mass of bridge 
            element_mass = length.*areas.*DENSITY; 
            total_mass = sum(element_mass)*2+PINMASS;
            total_applied_load_grams = 2*abs(appliedLoad)*1000/9.81;
            criticalLog(:,a) = criticalForces;
            % Calculate PM
            massLog(y,a) = total_mass;
            pm(y,a) = (5/6) * total_applied_load_grams /( total_mass^(1/1.3));
            yMatrix(y,a) = Y(1,y);
            ddMatrix(y,a) = DRIVING_DIM(1,a);
        end
    end
    figure;
    surfc(yMatrix,ddMatrix,pm);
    xlabel('Y Position of Node 2 (mm)');
    ylabel('Driving Dimention for Member #1 (mm)');
    title(strcat(sprintf('PM: X Position of Node #4 = %f', X(x)),' mm'));
    
    figure;
    surfc(yMatrix,ddMatrix,massLog);
    xlabel('Y Position of Node 2 (mm)');
    ylabel('Driving Dimention for Member #1 (mm)');
    title(strcat(sprintf('MASS: X Position of Node #4 = %f', X(x)),' mm'));
    
end

