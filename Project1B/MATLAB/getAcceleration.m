function A = getAcceleration(Ui, Uj, Vj, delta)
    A = (getVelocity(Ui-Uj) - Vk)./delta;
end