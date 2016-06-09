function x = luDecomp(A,b)
    
    % Initialize L and U
    n = size(A,1);
    L = zeros(n);
    U = zeros(n); 
    for i = 1:n
        U(i,i) = 1;
    end
    
    % Solve for first column of L
    L(:,1) = A(:,1);
    
    % Solve for first row of U
    U(1,2:n) = A(1,2:n)./L(1,1);
    
    % Solve for remaining LU terms
    for j = 2:n-1
        for i = j:n;
            L(i,j) = A(i,j) - sum(L(i,1:j-1).*U(1:j-1,j)');
        end
        for k = j+1:n;
            U(j,k) = (A(j,k) - sum(L(j,1:j-1).*U(1:j-1,k)')) / L(j,j);
        end
    end
    
    % Solve for last L term
    L(n,n) = A(n,n) - sum(L(n,1:n-1).*U(1:n-1,n)');
    
    % Forward substitute to find the z vector:
    % [L][U][x] = [b] -> [L][z] = [b] where [z] = [U][x]
    z = zeros(n,1);
    z(1) = b(1)/L(1,1); 
    for i = 2:n
        z(i) = (b(i) - sum(L(i,1:i-1).*z(1:i-1)')) / L(i,i);
    end
    
    % Backward substitue to find [x] since [U][x] = [z]
    x = zeros(n,1);
    x(n) = z(n);
    for i = n-1:-1:1
        x(i) = (z(i) - sum(U(i,i+1:n).*x(i+1:n)')) / U(i,i);
    end
    
end

    
    
    
    