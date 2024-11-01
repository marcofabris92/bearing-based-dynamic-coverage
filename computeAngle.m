function beta = computeAngle(a,b,c)

global rv

a = a';
b = b';
c = c';
ac = norm(a-c);
bc = norm(b-c);
ab = norm(a-b);

if bc > rv || ab > rv
    beta = [];
    return
end

csb = (bc^2+ab^2-ac^2)/(2*ab*bc);
if csb > 1
    csb = 1;
elseif csb < -1
    csb = -1;
end
beta = acos(csb);

sn = bc*sin(beta);
vers = (a-b)/ab;
h = b+bc*cos(beta)*vers;
orth = [vers(2) -vers(1)]';
if norm(c-h-sn*orth) >= norm(c-h+sn*orth)
    beta = -beta;
end
    
end