function [ NEXTUGLOBAL, FGLOBAL ] = solveMCKU( KGLOBAL, MGLOBAL, CGLOBAL,... 
         FGLOBAL, UGLOBAL, UDOTGLOBAL, UDDOTGLOBAL, PREVUGLOBAL,...
         FIXED, FREE, OPTION, TIME )
    % Options:
    % 1 - Implicit, no damping
    % 2 - Implicit, with damping
    % 3 - Explicit, no damping
    % 4 - Explicit, with damping
    BETA = 8/5;
    GAMMA = 3/2;
     
    n = length(KGLOBAL); % matrix is nxn
    m = length(FIXED);  % for mixed method, matrix will be split 1:m, m+1:n   
    
    if( mod(OPTION,2) )
    %NO DAMPING
        CGLOBAL = 0.*CGLOBAL;
    end

    if(OPTION > 2)
    %EXPLICIT
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
    
    % these vectors will track what the original ordering of the elements
    % of F/U matrices are
    f_order = zeros(1,n); 
    u_order = zeros(1,n);
    
    % % % Row swap to move unknown forces to the top
    A_temp = zeros(n); % Create empty temp matrix size nxn
    X_temp = zeros(n,1); % Create empty temp X vector
    F_temp = zeros(n,1); % Create empty temp F vector
    e_next = 1; % this will track the next available row from 1:m
    f_next = m + 1; % this will track the next available row from m+1:n
    for i = 1:n 
        if(ismember(i,FREE)) % if the index is one where a force is known,...
            A_temp(f_next,:) = A(i,:); % copy row into next available row below m
            F_temp(f_next,:) = FGLOBAL(i,:); % copy F element into next available spot below m
            X_temp(f_next,:) = X(i,:); % copy X element into next available spot below m
            f_order(i) = f_next; % store where i was swapped to
            f_next = f_next + 1; % increment tracker to indicate one less spot
        else
            A_temp(e_next,:) = A(i,:); % copy row into next available row from the top to m
            F_temp(e_next,:) = FGLOBAL(i,:); % copy F element into next available spot from top to m
            X_temp(e_next,:) = X(i,:); % copy X element into next available spot from top to m
            f_order(i) = e_next; % " "
            e_next = e_next + 1; % " "
        end
    end

    % Column swap to move unknown displacements to the bottom
    A_temp2 = zeros(n); % create another temporary Amatrix ( this one is for column swapping )
    U_temp = zeros(n,1); % create temporary displacement vector
    e_next = 1; % reset e marker
    f_next = m + 1; % reset f marker
    for i = 1:n % This is all the same as the rowswap for-loop, but now columns are swapped instead of rows
        if(ismember(i,FIXED)) 
            A_temp2(:,e_next) = A_temp(:,i);
            U_temp(e_next,:) = UGLOBAL(i,:);
            u_order(i) = e_next;
            e_next = e_next + 1;
        else
            A_temp2(:,f_next) = A_temp(:,i);
            U_temp(f_next,:) = UGLOBAL(i,:);
            u_order(i) = f_next;
            f_next = f_next + 1;
        end
    end
    
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

    F_temp = A_temp2 * U_temp - X_temp; % solve via matrix multiplication (Godbless MATLAB)
    
    FGLOBAL = F_temp(f_order); % revert to original ordering  
    NEXTUGLOBAL = U_temp(u_order); % " "
    

    
end

