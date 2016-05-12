function [AREA, YOUNG] = process_material_props(PROPS)
% % % This function receives the material properties matrix
% % % This function partitions and returns the area and elastic modulus

    AREA = PROPS(:,1);
    YOUNG = PROPS(:,2);

end