function output = nma(a,b,r,boundary)

% flag boundary (=1 consider boundary to compute lower bound N)

a_ = a/r;
b_ = b/r;
a_3 = a_/sqrt(3);
b_3 = b_/sqrt(3);


% Nm_ = @(x,y) (floor(x)+ceil(x))*floor(y)+ceil(x)*ceil(y-floor(y)-1/2)...
%     -(floor(x))*(1-ceil(y)+floor(y)) -(floor(y))*(1-ceil(x)+floor(x));

Nm_ = @(x,y)...
 ceil(x)*(ceil(y+1/2)+floor(y-1))+floor(x)*ceil(y-1)-floor(x+1)*floor(y);

%NM_ = @(x,y) (floor(x)+ceil(x))*floor(y)+ceil(x)*ceil(y-floor(y)-1/2) + 1;

NM_ = @(x,y) 1+floor(x)*floor(y)+ceil(x)*ceil(y-1/2);

Nm = 1;
NM = 1;
if a_3 > 1 && b_3 > 1
    Nm = min([Nm_(a_,b_3),Nm_(b_,a_3)]);
    NM = min([NM_(a_,b_3),NM_(b_,a_3)]);
elseif b_3 <= 1 && a_^2+(b_/2)^2 > 1
    Nm = 1+ceil(a_-2*sqrt(1-(b_/2)^2));
    NM = Nm;
elseif a_3 <= 1 && b_^2+(a_/2)^2 > 1
    Nm = 1+ceil(b_-2*sqrt(1-(a_/2)^2));
    NM = Nm;
end

Nm = Nm + max(boundary*(floor(2*(a_+b_))) , 0);

output = [Nm NM];


end

