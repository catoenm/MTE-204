function [KGLOBAL] = buildKGLOBAL(NODES,SCTR,DOF,YOUNG,AREA,KGLOBAL)


    % % % This function receives the node list, the elemental connectivity
    % matrix, degree of freedom of the problem, elastic modulus, area and an
    % empty Kglobal matrix.

    % % % This function builds the transformed local elemental matrix and inserts it into
    % % % the global stiffness matrix.

    % % % At the end of the function, the fully assembled Kglobal matrix is
    % % % returned.

    e = size(SCTR, 1);

    %Filling in props matrix
    props = zeros(e, 2);

    %Calculating properties
    for i = 1:e
        index1 = SCTR(i, 1);
        index2 = SCTR(i, 2);
        delx = NODES(index1, 1) - NODES(index2, 1);
        if (DOF > 1)
            dely = NODES(index1, 2) - NODES(index2, 2);
            length = sqrt((delx)^2 + (dely)^2);
            angle  = atan(dely/delx);
        else 
            length = delx;
            angle = 0;
        end
        
        props(i, 1) = YOUNG(i,1)*AREA(i,1)/length;
        props(i, 2) = angle;
    end

    %One dimensional case
    if DOF == 1  
        A = [1 -1; -1 1];
        for el = 1:e
            KLOCAL = props(el,1)*A;
            for i = 1:2
                for j = 1:2
                    index1 = SCTR(el,i);
                    index2 = SCTR(el,j);
                    KGLOBAL(index1, index2) = KGLOBAL(index1, index2) + KLOCAL(i,j);
                end
            end
        end
    end

    %Two dimensional case
    if DOF == 2
        for el = 1:e
           %Keff values
           a = cos(props(el, 2));
           b = sin(props(el, 2));
           a2 = a^2 * props(el, 1);
           b2 = b^2 * props(el, 1);
           ab = a*b * props(el, 1);
           
           Kp = [a2 ab; 
                 ab b2];
           Kn = -1*Kp;
           
           for i = 1:2
               for j = 1:2
                   index1 = (SCTR(el, i)*2)-1;
                   index2 = (SCTR(el, j)*2)-1;
                   if i == j
                      Keff = Kp; 
                   else
                      Keff = Kn;
                   end
                   KGLOBAL(index1, index2)     = KGLOBAL(index1, index2) + Keff(i, j);
                   KGLOBAL(index1, index2+1)   = KGLOBAL(index1, index2+1) + Keff(i, j);
                   KGLOBAL(index1+1, index2)   = KGLOBAL(index1+1, index2) + Keff(i, j);
                   KGLOBAL(index1+1, index2+1) = KGLOBAL(index1+1, index2+1) + Keff(i, j);
               end
           end
        end
    end

    %Three dimensional case
    if DOF == 3

         %To be filled in when needed

    end
end