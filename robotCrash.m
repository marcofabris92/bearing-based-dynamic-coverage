function [newPlace,expn] = robotCrash(newp,source)

global G P diam
newp = [newp(1) newp(2)]';
newPlace = newp';
expn = 1;
S = P(source,:)';
cd = S-newp;
cd = cd/norm(cd);

for t = 1:numnodes(G)-1
    C = P(t,:)';
    if norm(newp-C) <= diam && t ~= source
        b = S-C;
        b1 = b(1);
        b2 = b(2);
        bb = -2*(b1*cd(1)+b2*cd(2));
        cc = b1^2+b2^2-diam^2;
        delta = bb^2-4*cc;
        sol1 = (-bb+sqrt(delta))/2;
        sol2 = (-bb-sqrt(delta))/2;
        if imag(sol1) ~= 0
            error('complex solution!')
        end
        dcrash = min(abs([sol1 sol2]));
        newp = S-dcrash*cd;
        if norm(S-newp) <= diam
            expn = 0;
            return
        end
    end
end

newPlace = newp';

end