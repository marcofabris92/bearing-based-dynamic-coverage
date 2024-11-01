function [room,transition] = Scenario(casescenario)

%% DEFINE THE WALL SEGMENTS OF THE ENVIRONMENT TO BE EXPLORED AND DRAW IT 

% svx = [0 2 5 4 2 1 3 0 -1 1 0 -2 -5 -4 -2 -1 -3 0 1 -1];
% svy = [1 3 0 -1 1 0 -2 -5 -4 -2 -1 -3 0 1 -1 0 2 5 4 2];


% rectx = [0 25 25 0];
% recty = [0 0 20 20];
% room = [rectx;recty];
% transition = length(rectx);

% rectx = 3*[-5 5 5 -5];
% recty = 3*[-5 -5 5 5];
% 
% 
% intx = rectx*1/3;
% inty = recty*1/3;
% room = [rectx intx;recty inty];
% transition = [length(rectx) length(intx)];





%% ROOM FOR THE PRESENTATION

% room_x = [ 0 4 4    5    10 4 0 0     18    18   19 21   21 19  18  18 10   9   9 5 5   4   4];
% room_y = [ 3 3 2.5  6     9  7 7 9    12    7    8   8   0  0.5 0.5 0  0    0.5 0 0 0.5 0.5 0];
% room = [room_x ; room_y];
% int_x = [19 19  18 10 10 9 9 10 10 18 18];
% int_y = [2.55 5  3.25 3.25 4 6 2.55 2.55 2.75 2.75 2.55];
% int2_x = [ 12 16 16];
% int2_y = [ 10 10 5.5];
% int = [int_x ; int_y];
% int2 = [int2_x ; int2_y];
% room = [room int int2];
% transition = [length(room_x) length(int_x) length(int2_x)];

%% PAPER MED 2019, ISRAEL

switch casescenario
    case 'obstacles'
        
        wallx = 3*[-5 5 5 -5];
        wally = 3*[-5 -5 5 5];
        
        obst1x = [-1 1 1 -1];
        obst1y = [5 5 7 7];
        obst2x = [-15 -5 -3 -5];
        obst2y = [0 0 -5 -5];
        obst3x = [5 5];
        obst3y = [-15 1];
        obst4x = [5 7];
        obst4y = [0 0];
        obst5x = [10 12.5 15];
        obst5y = [15 12.5 15];
        obst6x = [-5 -5];
        obst6y = [0 2];
        obst7x = [-5 -6];
        obst7y = [2 2];
        obst8x = [10 11 10 9];
        obst8y = [-12 -13 -14 -13];
        
        room = [wallx obst1x obst2x obst3x obst4x obst5x obst6x obst7x obst8x;...
            wally obst1y obst2y obst3y obst4y obst5y obst6y obst7y obst8y];
        
        transition = [length(wallx) length(obst1x) length(obst2x)...
            length(obst3x) length(obst4x) length(obst5x)...
            length(obst6x) length(obst7x) length(obst8x)];
        
    case 'openspace'
        
        wallx = 3*[-5 5 5 -5];
        wally = 3*[-5 -5 5 5];
        
        
        room = [wallx ;...
            wally ];
        
        transition = [length(wallx) ];
end

end