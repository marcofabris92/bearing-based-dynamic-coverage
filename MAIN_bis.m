clear all
close all
clc

global G P ns rv room transition diam rp fdistance frazrv F0 F1 O0 O1...
    step_division muE rEV uncov_pr kf ...
    desired_cluster_nodes stop_dispatch contact_tol ftsz lw prim...
    count_bnn data_bnn new_edge_clst SNR

ftsz = 25;
lw = 2;
q = 750;
% [left bottom width height]
%pos_predn = [10 30 q q];
pos_predn = [10 30 q-180 q-150];
%pos_eventn = [1800 400 q+50 q+100];
pos_eventn = [1800 400 q-180 q-150];
%pos_funcn = [1800 -600 q-100 q-50];
pos_funcn = [1800 -600 q-150 q-120];
%pos_posdn = [800 30 q q];
pos_posdn = [800 30 q-180 q-150];

%% SIMULATION CHOICE
nn = 3;
%path_ = 'C:\Users\marco\Dropbox\PhD-Marco\Coverage&Dispatch\Paper_MED19\IMAGES'; % ufficio & casa
path_ = '../Paper_MED19/IMAGES'; % Angelo's Mac
formattype = 'epsc';
switch nn
    case 1
        casescenario = 'openspace';
        basestation = [0 0];
        muEs = [1 0];
        SNR_ = +Inf;
        dispatch_sessions_ = 10;
        desired_cluster_nodes_ = 15;
    case 2
        casescenario = 'obstacles';
        basestation = [0 0];
        muEs = [1 0;
                -15 0;
                0 6];
        SNR_ = [15 10 10];
        dispatch_sessions_ = [10 15 15];
        desired_cluster_nodes_ = [15 10 10];
    case 3
        casescenario = 'openspace';
        basestation = [14 0];
        muEs = [0 0];
        SNR_ = +Inf;
        dispatch_sessions_ = 10;
        desired_cluster_nodes_ = 15;
end
nn = num2str(nn);

%% COVERAGE REGION
[room,transition] = Scenario(casescenario);

%% PARAMETER SETUP
rv = 10;       % maximum distance between two robots (rv > 0)
G = graph;     % graph initialization
ns = 4;        % number of sensors, multiple of 4
diam = 1;      % robot diameter
rp = 0;        % deployment noise
fdistance = 0; % minimum distance between fence and basestation
frazrv = 0.99; % fraction for which the expation is not maximally carried out (i.e. until rv)
prim = 0.5;    % probability of rimoving useless robots at each iteration
pfailure = 0;  % probability of failure for a robot
uncov_pr = int16.empty(0,2); % flag used to check sharp-cornered coverage issues
step_division = 100;
contact_tol = 50;
rEV = 15;
kf = 160;

%% 1) DEPLOYMENT OF THE FIRST ROBOT
P = basestation;
F1 = int16.empty(0,2);
F0 = 1;
G = addnode(G,1);
G.Nodes.contact(1,ns) = 0;
G.Nodes.contact(1,:) = zeros(1,ns); % TO BE PLACED WITH CENTRAL BS
%G.Nodes.contact(1,:) = [0 0 1 1]; % TO BE PLACED WITH BS IN THE CORNER
G.Nodes.isobstacle(1) = 0;
G.Nodes.isfence(1) = 1;
G.Nodes.isredundant(1) = 0;
G.Nodes.basedist(1) = 0;
G.Nodes.event_intensity(1) = 0;
G.Nodes.event_cluster(1) = 0;
G.Nodes.dispatched(1) = 0;
G.Nodes.completed(1) = 0;
G.Nodes.k(1) = 1; % % counte for buildingClustering
G.Nodes.kbar(1) = 1; % % counter for buildingClustering
G.Nodes.filt_count(1) = 1; % counter for filtering

robots = 1;
useless = [];

%% 2) MAIN LOOP
                % 'Position', [left bottom width height]
