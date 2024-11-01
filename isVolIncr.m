function flag = isVolIncr(k, try_position_k)

global G rv P new_edge_clst data_bnn SNR

flag_adding_edges = 0;

flag = 1; % movement flag: 1 = it moves
deg_k = 0;
Nk = neighbors(G,k);
for h = 1:length(Nk)
    if G.Nodes.event_cluster(Nk(h))
        deg_k = deg_k+1;
    end
end
delta_volume = -deg_k*G.Nodes.event_intensity(k)/(1+1/SNR);
reference_k = P(k,:);
P(k,:) = try_position_k;
f_try_k = f(k);
deltaNk = []; % new neighbors
for h = 1:numnodes(G)
    if norm(P(k,:)-P(h,:)) <= rv &&...
       G.Nodes.event_cluster(h) &&...
       h~=k &&...
       ~findedge(G,k,h) &&...
       isVisible(P(k,:),P(h,:)) 
        deltaNk = [deltaNk h];
        delta_volume = delta_volume + G.Nodes.event_intensity(h);
    end
end
delta_volume = delta_volume + (deg_k+length(deltaNk))*f_try_k;
    
if delta_volume > 0
    %fprintf('Movement\n')
    G.Nodes.event_intensity(k) = f_try_k;
    G.Nodes.filt_count(k) = 1;
    for j = 1:length(deltaNk)
        h = deltaNk(j);
        G = addedge(G,k,h);
        if ~flag_adding_edges
            flag_adding_edges = 1;
            new_edge_clst = [new_edge_clst 1+length(data_bnn)];
        end
        G.Edges.Weights(findedge(G,k,h)) = (f_try_k+G.Nodes.event_intensity(h))/2;
    end
else
    P(k,:) = reference_k;
    flag = 0;
end

end

