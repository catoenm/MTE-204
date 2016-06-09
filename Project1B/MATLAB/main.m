%*************************************************************************
% MTE 204: Numerical Methods       
% Header: Christopher Kohar, University of Waterloo, Spring 2016
%*************************************************************************

clc;
close all;
clear all;

% % % **********************************************
% % % THE CORE FINITE ELEMENT STEPS
% % % **********************************************
% % % 1)	Model discretization  How to break up the problem into smaller manageable problems
% % % 2)	Interpolation  How to represent behaviour between two points (in this case, we will start with linear assumptions)
% % % 3)	Element properties   Apply our physics and mathematical models of motion
% % % 4)	Element assembly How to take the small individual elements to construct the phenomenon we are trying to model
% % % 5)	Boundary conditions and constrains
% % % 6)	Solving   Solve our equations of motion to determine displacement, deformation, voltage, current, temperature, etc.
% % % 7)	Post processing


% % % **********************************************
% % % Configure Options
% % % **********************************************
  
% Options:
    % 1 - Implicit, no damping
    % 2 - Implicit, with damping
    % 3 - Explicit, no damping
    % 4 - Explicit, with damping
OPTION = 1;

% Constants for Implicit Formulation
BETA = 8/5;
GAMMA = 3/2;

% % % **********************************************
% % % Step One: Input Information, determine DOF, and initialize
% % % **********************************************

[NODES,SCTR,PROPS,LOAD_CURVE] = open_files(...
               'Input_Files/nodes_1',...
               'Input_Files/sctr_1',...
               'Input_Files/props_1',...
               'Input_Files/load_1_100ms.txt');
           
numNodes = size(NODES,1);
DOF = size(NODES, 2);
TIME = LOAD_CURVE(5,1) - LOAD_CURVE(4,1);
KGLOBAL = zeros(numNodes*DOF, numNodes*DOF);
CGLOBAL = zeros(numNodes*DOF, numNodes*DOF);
MGLOBAL = zeros(numNodes*DOF, numNodes*DOF);
[FIXED,FREE] = buildFixedFree(DOF, numNodes, LOAD_CURVE);

% % % *******************************************************
% % % Step Three: PROCESS MATERIAL INFORMATION
% % % ******************************************************* 
[AREA,YOUNG,DENSITY,DAMPING] = process_material_props(PROPS);

% % % ******************************************************
% % % Step Four: Matrix Assembly
% % % ******************************************************
[GPROPS]  = buildGPROPS (NODES,DOF,AREA,YOUNG,SCTR);
[KGLOBAL] = buildKGLOBAL(DOF,KGLOBAL,SCTR,GPROPS);
[CGLOBAL] = buildCGLOBAL(DAMPING,DOF,CGLOBAL,SCTR,GPROPS);
[MGLOBAL] = buildMGLOBAL(AREA,DENSITY,MGLOBAL,SCTR,GPROPS);

% Set initial acceleration, velocity and prev displacement to 0
UGLOBAL = zeros(numNodes*DOF,1);
UDOTGLOBAL = UGLOBAL;
UDDOTGLOBAL = UGLOBAL; 
PREVUGLOBAL = UGLOBAL;

% % % **********************************************************
% % % Step 6: Iterate to Solve for Displacements and Forces
% % % **********************************************************

for i = 1:(length(LOAD_CURVE) - 3)
    
    [NEXTUGLOBAL,NEXTFGLOBAL] = getBCs(numNodes, DOF, LOAD_CURVE, i);
    
    % Calculate next UGLOBAL and FGLOBAL
    [NEXTUGLOBAL,NEXTFGLOBAL] = solveMCKU( KGLOBAL, MGLOBAL, CGLOBAL,... 
             NEXTFGLOBAL, NEXTUGLOBAL, UGLOBAL, UDOTGLOBAL, UDDOTGLOBAL, PREVUGLOBAL,...
             FIXED, FREE, OPTION, TIME, BETA, GAMMA);
 

    % If implicit, update velocity and acceleration
    if OPTION <= 2
        [UDOTGLOBAL, UDDOTGLOBAL] = update_implicit(NEXTUGLOBAL, UGLOBAL, UDOTGLOBAL,...
            UDDOTGLOBAL, BETA, GAMMA, TIME);
    else
        PREVUGLOBAL = UGLOBAL;
    end
    UGLOBAL = NEXTUGLOBAL;
end
