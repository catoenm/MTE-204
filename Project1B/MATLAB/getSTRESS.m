function [stress] = getStress(sctr,nodes,young,dof,uGlobal)

    % % % This function returns the stress in a spring/bar element
    % % % This function receives the elemental connectivity matrix, nodal
    % % % locations, elastic modulus, degree of freedom, and solved global
    % % % displacements vector.

    % % % This function returns an array/vector that contains the elemental
    % % % stress information for each element.
    
    % Create matrix to contain the position of the nodes at equilibrium
    newNodes = zeros(size(nodes));
    for i = 1:size(nodes,1)
        for j = 1:dof
            newNodes(i,j) = nodes(i,j) + uGlobal(dof*(i-1)+j);
        end
    end
    
    % Create vectors to contain the initial length of each node and the 
    % length at equilibrium
    initialLength = zeros(size(sctr,1));
    newLength = zeros(size(sctr,1));
    
    % Calculate lengths
    initalSumOfSquares = 0;
    for i = 1:dof
        initalSumOfSquares = initalSumOfSquares + (nodes(sctr(:,1),i)-nodes(sctr(:,2),i)).^2;
    end
    initialLength = sqrt(initalSumOfSquares);

    finalSumOfSquares = 0;
    for i = 1:dof
        finalSumOfSquares = finalSumOfSquares + (newNodes(sctr(:,1),i)-newNodes(sctr(:,2),i)).^2;
    end
    newLength = sqrt(finalSumOfSquares);
    
    % Calculate stress
    stress = ((newLength - initialLength)./initialLength).*young;

end