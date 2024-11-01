%% plot of the graph G
% P is the plane coordinate matrix for each node
% each row of P contains the coordinates (x,y)

function [] = plotGPMED(G,P,F0,F1,O1)

global rv room transition diam ftsz lw muE

if isempty(O1)
    O1 = int16.empty(0,2);
end
if isempty(F1)
    F1 = int16.empty(0,2);
end

R = diam/2;
xmin = min(room(1,:));
xmax = max(room(1,:));
ymin = min(room(2,:));
ymax = max(room(2,:));


%% adding vision circles
plot((xmin+xmax)/2,(ymin+ymax)/2);
hold on

%% plot scenario
plots = [];
leg = {};
gray = 110*[1 1 1]/255;
i = 1;
j = 0;
for cont=1:length(transition)
    t = transition(cont); 
    while  i <= j+t
        if i == j+t
            pl = plot([room(1,i),room(1,j+1)],[room(2,i),room(2,j+1)],...
                'color', gray,'linewidth',2);
        else
            pl = plot(room(1,i:i+1),room(2,i:i+1),'color',gray,'linewidth',2);
        end
        i = i+1;
    end
    j = i-1;
end
plots = [plots pl];
leg = [leg {'OB'}];

%% plot circles
darkgreen = [50,205,50]/255;
yellow = [153 255 153]/255; %[255 255 153]/255;
l = length(P(:,1));
for i = 1:l
    ang = 0:0.01:2*pi; 
%     xp = rv*cos(ang);
%     yp = rv*sin(ang);
%     pl = plot(P(i,1)+xp,P(i,2)+yp,'--','color',yellow);
%     if i == 1
%         plots = [plots pl];
%         leg = [leg {'Visib.'}];
%     end
    xxp = R*cos(ang);
    yyp = R*sin(ang);
    pl = plot(P(i,1)+xxp,P(i,2)+yyp,'color',darkgreen,'linewidth',2.5);
    if i == 1
        plots = [plots pl];
        leg = [leg {'Body'}];
        alp = 1;
        pl = plot(P(i,1)+alp*xxp,P(i,2)+alp*yyp,'color',darkgreen/2,...
            'linewidth',2.5);
        plots = [plots pl];
        leg = [leg {'BS'}];
    end
end

%% plot robots
s = 1.1;
axis([xmin-rv xmax+rv ymin-rv ymax+rv])
grid on
b = 1;
r = 1;
for i=1:l
    color = 'b';
    if ismember(i,F0)
        color = 'r';
    end
    pl = scatter(P(i,1),P(i,2),'o',color,'MarkerFaceColor',color,'linewidth',lw-1);
    if b && color == 'b'
        plots =[plots pl];
        leg = [leg {'$\mathcal{V}_{\overline{CL}}$'}];
        b = 0;
    end
    if r && color == 'r'
        plots =[plots pl];
        leg = [leg {'$\mathcal{V}_{CL}$'}];
        r = 0;
    end
end

%% plot edges
E = table2array(G.Edges);
l = length(E(:,1));
m = 1;
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
    color = 'b';
    if ismember([v1 v2],F1,'rows')
        color = 'r';
    end
    if ismember([v1 v2],O1,'rows')
        color = 'm';
    end
    
    pl = plot(edgeline(1,:),edgeline(2,:),color);
    if b && color == 'b'
        plots = [plots pl];
        leg = [leg {'$\mathcal{E}_{\overline{CL}}$'}];
        b = 0;
    end
    if r && color == 'r'
        plots = [plots pl];
        leg = [leg {'$\mathcal{E}_{CL}$'}];
        r = 0;
    end
    if m && color == 'm'
        plots = [plots pl];
        leg = [leg {'$\partial\mathcal{E}_{CL}$'}];
        m = 0;
    end
end

%% plot event
pl = plot(muE(1),muE(2),'pk','MarkerFaceColor','y','MarkerSize',15,...
    'MarkerEdgeColor',[255 128 0]/255,'linewidth',1);
plots = [plots pl];
leg = [leg {'$EV$'}];

for i = 1:length(P(:,1))
    str_i = strcat(['$' num2str(i) '$']);
    text(P(i,1)-diam,P(i,2),str_i,'FontSize',ftsz-8,'Interpreter','latex',...
        'HorizontalAlignment','right')
end


XYTicks = -20:5:20;
set(gca,'fontsize', ftsz,'XTick',XYTicks,'YTick',XYTicks)
xlabel('$x$ [m]','Interpreter',...
    'latex', 'FontSize', ftsz, 'linewidth', lw);
ylabel('$y$ [m]','Interpreter',...
    'latex', 'FontSize', ftsz, 'linewidth', lw);
set(gca,'TickLabelInterpreter','latex')


plots_ = plots;
leg_ = leg;

plots(1) = plots_(3);
plots(3) = plots_(1);
plots(4) = plots_(9);
plots(5) = plots_(4);
plots(6) = plots_(5);
plots(7) = plots_(6);
plots(9) = plots_(7);

leg(1) = leg_(3);
leg(3) = leg_(1);
leg(4) = leg_(9);
leg(5) = leg_(4);
leg(6) = leg_(5);
leg(7) = leg_(6);
leg(9) = leg_(7);

% a = plots(end-1);
% plots(end-1) = plots(end-2);
% plots(end-2) = a;
% a = leg(end-1);
% leg(end-1) = leg(end-2);
% leg(end-2) = a;
% a = plots(1);
% plots(1) = plots(3);
% plots(3) = a;
% a = leg(1);
% leg(1) = leg(3);
% leg(3) = a;

% LEFT BOTTOM WIDTH HEIGH
% old position [0.825    0.332    0.1683    0.3925]
leg_plotGPMED = legend(plots,leg,'Position',...
    [0.825    0.332    0.1683    0.3925]); 
% leg_plotGPMED = legend(plots,leg,'Position',...
%     [0.21731957347393 0.114 0.597347093192736 0.0873333333333336],...
%     'NumColumns',5); 

 
leg_plotGPMED.FontSize = ftsz;
leg_plotGPMED.Interpreter = 'latex';

end



