function [kGlobal,fGlobal,uGlobal, mGlobal, cGlobal] = initializeMatrices(dof,n)

% % % This function receives the degree of freedom and number of nodes.
% % % The function returns an initilized Kglobal, Fglobal, Uglobal,
% % % Mglobal, and Cglobal matrix.

kGlobal = zeros(n*dof, n*dof);
cGlobal = zeros(n*dof, n*dof);
mGlobal = zeros(n*dof, n*dof);

fGlobal = zeros(n*dof, 1);
uGlobal = zeros(n*dof, 1);
uGlobal(:,1) = nan;


end