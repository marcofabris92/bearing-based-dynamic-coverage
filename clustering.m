function best_agent = clustering()

global G cluster_nodes

% weighting function
wf = @(xx,yy) (xx+yy)/2; %min(xx,yy);

% inizialitialiozation
for i = 1:numnodes(G)
    G.Nodes.event_cluster(i) = 0;
    G.Nodes.completed(i) = 0;
    G.Nodes.k(i) = 1; % counter for buildingClustering
    G.Nodes.kbar(i) = 1; % counter for buildingClustering
    G.Nodes.filt_count(i) = 1; % counter for filtering
end

% 1) assigns sensing measures to nodes
% 2) finds the node having maximum sensing, which is the spanning tree root 
best_sensing = 0;
best_agent = 0;
for i = 1:numnodes(G)
    G.Nodes.event_intensity(i) = f(i);
    if G.Nodes.event_intensity(i) > best_sensing
        best_sensing = G.Nodes.event_intensity(i);
        best_agent = i;
    end
end

% Assigns edge weights
for k = 1:numedges(G)
    G.Edges.Weights(k) =...
        wf(G.Nodes.event_intensity(G.Edges.EndNodes(k,1)),...
        G.Nodes.event_intensity(G.Edges.EndNodes(k,2)));
end

% Fills cluster set by means of breadth-first: explore the neighborhood of 
% a node and then it spreads including further nodes

G.Nodes.event_cluster(best_agent) = 1;
cluster_nodes = 1;
buildingCluster(best_agent);

end

