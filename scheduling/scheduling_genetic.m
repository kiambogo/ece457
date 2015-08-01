% Takes a parameter of user_fitness_data which has the following format
% [Umax_distance Umax_climb user_fitness]
% and user_traits which has the following format
% [height mass c_rr c_d]

function [best_plan, best_score, i] = scheduling_genetic(training_plan, calendar, obj)
    global pop popnew popsel fitness fitold range buckets n nsbit;
    
    buckets = bucketGenerator(calendar);
    range = [1 size(buckets,1)];
    % Initializing the parameters
    rng('shuffle');     % Reset the random generator
    popsize=20; % Population size
    MaxGen=100; % Max number of generations
    count=0;    % counter
    pc=0.95;    % Crossover probability
    pm=0.05;    % Mutation probability
    nsbit=floor(log2(range(2))+1);
    n=8;        % Number of activities
    
    % Generating the initial population
    popnew=init_gen();
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
                popsel=[popsel; mutate(pop(kk,:))];
                count=count+1;
            end
        end
        
        popsel = [popsel; pop];
        evolve();

        % Record the current best
        bestfun(i)=min(fitness);
        best_index = find(fitness==bestfun(i));
        bestplan(i,:)=reshape(bintosched(transpose(reshape(pop(best_index(1),:),2+nsbit,n))),1,n*3);       
    end
    
    %set return values
    [best_score, ind] = min(bestfun);
    best_plan = reshape(bestplan(ind,:),n,3);

    function pop=init_gen()
        pop = zeros(popsize, n*(2+nsbit));
        for p=1:popsize
            sched = sched_init(training_plan, buckets);
            pop(p,:) = reshape(transpose(schedtobin(sched)),1,n*(2+nsbit));
        end
    end

    function bin=schedtobin(sched)
        acts = size(sched,1);
        bin = zeros(acts, 2+nsbit);
        for k=1:acts
            bin(k,:) = [sched(k,1) sched(k,2) dectobin(sched(k,3))];
        end
    end

    function sched=bintosched(bin)
        acts = size(bin,1);
        sched = zeros(acts, 3);
        for k=1:acts
            sched(k,:) = [bin(k,1) bin(k,2) bintodec(bin(k,3:end))];
        end
    end

    function dec=bintodec(bin)
        nn = length(bin);
        dec=0;
        for k=1:nn
            dec=dec+bin(k)*2^(nn-k);
        end
    end

    function bin=dectobin(dec)
        bin = zeros(1, nsbit);
        k = 0;
        while dec >= 1
            bin(nsbit-k) = mod(dec, 2);
            dec = fix(dec/2);
            k = k + 1;
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
            F = F + 1/(1 + obj(bintosched(transpose(reshape(popsel(f,:),2+nsbit,n))), buckets));
        end
        % distance between the pointers
        P = F/N;
        start = rand*P;
        pointers = zeros(1,N);
        for k=1:N
            pointers(k) = start + k*P;
        end
        keep = zeros(N,n*(2+nsbit));
        keep_fit = zeros(1,N);
        o = 1;
        sum_fit = 0;
        for p=1:N
            while (sum_fit < pointers(p) && o < size(popsel,1))
               sum_fit = sum_fit + 1/(1 + obj(bintosched(transpose(reshape(popsel(o,:),2+nsbit,n))), buckets));
               o = o + 1;
            end
            keep(p,:) = popsel(o,:);
            keep_fit(p) = obj(bintosched(transpose(reshape(popsel(o,:),2+nsbit,n))), buckets);
        end
        popnew = keep;
        fitness = keep_fit;
    end

    % Crossover operator
    function [pair]=crossover(a,b)
        c = a;
        d = b;
        for l=0:n-1
            crossover = rand(1, nsbit) > 0.5;
            for k=1:nsbit
                if (crossover(k) == 1)
                    m = k + 2 + (l*(2+nsbit));
                    temp = c(m);
                    c(m) = d(m);
                    d(m) = temp;
                end
            end
        end
        
        sched_c = bintosched(transpose(reshape(c,2+nsbit,n)));
        sched_d = bintosched(transpose(reshape(d,2+nsbit,n)));
        if (max(sched_c(:,3)) > range(2) || max(sched_c(:,3)) > range(2) ||...
                min(sched_c(:,3)) < range(1) || min(sched_c(:,3)) < range(1) ||...
                (size(unique(sched_c(:,3)),1) ~= size(sched_c(:,3),1)))
            c = mutate(c);
            sched_c = bintosched(transpose(reshape(c,2+nsbit,n)));
        end
        if (max(sched_d(:,3)) > range(2) || max(sched_d(:,3)) > range(2) ||...
                min(sched_d(:,3)) < range(1) || min(sched_d(:,3)) > range(1) ||...
                (size(unique(sched_d(:,3)),1) ~= size(sched_d(:,3),1)))
            d = mutate(d);
            sched_d = bintosched(transpose(reshape(d,2+nsbit,n)));
        end
        
        c_dur = sched_c(:,2);
        c_bucket_dur = buckets(sched_c(:,3),3);
        valid_c = sum(c_dur > c_bucket_dur) == 0;
        d_dur = sched_d(:,2);
        d_bucket_dur = buckets(sched_d(:,3),3);
        valid_d = sum(d_dur > d_bucket_dur) == 0;
        if (~valid_c)
            c = mutate(c);
        end
        if (~valid_d)
            d = mutate(d);
        end
        
        pair = [c;d];
    end

    % Mutation operator
    function sched=mutate(sched)
        valid = false;
        while (~valid)
            for l=0:n-1
                bitflip = rand(1, nsbit) > 0.5;
                for k=1:nsbit
                    if (bitflip(k) == 1)
                        m = k + 2 + (l*(2+nsbit));
                        sched(m) = ~sched(m);
                    end
                end
            end
            sched_sched = bintosched(transpose(reshape(sched,2+nsbit,n)));
            if (max(sched_sched(:,3)) <= range(2) && max(sched_sched(:,3)) <= range(2) &&...
                    min(sched_sched(:,3)) >= range(1) && min(sched_sched(:,3)) >= range(1) &&...
                    (size(unique(sched_sched(:,3)),1) == size(sched_sched(:,3),1)))
                dur = sched_sched(:,2);
                bucket_dur = buckets(sched_sched(:,3),3);
                valid = sum(dur > bucket_dur) == 0;
            end
        end
    end
end
