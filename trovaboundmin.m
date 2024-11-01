function [Px,Py] = trovaboundmin(Rv,H)
% trova = find
% connesso = connected

global a b xmin xmax ymin ymax rv

%% coverage for horizontal lines from bottom to top
Px = [];
Py = [];
dy = H/3;

if a == 0 && b == 0
    return
end

% turn the rectangle if  b <= rv && a > rv
swap = 0;
if b <= rv && a > rv
    swap = a;
    a = b;
    b = swap;
    swap = xmin;
    xmin = ymin;
    ymin = swap;
    swap = xmax;
    xmax = ymax;
    ymax = swap;
    swap = 1;
end

if a <= rv
    dy = a/2;
end
i = 0;
lastrow = 0;
px = -Inf;
py = -Inf;
ppx = -Inf;
ppy = -Inf;
bb = 0;

while dy <= a+2/3*H
    
    % complation of the last row on the top
    if dy > a
        if ymax-(dy-H) <= rv
            lastrow = 1;
            l = length(Px);
            px = Px(end);
            py = Py(end);
            if l > 1
                ppx = Px(l-1);
                ppy = Py(l-1);
            end
        end
        dy = a;
    end
    
    % horizontal offset for the horizontal deployment
    if b > rv
        if mod(i,2)
            dx = xmin;
        else
            dx = xmin+Rv/2;
        end
    else
        dx = b/2;
    end
    
    if a <= rv
        bb = sqrt(rv^2-(a/2)^2);
        dx = xmin+bb;
    end
    
    % horizontal deployment
    j = 0;
    while dx <= b
        Px = [Px dx];
        Py = [Py dy];
        j = j+1;
        if a > rv
            dx = dx+Rv;
        else
            dx = dx+2*bb;
        end
    end
    if a <= rv
        dx = dx-2*bb;
        if dx+rv < b
            if swap
                dx = ymax;
            else
                dx = xmax;
            end
            Px = [Px dx];
            Py = [Py dy];
        end
    elseif dx-Rv+Rv/2 <= b
        dx = xmax;
        Px = [Px dx];
        Py = [Py dy];
        l = length(Px);
        if dy+H > a+2/3*H && (norm([Px(l) Py(l)]-[Px(l-1) Py(l-1)]) <= rv...
                || norm([Px(l) Py(l)]-[Px(l-j) Py(l-j)]) <= rv)
            Px(end) = [];
            Py(end) = [];
        end
    end
    
    dy = dy+H;
    i = i+1;
    if a <= rv
    	break;
    end
end

% remove robot on the top right corner
l = length(Px);
if l > 1
    xend = (px+ppx)/2;
    yend = Py(end); 
    if lastrow && (norm([xend yend]-[px py]) <= rv ||...
            norm([xend yend]-[ppx ppy]) <= rv)
        Px(l) = [];
        Py(l) = [];
    end
end

if swap
    swap = a;
    a = b;
    b = swap;
    swap = Px;
    Px = Py;
    Py = swap;
    swap = xmin;
    xmin = ymin;
    ymin = swap;
    swap = xmax;
    xmax = ymax;
    ymax = swap;
end


end