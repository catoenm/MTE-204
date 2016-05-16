function [UGLOBAL,FGLOBAL] = solveKU(KGLOBAL,FGLOBAL,UGLOBAL,FIXED,FREE)

    % % % This function performs the matrix solving for all unknown displacements
    % % % The function is given the fully constructed Kglobal matrix, the
    % % % partially-populated force and displacement vectors, and list of the
    % % % free and fixed nodes.

    % % % This function partitions the Kglobal matrix and then solves for all
    % % % unknown displacements and forces.

    % % % The function returns the completed UGLOBAL and FGLOBAL vectors.

    % % % Free = Known forces [1,3,6]
    % % % Fixed = Known displacements [2,4,5]

    % //comment 
    n = length(KGLOBAL);
    m = length(FIXED);
    
    % //comment 
    f_order = zeros(1,n);
    u_order = zeros(1,n);
    
    % Row swap to move unknown forces to the top
    K_temp = zeros(n);
    F_temp = zeros(n,1);
    e_next = 1;
    f_next = m + 1;
    for i = 1:n
        if(ismember(i,FREE))
            K_temp(f_next,:) = KGLOBAL(i,:);
            F_temp(f_next,:) = FGLOBAL(i,:);
            f_order(i) = f_next;
            f_next = f_next + 1;
        else
            K_temp(e_next,:) = KGLOBAL(i,:);
            F_temp(e_next,:) = FGLOBAL(i,:);
            f_order(i) = e_next;
            e_next = e_next + 1;
        end
    end

    % Column swap to move unknown displacements to the bottom
    K_temp2 = zeros(n); % create temporary Kmatrix
    U_temp = zeros(n,1); % create temporary displacement vector
    e_next = 1; % reset e marker
    f_next = m + 1; % reset f marker
    for i = 1:n
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
    
    %commented out submatrices that are not used for calculations
    %Ke = K_temp2(1:m,1:m); 
    Kfe = K_temp2(m+1:n,1:m);
    %Kef = K_temp2(1:m,m+1:n);
    Kf = K_temp2(m+1:n,m+1:n);
    Ue = U_temp(1:m);
    %Uf = U_temp(m+1:n);
    %Fe = F_temp(1:m);
    Ff = F_temp(m+1:n);
    
    Uf = linsolve(Kf,Ff-Kfe*Ue);
    U_temp(m+1:n) = Uf;
    
    F_temp = K_temp2 * U_temp;
    
    FGLOBAL = F_temp(f_order);  
    UGLOBAL = U_temp(u_order);

end