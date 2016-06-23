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
% % % Step One: Input Information, determine DOF, and initialize
% % % **********************************************
% [NODES,SCTR,PROPS,NODAL_BCS,NODAL_FORCES] = open_files(...
%                'question1Input/nodes1.txt',...
%                'question1Input/sctr1.txt',...
%                'question1Input/props1.txt',...
%                'question1Input/nodeBCs1.txt',...
%                'question1Input/nodeFORCES1.txt');

[NODES,SCTR,PROPS,NODAL_BCS,NODAL_FORCES] = open_files(...
               'question2Input/nodes2.txt',...
               'question2Input/sctr2.txt',...
               'question2Input/props2.txt',...
               'question2Input/nodeBCs2.txt',...
               'question2Input/nodeFORCES2.txt');

[DOF] = get_DOF(NODES);
[KGLOBAL,FGLOBAL,UGLOBAL] = initialize_matrices(DOF,size(NODES,1));

% % % *******************************************************
% % % Step Three: PROCESS MATERIAL INFORMATION
% % % ******************************************************* 
[AREA, YOUNG] = process_material_props(PROPS);

% % % ******************************************************
% % % Step Four: Matrix Assembly
% % % ******************************************************
[KGLOBAL] = buildKGLOBAL(NODES,SCTR,DOF,YOUNG,AREA,KGLOBAL);

% % % ******************************************************
% % % Step Five: Boundary Conditions
% % % ******************************************************
[UGLOBAL,FIXED] = buildNODEBCs(UGLOBAL,NODAL_BCS,DOF);
[FGLOBAL,FREE] = buildFORCEBCs(FGLOBAL,NODAL_FORCES,FIXED,DOF,size(KGLOBAL,1));

% % % **********************************************************
% % % Step 6: Solve for Displacements and Forces
% % % **********************************************************
[UGLOBAL,FGLOBAL] = solveKU(KGLOBAL,FGLOBAL,UGLOBAL,FIXED,FREE);

% % % **********************************************************
% % % Step 7: Post Processing
% % % **********************************************************   
[STRESS] = getSTRESS(SCTR,NODES,YOUNG,DOF,UGLOBAL, KGLOBAL, );
writedataout('projectSOLUTIONS_1b.txt',NODES,SCTR,DOF,UGLOBAL,FGLOBAL,STRESS)







