function [FGLOBAL,FREE] = buildFORCEBCs(FGLOBAL,NODAL_FORCES,FIXED,DOF,N)

% % % This function receives the initialized global force matrix,
% % % list of nodes that have applied force, list nodal boundary conditions
% % % indices, degree of freedom and number of equations required to be solved.

% % % This function creates a vector (called FREE) that corresponds to the
% % % list of indices of the force vector [Fglobal] that are known.
% % % I.e. If F3y,F4x,F10y are known forces for a 2D problem, 
% % % the vector would contain the indices FREE = [6,7,20]
% % % 
% % % If a node was not prescribed in either displacements or force 
% % % boundary conditions, then it is assumed to be a free node with an
% % % applied load of 0.
% % %
% % % This function updates and returns the global force vector with the known
% % % perscribed boundary force condition.  The function also returns the vector
% % % of indices of known forces. 

    FREE = zeros((N*DOF)-size(FIXED,1),1);
    
    % NODAL_FORCES contains info on nodal forces in the row form [NODE, AXIS, VALUE]


    for a = 1 : size(FREE,1) % iterate through FREE vector
        FREE(a,1) = (NODAL_FORCES(a,1) * DOF) + NODAL_FORCES(a,2) - DOF; % locates y coordinate, if x coordinate, subtracts index value by 1 
    end
    
    for b = 1 : size(FIXED,1)
        FGLOBAL(FREE(b),1) = NODAL_FORCES(b,3); % adds nodal force to corresponding index in global force matrix
    end

end