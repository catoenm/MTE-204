function [x,k] = solve_gauss_jacobe(A,b,x0,tol)
    n = size(A,2);
    stop = false;
    k = 0;
    while (~stop)
        % update guess
        Xnext = zeros(n,1);
        for i = 1:n
            sum = 0;
            for j = 1:n
                if (i ~= j)
                    sum = sum + A(i,j)*x0(j);
                end
            end
            Xnext(i) = (b(i) - sum) / A(i,i);
        end
        % check relative error
        if (max(abs(Xnext-x0)./abs(x0)) < tol)
            stop = true;
        end
        x0 = Xnext;
        k = k + 1;
    end
    x = x0;
end