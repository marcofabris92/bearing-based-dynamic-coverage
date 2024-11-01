function robots = removeUseless(useless)

global P G uncov_pr prim

rimoz = useless(ceil(rand(1)*length(useless)));
if ~isempty(uncov_pr)
    for k = 1:length(uncov_pr(:,1))
        i = uncov_pr(k,1);
        j = uncov_pr(k,2);
        if i > 0 && i <= numnodes(G) && j > 0 && j <= numnodes(G) && i~=j
            Ni = neighbors(G,i);
            Nj = neighbors(G,j);
            Ni = setdiff(Ni,j);
            Nj = setdiff(Nj,i);
            Nij = union(Ni,Nj);
            Lij = length(Nij);
            if length(setdiff(Nij,rimoz)) < Lij && rand^2 > prim &&...
                    (G.Nodes.isobstacle(i) || G.Nodes.isobstacle(j))
                G.Nodes.isobstacle(i) = 1;
                G.Nodes.isobstacle(j) = 1;
                G.Edges.Weights(findedge(G,i,j)) = -1;
            end
        end
    end
end

P = [P(1:rimoz-1,:); P(rimoz+1:end,:)];
G = rmnode(G,rimoz);
robots = numnodes(G);
G.Nodes.basedist = distances(G,1)';

end

