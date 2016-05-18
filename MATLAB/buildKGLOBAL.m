function [KGLOBAL] = buildKGLOBAL(NODES,SCTR,DOF,YOUNG,AREA,KGLOBAL)


    % % % This function receives the node list, the elemental connectivity
    % matrix, degree of freedom of the problem, elastic modulus, area and an
    % empty Kglobal matrix.

    % % % This function builds the transformed local elemental matrix and inserts it into
    % % % the global stiffness matrix.

    % % % At the end of the function, the fully assembled Kglobal matrix is
    % % % returned.

    e = size(SCTR, 1); % e is the # of elements/rows in SCTR

    % initializing in properties matrix
    props = zeros(e, 2); 

    %Calculating properties
    for i = 1:e % each element
        index1 = SCTR(i, 1); % index of 1st node 
        index2 = SCTR(i, 2); % index of 2nd node
        delx = NODES(index1, 1) - NODES(index2, 1); % get x delta
        if (DOF > 1)
            dely = NODES(index1, 2) - NODES(index2, 2); % get y delta
            length = sqrt((delx)^2 + (dely)^2); % calculate pythagorean length
            angle  = atan(dely/delx); % calculate angle
        else 
            length = delx; 
            angle = 0; 
        end
        
        props(i, 1) = YOUNG(i,1) * AREA(i,1) / length; % E *A / L <= formula to get stiffness of a material
        props(i, 2) = angle; % add angle to properties
    end

    %One dimensional case
    if DOF == 1  
        A = [1 -1; -1 1]; % transformation
        for el = 1:e % each element
            KLOCAL = props(el,1)*A; % get stiffness for this local kmatrix from property matrix
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
        for el = 1:e
           %Keff values
           theta = props(el, 2); % angle between the local axis and the global axis
           stiffness = props(el, 1); % stiffness of the current element
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
                   KGLOBAL(index1, index2)     = KGLOBAL(index1, index2) + Keff(i, j); % superpositioning force onto index in global kmatrix
                   KGLOBAL(index1, index2+1)   = KGLOBAL(index1, index2+1) + Keff(i, j); %
                   KGLOBAL(index1+1, index2)   = KGLOBAL(index1+1, index2) + Keff(i, j); %
                   KGLOBAL(index1+1, index2+1) = KGLOBAL(index1+1, index2+1) + Keff(i, j); %
               end
           end
        end
    end

    %Three dimensional case
    if DOF == 3 % 
      
         %To be filled in when needed

    end
end