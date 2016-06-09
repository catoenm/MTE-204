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

[NODES,SCTR,PROPS,NODAL_BCS,NODAL_FORCES,LOAD_CURVE] = open_files(...
               'question2Input/nodes2.txt',...
               'question2Input/sctr2.txt',...
               'question2Input/props2.txt',...
               'question2Input/nodeBCs2.txt',...
               'question2Input/nodeFORCES2.txt',...
               'question2Input/loadCURVE2.txt');

[DOF] = get_DOF(NODES);
[KGLOBAL,FGLOBAL,UGLOBAL,MGLOBAL,CGLOBAL] = initialize_matrices(DOF,size(NODES,1));

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
    
% % % ******************************************************
% % % Step Five: Boundary Conditions
% % % ******************************************************
[UGLOBAL,FIXED] = buildNODEBCs(UGLOBAL,NODAL_BCS,DOF);

% % % **********************************************************
% % % Step 6: Iterate to Solve for Displacements and Forces
% % % **********************************************************

for i = 1:length(LOAD_CURVE)

    % Update FGLOBAL based on load curve
    CURR_LOAD = LOAD_CURVE(i,:);
    [FGLOBAL,FREE] = buildFORCEBCs(FGLOBAL,NODAL_FORCES,CURR_LOAD,DOF,size(KGLOBAL,1));
    
    % Calculate next UGLOBAL and FGLOBAL
    [UGLOBAL,FGLOBAL] = solveMCKU( KGLOBAL, MGLOBAL, CGLOBAL,... 
             FGLOBAL, UGLOBAL, UDOTGLOBAL, UDDOTGLOBAL, PREVUGLOBAL,...
             FIXED, FREE, OPTION, TIME, BETA, GAMMA);

    % Incrament U matricies 
    UPREVGLOBAL = UGLOBAL;
    % If implicit, update velocity and acceleration
    if OPTION > 2
        [UGLOBAL, UDOTGLOBAL, UDDOTGLOBAL] = update_implicit(UGLOBAL, PREVUGLOBAL, PREVUDOTGLOBAL,...
            PREVUDDOTGLOBAL, BETA, GAMMA, TIME);
        PREVUDOTGLOBAL = UDOTGLOBAL;
        PREVUDDOTGLOBAL = UDDOTGLOBAL;
    end

end

% % % **********************************************************
% % % Step 7: Post Processing
% % % **********************************************************   
[STRESS] = getSTRESS(SCTR,NODES,YOUNG,DOF,UGLOBAL);
writedataout('projectSOLUTIONS_1b.txt',NODES,SCTR,DOF,UGLOBAL,FGLOBAL,STRESS)