cycle_depl = figure('Position',[0 0 800 800]);
grid on
drawnow
cycl = -1;
while ~isempty(F0) || ~isempty(F1)

    % remove useless
    if ~isempty(useless) && rand > 1-prim
        robots = removeUseless(useless);
    end
    
    % robot failure
    if rand > 1-pfailure && robots > 1
        robots = removeUseless(1+ceil(rand((numnodes(G)-1))))
    end

    %% 3) CONSTRUCTION OF THE RIPS CPLX
    uncov_pr = int16.empty(0,2);
    [R1,R2] = computeRipsComplex();
    
    
    %% 4) CONSTRUCTION OF THE FENCE SUBCPLX
    fenceSubcomplex(R1,R2);

    %% 9) CHECKING EXITING CONDITION FROM THE LOOP
    if isempty(F0) && isempty(F1)
        break;
    end
    
    %% 5) REDUNDANT ROBOTS IDENTIFICATION
    useless = findRedundant(R2);

    %% ATTEMPT TO DEPLOY NEW ROBOT
    [robots,expn,path] = deployNewRobot(F0,F1,R2);
    robots
    
    % grafico
    cycl = cycl+1;
    if expn
      
        % nn=3
%             text(-7,-21,strcat('#AGENTS = ',{' '},num2str(robots)),'fontsize',ftsz)
%             text(-8,-24,strcat('#ITERATIONS = ',{' '},num2str(cycl)),'fontsize',ftsz)
%             axis equal
%             figure(cycle_depl);
%             axis equal
%             f_cycle_depl = strcat('cycle_depl-',num2str(cycl),'.pdf');
%             eval(['print -dpdf -painters ' f_cycle_depl])
        
        plotGP(G,P,F0,F1,O0,O1,path);
        hold off
        drawnow;
    end
    

end
cycl = cycl+1;
%% LOOP TO REMOVE USELESS ROBOTS

done = 0;
while ~done
    [R1,R2] = computeRipsComplex();
    useless = findRedundant(R2);
    if isempty(useless)
        done = 1;
    else
        robots = removeUseless(useless);
    end
end

fprintf('ciclo inutili\n')
P
robots

% nn=3
% text(-7,-21,strcat('#AGENTS = ',{' '},num2str(robots)),'fontsize',ftsz)
% text(-8,-24,strcat('#ITERATIONS = ',{' '},num2str(cycl)),'fontsize',ftsz)
% axis equal
% figure(cycle_depl);
% axis equal
% f_cycle_depl = strcat('cycle_depl-',num2str(cycl),'.pdf');
% eval(['print -dpdf -painters ' f_cycle_depl])


%% GRAPHIC ASSIGNMENT OF THE OBSTACLES
O1 = int16.empty(0,2);
O0 = [];
for t = 1:length(R1(:,1))
    i = R1(t,1);
    j = R1(t,2);
    flagi = G.Nodes.isobstacle(i);
    flagj = G.Nodes.isobstacle(j);
    if flagi
        O0 = union(O0,i);
    end
    if flagj
        O0 = union(O0,j);
    end
    if flagi && flagj || G.Edges.Weights(findedge(G,i,j)) == -1
        O1 = union(O1,[i j],'rows');
    end
end

%% Voronoi plot
% figure
% hold on
% voronoi(P(:,1),P(:,2));
% % plot scenario
% i = 1;
% j = 0;
% for cont = 1:length(transition)
%     c = transition(cont); 
%     while  i <= j+c
%         if i == j+c
%             plot([room(1,i),room(1,j+1)],[room(2,i),room(2,j+1)],'k','linewidth',2)
%         else
%             plot(room(1,i:i+1),room(2,i:i+1),'k','linewidth',2)
%         end
%         i = i+1;
%     end
%     j = i-1;
% end
% axis([min(room(1,:)) max(room(1,:)) min(room(2,:)) max(room(2,:))])
% hold off

%% plot of the final situazion
figure 
hold on
plotGP(G,P,[],[],O0,O1,[]);
hold off
drawnow

