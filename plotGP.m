%% plot of the graph G
% P is the plane coordinate matrix for each node
% each row of P contains the coordinates (x,y)

function [] = plotGP(G,P,F0,F1,O0,O1,path)

global rv room transition diam

if isempty(O1)
    O1 = int16.empty(0,2);
end
if isempty(F1)
    F1 = int16.empty(0,2);
end

area = 50; % area cerchi
R = diam/2;
xmin = min(room(1,:));
xmax = max(room(1,:));
ymin = min(room(2,:));
ymax = max(room(2,:));


%% adding vision circles
plot((xmin+xmax)/2,(ymin+ymax)/2);
hold on

%% plot scenario
i = 1;
j = 0;
for cont=1:length(transition)
    t = transition(cont); 
    while  i <= j+t
        if i == j+t
            plot([room(1,i),room(1,j+1)],[room(2,i),room(2,j+1)],'k','linewidth',2)
        else
            plot(room(1,i:i+1),room(2,i:i+1),'k','linewidth',2)
        end
        i = i+1;
    end
    j = i-1;
end

%% plot circles
l = length(P(:,1));
for i = 1:l
    ang = 0:0.01:2*pi; 
    xp = rv*cos(ang);
    yp = rv*sin(ang);
    plot(P(i,1)+xp,P(i,2)+yp,'y');
    xxp = R*cos(ang);
    yyp = R*sin(ang);
    plot(P(i,1)+xxp,P(i,2)+yyp,'k','linewidth',2);
end

%% plot robots
s = 1.1;
axis([xmin-rv xmax+rv ymin-rv ymax+rv])
grid on
g = 1;
r = 1;
b = 1;
c = 1;
y = 1;
m = 1;
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
    if ismember(i,path)
        color = 'y';
    end
    if i==l
        color = 'm';
    end
    if i == 1
        color = 'c';
    end
    scatter(P(i,1),P(i,2),area,'filled',color);
    if m && color == 'm'
        pl = plot(2*s*xmax,2*s*ymax,'.m');
        plots =[plots pl];
        leg = [leg {'expanded node'}];
        m = 0;
    end
    if c && color == 'c'
        pl = plot(2*s*xmax,2*s*ymax,'.c');
        plots =[plots pl];
        leg = [leg {'base station'}];
        c = 0;
    end
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
    if y && color == 'y'
        pl = plot(2*s*xmax,2*s*ymax,'.y');
        plots =[plots pl];
        leg = [leg {'path nodes'}];
        y = 0;
    end
    text(P(i,1),P(i,2),num2str(i))
end

%% plot edges
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

%legend(plots,leg)

end