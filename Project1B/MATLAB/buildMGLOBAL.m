function [ MGLOBAL ] = buildMGLOBAL(AREA,DENSITY,DOF,MGLOBAL,GPROPS)
%buildGlobalMass
%   Handle global mass matrix creation
    MASS = AREA.*DENSITY.*GPROPS(:,3)
    for i = 0:1:size(MASS)
        for j = 1:DOF
            MGLOBAL(i*DOF+j,i*DOF+j) = MASS(i+1);
        end
    end    
    
end