diam = diam-contact_tol*eps;
Pbackup = P;
Gbackup = G;

% close all
%% EVENT LOOP
for kkk = 1:length(muEs(:,1))
    % close all
    P = Pbackup;
    G = Gbackup;
    muE = muEs(kkk,:);
    SNR = SNR_(kkk);
    dispatch_sessions = dispatch_sessions_(kkk);
    desired_cluster_nodes = desired_cluster_nodes_(kkk);
    
    % CLUSTERING 

    leader_node1 = clustering();

    predn = figure;
    set(gcf, 'Position', pos_predn);
    F0 = [];
    for i = 1:numnodes(G)
        if G.Nodes.event_cluster(i)
            F0 = union(F0,i);
        end
    end
    F1 = int16.empty(0,2);
    O1 = int16.empty(0,2);
    for i = 1:numnodes(G)
        Ni = neighbors(G,i);
        for j = 1:length(Ni)
            k = Ni(j);
            if G.Nodes.event_cluster(k) && ~G.Nodes.event_cluster(i)
                O1 = union(O1,sort([i k]),'rows');
            end
            if G.Nodes.event_cluster(k) && G.Nodes.event_cluster(i)
                F1 = union(F1,sort([i k]),'rows');
            end
        end
    end
    hold on
    plotGPMED(G,P,F0,F1,O1)
    drawnow

    % PLOT OF THE SENSING BELL

    eventn = figure;
    set(gcf, 'Position', pos_eventn);
    delta = 0.1;
    xn = -15;
    xp = 15;
    yn = -15;
    yp = 15;
    [XX,YY] = meshgrid(xn:delta:xp,yn:delta:yp);
    fP = zeros(numedges(G),1);
    eP = zeros(numedges(G),2);
    for k = 1:numedges(G)
        fP(k) = G.Edges.Weights(k);
        ii = G.Edges.EndNodes(k,1);
        jj = G.Edges.EndNodes(k,2);
        eP(k,:) = (P(ii,:)+P(jj,:))/2;
    end
    ZZ = griddata(eP(:,1),eP(:,2),fP,XX,YY,'cubic');
    surface_sensed = surf(XX,YY,ZZ);
    surface_sensed.EdgeColor = 'none';
    surface_sensed.FaceAlpha = 0.90;
    surface_sensed.FaceColor = [255 0 0]/255;

    ZZ = zeros(length(XX));
    for i = 1:length(XX)
        for j = 1:length(XX)
            PXY = [XX(i,j) YY(i,j)];
            ZZ(i,j) = kf*exp(-norm(muE-PXY)^2/rEV^2);

        end
    end
    hold on
    surface_original = surf(XX,YY,ZZ);
    surface_original.EdgeColor = 'none';
    surface_original.FaceAlpha = 0.25;
    surface_original.FaceColor = [0 0 0];

    XYTicks = -20:10:20;
    ZTicks = 0:50:kf;
    set(gca,'fontsize', ftsz,'XTick',XYTicks,'YTick',XYTicks,'ZTick',ZTicks)
    zlim([0 kf]);
    xlabel('$x$ [m]','Interpreter',...
        'latex', 'FontSize', ftsz, 'linewidth', lw);
    ylabel('$y$ [m]','Interpreter',...
        'latex', 'FontSize', ftsz, 'linewidth', lw);
    %zlabel('$f_{EV}(x,y)$','Interpreter',...
        %'latex', 'FontSize', ftsz, 'linewidth', lw);
    set(gca,'TickLabelInterpreter','latex')
    leg_gauss = legend([surface_original surface_sensed],...
        {'Real $f_{EV}(x,y)$','Sensed $\hat{f}_{EV}(x,y)$'},'Location','NorthEast');
    leg_gauss.FontSize = ftsz;
    leg_gauss.Interpreter = 'latex';


    % PLOT OF THE SENSING COUNTOUR
    eventn = figure;
    set(gcf, 'Position', pos_eventn);
    delta = 0.1;
    xn = -15;
    xp = 15;
    yn = -15;
    yp = 15;
    [XX,YY] = meshgrid(xn:delta:xp,yn:delta:yp);
    fP = zeros(numedges(G),1);
    fPreal = zeros(numedges(G),1);
    eP = zeros(numedges(G),2);
    for k = 1:numedges(G)
        fP(k) = G.Edges.Weights(k);
        ii = G.Edges.EndNodes(k,1);
        jj = G.Edges.EndNodes(k,2);
        eP(k,:) = (P(ii,:)+P(jj,:))/2;
        fPreal(k) = freal(eP(k,:));
    end
    ZZ = griddata(eP(:,1),eP(:,2),fPreal-fP,XX,YY,'cubic');
    cof = contourf(XX,YY,ZZ,10);
    hold on
    cbar = colorbar('southoutside');
    cbar.Label.String = '$f_{EV}(x,y)-\hat{f}_{EV}(x,y)$';
    cbar.TickLabelInterpreter = 'latex';
    cbar.FontSize = ftsz;
    cbar.Label.Interpreter = 'latex';
    cbar.Label.FontSize = ftsz;
    
    lambd = linspace(0,1);
    edge_seg = zeros(length(lambd),2);
    for k = 1:numedges(G)
        ii = G.Edges.EndNodes(k,1);
        jj = G.Edges.EndNodes(k,2);
        for kk = 1:length(lambd)
            edge_seg(kk,:) = P(ii,:)*lambd(kk)+P(jj,:)*(1-lambd(kk));
        end
        plot(edge_seg(:,1),edge_seg(:,2),'k','linewidth',2.5);
        plot(edge_seg(:,1),edge_seg(:,2),'m','linewidth',1.5);
        scatter(eP(k,1),eP(k,2),'xk','linewidth',2);
    end
    for k = 1:numnodes(G)
        scatter(P(k,1),P(k,2),'o','k','MarkerFaceColor','m');
    end
    
    grid on
    XYTicks = -20:5:20;
    set(gca,'fontsize', ftsz,'XTick',XYTicks,'YTick',XYTicks)
    xlabel('$x$ [m]','Interpreter',...
        'latex', 'FontSize', ftsz, 'linewidth', lw);
    ylabel('$y$ [m]','Interpreter',...
        'latex', 'FontSize', ftsz, 'linewidth', lw);
    set(gca,'TickLabelInterpreter','latex')
    drawnow

    
    % DISPATCH (loop for getting close to the event... to be decided)

    disp_fig = figure;
    hold on
    plotGP(G,P,F0,[],[],[],[]);
    hold off
    drawnow

    
    data_bnn = bottleneckedness();
    new_edge_clst = [];
    data_len = zeros(1,dispatch_sessions);
    stop_dispatch = 0;
    dispatch_counter = 0;
    data_len(1) = 1;
    while ~stop_dispatch && dispatch_counter < dispatch_sessions
        %%
