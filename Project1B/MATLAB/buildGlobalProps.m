function [gProps] = buildGlobalProps(nodes,sctr,young,area)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
    sctr_size = size(sctr, 1); % # of elements/rows in SCTR

    % initializing in properties matrix
    gProps = zeros(sctr_size, 2); 

    %Calculating properties
    for i = 1:sctr_size % each element
        index1 = sctr(i, 1); % index of 1st node 
        index2 = sctr(i, 2); % index of 2nd node
        delx = nodes(index1, 1) - nodes(index2, 1); % get x delta
        if (DOF > 1)
            dely = nodes(index1, 2) - nodes(index2, 2); % get y delta
            length = sqrt((delx)^2 + (dely)^2); % calculate pythagorean length
            angle  = atan(dely/delx); % calculate angle
        else 
            length = delx; 
            angle = 0; 
        end
        
        gProps(i, 1) = young(i,1) * area(i,1) / length; % E *A / L <= formula to get stiffness of a material
        gProps(i, 2) = angle; % add angle to properties
    end

end

