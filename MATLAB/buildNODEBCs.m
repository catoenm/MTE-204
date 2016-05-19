function [UGLOBAL,FIXED] = buildNODEBCs(UGLOBAL,NODAL_BCS,DOF)

% % % This function receives the initialized global displacements matrix,
% % % list of nodal boundary conditions,and degree of freedom.

% % % This function creates a vector (called FIXED) that corresponds to the
% % % list of indices of the displacement vector [Uglobal] that are known.
% % % I.e. If U3y,U4x,U10y are known displacements for a 2D problem, 
% % % the vector would contain the indices FIXED = [6,7,20]
% % % 

% % % This function updates and returns the global displacement vector with the known
% % % perscribed boundary condition.  The function also returns the vector
% % % of indices of known displacements 

    % REFER TO documentation in buildFORCEBCs - it's the same thing

    FIXED = zeros(size(NODAL_BCS,1),1);
    
    for a = 1 : size(NODAL_BCS,1)
        FIXED(a,1) = (NODAL_BCS(a,1) * DOF) + NODAL_BCS(a,2) - DOF;
    end
    
    for b = 1 : size(FIXED,1)
        UGLOBAL(FIXED(b,1)) = NODAL_BCS(b,3);
    end
end
