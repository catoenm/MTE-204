function [ MGLOBAL ] = buildMGLOBAL(AREA,DENSITY,MGLOBAL,SCTR,GPROPS)
%buildGlobalMass
%   Handle global mass matrix creation
    sctr_size = size(SCTR,1);
    
    for el = 1:sctr_size % each element
        MLOCAL = AREA*DENSITY*GPROPS(el,3)/2;
        index1 = SCTR(el,1);
        index2 = SCTR(el,2);
        MGLOBAL(index1, index1) = MGLOBAL(index1, index1) + MLOCAL; % superposition the klocal value onto global Kmatrix
        MGLOBAL(index2, index2) = MGLOBAL(index2, index2) + MLOCAL;    
    end
end
