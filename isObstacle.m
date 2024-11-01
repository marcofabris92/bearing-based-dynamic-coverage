function [iob,job,ijob] = isObstacle(i,j)

global P G ns uncov_pr

betaerr = 0.00001; % angle error while reading
% obstacle flag for nodes i,j and the edge ij
iob = 0;
job = 0;
ijob = 0;

%% i)
si = G.Nodes.isobstacle(i);
sj = G.Nodes.isobstacle(j);
% sensi = find(G.Nodes.contact(i,:));
% sensj = find(G.Nodes.contact(j,:));

real_obs = 0;
k = 0;
while k < ns && ~real_obs
    k = k+1;
    if G.Nodes.contact(i,k) && G.Nodes.contact(i,k) == G.Nodes.contact(j,k)
       real_obs = 1;
    end
end

if si && sj && real_obs 
    iob = 1;
    job = 1;
    ijob = 1;
    return
end



%% ii)
uncov_pr = union(uncov_pr,[i j],'rows');
p_i = P(i,:);
p_j = P(j,:);
Ni = neighbors(G,i);
Nj = neighbors(G,j);

ki = setdiff(Ni,Nj);
ki = ki(ki~=j);
for t = 1:length(ki)
    if abs(computeAngle(p_j,p_i,P(ki(t),:))) < pi/3-2*betaerr && G.Nodes.isobstacle(j)
        ijob = 1;
        return
    end
end

kj = setdiff(Nj,Ni);
kj = kj(kj~=i);
for t = 1:length(kj)
    if abs(computeAngle(p_i,p_j,P(kj(t),:))) < pi/3-2*betaerr && G.Nodes.isobstacle(i)
        ijob = 1; 
        return
    end
end

end