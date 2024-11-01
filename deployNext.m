function robots = deployNext(newPlace,hasCrashed,H)

global G P rv ns
robots = numnodes(G);
Nnext = [];

if hasCrashed
    G.Nodes.contact(robots,:) = zeros(1,ns);
    G.Nodes.contact(robots,computeContact(newPlace,H)) = 1;
    G.Nodes.isobstacle(robots) = 1;
end

for t = 1:robots-1
    if norm(newPlace-P(t,:)) <= rv && isVisible(P(t,:),newPlace)
        Nnext = [Nnext t];
    end
end

P = [P; newPlace]
ln = length(Nnext);
if ln > 0
    G = addedge(G,robots*ones(1,ln),Nnext);
    G.Edges.Weights(findedge(G,robots*ones(1,ln),Nnext)) = 0;
end
G.Nodes.basedist(robots) = distances(G,robots,1);
    
end