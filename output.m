% Objective function to evaluate a training plan

% user_traits = [height mass c_rr c_d]

% Returns the fitness of a training plan

function fitness = output(training_plan, user_fitness, user_traits)
    global length height mass c_rr;
    
    length = 14; %length of the training plan in days
    height = user_traits(1);
    mass = user_traits(2);
    %https://en.wikipedia.org/wiki/Rolling_resistance, typically about 0.004
    c_rr = user_traits(3);
    %https://en.wikipedia.org/wiki/Drag_coefficient, typically about 1.0
    c_d = user_traits(4);

    fitness = 0;
    for i=1:size(training_plan)
        fitness = fitness + (2.75 * training_plan(i,2));
    end
    fitness = fitness - H(training_plan) - Q(training_plan, user_fitness) - V(training_plan)

    function y = heaviside(X)
        %heaviside step function
        he = zeros(size(X));
        he(X > 0) = 1;
        he(X == 0) = .5;
        y = he .* X;
    end

    function h = H(X)
        recovery_time = 0;
        for j=1:size(X)
            recovery_time = recovery_time + (2.75 * X(j,2) / 100);
        end
        h = 100 * heaviside(recovery_time - length)
    end

    function q = Q(X, user_fitness)
        total_levels = 0;
        for j=1:size(X)
           l = L(X(j,:));
           if l > (user_fitness + 1)
               lvl_penalty = l - (user_fitness + 1);
           elseif l < (user_fitness - 4)
               lvl_penalty = (user_fitness - 4) - l;
           else
               lvl_penalty = 0;
           end
           total_levels = total_levels + lvl_penalty;
        end
        q = heaviside(1000 * total_levels)
    end

    function lvl = L(x)
        p = P(x);
        lvl = heaviside(-200/x(2) + p/5 - 9);
    end

    function v = V(training_plan)
        short = 0;
        average = 0;
        long = 0;
        penalty = 0;
        for j = 1:8
            activity = training_plan(j,:);
            duration = activity(2);
            if duration >= 30 && duration < 60
                short = short + 1;
            elseif duration >= 60 && duration <= 120
                average = average + 1;
            elseif duration > 120
                long = long + 1;
            end
        end
        short_p = short/8;
        if (short_p >= 0.35)
            penalty = penalty + (short_p - 0.35)*40000;
        elseif (short_p <= 0.15)
            penalty = penalty + (0.15 - short_p)*40000;
        end
        avg_p = average/8;
        if (avg_p >= 0.6)
            penalty = penalty + (avg_p - 0.6)*40000;
        elseif (avg_p <= 0.4)
            penalty = penalty + (0.4 - avg_p)*40000;
        end
        long_p = long/8;
        if (long_p >= 0.37)
            penalty = penalty + (long_p - 0.35)*40000;
        elseif (long_p <= 0.15)
            penalty = penalty + (0.15 - long_p)*40000;
        end
        v = penalty
    end

    %https://strava.zendesk.com/entries/20959332-Power-Calculations
    function p = P(x)
        d = x(1);
        t = x(2);
        e = x(3);
        v = (d*1000)/(t*60);
        theta = asin(e/(d*1000/3));
        %https://en.wikipedia.org/wiki/Normal_force
        N_hill = cos(theta) * mass * 9.8;
        N_flat = mass * 9.8;
        %http://en.wikipedia.org/wiki/Rolling_resistance
        p_rr_hill = c_rr * N_hill * v;
        p_rr_flat = c_rr * N_flat * v;
        %https://en.wikipedia.org/wiki/Density_of_air
        ro = 1.255;
        %assuming frontal surface area
        a = 0.5;
        %http://en.wikipedia.org/wiki/Drag_(physics)
        p_wind = 0.5 * ro * v^3 * c_d * a;
        p_g = mass * 9.8 * sin(theta) * v;
        p_up = p_rr_hill + p_wind + p_g;
        p_flat = p_rr_flat + p_wind;
        p_down = p_rr_hill + p_wind - p_g;
        p = (p_up + p_flat + p_down)/3;
    end
end