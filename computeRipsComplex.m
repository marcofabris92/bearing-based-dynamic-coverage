function [R1,R2] = computeRipsComplex()

global G

R1 = table2array(G.Edges);
R1 = R1(:,1:2);

R2 = int16.empty(0,3);
for i = 1:numnodes(G)
    Ni = neighbors(G,i);
    for t = 1:length(Ni)
        j = Ni(t);
        K = intersect(Ni,neighbors(G,j));
        for tt = 1:length(K)
            k = K(tt);
            if i < j && j < k
                R2 = union(R2,[i j k],'rows');
            end
        end   
    end        
end

end