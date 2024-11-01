function [new,dcrash,hasCrashed,crashPoint] = realPlace(S,D)

global room transition diam

R = diam/2;
S = [S(1) S(2)]';
D = [D(1) D(2)]';
crashPoint = [];   % crash point on the circle
distSD = norm(D-S);
dcrash = distSD;   % distanc from crash to S
hasCrashed = 0;    % crash flag 
cd = (D-S)/distSD; % current direction: heading
j = 1;

%% search crashes over all segments
for cont = 1:length(transition)
    L = j+transition(cont)-1;
    
    for i = j:L
        if i == L
            seg = [room(1,j) room(1,L); room(2,j) room(2,L)];         
        else
            seg = [room(1,i:i+1); room(2,i:i+1)];
        end
        
        % calcolo il punto T di presunta tangenza
        % compute the tangent point T, where crash is presumed
        [T,zeroDistCrash] = tangentPoint(seg,S);
        
        % exit 1, due to the movement impossibility from S
        if zeroDistCrash && (distpointline(D,seg) < R || cantMove(seg,S,D)) 
            new = S';
            dcrash = 0;
            hasCrashed = 1;
            crashPoint = T;
            return
        end
        
        % verifying collision on T
        [crash,dist] = changedir(seg,T(1),T(2),cd,distSD);
        
        % computing vertices-circle distance 
        v1 = seg(:,1);
        v2 = seg(:,2);
        distV1 = syslinecircle(v1,S,cd);
        distV2 = syslinecircle(v2,S,cd);
        [distV,iv] = min([distV1(1) distV2(1)]);
        vert = v1;
        infoV = distV1;
        if iv == 2 || length(distV1) == 1 && length(distV2) == 2 
            vert = v2;
            infoV = distV2;
            distV = distV2(1); 
        end
        
        % exit 2 due to zero distance from a vertex
        if distV < 50*eps && length(infoV) == 2
            new = S';
            dcrash = 0;
            hasCrashed = 1;
            crashPoint = vert;
            return
        end  
        
        % cases of tangent vertex/point
        crashVertex = 0;
        if distV <= distSD
            crashVertex = 1;
        end
        if crash && crashVertex
            [dist,tv] = min([dist distV]);
            if tv == 1
                crashVertex = 0;
            end
        elseif ~crash && crashVertex
            dist = distV;
            crash = 1;
        end
        
        % distance relaxation
        if crash && dist <= dcrash
            hasCrashed = 1;
            dcrash = dist;
            if ~crashVertex
                crashPoint = T+cd*dcrash;
            else
            	crashPoint = vert;
            end
        end
        
    end
    
    j = i+1;
end

%% re-deployment and turning on contacts
new = (S+cd*dcrash)';

end