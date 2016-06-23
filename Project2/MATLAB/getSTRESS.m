function [STRESS, FORCES] = getSTRESS(SCTR,NODES,YOUNG,DOF,UGLOBAL,AREA)

    % % % This function returns the stress in a spring/bar element
    % % % This function receives the elemental connectivity matrix, nodal
    % % % locations, elastic modulus, degree of freedom, and solved global
    % % % displacements vector.

    % % % This function returns an array/vector that contains the elemental
    % % % stress information for each element.
    
    % Create matrix to contain the position of the nodes at equilibrium
    NEWNODES = zeros(size(NODES));
    for i = 1:size(NODES,1)
        for j = 1:DOF
            NEWNODES(i,j) = NODES(i,j) + UGLOBAL(DOF*(i-1)+j);
        end
    end
    
    % Create vectors to contain the initial length of each node and the 
    % length at equilibrium
    initial_length = zeros(size(SCTR,1));
    new_length = zeros(size(SCTR,1));
    
    % Calculate lengths
    initial_sum_of_squares = 0;
    for i = 1:DOF
        initial_sum_of_squares = initial_sum_of_squares + (NODES(SCTR(:,1),i)-NODES(SCTR(:,2),i)).^2;
    end
    initial_length = sqrt(initial_sum_of_squares);

    final_sum_of_squares = 0;
    for i = 1:DOF
        final_sum_of_squares = final_sum_of_squares + (NEWNODES(SCTR(:,1),i)-NEWNODES(SCTR(:,2),i)).^2;
    end
    new_length = sqrt(final_sum_of_squares);
    
    % Calculate stress
    STRESS = -1*((new_length - initial_length)./initial_length).*YOUNG;
    
    % Calculate forces and stress from transfer matrix
    for i = 1:size(SCTR,1)
        index1 = SCTR(i, 1); % index of 1st node 
        index2 = SCTR(i, 2); % index of 2nd node
        delx = NODES(index1, 1) - NODES(index2, 1); % get x delta
        dely = NODES(index1, 2) - NODES(index2, 2); % get y delta
        angle  = atan2(dely,delx); % calculate angle
        length = sqrt((delx)^2 + (dely)^2); % calculate pythagorean length
        a = cos(angle); % a is the consine of the angle 
        b = sin(angle); % b " " sine
        stiffness = YOUNG(i,1) * AREA(i,1) / length;
        KLOCAL = zeros(DOF*2,DOF*2);
        KLOCAL(1,1) = stiffness;
        KLOCAL(1,1+DOF) = -1*stiffness;
        KLOCAL(1+DOF,1) = -1*stiffness;
        KLOCAL(1+DOF,1+DOF) = stiffness;

        TRANSF = [ a,  b,  0,  0;
                  -b,  a,  0,  0;
                   0,  0,  a,  b;
                   0,  0, -b,  a];
               
       ULOCAL = [UGLOBAL( SCTR(i,1)*DOF-1 : SCTR(i,1)*DOF ); 
                 UGLOBAL( SCTR(i,2)*DOF-1 : SCTR(i,2)*DOF )];
       
       TEMPFORCE = KLOCAL*TRANSF*ULOCAL;
       FORCES(i,1) = TEMPFORCE(1);
    end
    
    STRESS = FORCES./AREA;

end