function [] = dispatch(leader_node1)

global G
e
% ending recursion
G.Nodes.dispatched(leader_node1) = 1;

% filtering estimates
cn = G.Nodes.filt_count(leader_node1);
G.Nodes.filt_count(leader_node1) = cn+1;
G.Nodes.event_intensity(leader_node1) = G.Nodes.event_intensity(leader_node1)*...
    cn/(cn+1)+f(leader_node1)/(cn+1);

% looking for the second leader 
% N1 = neighbors(G,leader_node1);
% L1 = length(N1);
% max_measure = 0;
leader_node2 = 0; % fictitious node, useful if we want to converge toward
                  % the event by heading towards a couple of agents
% for k = 1:L1
%     j = N1(k);
%     if G.Nodes.event_intensity(j) > max_measure && G.Nodes.event_cluster(j)
%         max_measure = G.Nodes.event_intensity(j);
%         leader_node2 = j;
%     end
% end

% meging the two neighborhoods + exclusion of nodes that have already
% been displached
% N12 = union(setdiff(N1,leader_node2),...
%             setdiff(neighbors(G,leader_node2),leader_node1));


N12 = neighbors(G,leader_node1);
k = 1;
while k <= length(N12)
    j = N12(k);
    if G.Nodes.dispatched(j) || ~G.Nodes.event_cluster(j)
        N12(k) = [];
    else
        k = k+1;
    end
end

% sorting the merged neighborhood based on the intensity of the event
% the larger the intensity the smaller the array index for the neighborhood
L12 = length(N12);
N12_sort = zeros(1,L12);
for k = 1:L12
    N12_sort(k) = G.Nodes.event_intensity(N12(k));
end
[~,indexes] = sort(N12_sort);
for k = 1:L12
    N12_sort(L12-k+1) = N12(indexes(k));
end

% agent movement + recursion
for k = 1:L12
    j = N12(k);
    dispatch_law(leader_node1,leader_node2,j);

    dispatch(j);
end



end

