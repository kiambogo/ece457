% Objective function to evaluate a training plan

% user_traits = [height mass c_rr c_d]

% Returns the fitness of a training plan

function fitness = objective(training_plan, user_fitness, user_traits)
    global length height mass c_rr;
    
    %length = size(training_plan);
    length = 14;
    height = user_traits(1);
    mass = user_traits(2);
    %https://en.wikipedia.org/wiki/Rolling_resistance, typically about 0.03
    c_rr = user_traits(3);
    %https://en.wikipedia.org/wiki/Drag_coefficient, typically about 1.0
    c_d = user_traits(4);

    fitness = 0;
    for i=1:size(training_plan)
        fitness = fitness + (2.75 * training_plan(i,2));
    end
    h = H(training_plan)
    q = Q(training_plan, user_fitness)
    fitness = fitness - h - q;

    function y = heaviside(X)
        %heaviside step function
        y = zeros(size(X));
        y(X > 0) = 1 * X;
        y(X == 0) = .5 * X;
    end

    function h = H(X)
        recovery_time = 0;
        for j=1:size(X)
            recovery_time = recovery_time + (2.75 * X(j,2) / 100);
        end
        h = 100 * heaviside(recovery_time - length);
    end

    function q = Q(X, user_fitness)
        total_levels = 0;
        for j=1:size(X)
            l = L(X(j,:));
           total_levels = total_levels + l - user_fitness
        end
        q = heaviside(1000 * total_levels);
    end

    function lvl = L(x)
        p = P(x);
        lvl = heaviside(-200/x(2) + p/5 - 9);
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