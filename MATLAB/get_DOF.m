function [DOF] = get_DOF(NODES)

% % % This function receives the nodes matrix.
% % % It determines and returns the degree of freedom of the problem.
% % % I.e. Is the problem a 1D problem? 2D problem? 3D problem?

DOF = size(NODES, 2);

end