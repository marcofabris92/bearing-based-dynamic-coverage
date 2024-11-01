function status = isFakeObsEdge(i,j)

global G ns

si = G.Nodes.contact(i,:);
sj = G.Nodes.contact(j,:);

status = 0;

if ~(sum(si) == 1 && sum(sj) == 1)
    return
end

sia = find(si);
k = mod(sia-ns/2,ns);
if k == 0
    k = ns;
end
sja = find(sj);
if sja == k
    status = 1;
end


end

