function [dof] = getDOF(nodes)
% % % This function receives the nodes matrix.
% % % It determines and returns the degree of freedom of the problem.
% % % I.e. Is the problem a 1D problem? 2D problem? 3D problem?


    dof = size(nodes, 2); % size returns row , column, so return value of "column"

end