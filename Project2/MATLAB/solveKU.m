function [UGLOBAL,FGLOBAL] = solveKU(KGLOBAL,FGLOBAL,UGLOBAL,FIXED,FREE)

    % % % This function performs the matrix solving for all unknown displacements
    % % % The function is given the fully constructed Kglobal matrix, the
    % % % partially-populated force and displacement vectors, and list of the
    % % % free and fixed nodes.

    % % % This function partitions the Kglobal matrix and then solves for all
    % % % unknown displacements and forces.

    % % % The function returns the completed UGLOBAL and FGLOBAL vectors.

    % % % Free = Known forces e.g.[1,3,6]
    % % % Fixed = Known displacements e.g.[2,4,5]

    n = length(KGLOBAL); % matrix is nxn
    m = length(FIXED);  % for mixed method, matrix will be split 1:m, m+1:n
    
    % these vectors will track what the original ordering of the elements
    % of F/U matrices are
    f_order = zeros(1,n); 
    u_order = zeros(1,n);
    
    % % % Row swap to move unknown forces to the top
    K_temp = zeros(n); % Create empty temp matrix size nxn
    F_temp = zeros(n,1); % Create empty temp F vector
    e_next = 1; % this will track the next available row from 1:m
    f_next = m + 1; % this will track the next available row from m+1:n
    for i = 1:n 
        if(ismember(i,FREE)) % if the index is one where a force is known,...
            K_temp(f_next,:) = KGLOBAL(i,:); % copy row into next available row below m
            F_temp(f_next,:) = FGLOBAL(i,:); % copy F element into next available spot below m
            f_order(i) = f_next; % store where i was swapped to
            f_next = f_next + 1; % increment tracker to indicate one less spot
        else
            K_temp(e_next,:) = KGLOBAL(i,:); % copy row into next available row from the top to m
            F_temp(e_next,:) = FGLOBAL(i,:); % copy F element into next available spot from top to m
            f_order(i) = e_next; % " "
            e_next = e_next + 1; % " "
        end
    end

    % Column swap to move unknown displacements to the bottom
    K_temp2 = zeros(n); % create another temporary Kmatrix ( this one is for column swapping )
    U_temp = zeros(n,1); % create temporary displacement vector
    e_next = 1; % reset e marker
    f_next = m + 1; % reset f marker
    for i = 1:n % This is all the same as the rowswap for-loop, but now columns are swapped instead of rows
        if(ismember(i,FIXED)) 
            K_temp2(:,e_next) = K_temp(:,i);
            U_temp(e_next,:) = UGLOBAL(i,:);
            u_order(i) = e_next;
            e_next = e_next + 1;
        else
            K_temp2(:,f_next) = K_temp(:,i);
            U_temp(f_next,:) = UGLOBAL(i,:);
            u_order(i) = f_next;
            f_next = f_next + 1;
        end
    end
    
    % commented out submatrices that are not used for calculations
    %Ke = K_temp2(1:m,1:m); 
    Kfe = K_temp2(m+1:n,1:m);
    %Kef = K_temp2(1:m,m+1:n);
    Kf = K_temp2(m+1:n,m+1:n);
    Ue = U_temp(1:m);
    %Uf = U_temp(m+1:n);
    %Fe = F_temp(1:m);
    Ff = F_temp(m+1:n);
    
    % use LU decomposition to find solution for [Kf][Uf] = [Ff]-[Kfe]*[Ue]
    Uf = LU_decomp(Kf,Ff-Kfe*Ue);
    U_temp(m+1:n) = Uf; % Add these solved variables back to U vector
    
    F_temp = K_temp2 * U_temp; % solve via matrix multiplication (Godbless MATLAB)
    
    FGLOBAL = F_temp(f_order); % revert to original ordering  
    UGLOBAL = U_temp(u_order); % " "

end