% The Simulated Annealing implementation of the training plan generator. 
% Performs an optimization on activities that constitute a training plan in an attempt to create the best training plan. 

% Takes a parameter of user_fitness_data which has the following format
% [Umax_distance Umax_climb user_fitness]
% and user_traits which has the following format
% [height mass c_rr c_d]

% Takes a function obj which is the objective function

function [best, obj_opt, totaleval] = training_annealing(user_fitness_data, user_traits, obj)
 
    search_space = ...
        [5 user_fitness_data(1)*1.25;...
        20 user_fitness_data(1)*1.25*(60/40);...
        0 user_fitness_data(2)*1.25];
    user_fitness=user_fitness_data(3);

    T_init = 1.0; % Initial temperature
    T_min = 1e-10; % Final stopping temperature
    obj_max = 1e+100; % Min value of the function
    max_rej=2500; % Maximum number of rejectionsgi
    max_run=500; % Maximum number of runs
    max_accept = 15; % Maximum number of accept
    k = 1; % Boltzmann constant
    alpha=0.95; % Cooling factor
    Enorm=1e-8; % Energy norm (eg, Enorm=le-8)
    guess=G(user_fitness); % Initial guess
    
    % Initializing the counters i,j etc
    i= 0; j = 0; accept = 0; totaleval = 0;

    % Initializing various values
    T = T_init;
    E_init = obj(guess, user_fitness, user_traits);
    E_old = E_init; E_new=E_old;
    best=guess; % initially guessed values

    % Starting the simulated annealling
    while ((T > T_min) && (j <= max_rej) && E_new<obj_max)
        i = i+1;

        % Check if max numbers of run/accept are met
        if (i >= max_run) || (accept >= max_accept)

            % Cooling according to a cooling schedule
            T = alpha*T;
            totaleval = totaleval + i;

            % reset the counters
            i = 1; accept = 1;
        end

        % Function evaluations at new locations
        ns = best;
        for j = 1:8
            ns(j,:)=[ ...
                ns(j,1)+randn(1)*sqrt(1), ...
                ns(j,2)+randn(1)*sqrt(4), ...
                ns(j,2)+randn(1)*sqrt(10)];
        end
        E_new = obj(ns, user_fitness, user_traits);

        % Decide to accept the new solution
        DeltaE=E_new-E_old;

        % Accept if improved
        if (DeltaE > Enorm)
            best = ns; E_old = E_new;
            accept=accept+1; j = 0;
        else
            % Accept with a small probability if not improved
            if (exp(DeltaE/(k*T))>rand)
                best = ns; E_old = E_new;
                accept=accept+1;
            else
                j=j+1;
            end
        end

        % Update the estimated optimal solution
        obj_opt=E_old;
    end
    
    function initTrainingPlan = init(ss)
        initTrainingPlan = zeros(8,3);
        for n = 1:8
            initTrainingPlan(n,:) = [...
                (ss(1,2)-ss(1,1))*rand(1, 1)+ss(1,1),...
                (ss(2,2)-ss(2,1))*rand(1, 1)+ss(2,1),...
                (ss(3,2)-ss(3,1))*rand(1, 1)+ss(3,1)];
        end
    end
end
