function [] = fenceSubcomplex(R1,R2)
global G O0 O1 F0 F1

n = numnodes(G);
if neighbors(G,1) > 0
    G.Nodes.isfence = zeros(n,1);
end
if length(R1(:,1)) == 1
    G.Edges.Weights(findedge(G,R1(1,1),R1(1,2))) = 0;
elseif ~isempty(R1)
    for h = 1:numedges(G)
        if G.Edges.Weights(h) > 0
            G.Edges.Weights(h) = 0;
        end
    end
end


%% 1
F0 = [];
F1 = int16.empty(0,2);
O0 = [];
O1 = int16.empty(0,2);
LR2 = length(R2(:,1));

if LR2 == 0
    F0 = 1:numnodes(G);
end

%% 2
E = computeException(R1);

%% 3
C = R1;
if ~isempty(E)
    C = setdiff(C,E,'rows');
end

for t = 1:length(C(:,1))
    i = C(t,1);
    j = C(t,2);

    %% 4
    unCovij = uncovered(R2,i,j);
    
    %% 5-6
    if ~isempty(unCovij)
        %% 7-8
        eij = findedge(G,i,j);
        if G.Edges.Weights(eij) == -1
            O1 = union(O1,[i j],'rows');
        end
        [iob,job,ijob] = isObstacle(i,j);
        if iob || job || ijob 
            if  iob 
                O0 = union(O0,i);
            end
            if job
                O0 = union(O0,j);
            end
            if ijob
                O1 = union(O1,[i j],'rows');
            end
        elseif G.Edges.Weights(findedge(G,i,j)) > -1
            %% 9-10
             F0 = union(F0,[i j]);
             F1 = union(F1,sort([i j]),'rows');

        end
%         if eij > 0 && isFakeObsEdge(i,j) %&& G.Edges.Weights(eij) == -1
%             F1 = union(F1,sort([i j]),'rows');
%             F0 = union(F0,[i j]);
%             O1 = setdiff(O1,sort([i j]),'rows');
%             O0 = setdiff(O0,i);
%             O0 = setdiff(O0,j);
%             G.Edges.Weights(eij) = 1;
%         end
    end
end

F1 = setdiff(F1,O1,'rows');
F0 = setdiff(F0,O0);
for t = 1:length(F1(:,1))    
    G.Edges.Weights(findedge(G,F1(t,1),F1(t,2))) = 1;
end
for t = 1:length(F0)    
    G.Nodes.isfence(t) = 1;
end


end