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
               'Input_Files/nodes_2',...
               'Input_Files/sctr_2',...
               'Input_Files/props_2',...
               'Input_Files/load_2_1ms');
           
numNodes = size(NODES,1);
[DOF] = get_DOF(NODES);
TIME = LOAD_CURVE(5,1) - LOAD_CURVE(4,1);
[FREE,FIXED] = buildFixedFree(DOF, numNodes, LOAD_CURVE);
[KGLOBAL,FGLOBAL,UGLOBAL,MGLOBAL,CGLOBAL] = initialize_matrices(DOF,numNodes);

% % % *******************************************************
% % % Step Three: PROCESS MATERIAL INFORMATION
% % % ******************************************************* 
[AREA,YOUNG,DENSITY,DAMPING] = process_material_props(PROPS);

% % % ******************************************************
% % % Step Four: Matrix Assembly
% % % ******************************************************
[GPROPS]  = buildGPROPS (NODES,SCTR,DOF,AREA,YOUNG);
[KGLOBAL] = buildKGLOBAL(SCTR,DOF,KGLOBAL,GPROPS);
[CGLOBAL] = buildCGLOBAL(DAMPING,SCTR,DOF,CGLOBAL,GPROPS);
[MGLOBAL] = buildMGLOBAL(AREA,DENSITY,DOF,MGLOBAL,GPROPS);

% Set initial acceleration, velocity and prev displacement to 0
UDOTGLOBAL = zeros(numNodes*DOF,1);
UDDOTGLOBAL = UDOTGLOBAL; 
PREVUGLOBAL = UDOTGLOBAL;

% % % **********************************************************
% % % Step 6: Iterate to Solve for Displacements and Forces
% % % **********************************************************

for i = 1:(length(LOAD_CURVE) - 3)
    
    [UGLOBAL,FGLOBAL] = getBCs(numNodes, DOF, LOADCURVE, i);
    
    % Calculate next UGLOBAL and FGLOBAL
    [UGLOBAL,FGLOBAL] = solveMCKU( KGLOBAL, MGLOBAL, CGLOBAL,... 
             FGLOBAL, UGLOBAL, UDOTGLOBAL, UDDOTGLOBAL, PREVUGLOBAL,...
             FIXED, FREE, OPTION, TIME, BETA, GAMMA);
 

    % If implicit, update velocity and acceleration
    if OPTION <= 2
        [UDOTGLOBAL, UDDOTGLOBAL] = update_implicit(UGLOBAL, PREVUGLOBAL, PREVUDOTGLOBAL,...
            PREVUDDOTGLOBAL, BETA, GAMMA, TIME);
        PREVUDOTGLOBAL = UDOTGLOBAL;
        PREVUDDOTGLOBAL = UDDOTGLOBAL;
    end
    
    % Increment U matricies 
    UPREVGLOBAL = UGLOBAL;
end