%         text(-4,-17.5,strcat('SESSION = ',{' '},num2str(dispatch_counter)))
%         axis equal
%         figure(disp_fig);
%         axis equal
%         disp_name = strcat('disp-',num2str(dispatch_counter),'.pdf');
%         eval(['print -dpdf -painters ' disp_name])
        %%
        pause
        dispatch_counter = dispatch_counter+1;
        dispatch_counter
        count_bnn = 0;
        if dispatch_counter == 1
            count_bnn = 1;
        end
        stop_dispatch = 1;
        max_intensity = 0;
        for i = 1:numnodes(G)
            G.Nodes.dispatched(i) = 0; 
            if G.Nodes.event_intensity(i) > max_intensity &&...
                    G.Nodes.event_cluster(i)
                max_intensity = G.Nodes.event_intensity(i);
                leader_node1 = i;
            end
        end
        dispatch(leader_node1);
        
        

       data_len(dispatch_counter) = count_bnn;
    end

    % DEPICTING THE DECREASING FUNCTIONAL
    
    funcn = figure;
    set(gcf, 'Position', pos_funcn);
    grid on
    hold on
    
    

    blue = [30,144,255]/255;

    einf = 0;
    for kk = 1:dispatch_counter
        if data_len(kk) > 0
            esup = einf+data_len(kk);
            if kk == 1
                einf = 1;
            end
            area(einf-1:esup-1,data_bnn(einf:esup),'FaceColor',blue,...
                'FaceAlpha',1/(0.75+kk));
            einf = esup;
        end
    end
    for kk = 1:length(new_edge_clst)
        ii = new_edge_clst(kk);
        stem(ii-1,data_bnn(ii),'color',[139,0,139]/255);
    end

    set(gca,'fontsize', ftsz)
    xlabel('\# iterations','Interpreter',...
        'latex', 'FontSize', ftsz, 'linewidth', lw);
    ylabel('$h_{\mathcal{G}}(\mathcal{G}_{CL})$','Interpreter',...
        'latex', 'FontSize', ftsz, 'linewidth', lw);
    set(gca,'TickLabelInterpreter','latex')
    axis([0 length(data_bnn) min(data_bnn) (1+10^-5)*max(data_bnn)])

    % FINAL SITUATION
    F1 = int16.empty(0,2);
    O1 = int16.empty(0,2);
    for i = 1:numnodes(G)
        Ni = neighbors(G,i);
        for j = 1:length(Ni)
            k = Ni(j);
            if G.Nodes.event_cluster(k) && ~G.Nodes.event_cluster(i)
                O1 = union(O1,sort([i k]),'rows');
            end
            if G.Nodes.event_cluster(k) && G.Nodes.event_cluster(i)
                F1 = union(F1,sort([i k]),'rows');
            end
        end
    end
    

    posdn = figure;
    set(gcf, 'Position', pos_posdn);
    hold on
    plotGPMED(G,P,F0,F1,O1)

    %%
    
    % SAVING
    kkk_ = strcat('_',num2str(kkk));
