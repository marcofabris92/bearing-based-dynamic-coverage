function robot_can_move = dispatch_law(i,j,k)

% i: leader 1
% j: leader 2
% k: moving agent
%
% Policy: 
% 1) move k in the bisector of angle ikj
% 2) try to minimize conductance_G moving k
% Constraints:
% 1) maintain invariate Nk... be careful to respect visibility between walls
% 2) stop if a physical obstacle is present

global G rv P step_division stop_dispatch diam F0 data_bnn count_bnn

%fprintf('--- ENTERING ---\n')

    
    % finds the movement direction for k
    ki = P(i,:)-P(k,:);

    % heading direction for the dispatch: heading towards an single agent,
    % with this policy
    dir_k = ki'/norm(ki);
    distmax_bisect = norm(ki);
    
    
    % movement loop
    step_cnt = 0;
    step = distmax_bisect/step_division;
    
    robot_can_move = 1;
    while robot_can_move && step_cnt < step_division
        %fprintf('loop to reduce hG has started\n')
        %P(k,:)
        step_cnt = step_cnt+1;
        current_position_k = P(k,:)';
        try_position_k = current_position_k+dir_k*step;
        
        % reshape everything after crash (wall collisions)
        [new_position_k,~,hasCrashed,~] = realPlace(...
            current_position_k,try_position_k);
        if hasCrashed && norm(try_position_k-new_position_k) <= diam
            robot_can_move = 0;
            %fprintf('wall exit\n')
            return
        end
        try_position_k = new_position_k';
        
        % reshape everything after crash (robot collisions)
        [new_position_k,expn] = robotCrash(try_position_k,k);
        if expn == 0
            robot_can_move = 0;
            %fprintf('agents exit\n')
            return;
        end
        try_position_k = new_position_k';
        
        % visibility check: if no visibility then do not update the 
        % current position current_pos_k
        Nk = neighbors(G,k);
        visibility_cnt = 0;
        while robot_can_move && visibility_cnt < length(Nk)
            visibility_cnt = visibility_cnt+1;
            h = Nk(visibility_cnt);
            if norm(try_position_k-P(h,:)') > rv ||...
                    ~isVisible(try_position_k,P(h,:)')
                robot_can_move = 0;
                %fprintf('visibility exit\n')
                return;
            end
        end
        
        % checks whether the cluster volume increases
        robot_can_move = isVolIncr(k, try_position_k);
        data_bnn = [data_bnn bottleneckedness()];
        count_bnn = count_bnn+1;

        
        % if none of the robot can move then it is time to end the dispatch
        % hence I turn the general flag down
        if stop_dispatch && robot_can_move
            %fprintf('stop_dispatch deactivated\n')
            stop_dispatch = 0;
        end
        
    end
    
    
    plotGP(G,P,F0,[],[],[],[]);
    hold off
    drawnow
    
    
    


%fprintf('--- EXITING ---\n')

end

