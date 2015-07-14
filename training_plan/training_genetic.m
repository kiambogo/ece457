% Takes a parameter of user_fitness_data which has the following format
% [Umax_distance Umax_climb user_fitness]
% and user_traits which has the following format
% [height mass c_rr c_d]

function [bestplan, bestfun, count] = training_genetic(user_fitness_data, user_traits, obj)
    global pop popnew popsel fitness fitold range user_fitness n;
    
    % Initializing the parameters
    rng(0);     % Reset the random generator
    popsize=20; % Population size
    MaxGen=1000; % Max number of generations
    count=0;    % counter
    pc=0.95;    % Crossover probability
    pm=0.05;    % Mutation probability
    n=8;        % Number of activities
    
    range = [5 user_fitness_data(1)*1.25;...
            20 user_fitness_data(1)*1.25*(60/40);...
            0 user_fitness_data(2)*1.25];
    user_fitness = user_fitness_data(3);
    
    % Generating the initial population
    popnew=init_gen(range);
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
                popsel=[popsel; mutate(range)];
                count=count+1;
            end
        end
        
        popsel = [popsel; pop];
        evolve();

        % Record the current best
        bestfun(i)=max(fitness);
        best_index = find(fitness==bestfun(i));
        bestplan(i,:)=pop(best_index(1),:);
    end

    function pop=init_gen(ss)
        pop = zeros(popsize, n*3);
        for p=1:popsize
            plan = G(user_fitness);
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
           F = F + 1.0e+8 + obj(reshape(popsel(f,:),n,3), user_fitness, user_traits);
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
               sum_fit = sum_fit + 1.0e+8 + obj(reshape(popsel(o,:),n,3), user_fitness, user_traits);
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

    function plan=mutate(ss)
        plan = zeros(n,3);
        for a=1:n
            plan(a,:) = [...
                (ss(1,2)-ss(1,1))*rand(1, 1)+ss(1,1),...
                (ss(2,2)-ss(2,1))*rand(1, 1)+ss(2,1),...
                (ss(3,2)-ss(3,1))*rand(1, 1)+ss(3,1)];
        end
        plan = reshape(plan,1,n*3);
    end
end
