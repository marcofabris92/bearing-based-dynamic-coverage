function useless = findRedundant(R2)

useless = [];
epsilon = 10^-7;
global G P

for t = 1:length(R2(:,1))
    i = R2(t,1);
    j = R2(t,2);
    k = R2(t,3);
    p_i = P(i,:);
    p_j = P(j,:);
    p_k = P(k,:);
    
    %% elminnation of the vertex of a degenerate 2simplex
    ijk = [computeAngle(p_j,p_i,p_k)...
        computeAngle(p_i,p_j,p_k) computeAngle(p_i,p_k,p_j)];
    for tt = 1:3
        if abs(ijk(tt)) > pi-epsilon
            q = R2(t,tt);
            if q ~= 1
                useless = union(useless,q);
                G.Nodes.isredundant(q) = 1;
            end
        end
    end
    
    %% elimination of a robot inside a 2simplex
    Qs = intersect(neighbors(G,i),neighbors(G,j));
    Qs = intersect(Qs,neighbors(G,k));
    for tt = 1:length(Qs)
        q = Qs(tt);
        p_q = P(q,:);
        if abs(computeAngle(p_i,p_q,p_j)+computeAngle(p_j,p_q,p_k)+...
                computeAngle(p_k,p_q,p_i)) > 2*pi-epsilon
            if q ~= 1
                useless = union(useless,q);
                G.Nodes.isredundant(q) = 1;
            end
        end       
    end    
end

end