% Takes a parameter of training_plan which was output from a training plan
% optmization function
% and calendar vector which has the format of:
% 0 => free 15 minute period
% 1 => busy 15 minute period
% Takes a function obj which is the objective function

function [best, obj_opt, totaleval] = scheduling_annealing(training_plan, calendar, obj)
 
    % Generate free buckets (or slots) of time in the calendar
    buckets = bucketGenerator(calendar);
    T_init = 1.0; % Initial temperature
    T_min = 1e-10; % Final stopping temperature
    obj_min = -1e+100; % Min value of the function
    max_rej=2500; % Maximum number of rejectionsgi
    max_run=500; % Maximum number of runs
    max_accept = 15; % Maximum number of accept
    k = 1; % Boltzmann constant
    alpha=0.95; % Cooling factor
    Enorm=1e-8; % Energy norm
    guess=sched_init(training_plan, buckets); % Initial guess
    
    % Initializing the counters i,j etc
    i= 0; 
    j = 0; 
    accept = 0; 
    totaleval = 0;

    % Initializing various values
    T = T_init;
    % Initial solution values
    E_init = obj(guess, buckets);
    E_old = E_init;
    E_new = E_old;
    best = guess; % initially guessed values

    % Starting the simulated annealling
    while ((T > T_min) && (j <= max_rej) && E_new>obj_min && totaleval+i<10000)
        % Check if max numbers of run/accept are met
        if (i >= max_run) || (accept >= max_accept)

            % Cooling according to a cooling schedule
            T = alpha*T;
            totaleval = totaleval + i;

            % reset the counters
            i = 0; accept = 0;
        end
        i = i+1;

        % Function evaluations at new locations
        ns = best;
        for j = 1:8
            valid = false;
            while (~valid)
                validList = ones(8,1);
                ns(j,:)=[ ...
                    ns(j,1), ...
                    ns(j,2), ...
                    randi(min([find(buckets(:,3)<ns(j,2), 1)-1 size(buckets,1)]))];
                for k=1:8
                    if (size(find(ns(k,3)==ns(:,3)),1) ~= 1)
                        validList(k)=0;
                    end
                end
                if (validList == 1)
                    valid = true;
                else
                    valid = false;
                end
            end
        end
        E_new = obj(ns, buckets);

        % Decide to accept the new solution
        DeltaE=E_new-E_old;

        % Accept if improved
        if (-DeltaE > Enorm)
            best = ns; E_old = E_new;
            accept=accept+1; j = 0;
        else
            % Accept with a small probability if not improved
            if (exp(-DeltaE/(k*T))>rand)
                best = ns; E_old = E_new;
                accept=accept+1;
            else
                j=j+1;
            end
        end

        % Update the estimated optimal solution
        obj_opt=E_old;
    end
    
    totaleval = totaleval + i;
end
