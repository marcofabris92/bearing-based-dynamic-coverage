function [unCovij,locs] = uncovered(R2,i,j)

global P

unCovij = [1 -1];
locs = []; % R2 location where a triangle with i and j appears
for t = 1:length(R2(:,1))
    r = R2(t,:);
    if length(r(r~=i & r~=j)) == 1
        locs = union(locs,t);
    end
end

plusone = 0;
minusone = 0;
t = 0;
done = 0;
while t < length(locs) && ~done
    t = t+1;
    ku = setdiff(R2(locs(t),:),[i j]);
    s = sign(computeAngle(P(j,:),P(i,:),P(ku,:)));
    if s == 1
        plusone = 1;
        if minusone == -1
            done = 1;
        end
    end
    if s == -1
        minusone = -1;
        if plusone == 1
            done = 1;
        end
    end
end

unCovij = setdiff(unCovij,[plusone minusone]);

end