function [AREA, YOUNG, DAMPING, MASS] = process_material_props(PROPS)
% % % This function receives the material properties matrix
% % % This function partitions and returns the area and elastic modulus

    AREA = PROPS(:,1);
    YOUNG = PROPS(:,2);
    DAMPING = PROPS(:,3);
    MASS = PROPS(:,4);
    
    
end