function [KGLOBAL,FGLOBAL,UGLOBAL, MGLOBAL, CGLOBAL] = initializeMatrices(DOF,N)

% % % This function receives the degree of freedom and number of nodes.
% % % The function returns an initilized Kglobal, Fglobal, Uglobal,
% % % Mglobal, and Cglobal matrix.

KGLOBAL = zeros(N*DOF, N*DOF);
CGLOBAL = zeros(N*DOF, N*DOF);
MGLOBAL = zeros(N*DOF, N*DOF);

FGLOBAL = zeros(N*DOF, 1);
UGLOBAL = zeros(N*DOF, 1);
UGLOBAL(:,1) = nan;


end