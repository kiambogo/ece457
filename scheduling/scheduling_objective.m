% Objective function to evaluate scheduling a training plan

% calendar is an array of booleans representing if a 15 min segment is busy
% calendar = [0 1 1 1 1 0 0 0 0 0 1 1 1 1 1 1 1 0 0 0 0 ...];

% scheduled_training_plan is a list of the activities with associated
% start_time
% scheduled_training_plan = [X_id X_duration X_start; ...]

% Returns the fitness of a scheduled training plan

function fitness = scheduling_objective(scheduled_training_plan, calendar)
    global U_PRE U_POST cal_size;
    
    % Calendar size is 1344 15min segments
    CAL_SIZE = 1344;
    % Pre exercise window is 1 15min window
    U_PRE = 1;
    % Post exercise window is 2 15min windows
    U_POST = 2;
    
    % Calculates the percent overlap between a period of time and a
    % calendar event
    % Return type is a 3 value vector of pre, during, post
    function o = O(start, finish, calendar)
        busy_pre_size = 0;
        busy_during_size = 0;
        busy_post_size = 0;
        for j = start-U_PRE:start
            busy_pre_size = busy_pre_size + calendar(j);
        end
        for j = start:finish
            busy_during_size = busy_during_size + calendar(j);
        end
        for j = finish:finish+U_POST
            busy_post_size = busy_post_size + calendar(j);
        end
        total_size = busy_pre_size + busy_during_size + busy_post_size;
        if total_size == 0
            o = [0 0 0];
        else o = [busy_pre_size/total_size busy_during_size/total_size busy_post_size/total_size];
        end
    end

    % Calculates the penalty for overlap between an activity and a calendar
    % event
    function ov = OV(activity, calendar)
        act_duration = activity(2);
        act_start = activity(3);
        o = O(act_start, act_start+act_duration, calendar);
        ov = 50 * o(1) + 300 * o(2) + 50 * o(3);
    end

    function g = G(scheduled_training_plan, calendar)
        g = 0;
        for k = 1:size(scheduled_training_plan, 1)
            g = g + OV(scheduled_training_plan(k,:), calendar);
        end
    end

    function r = R(eff, t)
        r = 0;
        if t < eff/100
            r = (-3000000/(eff*eff)) * t^3 + (45000/eff)*t^2;
        else
            r = 8*t + (3/2)*eff - (8/100)*eff;
        end
    end

    function w = W(x)
        if (x(2)*15 >= 30 && x(2)*15 < 60)
            w=120+randn(1)*15;
        elseif (x(2)*15 >= 60 && x(2)*15 <= 120)
            w=250+randn(1)*30;
        else
            w=2.75*x(2)*15;
        end
    end

    function h = H(scheduled_training_plan)
        h = 0;
        for n = 1:size(scheduled_training_plan,1)-1
            act = scheduled_training_plan(n,:);
            effort = W(act);
            h = h + abs((R(effort, (effort/200)) - R(effort,(scheduled_training_plan(n+1,3)-act(3))/96)));
        end
    end

    fitness = 0;
    g = G(scheduled_training_plan, calendar)
    h = H(scheduled_training_plan)
    fitness = g + h;
end
