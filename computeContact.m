function sensor = computeContact(S,H)

global ns

S = [S(1) S(2)]'; % center
H = [H(1) H(2)]'; % crash point on the circle
R = norm(S-H);
v = [1 0]'; % rotating unit vector versore rotante, starting from EST
step = exp(1i*2*pi/ns);
sensor = []; %0
angMin = 2*pi;
for t = 1:ns
    ang = abs(getAngle(H,S,S+v*R));
    if abs(ang-angMin) < 50*eps
        sensor = [sensor t];
    elseif ang < angMin
        angMin = ang;
        sensor = t;
    end
    a = (v(1)+1i*v(2))*step;
    v = [real(a) imag(a)]';
end

end