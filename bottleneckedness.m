function value = bottleneckedness()

global G

    function value = cut_cardinality()
        value = 0;
        for i = 1:numnodes(G)
            if G.Nodes.event_cluster(i)
                Ni = neighbors(G,i);
                for k = 1:length(Ni)
                    if ~G.Nodes.event_cluster(Ni(k))
                        value = value+1;
                    end
                end
            end
        end
    end

    function value = cluster_volume(clst)
        % clst == 1 means that cluster C is taken into consideration
        % clst == 0 means that the complement of cluster C is considered
        value = 0;
        for i = 1:numnodes(G)
            if G.Nodes.event_cluster(i) == clst
                Ni = neighbors(G,i);
                for k = 1:length(Ni)
                    value = value + G.Nodes.event_intensity(Ni(k));
                end
            end
        end
    end

    value = cut_cardinality()*(1/cluster_volume(1)+1/cluster_volume(0));

end

