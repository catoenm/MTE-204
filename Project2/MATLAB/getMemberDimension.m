function dim = getMemberDimension(forceCritical, E, ultimateStress)
    if (forceCritical < 0) % tension member
        dim = forceCritical/(ultimateStress * 3.175);
    else % compression member
        I = (forceCritical * L^2)/(E * pi^2);
        ay = (I - 541.967)/298.722;
        az = (((I - 16.937)/0.529)^(1/3) - 3.175)/2;
        dim = max(ay, az); % weaker axis of failure dictates minimum a
    end    
end