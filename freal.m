function value = freal(P)

global kf rEV muE


value = kf*exp(-norm(muE-P)^2/rEV^2);



end

