function [] = reconstructG(reached,Pev,exch)

global P G rv

strg = reached(:,exch);
reached(:,exch) = reached(:,1);
reached(:,1) = strg;

LP = length(P(:,1));
n = 0;
for i = 1:LP
    if Pev(i)
        n = n+1;
        P(i,:) = reached(:,n)';
    end
end

% RECONSTRUCTION OF EDGES

for k = 1:numnodes(G)
    Nk = neighbors(G,k);
    ck = P(k,:);
    for j = 1:length(Nk)
        n = Nk(j);
        if norm(ck-P(n,:)) > rv
            G = rmedge(G,k,n);
        end
    end
    for j = 1:numnodes(G)
        if j ~= k && findedge(G,k,j) == 0 && norm(ck-P(j,:)) <= rv 
            G = addedge(G,k,j);
        end
    end
end


end

