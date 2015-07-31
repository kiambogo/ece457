% Takes a parameter of user_fitness_data which has the following format
% [Umax_distance Umax_climb user_fitness]
% and user_traits which has the following format
% [height mass c_rr c_d]
% and user_prefs which has the following format
% [num_acts pct_short pct_avg pct_long]

function [bestplan, bestfun, count] = training_genetic(user_fitness_data, user_traits, user_prefs, obj)
    global pop popnew popsel fitness fitold user_fitness n sigma;
    
    % Initializing the parameters
    rng('shuffle');     % Reset the random generator
    popsize=20;         % Population size
    MaxGen=1000;         % Max number of generations
    count=0;            % counter
    pc=0.95;            % Crossover probability
    pm=0.05;            % Mutation probability
    n=user_prefs(1);    % Number of activities
    sigma=1;            % Mutation standard deviation
    mut_suc=0;          % Successful mutations
    mut_tot=0;          % Total mutations
    
    range = [5 user_fitness_data(1)*1.25;...
            20 user_fitness_data(1)*1.25*(60/40);...
            0 user_fitness_data(2)*1.25];
    user_fitness = user_fitness_data(3);
    macro_varience = [floor(n*user_prefs(2)) ceil(n*user_prefs(3)) floor(n*user_prefs(4))];
    
    % Generating the initial population
    popnew=init_gen(macro_varience);
    fitness=zeros(1,popsize); % fitness array
    
    % Start the evolution loop
    for i=1:MaxGen
        % Record as the history
        fitold=fitness; pop=popnew; popsel=[];
        for j=1:popsize
            % Cross over
            if pc>rand
                % Crossover pair
                ii=floor(popsize*rand)+1;
                jj=floor(popsize*rand)+1;
                popsel=[popsel; crossover(pop(ii,:),pop(jj,:))];
                % Evaluate the new pairs
                count=count+2;
            end

            % Mutation
            if pm>rand 
                kk=floor(popsize*rand)+1;
                mut=mutate(pop(kk,:),range);
                popsel=[popsel; mut];
                count=count+1;
                mut_tot=mut_tot+1;
                fit_org=obj(reshape(pop(kk,:),n,3), user_fitness, user_traits);
                fit_mut=obj(reshape(mut,n,3), user_fitness, user_traits);
                % Successful mutation
                if (fit_mut > fit_org)
                   mut_suc=mut_suc+1; 
                end
            end
        end
        
        popsel = [popsel; pop];
        evolve();
        
        % Adapt sigma every 5th generation
        if (mod(i,5) == 0)
            if (mut_tot == 0)
               sigma = 1;
            else
                if (mut_suc/mut_tot > 1/5)
                   sigma = sigma/0.9; 
                elseif (mut_suc/mut_tot < 1/5)
                   sigma = sigma*0.9;
                end
            end
        end

        % Record the current best
        bestfun(i)=max(fitness);
        best_index = find(fitness==bestfun(i));
        bestplan(i,:)=pop(best_index(1),:);
        
        %Check termination criteria
        if (i > 200)
            last_100 = max(bestfun(i-200:i-101));
            curr_100 = max(bestfun(i-100:i));
            pct_inc = (curr_100 - last_100)/last_100 * 100;
            if (pct_inc < 0.1)
                break;
            end
        end
    end

    function pop=init_gen(macro_varience)
        pop = zeros(popsize, n*3);
        for p=1:popsize
            plan = G(user_fitness, macro_varience);
            pop(p,:) = reshape(plan,1,n*3);
        end
    end

    % Evolving the new generation with Stochastic universal sampling
    % https://en.wikipedia.org/wiki/Stochastic_universal_sampling
    function evolve()
        % total fitness of population
        F = 0;
        % number of offspring to keep
        N = popsize;
        for f=1:size(popsel, 1)
           F = F + obj(reshape(popsel(f,:),n,3), user_fitness, user_traits);
        end
        % distance between the pointers
        P = F/N;
        start = rand*P;
        pointers = zeros(1,N);
        for k=1:N
            pointers(k) = start + k*P;
        end
        keep = zeros(N,n*3);
        keep_fit = zeros(1,N);
        o = 1;
        sum_fit = 0;
        for p=1:N
            while (sum_fit < pointers(p) && o < size(popsel,1))
               sum_fit = sum_fit + obj(reshape(popsel(o,:),n,3), user_fitness, user_traits);
               o = o + 1;
            end
            keep(p,:) = popsel(o,:);
            keep_fit(p) = obj(reshape(popsel(o,:),n,3), user_fitness, user_traits);
        end
        popnew = keep;
        fitness = keep_fit;
    end

    % Crossover operator
    function [pair]=crossover(a,b)
        alpha = 0.4;
        c = alpha*a + (1-alpha)*b;
        d = alpha*b + (1-alpha)*a;
        pair = [c;d];
    end

    function plan=mutate(c,ss)
        plan = reshape(c,n,3);
        for a=1:n
            valid = false;
            while(~valid)
                plan(a,:) = [...
                    plan(a,1) + randn*sigma,...
                    plan(a,2) + randn*2*sigma,...
                    plan(a,3) + randn*4*sigma];
                if (plan(a,1) <= ss(1,2) && plan(a,1) >= ss(1,1) &&...
                        plan(a,2) <= ss(2,2) && plan(a,2) >= ss(2,1) &&...
                        plan(a,3) <= ss(3,2) && plan(a,3) >= ss(3,1))
                    valid = true;
                end
            end
        end
        plan = reshape(plan,1,n*3);
    end
end
