function [BUCKLING] = getBUCKLING(NODES,SCTR,YOUNG,AREA,MOI)
    % Note: MOI is stored as Iyy, Izz
    
    delx = NODES(SCTR(:, 1), 1) - NODES(SCTR(:, 2), 1); % get x delta
    dely = NODES(SCTR(:, 1), 2) - NODES(SCTR(:, 2), 2);
    length = sqrt((delx).^2 + (dely).^2); % calculate pythagorean length
    K = 1; % for two pinned joints
    
    % Calculate critical forces for buckling abou tthe Y axis
    BUCKLING(:,1) = (pi^2.*YOUNG.*MOI(:,1)) ./ (K.*length).^2;
    % Calculate critical forces for buckling abou tthe Z axis
    BUCKLING(:,2) = (pi^2.*YOUNG.*MOI(:,2)) ./ (K.*length).^2;
end