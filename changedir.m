function [change,distmaxcd] = changedir(seg,xc,yc,cd,distmaxcd)

change = 0;

xa = seg(1,1);
ya = seg(2,1);
xb = seg(1,2);
yb = seg(2,2);

ab = [xb yb]-[xa ya];
distab = norm(ab);
ab = ab'/distab;
cd = cd/norm(cd);
M = [ab -cd];
q = [xc-xa; yc-ya];
r = rank(M);

if rank([M q]) ~= r    % parall non-coinc
    return
elseif r == 2
    lambda = (M^-1)*q; % non-parall
else
                       % parall and coinc
    if getAngle([xa ya],[xc yc]'+cd*distmaxcd,[xb yb]) > pi/2
        change = 1;
    end
    return
end

lambdaa = lambda(1);
lambdac = lambda(2);

if 0 <= lambdaa && lambdaa <= distab && 0 <= lambdac && lambdac <= distmaxcd
    distmaxcd = lambdac;
    change = 1;
end

end