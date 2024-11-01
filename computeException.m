% R1: edge list
% E: list of exception found in R1

function E = computeException(R1)

% G: graph of the network
% fdistance: minimum distance between a node in the fence and the base station
global G fdistance

E = [];
for t = 1:length(R1(:,1))
    i = R1(t,1);
    j = R1(t,2);
    if G.Nodes.basedist(i) > fdistance-2 || G.Nodes.basedist(j) > fdistance-2
        % K: exception candidate
        K = intersect(neighbors(G,i),neighbors(G,j)); 
        % exception searching
        for tt = 1:length(K)
            if isException(i,K(tt),j)
                E = [E; [i j]];
            end 
        end 
    else
        E = [E; [i j]];
    end    
end

end