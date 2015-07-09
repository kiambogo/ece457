% Objective function to evaluate a training plan

% user_fitness = [fitness fatigue endurance climbing sprinting]
% user_traits = [endurance_threshold]
% user_goals = [total_fitness endurance climbing sprinting]

% Returns the fitness of a training plan

function fitness = objective(training_plan, user_fitness, user_traits, user_goals, L_fit, L_end, L_cli, L_spr)
    global endur length L_fitness L_endurance L_climbing L_sprinting;
    
    endur = user_traits(1);
    length = size(training_plan);
    L_fitness = L_fit;
    L_endurance = L_end;
    L_climbing = L_cli;
    L_sprinting = L_spr;
    
    for i=1:size(training_plan)
        fitness = fitness + g(training_plan(i,:), user_goals);
    end
    fitness = fitness - h(training_plan) - q(training_plan, user_fitness);
    
    function y = g(x, goals)
        endurance_points = heaviside(w((x(1)-endur)*x(2)/x(1)));
        climbing_points = w((100/5)*x(3)*x(2)/x(1));
        sprinting_points = w(x(2)/10);
        y = goals(1)*w(x(2)) + goals(2)*endurance_points + goals(3)*climbing_points + goals(4)*sprinting_points;
    end

    function y = heaviside(X)
        %heaviside step function
        y = zeros(size(X));
        y(X > 0) = 1;
        y(X == 0) = .5;
    end

    %calculate estimated effort for an activity
    function y = w(x_time)
        %0.1*1*x_time + 0.3*2*x_time + 0.4*3*x_time + 0.15*4*x_time + 0.05*5*x_time
        y = 2.75*x_time;
    end

    function y = h(X)
        recovery_time = 0;
        for j=1:size(X)
            recovery_time = recovery_time + u(X(j,:));
        end
        y = 100 * heaviside(recovery_time - length);
    end

    function y = u(x)
        y = g(x, [1 0 0 0])/100;
    end

    function y = q(X, p)
        total_levels = 0;
        for j=1:size(X)
           total_levels = total_levels + z(x, p);
        end
        y = heaviside(-1000*total_levels);
    end

    function y = z(x, p)
        endurance = heaviside((x(1)-endur)/x(1))*v(L_endurance, x, p(3));
        climbing = ((100/5)*x(3)/x(1))*v(L_climbing, x, p(4));
        sprinting = v(L_sprinting, x, p(5))/10;
        y = v(L_fitness, x, p(1)) + endurance + climbing + sprinting;
    end

    function y = v(L, x, p)
        y = L(x(1), x(2), x(3)) - p;
    end
end