% The Simulated Annealing implementation of the training plan generator. 
% Performs an optimization on activities that constitute a training plan in an attempt to create the best training plan. 

% Takes a parameter of user_data which has the following format
% [Umax_distance Umax_climb]

% Takes a function obj which is the objective function

function [best, obj_opt, totaleval] = training_annealing(user_data, obj)
    T_init = 1.0; % Initial temperature
    T_min = 1e-10; % Final stopping temperature
    obj_max = 1e+100; % Min value of the function
    max_rej=2500; % Maximum number of rejectionsgi
    max_run=500; % Maximum number of runs
    max_accept = 15; % Maximum number of accept
    k = 1; % Boltzmann constant
    alpha=0.95; % Cooling factor
    Enorm=1e-8; % Energy norm (eg, Enorm=le-8)
    guess=-1; % Initial guess
    
    % Initializing the counters i,j etc
    i= 0; j = 0; accept = 0; totaleval = 0;

    % Initializing various values
    T = T_init;
    E_init = obj(guess);
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
        if (rand > 0.5)
            ns=guess+rand;
        else
            ns=guess-rand;
        end
        E_new = obj(ns);

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
end
