function [SHEAR] = tearout(DIA_I,DIA_O,THICKNESS,TAU_MAX,FORCE)

    % TAU = (F / 2) / (S * T)
    % IF TAU_MAX < TAU, YOU'RE FUCKED 
    %
    % DIA_I, DIA_O, THICKNESS, all in [mm]
    % FORCE in [N]
    % TAU_MAX in MEGAPASCALS
    %
    
    F = (FORCE/2);
    
    S = (DIA_O - DIA_I)/2;
    
    T = THICKNESS;
    
    SHEAR = F/(S*T);
    
    if( SHEAR > TAU_MAX)
        disp('tearout occured');
    end
    
end
    
    
    













