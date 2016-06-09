function [nextUDotGlobal, nextUDDotGlobal] = updateImplicit(uGlobal,...
    prevUGlobal, prevUDotGlobal, prevUDDotGlobal, beta, gamma, time)
    % Update Acceleration
    nextUDDotGlobal = (2/(beta*time^2)).*(uGlobal-prevUGlobal) -...
        (2/(beta*time)).*prevUDotGlobal - ((1-beta)/beta).*prevUDDotGlobal;
    % Update Velocity
    nextUDotGlobal = time.*((1-gamma).*prevUDDotGlobal + gamma.*nextUDDotGlobal)...
        + prevUDotGlobal;
end

