function [AREA, YOUNG, DAMPING, DENSITY] = process_material_props(PROPS)
% % % This function receives the material properties matrix
% % % This function partitions and returns the area and elastic modulus

    YOUNG = PROPS(:,1);
    AREA = PROPS(:,2);
    DENSITY = PROPS(:,3);
    DAMPING = PROPS(:,4);

end