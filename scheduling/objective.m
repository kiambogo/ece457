% Objective function to evaluate scheduling a training plan

% calendar = [A1_start A1_end; A2_start A2_end; ... AN_start AN_end]

% Returns the fitness of a scheduled training plan

function fitness = scheduling_objective(training_plan, calendar)
    global U_pre U_post
    
    % Pre exercise window is 10 min
    U_pre = 10;
    % Post exercise window is 15 min
    U_post = 15;
    
    % Calculates the percent overlap between a period of time and a
    % calendar event
    function o = O(start, finish, c)
        o = 0;
        event_start = c(1);
        event_end = c(2);
        if finish < event_start || start > event_end
            o = 0;
        elseif start < event_start && finish > event_start && finish < event_end
            o = (finish-event_start)/(finish-start);
        elseif start > event_start && start < event_end && finish > event_end
            o = (event_end-start)/(finish-start);
        elseif start > event_start && finish < event_end
            o = 1;
        end
    end

    % Calculates the penalty for overlap between an activity and a calendar
    % event
    function ov = OV(activity, calendar_event)
        act_duration = activity(2);
        act_start = activity(3);
        ov = 50 * O(act_start, act_start + U_pre, calendar_event) ...
            + 300 * O(act_start + U_pre, act_start + U_pre + act_duration, calendar_event) ...
            + 50 * O(act_start + U_pre + act_duration, act_start + U_pre + act_duration + U_post, calendar_event);
    end

    function g = G(training_plan, calendar)
        g = 0;
        for j=size(calendar,1)
            for k = size(training_plan, 1)
                g = g + OV(training_plan(k,:), calendar(j,:)); 
            end
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
        if (x(2) >= 30 && x(2) < 60)
            w=120+randn(1)*15;
        elseif (x(2) >= 60 && x(2) <= 120)
            w=250+randn(1)*30;
        else
            w=2.75*x(2);
        end
    end

    function h = H(training_plan)
        h = 0;
        for n = 1:size(training_plan,1)-1
            act = training_plan(n,:);
            x_time = W(act);
            h = h + 150/(x_time/100) * (R(x_time, x_time/100) - R(x_time,training_plan(n+1,2)-act(2)));
        end
    end

    fitness = 0;
    fitness = G(training_plan, calendar) + H(training_plan);
end
