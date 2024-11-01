function [theta1,theta2,sigma,osimplex] = deploymentAngle(i,j,UnCov)

global P G
%% 1) initalization
theta1 = [];
theta2 = [];
sigma = [];
S_i = [];
S_j = [];
p_i = P(i,:);
p_j = P(j,:);
osimplex = int16.empty(0,2);
ki = [];
kj = [];

%% 2) main loop
for t = 1:length(UnCov)
    sigma = UnCov(t);
    theta1=+sigma*pi/3;
    theta2=-sigma*pi/3;   
    %% 3) construction of S_i
    Ni_j = setdiff(neighbors(G,i),j);
    for tt = 1:length(Ni_j)
        ni_j = Ni_j(tt);
        ajil = computeAngle(p_j,p_i,P(ni_j,:));
        if ~isempty(ajil) && sign(ajil) == sigma
            S_i = [S_i; ni_j];
        end
    end
    
    %% 4) search the best ki
    ajiki = pi;
    if ~isempty(S_i)
        for tt = 1:length(S_i(:,1))
            ajisi = abs(computeAngle(p_j,p_i,P(S_i(tt),:)));
            if ~isempty(ajisi) && ajisi < ajiki
                ajiki = ajisi;
                ki = S_i(tt);
            end
        end
    end

    %% 5) construction of S_j
    Nj_i = setdiff(neighbors(G,j),i);
    for tt = 1:length(Nj_i)
        nj_i = Nj_i(tt);
        aijl = computeAngle(p_i,p_j,P(nj_i,:));
        if ~isempty(aijl) && sign(aijl) == -sigma
            S_j = [S_j; nj_i];    
        end
    end

    %% 6) search the best kj
    aijkj = pi;
    if ~isempty(S_j)
        for tt = 1:length(S_j(:,1))
            aijsj = abs(computeAngle(p_i,p_j,P(S_j(tt),:)));
            if ~isempty(aijsj) && aijsj < aijkj
                aijkj = aijsj;
                kj = S_j(tt);
            end
        end
    end
    
    %% 7) simplex obstacle condition
    if ajiki < pi/3 && aijkj < pi/3 
         osimplex = [i j];
    else
        theta1 = +sigma*min([pi/3 ajiki/2]); 
        theta2 = -sigma*min([pi/3 aijkj/2]);
    end

end


end