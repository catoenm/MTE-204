function [ MGLOBAL ] = buildMGLOBAL(AREA,DENSITY,DOF,MGLOBAL,SCTR,GPROPS)
    % Handle global mass matrix creation
    sctr_size = size(SCTR,1);
    
    for el = 1:sctr_size % each element
        MLOCAL = AREA(el, 1).*DENSITY(el, 1)*GPROPS(el,3)/2;
        index1 = SCTR(el,1);
        index2 = SCTR(el,2);
        if DOF == 1
            MGLOBAL(index1, index1) = MGLOBAL(index1, index1) + MLOCAL; % superposition the klocal value onto global Kmatrix
            MGLOBAL(index2, index2) = MGLOBAL(index2, index2) + MLOCAL;    
        else
            MGLOBAL(index1*DOF-1, index1*DOF-1) = MGLOBAL(index1*DOF-1, index1*DOF-1) + MLOCAL; % superposition the klocal value onto global Kmatrix
            MGLOBAL(index1*DOF, index1*DOF) = MGLOBAL(index1*DOF, index1*DOF) + MLOCAL; % superposition the klocal value onto global Kmatrix
            MGLOBAL(index2*DOF-1, index2*DOF-1) = MGLOBAL(index2*DOF-1, index2*DOF-1) + MLOCAL;    
            MGLOBAL(index2*DOF, index2*DOF) = MGLOBAL(index2*DOF, index2*DOF) + MLOCAL;    
        end
    end
end
