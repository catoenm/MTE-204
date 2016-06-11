function [ uGlobal, fGlobal ] = getBCs( numNodes, DOF, loadCurve, iteration, free, fixed )
    % Input boundary conditions into the global U and F vectors
 
    fGlobal = zeros(numNodes*DOF,1);
    uGlobal = fGlobal;
    
    for i = 2:size(loadCurve, 2)
        index = loadCurve(2,i)*DOF + loadCurve(3,i) - DOF;
        if loadCurve(1,i) == 1
            fGlobal(index) = loadCurve(iteration + 3,i);
        else
            uGlobal(index) = loadCurve(iteration + 3,i);
        end
    end
    
    fGlobal(fixed) = nan;
    uGlobal(free) = nan;
    
end