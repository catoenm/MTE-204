function [ mGlobal ] = buildMGlobal(m, dof, mGlobal)
%buildGlobalMass
%   Handle global mass matrix creation

    mGlobal = zeros(size(m)*dof, size(m)*dof);

    for i = 0:1:size(m)
        for j = 1:dof
            mGlobal(i*dof+j,i*dof+j) = m(i+1);
        end
    end    
    
end
