% Training Plan ACO
% Based on ACO by Haupt & Haupt, 2003
% © Trifecta Labs

% Takes a parameter of user_fitness_data which has the following format
% [Umax_distance Umax_climb user_fitness]

% and user_traits which has the following format
% [height mass c_rr c_d]

% and user_prefs which has the following format
% [num_acts pct_short pct_avg pct_long]

function training_aco(user_fitness_data, user_traits, user_prefs, obj)
    rng('shuffle');
    
    range = [5 user_fitness_data(1)*1.25;...
            20 user_fitness_data(1)*1.25*(60/40);...
            0 user_fitness_data(2)*1.25];
    
    n = user_prefs(1);  % number of activities
    Npaths = 50;        % number of options for each variable
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
    
    % a1=0 - closest city is selected
    % be=0 - algorithm only works w/ pheromones and not distance of city
    % Q - close to the lenght of the optimal tour
    % rr - trail decay
    % maxit - max number of iterations
    maxit = 1000;
    a = 2;
    b = 6;
    rr = 0.5;
    Q = sum(1./(1:8));
    dbest = 9999999;
    e = 5;
    
    for ia=1:Nants
       ants(ia,:) = randperm(50,24);
    end
    
    for it=1:maxit
        % find the city tour for each ant
        % st is the current city
        % nxt contains the remaining cities to be visited
        for ia=1:Nants
            for iq=2:Ncity-1
                [iq tour(ia,:)];
                st=tour(ia,iq-1); nxt=tour(ia,iq:Ncity);
                prob=((phmone(st,nxt).^a).*(vis(st,nxt).^b)).^sum((phmone(st,nxt).^a).*(vis(st,nxt).^b));
                rcity=rand;
                for iz=1:length(prob)
                    if rcity<sum(prob(1:iz))
                        newcity=iq-1+iz; % next city to be visited
                        break
                    end % if
                end % iz
                temp=tour(ia,newcity); % puts the new city
                % selected next in line
                tour(ia,newcity)=tour(ia,iq);
                tour(ia,iq)=temp;
            end % iq
        end % ia
        % calculate the length of each tour and pheromone distribution
        phtemp=zeros(Ncity,Ncity);
        for ic=1:Nants
            dist(ic,1)=0;
            for id=1:Ncity
                dist(ic,1)=dist(ic)+dcity(tour(ic,id),tour(ic,id+1));
                phtemp(tour(ic,id),tour(ic,id+1))=Q/dist(ic,1);
            end % id
        end % ic
        [dmin,ind]=min(dist);
        if dmin<dbest
            dbest=dmin;
        end % if
        % pheromone for elite path
        ph1=zeros(Ncity,Ncity);
        for id=1:Ncity
            ph1(tour(ind,id),tour(ind,id+1))=Q/dbest;
        end % id
        % update pheromone trails
        phmone=(1-rr)*phmone+phtemp+e*ph1;
        dd(it,:)=[dbest dmin];
        [it dmin dbest]
    end %it

    [tour,dist]
    figure(1)
    plot(xcity(tour(ind,:)),ycity(tour(ind,:)),xcity,ycity,'o')
    set(gcf,'color','w');
    axis square
    figure(2);
    plot([1:maxit],dd(:,1),[1:maxit],dd(:,2))
    set(gcf,'color','w');
end