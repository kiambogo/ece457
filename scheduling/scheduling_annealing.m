function [best, obj_opt, totaleval] = scheduling_annealing(training_plan, calendar, obj)
 
    search_space = [0 1344];

    T_init = 1.0; % Initial temperature
    T_min = 1e-10; % Final stopping temperature
    obj_max = 1e+100; % Min value of the function
    max_rej=2500; % Maximum number of rejectionsgi
    max_run=500; % Maximum number of runs
    max_accept = 15; % Maximum number of accept
    k = 1; % Boltzmann constant
    alpha=0.95; % Cooling factor
    Enorm=1e-8; % Energy norm (eg, Enorm=le-8)
    guess=sched_init(training_plan); % Initial guess
    
    % Initializing the counters i,j etc
    i= 0; j = 0; accept = 0; totaleval = 0;

    % Initializing various values
    T = T_init;
    E_init = obj(guess, calendar);
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
            valid = false;
            while (~valid)
                ns(j,:)=[ ...
                    ns(j,1), ...
                    ns(j,2), ...
                    ns(j,3)+randn(1)*sqrt(1)];
                if (ns(j,3) >= search_space(1,1) && ns(j,3) <= search_space(1,2))
                    valid = true;
                end
            end
        end
        E_new = obj(ns, calendar);

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
