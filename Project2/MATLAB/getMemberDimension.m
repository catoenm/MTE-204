function [dim, area] = getMemberDimension(forceCritical, E, length, ultimateStrength)
    if (forceCritical > 0) % tension member
        dim = forceCritical/(ultimateStrength * 3.175);
        area = dim * 3.175;
    else % compression member
        I = (abs(forceCritical) * length^2)/(E * pi^2);
        ay = (I - 541.967)/298.722;
        az = (((I - 16.937)/0.529)^(1/3) - 3.175)/2;
        dim = max(ay, az); % weaker axis of failure dictates minimum a
        area = 12.7*dim + 40.3225; % area of 'I' member
    end    
end