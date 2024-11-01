function [newPlace,expn,path,hasCrashed,H] = pushing(F0,F1,R2)

global G P rv rp frazrv diam O0 O1

%% output initialization
newPlace = [];
expn = 1;
F = union(F0,F1(:,1));
F = union(F,F1(:,2));
path = findPath(F);
i = path(end);
hasCrashed = 0;
H = [];

%% pushing a new robot
G = addnode(G,1);
isExtInF1 = 0; % this flag allows me to understand whether i does not belong to F1

%% expansion in F1
if ~isempty(F1)

    % looking for the external node from which carry out deployment in F1
    Ni = neighbors(G,i);
    NiF1 = [];
    for t = 1:length(Ni)
        j = Ni(t);
        if G.Edges.Weights(findedge(G,i,j)) == 1 % belongs to F1
            isExtInF1 = 1;
            NiF1 = [NiF1 j];
        end
    end
    
    if isExtInF1
        
        j = NiF1(ceil(rand*length(NiF1)));
        unCovij = uncovered(R2,i,j);
        if ~isempty(unCovij)
            [jinew,ijnew,sigma] = deploymentAngle(i,j,unCovij);
            [newPlace,expn,hasCrashed,H] = expansionFence(i,j,jinew,ijnew);
            if ~expn && length(unCovij) == 2
                unCovij = setdiff(unCovij,sigma);
                [jinew,ijnew] = deploymentAngle(i,j,unCovij);
                [newPlace,expn,hasCrashed,H] = expansionFence(i,j,jinew,ijnew);
            end
        else
            expn = 0;
        end

        % expansion failure
        if ~expn 
            O1 = union(O1,sort([i j]),'rows');
            G.Edges.Weights(findedge(G,i,j)) = -1;
            G = rmnode(G,numnodes(G));
        end
        
    end
end


%% expansion from F0 
if isempty(F1) || ~isExtInF1
    dcrash = 0;
    p_i = P(i,:);
    source = i;
    hasCrashed = 0;
    count = 0;
    maxcount = 36;
    ang = rand*2*pi;
    while dcrash <= diam && count < maxcount
        count = count+1;
        newPlace = p_i+frazrv*rv*[cos(ang) sin(ang)]+rp*randn(1,2);
        [newPlace,dcrash,hasCrashed,H] = realPlace(p_i,newPlace);
        if dcrash > diam
            oldPlace = newPlace;
            [newPlace,expn] = robotCrash(newPlace,source);
            if norm(oldPlace-newPlace) >= 50*eps
                hasCrashed = 0;
            end
        end
        ang = ang+2*pi/maxcount;
    end
    if ~expn
        O0 = union(O0,i);
        G.Nodes.isobstacle(i) = 1;
        G = rmnode(G,numnodes(G));
    end
end

end