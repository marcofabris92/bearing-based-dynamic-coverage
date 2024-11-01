function [Px,Py] = trovaboundconnesso(rv,h)
% trova = find
% connesso = connected
global a b xmin xmax ymin ymax


%% coverage for horizontal lines from bottom to top
Px = [];
Py = [];
dy = h;

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

if b <= rv
    dy = rv;
end
if a <= rv
    dy = a/2;
    bb = sqrt(rv^2-(a/2)^2);
    dx = xmin+bb;
    if dx > b
        dx = b/2;
    end
end
i = 0;
while dy <= a
    
    % horizontal offset for the horizontal deployment 
    if b > rv && a > rv
        if mod(i,2)
            dx = xmin+rv;
        else
            dx = xmin+rv/2;
        end
    end
    % horizontal deployment
    j = -1;
    while dx <= b
        Px = [Px dx];
        Py = [Py dy];
        dx = dx+rv;
        j = j+1;
    end
    
    % right wall gap
    if i == 0
        s = Px(end);
    end
    if i == 1 && Px(end) < s
        s = Px(end);
    end
    
    % lower bottom angle coverage
    if dy == h
        if norm([dx-rv dy]-[xmax ymin]) > rv
            Px = [Px xmax];
            Py = [Py dy];
            j = j+1;
        end
    end
    
    dy = dy+h;
    if b <= rv && dy+rv <= a
    	dv = dy+rv;
    end
    
    % coverage angoli in alto a sinistra/destra
    % coverage for the top corners (left/right)
    if dy > a && b > rv
        ddy = dy-h;
        xend_j = Px(end-j);
        xend = Px(end);
        if norm([xend_j ddy]-[xmin ymax]) > rv
            ds = rv-(xmax-s);
            xend_j = xend_j-ds;
            if norm([xend_j ddy]-[xmin ymax]) > rv
                Px = [Px xmin];
                Py = [Py ddy];
            else
                Px = Px-ds;
                xend = xend-ds;
            end
        end
        if norm([xend ddy]-[xmax ymax]) > rv
            Px = [Px xmax];
            Py = [Py ddy];
        end
    end
    
    i = i+1;
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