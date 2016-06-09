function [ MGLOBAL ] = buildMGlobal(M, DOF, MGLOBAL)
%buildGlobalMass
%   Handle global mass matrix creation

    MGLOBAL = zeros(size(M)*DOF, size(M)*DOF);

    for i = 0:1:size(M)
        for j = 1:DOF
            MGLOBAL(i*DOF+j,i*DOF+j) = M(i+1);
        end
    end    
    
end
