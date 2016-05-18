function [STRESS] = getSTRESS(SCTR,NODES,YOUNG,DOF,UGLOBAL)

    % % % This function returns the stress in a spring/bar element
    % % % This function receives the elemental connectivity matrix, nodal
    % % % locations, elastic modulus, degree of freedom, and solved global
    % % % displacements vector.

    % % % This function returns an array/vector that contains the elemental
    % % % stress information for each element.
    
    % Create matrix to containt the position of the nodes at equilibrium
    NEWNODES = zeros(size(NODES));
    for i = 1:size(NODES,1)
        NEWNODES(i,1) = NODES(i,1) + UGLOBAL(2*i-1);
        NEWNODES(i,2) = NODES(i,2) + UGLOBAL(2*i);
    end
    
    % Create vectors to contain the initial length of each node and the 
    % length at equilibrium
    initial_length = zeros(size(SCTR,1));
    new_length = zeros(size(SCTR,1));
    
    % Calculate lengths
    
    initial_length = sqrt( (NODES(SCTR(:,1),1)-NODES(SCTR(:,2),1)).^2 + ...
                           (NODES(SCTR(:,1),2)-NODES(SCTR(:,2),2)).^2 ...
                         );

    new_length = sqrt( (NEWNODES(SCTR(:,1),1)-NEWNODES(SCTR(:,2),1)).^2 + ...
                       (NEWNODES(SCTR(:,1),2)-NEWNODES(SCTR(:,2),2)).^2 ...
                     );
    
    % Calculate stress
    STRESS = ((new_length - initial_length)./initial_length).*YOUNG;

end