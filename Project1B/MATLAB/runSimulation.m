%*************************************************************************
% MTE 204: Numerical Methods       
% Header: Christopher Kohar, University of Waterloo, Spring 2016
%*************************************************************************

function [NEXTUGLOBAL, NEXTFGLOBAL, UGLOBALCOMPLETE] = runSimulation(nodesFile, sctrFile, propsFile, loadCurveFile, OPTION)

    % % % **********************************************
    % % % Configure Options
    % % % **********************************************

    % Options:
        % 1 - Implicit, no damping
        % 2 - Implicit, with damping
        % 3 - Explicit, no damping
        % 4 - Explicit, with damping

    % Constants for Implicit Formulation
    BETA = 8/5;
    GAMMA = 3/2;

    % % % **********************************************
    % % % Input Information, determine DOF, and initialize
    % % % **********************************************

    [NODES,SCTR,PROPS,LOAD_CURVE] = open_files(nodesFile, sctrFile, propsFile,...
        loadCurveFile);

    numNodes = size(NODES,1);
    DOF = size(NODES, 2);
    TIME = LOAD_CURVE(5,1) - LOAD_CURVE(4,1);
    KGLOBAL = zeros(numNodes*DOF, numNodes*DOF);
    CGLOBAL = zeros(numNodes*DOF, numNodes*DOF);
    MGLOBAL = zeros(numNodes*DOF, numNodes*DOF);
    [FIXED,FREE] = buildFixedFree(DOF, numNodes, LOAD_CURVE);
    [AREA,YOUNG,DENSITY,DAMPING] = process_material_props(PROPS);

    % % % ******************************************************
    % % % Matrix Assembly
    % % % ******************************************************
    [GPROPS]  = buildGPROPS (NODES,DOF,AREA,YOUNG,SCTR);
    [KGLOBAL] = buildKGLOBAL(DOF,KGLOBAL,SCTR,GPROPS);
    [CGLOBAL] = buildCGLOBAL(DAMPING,DOF,CGLOBAL,SCTR,GPROPS);
    [MGLOBAL] = buildMGLOBAL(AREA,DENSITY,MGLOBAL,SCTR,GPROPS);

    % % % ******************************************************
    % Set initial acceleration, velocity and prev displacement to 0
    % % % ******************************************************
    UGLOBAL = zeros(numNodes*DOF,1);
    UDOTGLOBAL = UGLOBAL;
    UDDOTGLOBAL = UGLOBAL; 
    PREVUGLOBAL = UGLOBAL;

    % % % **********************************************************
    % % % Iterate to Solve for Displacements and Forces
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
        UGLOBALCOMPLETE(:,i) = UGLOBAL;
    end

end