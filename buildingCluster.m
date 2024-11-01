function [] = buildingCluster(i)

global G desired_cluster_nodes cluster_nodes

% finds neighborhood of current node i
Ni = neighbors(G,i);
LNi = length(Ni);

% finds the edge weights around i and sorts them in descending order
Wi = zeros(1,LNi);
for k = 1:LNi
    Wi(k) = G.Edges.Weights(findedge(G,i,Ni(k)));
end
[Wi,Ni_indexes] = sort(Wi);
Wi = fliplr(Wi);

% sorts i's neighbors as the edge-weights were sorted
Ni_unsorted = Ni;
for k = 1:LNi
    Ni(LNi-k+1) = Ni_unsorted(Ni_indexes(k));
end

while G.Nodes.kbar(i) <= 3
    ks = G.Nodes.kbar(i);
    G.Nodes.k(i) = 1;
    while G.Nodes.k(i) <= LNi && cluster_nodes < desired_cluster_nodes
        k = G.Nodes.k(i);
        j = Ni(k);
        if G.Nodes.event_cluster(j) == 0 || ks == 3
            if ks < 3
                G.Nodes.event_cluster(j) = 1;
                cluster_nodes = cluster_nodes+1;
            end
            if cluster_nodes < desired_cluster_nodes && (ks == 1 &&...
                    G.Nodes.event_intensity(j) > Wi(k) || ks == 2 ||...
                    ks == 3 && G.Nodes.completed(j) == 0)
                buildingCluster(j);
            end
        end
        if ks == 2 && k == LNi
            G.Nodes.completed(i) = 1;
        end
        G.Nodes.k(i) = G.Nodes.k(i)+1;
    end
    G.Nodes.kbar(i) = G.Nodes.kbar(i)+1;
end

end

