function [GPROPS] = buildGPROPS(NODES,DOF,YOUNG,AREA,SCTR)
    % builds gemometric properties 
    sctr_size = size(SCTR, 1); % # of elements/rows in SCTR

    % initializing in properties matrix
    GPROPS = zeros(sctr_size, 3); 

    %Calculating properties
    for i = 1:sctr_size % each element
        index1 = SCTR(i, 1); % index of 1st node 
        index2 = SCTR(i, 2); % index of 2nd node
        delx = NODES(index1, 1) - NODES(index2, 1); % get x delta
        if (DOF > 1)
            dely = NODES(index1, 2) - NODES(index2, 2); % get y delta
            length = sqrt((delx)^2 + (dely)^2); % calculate pythagorean length
            angle  = atan(dely/delx); % calculate angle
        else 
            length = abs(delx); 
            angle = 0; 
        end
        
        GPROPS(i, 1) = YOUNG(i,1) * AREA(i,1) / length; % E *A / L <= formula to get stiffness of a material
        GPROPS(i, 2) = angle; % add angle to properties
        GPROPS(i, 3) = length; %add length to properties
    end

end

