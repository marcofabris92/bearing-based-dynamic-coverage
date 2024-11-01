function value = f(i)

global P kf rEV muE SNR


value = kf*exp(-norm(muE-P(i,:))^2/rEV^2);

value = value + 2*value/SNR*(rand-0.5);



end

