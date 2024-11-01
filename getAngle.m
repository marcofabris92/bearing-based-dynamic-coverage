function beta = getAngle(a,b,c)

a = [a(1) a(2)]';
b = [b(1) b(2)]';
c = [c(1) c(2)]';
ac = norm(a-c);
bc = norm(b-c);
ab = norm(a-b);


beta = real(acos((bc^2+ab^2-ac^2)/(2*ab*bc)));

sn = bc*sin(beta);
vers = (a-b)/ab;
h = b+bc*cos(beta)*vers;
orth = [vers(2) -vers(1)]';
if norm(c-h-sn*orth) >= norm(c-h+sn*orth)
    beta = -beta;
end
    
end

