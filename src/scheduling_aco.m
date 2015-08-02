% Scheduling ACO
% Based on ACO by Haupt & Haupt, 2003
% © Trifecta Labs

function [best_sched, best_score, it] = scheduling_aco(training_plan, calendar, obj)
    % Reset the random generator
    rng('default');
    rng('shuffle');
    
    buckets = scheduling_BucketGenerator(calendar);
    range = [1 size(buckets,1)];
    n = size(training_plan, 1);
    Npaths = range(2);       % number of options for each variable
    Nants = Npaths;     % number of ants = number of paths

    bucket_paths = range(1):Npaths; % bucket path values
    
    % Benchmark solution path scores are based on
    benchmark = scheduling_init(training_plan, buckets);
    benchscore = obj(benchmark, buckets); 
    benchmark = reshape(benchmark,1,n*3)
    
    % Initialize distance matrix
    path_dist = zeros(Npaths, n*3);
    % For each distance/time/elevation path replace the respective value
    % in the benchmark plan and calculate the score difference
    for ic=1:Npaths
        for id=1:n
            path_plan = benchmark;
            path_plan(3) = bucket_paths(ic);
            path_score = obj(reshape(path_plan,n,3), buckets);
            path_dist(ic,id) = path_score - benchscore;
        end
    end
    path_dist
    % Set path distances equal to the inverse of the scores relative to the
    % minimum benchmark score difference
    for id=1:n
       path_dist(:,id) = 1. ./ (1. + path_dist(:,id) - min(path_dist(:,id)));
    end
    path_dist
    vis = 1./path_dist; % visibility equal inverse of distance
    phmone = .1 * ones(Npaths, n); % initialized pheromones between cities

    maxit = 500; % max number of iterations
    a = 0.5; % alpha
    b = 0.5; % beta
    rr = 0.1; % decay rate
    Q = 4; % phermone quantity
    dbest = Inf; % shortest distance is initially infinite
    e = 5; % weight of elite path
    
    % Initialize ant paths
    for ia=1:Nants
       ants(ia,:) = randperm(Npaths, n);
    end
    
    for it=1:maxit
        % find the training plan for each ant
        % st is the current position
        % nxt contains list of next paths
        for ia=1:Nants
            for iq=1:n
                prob=((phmone(:,iq).^a).*(vis(:,iq).^b))./sum((phmone(:,iq).^a).*(vis(:,iq).^b));
                rpath=rand;
                for iz=1:length(prob)
                    if rpath<sum(prob(1:iz))
                        newpath=iz; % next path to be taken
                        break
                    end % if
                end % iz
                ants(ia,iq)=newpath;
            end % iq
        end % ia        
        % calculate the length of each tour and pheromone distribution
        phtemp=zeros(Npaths, n);
        for ic=1:Nants
            dist(ic)=0;
            for id=1:n
                dist(ic)=dist(ic)+path_dist(ants(ic,id),id);
                phtemp(ants(ic,id),id) = phtemp(ants(ic,id),id) + Q/dist(ic);
            end % id
        end % ic
        [dmin,ind] = min(dist);
        if dmin < dbest
            dbest = dmin;
            pbest = reshape(ants(ind,:),n,1);
            pbest
        end % if
        % pheromone for elite path
        ph1 = zeros(Npaths, n);
        for id=1:n
            ph1(ants(ind,id),id) = Q/dmin;
        end % id
        % update pheromone trails
        phmone = (1-rr)*phmone + phtemp + e*ph1;
        dd(it,:) = [dbest dmin];
        %[it dmin dbest]
    end %it

    %set return values
    best_sched = [transpose(benchmark(1:n)) transpose(benchmark(1+n:2*n)) pbest];
    %best_plan = [transpose(distances(pbest(:,1))) transpose(times(pbest(:,2))) transpose(elevations(pbest(:,3)))];
    best_score = obj(best_sched, buckets);
end


