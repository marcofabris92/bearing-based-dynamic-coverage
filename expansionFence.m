function [newPlace,expn,hasCrashed,H] = expansionFence(i,j,jinew,ijnew)

global P diam rp

ci = P(i,:)';
cj = P(j,:)';

%% computation of the destination
vij = (cj-ci)/norm(ci-cj);
vinew = [cos(jinew) sin(jinew); -sin(jinew) cos(jinew)]*vij;
vjnew = -[cos(ijnew) sin(ijnew); -sin(ijnew) cos(ijnew)]*vij;
M = [vinew(1) -vjnew(1) ; vinew(2) -vjnew(2)];
lambda = M^-1*(cj-ci);
destination = (ci+lambda(1)*vinew)'+rp*randn(1,2);

%% output initialization
newPlace = destination;
expn = 0;
hasCrashed = 0;
H = [];

%% expansion test from i
[newPlacei,dcrashi,hasCrashedi,Hi] = realPlace(ci,destination);
if dcrashi > diam
    [newPlace,expn] = robotCrash(newPlacei,i);
    if expn
        if norm(newPlacei-newPlace) < 50*eps
            hasCrashed = hasCrashedi;
        end
        H = Hi;
        return
    end
end

%% expansion test from j
[newPlacej,dcrashj,hasCrashedj,Hj] = realPlace(cj,destination);
if dcrashj > diam
    [newPlace,expn] = robotCrash(newPlacej,j);
    if expn
        if norm(newPlacej-newPlace) < 50*eps
            hasCrashed = hasCrashedj;
        end
        H = Hj;
    end
end

end