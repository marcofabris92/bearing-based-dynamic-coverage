function dists = syslinecircle(V,s,cd)

% finds the distance between points Q1, Q2 on the circle w.r.t. V

global diam

dists = +inf;
xv = V(1);
yv = V(2);
xc = s(1);
yc = s(2);
cd1 = cd(1);
cd2 = cd(2);
bb = 2*(-xv*cd1-yv*cd2+cd1*xc+cd2*yc); 
cc = xv^2+yv^2+xc^2+yc^2-2*xv*xc-2*yv*yc-(diam/2)^2;
sol1 = (-bb+sqrt(bb^2-4*cc))/2;
sol2 = (-bb-sqrt(bb^2-4*cc))/2;

if imag(sol1) == 0
    dists = sort([sol1 sol2]);
    if sol1 < 0
        dists = dists(dists~=sol1);
    end
    if sol2 < 0
        dists = dists(dists~=sol2);
    end
    if isempty(dists)
        dists = +inf;
    end
end

end