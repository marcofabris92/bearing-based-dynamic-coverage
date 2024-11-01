function vis = isVisible(s,d)

global room transition

vis = 1;
s = [s(1) s(2)]';
d = [d(1) d(2)]';
xc = s(1);
yc = s(2);
distmaxcd = norm(d-s);
if distmaxcd < eps
    return
end
cd = (d-s)/distmaxcd;

i = 1;
j = 0;
cont = 1;
while vis && cont <= length(transition)
    c = transition(cont); 
    while  vis && i <= j+c
        if i == j+c
            seg = [room(1,i),room(1,j+1) ; room(2,i),room(2,j+1)];         
        else
            seg = [room(1,i:i+1) ; room(2,i:i+1)];
        end       
        [crash,dist] = changedir(seg,xc,yc,cd,distmaxcd);
        if crash && dist < distmaxcd
            vis = 0;
            return
        end
        i = i+1;
    end
    j = i-1;
    cont = cont+1;
end

end