% The Simulated Annealing implementation of the training plan generator. 
% Performs an optimization on activities that constitute a training plan in an attempt to create the best training plan. 

% Takes a parameter of user_fitness_data which has the following format
% [Umax_distance Umax_climb user_fitness]
% and user_traits which has the following format
% [height mass c_rr c_d]

% Takes a function obj which is the objective function

function [best, obj_opt, best_obj, totaleval] = training_annealing(user_fitness_data, user_traits, user_prefs, obj)
 
    search_space = ...
        [5 user_fitness_data(1)*1.25;...
        20 user_fitness_data(1)*1.25*(60/40);...
        0 user_fitness_data(2)*1.25];
    user_fitness=user_fitness_data(3);

    T_init = 10.0; % Initial temperature
    T_min = 1e-10; % Final stopping temperature
    obj_max = 3000; % Max value of the function
    max_rej=2500; % Maximum number of rejectionsgi
    max_run=500; % Maximum number of runs
    max_accept = 15; % Maximum number of accept
    k = 1; % Boltzmann constant
    alpha=0.95; % Cooling factor
    Enorm=1; % Energy norm
    n=user_prefs(1);    % Number of activities
    macro_varience = [floor(n*user_prefs(2)) ceil(n*user_prefs(3)) floor(n*user_prefs(4))];
    guess=G(user_fitness,macro_varience); % Initial guess
    
    % Initializing the counters i,j etc
    i= 0; j = 0; accept = 0; totaleval = 0;

    % Initializing various values
    T = T_init;
    E_init = obj(guess, user_fitness, user_traits);
    E_old = E_init; E_new=E_old;
    best=guess; % initially guessed values
    best_obj=E_init;

    % Starting the simulated annealling
    while ((T > T_min) && (j <= max_rej) && E_new<obj_max && totaleval+i<10000)
        

        % Check if max numbers of run/accept are met
        if (i >= max_run) || (accept >= max_accept)
            totaleval = totaleval + i;
            
            % Cooling according to a cooling schedule
            if (totaleval > 200)
                last_100 = max(best_obj(totaleval-200:totaleval-101));
                curr_100 = max(best_obj(totaleval-100:totaleval-5));
                pct_inc = (curr_100 - last_100)/last_100 * 100;
                if (pct_inc < 0.1)
                    T = T - 1;
                else
                    T = alpha*T;
                end
            else
                T = alpha*T;
            end

            % reset the counters
            i = 0; accept = 0;
        end
        i = i+1;

        % Function evaluations at new locations
        ns = best;
        for k = 1:8
            valid = false;
            while (~valid)
                ns(k,:)=[ ...
                    ns(k,1)+randn(1)*sqrt(1), ...
                    ns(k,2)+randn(1)*sqrt(4), ...
                    ns(k,3)+randn(1)*sqrt(10)];
                if (ns(k,1) >= search_space(1,1) && ns(k,1) <= search_space(1,2) && ...
                    ns(k,2) >= search_space(2,1) && ns(k,2) <= search_space(2,2) && ...
                    ns(k,3) >= search_space(3,1) && ns(k,3) <= search_space(3,2))
                    valid = true;
                end
            end
        end
        E_new = obj(ns, user_fitness, user_traits);

        % Decide to accept the new solution
        DeltaE=E_new-E_old;

        % Accept if improved
        if (DeltaE > Enorm)
            best = ns; 
            E_old = E_new;
            accept = accept+1;
            j = 0;
            % Update the estimated optimal solution
            obj_opt = E_old;
        else
            % Accept with a small probability if not improved
            if (exp(DeltaE/(k*T))>rand)
                best = ns; 
                E_old = E_new;
                accept = accept+1;
            else
                j = j+1;
            end
        end

        best_obj = [best_obj; max([best_obj(end) E_old])];
    end
    
    totaleval = totaleval + i;
end
