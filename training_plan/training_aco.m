% Training Plan ACO
% Based on ACO by Haupt & Haupt, 2003
% © Trifecta Labs

% Takes a parameter of user_fitness_data which has the following format
% [Umax_distance Umax_climb user_fitness]

% and user_traits which has the following format
% [height mass c_rr c_d]

% and user_prefs which has the following format
% [num_acts pct_short pct_avg pct_long]

function [best_plan, best_score, it] = training_aco(user_fitness_data, user_traits, user_prefs, obj)
    rng('default');
    rng('shuffle');
    
    range = [5 user_fitness_data(1)*1.25;...
            20 user_fitness_data(1)*1.25*(60/40);...
            0 user_fitness_data(2)*1.25];
    
    n = user_prefs(1);  % number of activities
    Npaths = 100;        % number of options for each variable
    Nants = Npaths;     % number of ants = number of paths
    
    distances = linspace(range(1,1), range(1,2), Npaths);
    times = linspace(range(2,1), range(2,2), Npaths);
    elevations = linspace(range(3,1), range(3,2), Npaths);
    
    user_fitness = user_fitness_data(3);
    macro_varience = [floor(n*user_prefs(2)) ceil(n*user_prefs(3)) floor(n*user_prefs(4))];
    benchmark = G(user_fitness, macro_varience);
    benchscore = obj(benchmark, user_fitness, user_traits);
    benchmark = reshape(benchmark,1,n*3);
    
    path_dist = zeros(Npaths, n*3);
    for ic=1:Npaths
        for id=1:n
            path_plan = benchmark;
            path_plan(id) = distances(ic);
            path_score = obj(reshape(path_plan,n,3), user_fitness, user_traits);
            path_dist(ic,id) = path_score - benchscore;
        end
        for id=n+1:2*n
            path_plan = benchmark;
            path_plan(id) = times(ic);
            path_score = obj(reshape(path_plan,n,3), user_fitness, user_traits);
            path_dist(ic,id) = path_score - benchscore;
        end
        for id=2*n+1:3*n
            path_plan = benchmark;
            path_plan(id) = elevations(ic);
            path_score = obj(reshape(path_plan,n,3), user_fitness, user_traits);
            path_dist(ic,id) = path_score - benchscore;
        end
    end
    for id=1:n*3
       path_dist(:,id) = 1. ./ (1. + path_dist(:,id) - min(path_dist(:,id)));
    end
    vis = 1./path_dist; % visibility equal inverse of distance
    phmone = .1 * ones(Npaths, n*3); % initialized pheromones between cities
    
    % rr - trail decay
    % maxit - max number of iterations
    maxit = 500;
    a = 0.5; % alpha
    b = 0.5; % beta
    rr = 0.1; % decay rate
    Q = 4;
    dbest = Inf;
    e = 5;
    
    for ia=1:Nants
       ants(ia,:) = randperm(50,24);
    end
    
    for it=1:maxit
        % find the training plan for each ant
        % st is the current position
        % nxt contains list of next paths
        for ia=1:Nants
            for iq=1:n*3
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
        phtemp=zeros(Npaths, n*3);
        for ic=1:Nants
            dist(ic)=0;
            for id=1:n*3
                dist(ic)=dist(ic)+path_dist(ants(ic,id),id);
                phtemp(ants(ic,id),id) = phtemp(ants(ic,id),id) + Q/dist(ic);
            end % id
        end % ic
        [dmin,ind] = min(dist);
        if dmin < dbest
            dbest = dmin;
            pbest = reshape(ants(ind,:),n,3);
        end % if
        % pheromone for elite path
        ph1 = zeros(Npaths, n*3);
        for id=1:n*3
            ph1(ants(ind,id),id) = Q/dmin;
        end % id
        % update pheromone trails
        phmone = (1-rr)*phmone + phtemp + e*ph1;
        dd(it,:) = [dbest dmin];
        [it dmin dbest]
    end %it

    best_plan = [transpose(distances(pbest(:,1))) transpose(times(pbest(:,2))) transpose(elevations(pbest(:,3)))];
    best_score = obj(best_plan, user_fitness, user_traits);
end