function trussRatio = getTrussRatio(NODES)
    bridgeID = 'tacoma';
    [UNUSED,SCTR,PROPS,NODAL_BCS,NODAL_FORCES, MOI] = open_files(...
                   strcat(bridgeID,'/nodes.txt'),...
                   strcat(bridgeID,'/sctr.txt'),...
                   strcat(bridgeID,'/props.txt'),...
                   strcat(bridgeID,'/nodeBCs.txt'),...
                   strcat(bridgeID, '/nodeFORCES.txt'),...
                   strcat(bridgeID, '/moi.txt'));

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
    [STRESS,FORCES] = getSTRESS(SCTR,NODES,YOUNG,DOF,UGLOBAL,AREA);
    trussRatio = FORCES./abs(NODAL_FORCES(1,3));
end