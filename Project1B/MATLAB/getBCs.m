function [ fGlobal, uGlobal ] = getBCs( numNodes, DOF, timeIncrement )
%GETBCS Summary of this function goes here
%   Detailed explanation goes here


    [loadCurve] = open_files('load_curve.txt');
    
    fGlobal = zeros(size(numNodes*DOF),1);
    uGlobal = fGlobal;
    
    for i = 2:size(loadCurve, 2)
        temp = loadCurve(2,i)*DOF + loadCurve(3,i) - DOF;
        if loadCurve(1,i) == 1
            fGlobal(temp) = loadCurve(timeIncrement + 3,i);
        else
            uGlobal(temp) = loadCurve(timeIncrement + 3,1);
        end
    end

end

