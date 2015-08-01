% Objective function to evaluate scheduling a training plan

% scheduled_training_plan is a list of the activities with associated
% start_time
% scheduled_training_plan = [X_id X_duration X_start; ...]

% Returns the fitness of a scheduled training plan

function fitness = scheduling_objective(scheduled_training_plan, buckets)
    function r = R(eff, t)
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

    sortedPlan = sortrows(scheduled_training_plan, 3);
    for p = 1:size(sortedPlan,1)
        sortedPlan(p,3) = buckets(sortedPlan(p,3),1);
    end
    
    h = H(sortedPlan);
    fitness = h;
end
