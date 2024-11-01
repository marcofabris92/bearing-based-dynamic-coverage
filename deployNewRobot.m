function [robots,expn,path] = deployNewRobot(F0,F1,R2)

global G

robots = numnodes(G);

%% 6) FIND PATH FOR PUSHING ROBOTS
[newPlace,expn,path,hasCrashed,H] = pushing(F0,F1,R2);

%% 8) DEPLOY NEXT ROBOT
if expn
    robots = deployNext(newPlace,hasCrashed,H);
end


end

