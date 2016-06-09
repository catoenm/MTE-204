function [ fGlobal, uGlobal ] = getBCs( numNodes, DOF, loadCurve, iteration )
%GETBCS Summary of this function goes here
%   Detailed explanation goes here

 
    fGlobal = zeros(numNodes*DOF,1).*nan;
    uGlobal = fGlobal;
    
    for i = 2:size(loadCurve, 2)
        index = loadCurve(2,i)*DOF + loadCurve(3,i) - DOF;
        if loadCurve(1,i) == 1
            fGlobal(index) = loadCurve(iteration + 3,i);
        else
            uGlobal(index) = loadCurve(iteration + 3,1);
        end
    end

end