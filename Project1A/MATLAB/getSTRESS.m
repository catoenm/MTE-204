function [STRESS] = getSTRESS(SCTR,NODES,YOUNG,DOF,UGLOBAL)

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
    STRESS = ((new_length - initial_length)./initial_length).*YOUNG;

end