%     saveas(predn,fullfile(path_,strcat('f_predn',nn,kkk_)),formattype);
%     saveas(eventn,fullfile(path_,strcat('f_eventn',nn,kkk_)),formattype);
%     saveas(posdn,fullfile(path_,strcat('f_posdn',nn,kkk_)),formattype);
%     saveas(funcn,fullfile(path_,strcat('f_funcn',nn,kkk_)),formattype);
% 
%     extn = '.eps';
%     f_predneps = strcat('f_predn',nn,kkk_,extn);
%     f_eventneps = strcat('f_eventn',nn,kkk_,extn);
%     f_posdneps = strcat('f_posdn',nn,kkk_,extn);
%     f_funcneps = strcat('f_funcn',nn,kkk_,extn);
%     
%     figure(predn);
%     eval(['print -depsc -painters ' f_predneps])
%     figure(eventn);
%     eval(['print -depsc -painters ' f_eventneps])
%     figure(posdn);
%     eval(['print -depsc -painters ' f_posdneps])
%     figure(funcn);
%     eval(['print -depsc -painters ' f_funcneps])

    extn = '.pdf';
    f_predneps = strcat('f_predn',nn,kkk_,extn);
    f_eventneps = strcat('f_eventn',nn,kkk_,extn);
    f_posdneps = strcat('f_posdn',nn,kkk_,extn);
    f_funcneps = strcat('f_funcn',nn,kkk_,extn);
    
    figure(predn);
    % eval(['print -dpdf -painters ' f_predneps])
    figure(eventn);
    % eval(['print -dpdf -painters ' f_eventneps])
    figure(posdn);
    % eval(['print -dpdf -painters ' f_posdneps])
    figure(funcn);
    % eval(['print -dpdf -painters ' f_funcneps])
    
    % close all
    
end
fprintf('\n--- END ---\n')

%%
% posdn = figure;
% set(gcf, 'Position', pos_posdn);
% hold on
% plotGPMED(G,P,F0,F1,O1)
