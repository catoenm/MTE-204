function [ FIXED, FREE ] = buildFixedFree( DOF, numNodes, loadCurve )
    %UNTITLED Summary of this function goes here
    %   Detailed explanation goes here
 
    for i = 2:size(loadCurve, 2)
        if loadCurve(1,i) == 0
            FIXED(i-1) = loadCurve(2,i)*DOF + loadCurve(3,i) - DOF;
        end
    end

    N = numNodes * DOF;
    FREE = zeros((N)-size(FIXED,1),1);
    counter = 1;
    for a = 1 : N % FOR RANGE OF N
        if (~ismember(a,FIXED)) % IF THIS INDEX IS NOT IN FIXED . . .
            FREE(counter,1) = a; % PUT IT IN FREE
            counter = counter + 1; % INCREMENT COUNTER OF NEXT AVAILABLE SPACE IN FREE
        end
    end
end

