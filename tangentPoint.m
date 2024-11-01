function [t,zeroDistCrash] = tangentPoint(seg,s)

global diam contact_tol

s = [s(1) s(2)]';

h = [seg(1,2) seg(2,2)]-[seg(1,1) seg(2,1)];
h = h/norm(h);
h = [h(2) -h(1)]';
R = diam/2;
t1 = s+R*h;
t2 = s-R*h;

dist1 = distpointline(t1,seg);
dist2 = distpointline(t2,seg);
if dist1 < dist2
    t = t1;
    dist = dist1;
else
    t = t2;
    dist = dist2;
end

zeroDistCrash = 0;
if dist < 50*eps
    v1 = seg(:,1);
    v2 = seg(:,2);
    if abs(getAngle(v1,t,v2)) > pi/2 || norm(t-v1) < contact_tol*eps...
            || norm(t-v2) < contact_tol*eps 
        zeroDistCrash = 1;
    end
end

end