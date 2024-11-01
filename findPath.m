function bestpath = findPath(F)

global G fdistance

bestpath = 1;
lp = +inf;
for i = 1:length(F)
    if ~isempty(neighbors(G,F(i)))
        path = shortestpath(G,1,F(i),'Method','unweighted');
        if ~isempty(path) && length(path) < lp
            bestpath = path;
            lp = length(bestpath);  
        elseif ~isempty(path) && length(path) == lp
            bestpath = [bestpath; path];
        end
    end
end

c = ceil(length(bestpath(:,1))*rand);
bestpath = bestpath(c,:);
if rand < 0.95
    fdistance = length(bestpath);
else
    % robot failure -> periodically check the whole graph
    fdistance = 0;
end

end