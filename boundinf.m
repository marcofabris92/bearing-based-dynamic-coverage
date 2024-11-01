% test for the lower bound
close all
clc

global xmin xmax ymin ymax rv a b

xmin = 0;
ymin = 0;
xmax = 20%rand(1)*100;
ymax = 25%rand(1)*100;

a = ymax-ymin
b = xmax-xmin

rv = 5%ceil(max(a,b)/10)
h = sqrt(3)/2*rv;

%% 1 diagram (coverage+connetion)
[Px,Py] = trovaboundconnesso(rv,h);
G = graph;
G = addnode(G,length(Px));
figure
plotG2(G,[Px' Py'],[],[],[],[])

%% 1 discussione bound (coverage+connection)
fprintf('--- Minimum number of robots needed for the total coverage while having connectivity:')


boundTeorico = ceil((a-h)/h)*floor(b/rv)+1
if b <= rv && ~(a <= rv)
    fprintf ('b <= rv')
    boundTeoricoRicalcolato = floor(a/rv)
end
if a <= rv && ~(b <= rv)
    fprintf('a <= rv')
    boundTeoricoRicalcolato = floor(b/rv)
end
if a <= rv && b <= rv && a > 0 && b > 0
    fprintf('a <= rv && b <= rv')
    boundTeoricoRicalcolato = 1
end
if a <= 0 && b <= 0
    fprintf('a == 0 && b == 0')
    boundTeoricoRicalcolato = 0
end
boundReale = numnodes(G)


%% grafico (coverage minimo)

Rv = sqrt(3)*rv;
H = sqrt(3)*h; 
[Px,Py] = trovaboundmin(Rv,H);
G = graph;
G = addnode(G,length(Px));
figure
plotG2(G,[Px' Py'],[],[],[],[])

%% discussione bound (coverage minimo)
fprintf('--- Minimum number of robots needed for the total coverage:')


boundTeoricominimo = ceil((a+H/3)/H)*floor(b/Rv)-1,
if b <= rv && ~(a <= rv)
    fprintf ('b <= rv')
    boundTeoricominimoRicalcolato = ceil(a/(2*sqrt(rv^2-(b/2)^2)))
end
if a <= rv && ~(b <= rv)
    fprintf('a <= rv')
    boundTeoricominimoRicalcolato = ceil(b/(2*sqrt(rv^2-(a/2)^2)))
end
if a <= rv && b <= rv && a > 0 && b > 0
    fprintf('a <= rv && b <= rv')
    boundTeoricominimoRicalcolato = 1
end
if a <= 0 && b <= 0
    fprintf('a == 0 && b == 0')
    boundTeoricominimoRicalcolato = 0
end
boundReale = numnodes(G)



%% ------------------
% swap a/b
swap = a;
a = b;
b = swap;
swap = xmin;
xmin = ymin;
ymin = swap;
swap = xmax;
xmax = ymax;
ymax = swap;
fprintf('*************** SWAP **************\n')
    
%% 2 diagram (coverage+connection)
[Px,Py] = trovaboundconnesso(rv,h);
G = graph;
G = addnode(G,length(Px));
figure
plotG2(G,[Px' Py'],[],[],[],[])

%% 2 discussion on bound (coverage+connection)
fprintf('--- Minimum number of robots needed for the total coverage while having connectivity:')


boundTeorico = ceil((a-h)/h)*floor(b/rv)+1
if b <= rv && ~(a <= rv)
    fprintf ('b <= rv')
    boundTeoricoRicalcolato = floor(a/rv)
end
if a <= rv && ~(b <= rv)
    fprintf('a <= rv')
    boundTeoricoRicalcolato = floor(b/rv)
end
if a <= rv && b <= rv && a > 0 && b > 0
    fprintf('a <= rv && b <= rv')
    boundTeoricoRicalcolato = 1
end
if a <= 0 && b <= 0
    fprintf('a == 0 && b == 0')
    boundTeoricoRicalcolato = 0
end
boundReale = numnodes(G)

%% 2 diagram (minimum coverage)

Rv = sqrt(3)*rv;
H = sqrt(3)*h; 
[Px,Py] = trovaboundmin(Rv,H);
G = graph;
G = addnode(G,length(Px));
figure
plotG2(G,[Px' Py'],[],[],[],[])

%% 2 discussion on bound (minimum coverage)
fprintf('--- Minimum number of robots needed for the total coverage:')

boundTeoricominimo = ceil((a+H/3)/H)*floor(b/Rv)-1,
if b <= rv && ~(a <= rv)
    fprintf ('b <= rv')
    boundTeoricominimoRicalcolato = ceil(a/(2*sqrt(rv^2-(b/2)^2)))
end
if a <= rv && ~(b <= rv)
    fprintf('a <= rv')
    boundTeoricominimoRicalcolato = ceil(b/(2*sqrt(rv^2-(a/2)^2)))
end
if a <= rv && b <= rv && a > 0 && b > 0
    fprintf('a <= rv && b <= rv')
    boundTeoricominimoRicalcolato = 1
end
if a <= 0 && b <= 0
    fprintf('a == 0 && b == 0')
    boundTeoricominimoRicalcolato = 0
end
boundReale = numnodes(G)