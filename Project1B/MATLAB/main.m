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
option = 1;

% Constants for Implicit Formulation
beta = 8/5;
gamma = 3/2;

% % % **********************************************
% % % Step One: Input Information, determine DOF, and initialize
% % % **********************************************

[nodes,sctr,props,load_curve] = open_files(...
               'question2Input/nodes.txt',...
               'question2Input/sctr.txt',...
               'question2Input/props.txt',...
               'question2Input/loadCurve.txt');

[dof] = get_DOF(nodes);
[kGlobal,fGlobal,uGlobal,mGlobal,cGlobal] = initialize_matrices(dof,size(nodes,1));
[free, fixed] = build_fixed_free(load_curve);
time = load_curve(5,1) - load_curve(4,1);

% % % *******************************************************
% % % Step Three: PROCESS MATERIAL INFORMATION
% % % ******************************************************* 
[area,young,damping,mass] = process_material_props(props);

% % % ******************************************************
% % % Step Four: Matrix Assembly
% % % ******************************************************
[globalProps]  = buildGlobalProps (nodes,sctr,dof,area,young);
[kGlobal] = buildKGlobal(sctr,dof,kGlobal,globalProps);
[cGlobal] = buildCGlobal(damping,sctr,dof,cGlobal,globalProps);
[mGlobal] = buildMGlobal(mass,dof,mGlobal);

% % % **********************************************************
% % % Step 6: Iterate to Solve for Displacements and Forces
% % % **********************************************************

for (i = 1:length(load_curve))

    % Update FGLOBAL or UGLOBAl based on load curve
    
    
    % Calculate next UGLOBAL and FGLOBAL
    [uGlobal,fGlobal] = solveMCKU( kGlobal, mGlobal, cGlobal,... 
             fGlobal, uGlobal, uDotGlobal , uDDotGlobal, prevUglobal,...
             fixed, free, option, time, beta, gamma);

    % Incrament U matricies 
    prevUglobal = uGlobal;
    % If implicit, update velocity and acceleration
    if option <= 2
        [uGlobal, uDotGlobal, uDDotGlobal] = update_implicit(uGlobal, prevUglobal, prevUDotGlobal,...
            prevUDDotGlobal, beta, gamma, time);
        prevUDotGlobal = uDotGlobal;
        prevUDDotGlobal = uDDotGlobal;
    end

end

% % % **********************************************************
% % % Step 7: Post Processing
% % % **********************************************************   
[stress] = getSTRESS(sctr,nodes,young,dof,uGlobal);

