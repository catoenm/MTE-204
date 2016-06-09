function [ nextUGlobal, fGlobal ] = solveMCKU( kGlobal, mGlobal, cGlobal,... 
         fGlobal, uGlobal, uDotGlobal, uDDotGlobal, prevUGlobal,...
         fixed, free, option, time, beta, gamma)
    % Options:
    % 1 - Implicit, no damping
    % 2 - Implicit, with damping
    % 3 - Explicit, no damping
    % 4 - Explicit, with damping
     
    n = length(kGlobal); % matrix is nxn
    m = length(fixed);  % for mixed method, matrix will be split 1:m, m+1:n   
    
    if( mod(option,2) )
    % NO DAMPING
        cGlobal = 0.*cGlobal;
    end

    if(option > 2)
    % EXPLICIT
        %calculate A,B,D
        A = mGlobal./(time^2) + cGlobal./(2*time);
        B = kGlobal - 2.*mGlobal./(time^2);
        D = mGlobal./(time^2) - cGlobal/(2*time);
        %add a dummy variable
        X = -B*uGlobal - D*prevUGlobal;
        
    else
    %IMPLICIT
        %calculate A,B,C,D 
        A = 2/(beta*time^2).*mGlobal + kGlobal + (2*gamma)/(beta*time).*cGlobal;
        B = 2/(beta*time^2).*mGlobal + (2*gamma)/(beta*time).*cGlobal;
        C = 2/(beta*time).*mGlobal + (((2*gamma)/beta) - 1).*cGlobal;
        D = ((1 - beta)/beta).*mGlobal + ((gamma - 1) + ((1 - beta)/beta)*gamma)*time.*cGlobal;
        %add a dummy variable
        X = B*uGlobal + C*uDotGlobal + D*uDDotGlobal;
    
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
        if(ismember(i,free)) % if the index is one where a force is known,...
            A_temp(f_next,:) = A(i,:); % copy row into next available row below m
            F_temp(f_next,:) = fGlobal(i,:); % copy F element into next available spot below m
            X_temp(f_next,:) = X(i,:); % copy X element into next available spot below m
            f_order(i) = f_next; % store where i was swapped to
            f_next = f_next + 1; % increment tracker to indicate one less spot
        else
            A_temp(e_next,:) = A(i,:); % copy row into next available row from the top to m
            F_temp(e_next,:) = fGlobal(i,:); % copy F element into next available spot from top to m
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
        if(ismember(i,fixed)) 
            A_temp2(:,e_next) = A_temp(:,i);
            U_temp(e_next,:) = uGlobal(i,:);
            u_order(i) = e_next;
            e_next = e_next + 1;
        else
            A_temp2(:,f_next) = A_temp(:,i);
            U_temp(f_next,:) = uGlobal(i,:);
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
    
    fGlobal = F_temp(f_order); % revert to original ordering  
    nextUGlobal = U_temp(u_order); % " "
    

    
end

