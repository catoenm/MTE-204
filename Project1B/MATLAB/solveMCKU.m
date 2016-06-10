function [ NEXTUGLOBAL, NEXTFGLOBAL ] = solveMCKU( KGLOBAL, MGLOBAL, CGLOBAL,... 
         NEXTFGLOBAL, NEXTUGLOBAL, UGLOBAL, UDOTGLOBAL, UDDOTGLOBAL, PREVUGLOBAL,...
         FIXED, FREE, OPTION, TIME, BETA, GAMMA)

    % % % FREE = Known forces e.g.[1,3,6]
    % % % FIXED = Known displacements e.g.[2,4,5]

    % Options:
    % 1 - Implicit, no damping
    % 2 - Implicit, with damping
    % 3 - Explicit, no damping
    % 4 - Explicit, with damping

    n = length(KGLOBAL); % matrix is nxn
    m = length(FIXED);  % for mixed method, matrix will be split 1:m, m+1:n   

    if( mod(OPTION,2) )
    % NO DAMPING
        CGLOBAL = 0.*CGLOBAL;
    end

    if(OPTION > 2)
    % EXPLICIT
        %calculate A,B,D
        A = MGLOBAL./(TIME^2) + CGLOBAL./(2*TIME);
        B = KGLOBAL - 2.*MGLOBAL./(TIME^2);
        D = MGLOBAL./(TIME^2) - CGLOBAL/(2*TIME);
        %add a dummy variable
        X = -B*UGLOBAL - D*PREVUGLOBAL;  
    else
    %IMPLICIT
        %calculate A,B,C,D 
        A = 2/(BETA*TIME^2).*MGLOBAL + KGLOBAL + (2*GAMMA)/(BETA*TIME).*CGLOBAL;
        B = 2/(BETA*TIME^2).*MGLOBAL + (2*GAMMA)/(BETA*TIME).*CGLOBAL;
        C = 2/(BETA*TIME).*MGLOBAL + (((2*GAMMA)/BETA) - 1).*CGLOBAL;
        D = ((1 - BETA)/BETA).*MGLOBAL + ((GAMMA - 1) + ((1 - BETA)/BETA)*GAMMA)*TIME.*CGLOBAL;
        %add a dummy variable
        X = B*UGLOBAL + C*UDOTGLOBAL + D*UDDOTGLOBAL;
    end

    % these vectors will track what the original ordering of the elements
    % of F/U matrices are
    f_order = zeros(1,n); 
    u_order = zeros(1,n);

    % % % Row swap to move unknown forces to the top
    A_temp = zeros(n); % Create empty temp matrix size nxn
    X_temp = zeros(n,1); % Create empty temp X vector
    F_temp = zeros(n,1); % Create empty temp F vector
    A_temp(1:size(FIXED,1),:) = A(FIXED,:);
    F_temp(1:size(FIXED,1),:) = NEXTFGLOBAL(FIXED,:);
    X_temp(1:size(FIXED,1),:) = X(FIXED,:);
    A_temp(size(FIXED,1)+1:end,:) = A(FREE,:);
    F_temp(size(FIXED,1)+1:end,:) = NEXTFGLOBAL(FREE,:);
    X_temp(size(FIXED,1)+1:end,:) = X(FREE,:);

    % Column swap to move unknown displacements to the bottom
    A_temp2 = zeros(n); % create another temporary Amatrix ( this one is for column swapping )
    U_temp = zeros(n,1); % create temporary displacement vector

    U_temp(1:size(FIXED,1),:) = NEXTUGLOBAL(FIXED,:);
    A_temp2(:,1:size(FIXED,1)) = A_temp(:,FIXED);
    U_temp(size(FIXED,1)+1:end,:) = NEXTUGLOBAL(FREE,:);
    A_temp2(:,size(FIXED,1)+1:end) = A_temp(:,FREE);

    % commented out submatrices that are not used for calculations
    %Ke = K_temp2(1:m,1:m); 
    Kfe = A_temp2(m+1:n,1:m);
    %Kef = K_temp2(1:m,m+1:n);
    Kf = A_temp2(m+1:n,m+1:n);
    Ue = U_temp(1:m);
    %Uf = U_temp(m+1:n);
    %Fe = F_temp(1:m);
    Ff = F_temp(m+1:n);
    Xf = X_temp(m+1:n);

    % use LU decomposition to find solution for 
    % [Kf][Uf] = [Ff]-[Kfe]*[Ue] + [Xf] 
    Uf = LU_decomp(Kf,Ff-Kfe*Ue + Xf);
    U_temp(m+1:n) = Uf; % Add these solved variables back to U vector
    % solve via matrix multiplication (Godbless MATLAB)
    F_temp = A_temp2 * U_temp - X_temp;
    
    % revert to original ordering
    NEXTUGLOBAL(FIXED,:) = U_temp(1:size(FIXED,1),:);
    NEXTUGLOBAL(FREE,:) = U_temp(size(FIXED,1)+1:end,:);
    NEXTFGLOBAL(FIXED,:) = F_temp(1:size(FIXED,1),:);
    NEXTFGLOBAL(FREE,:) = F_temp(size(FIXED,1)+1:end,:);

end

