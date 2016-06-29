function [criticalForces, appliedLoad] = getCriticalForces(drivingDim, sctrIndex,  E, L, ULTIMATE_STRENGTH, TRUSS_RATIO) 
    % Calculate drivingCriticalForce from drivingDim
    if (TRUSS_RATIO(sctrIndex) > 0) % tension member
        drivingCriticalForce = drivingDim * ULTIMATE_STRENGTH * 3.175;
    else % compression member
        Iyy = (drivingDim * 298.722) + 541.967;
        Izz = (drivingDim * 2 +  3.175)^3 * 0.529 + 16.937;
        drivingCriticalForce = -1*(min(Izz, Iyy)* E * pi^2)/(L(sctrIndex)^2);
    end 
    % Backcalculate the applied load based on teh drivingCritical Force
    appliedLoad = drivingCriticalForce / TRUSS_RATIO(sctrIndex);
    % Calculate all forces based on TRUSS_RATIO and load
    criticalForces = appliedLoad.*TRUSS_RATIO;
end