function distpl = distpointline(point,seg)

xa = seg(1,1);
ya = seg(2,1);
xb = seg(1,2);
yb = seg(2,2);
px = point(1);
py = point(2);

% implicit form: ay+bx+c=0 -> y=(-b/a)*x-(c/a)
a = 0;
b = 1;
c = -xa;
if xa ~= xb
    a = 1;
    b = -(yb-ya)/(xb-xa);
    c = -(ya+b*xa);
end

distpl = abs(a*py+b*px+c)/sqrt(a^2+b^2);

end

