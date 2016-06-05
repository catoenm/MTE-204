function [x,k] = solve_gauss_seidel(A,b,x0,tol)
    n = size(A,2);
    stop = false;
    k = 0;
    while (~stop)
        % update guess
        xlast = x0;
        for i = 1:n
            sum = 0;
            for j = 1:n
                if (i ~= j)
                    sum = sum + A(i,j)*x0(j);
                end
            end
            x0(i) = (b(i) - sum) / A(i,i);
        end
        % check relative error
        if (max(abs(xlast-x0)./abs(x0)) < tol)
            stop = true;
        end
        k = k + 1;
    end
    x = x0;
end