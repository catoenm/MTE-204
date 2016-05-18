function [KGLOBAL,FGLOBAL,UGLOBAL] = initialize_matrices(DOF,N)

% % % This function receives the degree of freedom and number of nodes.
% % % The function returns an initilized Kglobal, Fglobal, and Uglobal
% % % matrix.

KGLOBAL = zeros(N*DOF, N*DOF);
FGLOBAL = zeros(N*DOF, 1);
UGLOBAL = zeros(N*DOF, 1);

for i = 1:(N*DOF)
    for j = 1:(N*DOF)
        KGLOBAL(i,j) = nan; % bench = 987654321, squat = bench - 1 
    end    
    FGLOBAL(i,1) = nan;
    UGLOBAL(i,1) = nan;
end

end