function [KGLOBAL] = buildKGLOBAL(DOF,KGLOBAL,SCTR,GPROPS)
    % % % This function receives the node list, the elemental connectivity
    % matrix, degree of freedom of the problem, elastic modulus, area and an
    % empty Kglobal matrix.

    % % % This function builds the transformed local elemental matrix and inserts it into
    % % % the global stiffness matrix.

    % % % At the end of the function, the fully assembled Kglobal matrix is
    % % % returned.

    sctr_size = size(SCTR,1);
    
    %One dimensional case
    if DOF == 1  
        A = [1 -1; -1 1]; % transformation
        for el = 1:sctr_size % each element
            KLOCAL = GPROPS(el,1)*A; % get stiffness for this local kmatrix from property matrix
            for i = 1:2
                for j = 1:2
                    index1 = SCTR(el,i);
                    index2 = SCTR(el,j);
                    KGLOBAL(index1, index2) = KGLOBAL(index1, index2) + KLOCAL(i,j); % superposition the klocal value onto global Kmatrix
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
                   KGLOBAL(index1, index2)     = KGLOBAL(index1, index2) + Keff(1, 1); % superpositioning force onto index in global kmatrix
                   KGLOBAL(index1, index2+1)   = KGLOBAL(index1, index2+1) + Keff(1, 2); %
                   KGLOBAL(index1+1, index2)   = KGLOBAL(index1+1, index2) + Keff(2, 1); %
                   KGLOBAL(index1+1, index2+1) = KGLOBAL(index1+1, index2+1) + Keff(2, 2); %
               end
           end
        end
    end
end