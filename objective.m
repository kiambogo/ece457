% Objective function to evaluate a training plan

% user_traits = [height mass c_rr c_d]

% Returns the fitness of a training plan

function fitness = objective(training_plan, user_fitness, user_traits)
    global length height mass c_rr;
    
    length = size(training_plan);
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
    fitness = fitness - H(training_plan) - Q(training_plan, user_fitness);

    function y = heaviside(X)
        %heaviside step function
        y = zeros(size(X));
        y(X > 0) = 1;
        y(X == 0) = .5;
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
           total_levels = total_levels + L(X) - user_fitness;
        end
        q = heaviside(-1000 * total_levels);
    end

    %https://strava.zendesk.com/entries/20959332-Power-Calculations
    function lvl = L(x)
        p = P(x);
        
        if p < 2.5 || t <= 0
            lvl = 0;
        else
            lvl_sc = p*t^(1/3);
            lvl = 10*(lvl_sc - 2.5) + 1;
        end
    end

    function p = P(x)
        d = x(1);
        t = x(2);
        e = x(3);
        v = (d*1000)/(t*60);
        grade = sin(e/d/2);
        %https://en.wikipedia.org/wiki/Normal_force
        N = acos(grade) / (mass * 9.8);
        %http://en.wikipedia.org/wiki/Rolling_resistance
        p_rr = c_rr * N * v; 
        %https://en.wikipedia.org/wiki/Density_of_air
        ro = 1.2041;
        %http://www.medcalc.com/body.html
        a = (height * mass / 3600)^0.5; 
        %http://en.wikipedia.org/wiki/Drag_(physics)
        p_wind = 0.5 * ro * v^3 * c_d * a; 
        %p_g = mass * 9.8 * sin(atan(grade)) * v;
        p = p_rr + p_wind;% + p_g;
    end
end