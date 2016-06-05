function A = getAcceleration(U0, U1, V1, delta)
    A = (getVelocity(U0 - U1) - V1)./delta;
end