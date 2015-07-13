% Takes a parameter of user_fitness_data which has the following format
% [Umax_distance Umax_climb user_fitness]
% and user_traits which has the following format
% [height mass c_rr c_d]

function [bestplan, bestfun, count] = training_genetic(user_fitness_data, user_traits, obj)
    global pop popnew fitness fitold range user_fitness n;
    
    % Initializing the parameters
    rng(0);     % Reset the random generator
    popsize=20; % Population size
    MaxGen=10000; % Max number of generations
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
        fitold=fitness; pop=popnew;
        for j=1:popsize
            % Crossover pair
            ii=floor(popsize*rand)+1; jj=floor(popsize*rand)+1;
            % Cross over
            if pc>rand
                [popnew(ii,:),popnew(jj,:)]=crossover(pop(ii,:),pop(jj,:));
                % Evaluate the new pairs
                count=count+2;
                evolve(ii); 
                evolve(jj);
            end

            % Mutation at n sites
            if pm>rand
                kk=floor(popsize*rand)+1; count=count+1;
                popnew(kk,:)=mutate(range);
                evolve(kk);
            end
        end

        % Record the current best
        bestfun(i)=max(fitness);
        bestplan(i,:)=mean(pop(bestfun(i)==fitness,:));
    end

    function pop=init_gen(ss)
        pop = zeros(popsize, n*3);
        for p=1:popsize
            plan = zeros(n,3);
            for a=1:8
                plan(a,:) = [...
                    (ss(1,2)-ss(1,1))*rand(1, 1)+ss(1,1),...
                    (ss(2,2)-ss(2,1))*rand(1, 1)+ss(2,1),...
                    (ss(3,2)-ss(3,1))*rand(1, 1)+ss(3,1)];
            end
            pop(p,:) = reshape(plan,1,24);
        end
    end

    % Evolving the new generation
    function evolve(j)
        fitness(j)=obj(reshape(popnew(j,:),8,3), user_fitness, user_traits);
        if fitness(j)>fitold(j),
            pop(j,:)=popnew(j,:);
        end
    end

    % Crossover operator
    function [c,d]=crossover(a,b)
        alpha = 0.4;
        c = alpha*a + (1-alpha)*b;
        d = alpha*b + (1-alpha)*a;
    end

    function plan=mutate(ss)
        plan = zeros(n,3);
        for a=1:8
            plan(a,:) = [...
                (ss(1,2)-ss(1,1))*rand(1, 1)+ss(1,1),...
                (ss(2,2)-ss(2,1))*rand(1, 1)+ss(2,1),...
                (ss(3,2)-ss(3,1))*rand(1, 1)+ss(3,1)];
        end
        plan = reshape(plan,1,24);
    end
end
