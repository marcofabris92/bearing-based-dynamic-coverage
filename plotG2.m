%% plot of the graph G
% P is the plane coordinate matrix for each node
% each row of P contains the coordinates (x,y)



function [] = plotG2(G,P,F0,F1,O0,O1)

global xmin xmax ymin ymax rv

% adding vision circles
plot((xmin+xmax)/2,(ymin+ymax)/2);
hold on


for i=1:length(P(:,1))   
    ang=0:0.01:2*pi; 
    xp=rv*cos(ang);
    yp=rv*sin(ang);
    plot(P(i,1)+xp,P(i,2)+yp,'y');    
end


s = 1.1;
%rectangle('Position',s*[Xmin Ymin Xmax-Xmin Ymax-Ymin],'linewidth',2)
axis([xmin-rv xmax+rv ymin-rv ymax+rv])
grid on
l = length(P(:,1));
g = 1;
r = 1;
b = 1;
plots = [];
leg = {};
for i=1:l
    color = 'g';
    if ismember(i,F0)
        color = 'r';
    end
    if ismember(i,O0)
        color = 'b';
    end
    scatter(P(i,1),P(i,2),50,'filled',color);
    if g && color == 'g'
        pl = plot(2*s*xmax,2*s*ymax,'.g');
        plots =[plots pl];
        leg = [leg {'normal nodes'}];
        g = 0;
    end
    if r && color == 'r'
        pl = plot(2*s*xmax,2*s*ymax,'.r');
        plots =[plots pl];
        leg = [leg {'fence nodes'}];
        r = 0;
    end
    if b && color == 'b'
        pl = plot(2*s*xmax,2*s*ymax,'.b');
        plots =[plots pl];
        leg = [leg {'obstacle nodes'}];
        b = 0;
    end
    text(P(i,1),P(i,2),num2str(i))
end


E = table2array(G.Edges);
l = length(E(:,1));
k = 1;
r = 1;
b = 1;
for i=1:l
    v1 = E(i,1);
    v2 = E(i,2);
    p2 = P(v2,:)';
    vers = P(v1,:)'-p2;
    dist12 = norm(vers);
    vers = vers/dist12;
    lambda = linspace(0,dist12);
    edgeline = zeros(2,100);
    for j=1:100
        edgeline(:,j) = p2+lambda(j)*vers;
    end
    color = 'k';
    if ismember([v1 v2],F1,'rows')
        color = 'r';
    end
    if ismember([v1 v2],O1,'rows')
        color = 'b';
    end
    pl = plot(edgeline(1,:),edgeline(2,:),color);
    if k && color == 'k'
        plots = [plots pl];
        leg = [leg {'normal edges'}];
        k = 0;
    end
    if r && color == 'r'
        plots = [plots pl];
        leg = [leg {'fence edges'}];
        r = 0;
    end
    if b && color == 'b'
        plots = [plots pl];
        leg = [leg {'obstacle edges'}];
        b = 0;
    end
end
rectangle('Position',[xmin ymin xmax-xmin ymax-ymin])
%legend(plots,leg)

hold off


end

