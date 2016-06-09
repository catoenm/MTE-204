function [area, young, damping, mass] = processMaterialProps(props)
% % % This function receives the material properties matrix
% % % This function partitions and returns the area and elastic modulus

    area = props(:,1);
    young = props(:,2);
    damping = props(:,3);
    mass = props(:,4);

end