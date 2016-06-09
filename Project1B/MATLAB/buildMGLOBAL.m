function [ MGLOBAL ] = buildMGLOBAL(AREA,DENSITY,DOF,MGLOBAL,GPROPS)
%buildGlobalMass
%   Handle global mass matrix creation
    sctr_size = size(SCTR,1);
    
    %One dimensional case
    if DOF == 1  
        A = [1 0; 0 1]; % transformation
        for el = 1:sctr_size % each element
            MLOCAL = AREA*DENSITY*GPROPS(el,3)*A; % get stiffness for this local kmatrix from property matrix
            for i = 1:2
                for j = 1:2
                    index1 = SCTR(el,i);
                    index2 = SCTR(el,j);
                    MGLOBAL(index1, index2) = MGLOBAL(index1, index2) + MLOCAL(i,j); % superposition the klocal value onto global Kmatrix
                end
            end
        end
    end

    %Two dimensional case
    if DOF == 2
        for el = 1:sctr_size
           %Keff values
           theta = GPROPS(el, 2); % angle between the local axis and the global axis
           stiffness = GPROPS(el, 1); % stiffness of the current element
           a = cos(theta); % a is the consine of the angle 
           b = sin(theta); % b " " sine
           a2 = a^2 * stiffness;
           b2 = b^2 * stiffness;
           ab = a*b * stiffness;
           

           % kglobal = [ Kp Kn 
           %             Kn Kp ]
           Kp = [a2 ab;  % positive partitions of K-eff  
                 ab b2];
           Kn = -1*Kp; % negative partition
           
           for i = 1:2
               for j = 1:2
                   index1 = (SCTR(el, i)*2)-1; % getting indices of node with respect to global matrix
                   index2 = (SCTR(el, j)*2)-1;
                   if i == j
                      Keff = Kp; 
                   else
                      Keff = Kn;
                   end
                   MGLOBAL(index1, index2)     = MGLOBAL(index1, index2) + Keff(1, 1); % superpositioning force onto index in global kmatrix
                   MGLOBAL(index1, index2+1)   = MGLOBAL(index1, index2+1) + Keff(1, 2); %
                   MGLOBAL(index1+1, index2)   = MGLOBAL(index1+1, index2) + Keff(2, 1); %
                   MGLOBAL(index1+1, index2+1) = MGLOBAL(index1+1, index2+1) + Keff(2, 2); %
               end
           end
        end
    end
end
