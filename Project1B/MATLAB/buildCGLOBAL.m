function [ CGLOBAL ] = buildCGLOBAL(DAMPING,DOF,CGLOBAL,SCTR,GPROPS)
    % Handles global damping matrix creation
    
    sctr_size = size(SCTR,1);
    
    %One dimensional case
    if DOF == 1  
        A = [1 -1; -1 1]; % transformation
        for el = 1:sctr_size % each element
            CLOCAL = DAMPING(el)*A; % get stiffness for this local kmatrix from property matrix
            for i = 1:2
                for j = 1:2
                    index1 = SCTR(el,i);
                    index2 = SCTR(el,j);
                    CGLOBAL(index1, index2) = CGLOBAL(index1, index2) + CLOCAL(i,j); % superposition the klocal value onto global Cmatrix
                end
            end
        end
    end

    %Two dimensional case
    if DOF == 2
        for el = 1:sctr_size
           %Keff values
           theta = GPROPS(el, 2); % angle between the local axis and the global axis
           damping = DAMPING(el); % stiffness of the current element
           a = cos(theta); % a is the consine of the angle 
           b = sin(theta); % b " " sine
           a2 = a^2 * damping;
           b2 = b^2 * damping;
           ab = a*b * damping;
           
           % kglobal = [ Kp Kn 
           %             Kn Kp ]
           Cp = [a2 ab;  % positive partitions of C-eff  
                 ab b2];
           Cn = -1*Cp; % negative partition
           
           for i = 1:2
               for j = 1:2
                   index1 = (SCTR(el, i)*2)-1; % getting indices of node with respect to global matrix
                   index2 = (SCTR(el, j)*2)-1;
                   if i == j
                      Ceff = Cp; 
                   else
                      Ceff = Cn;
                   end
                   CGLOBAL(index1, index2)     = CGLOBAL(index1, index2) + Ceff(1, 1); % superpositioning force onto index in global cmatrix
                   CGLOBAL(index1, index2+1)   = CGLOBAL(index1, index2+1) + Ceff(1, 2); %
                   CGLOBAL(index1+1, index2)   = CGLOBAL(index1+1, index2) + Ceff(2, 1); %
                   CGLOBAL(index1+1, index2+1) = CGLOBAL(index1+1, index2+1) + Ceff(2, 2); %
               end
           end
        end
    end
end

