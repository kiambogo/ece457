% Training Plan PSO
% Based on PSO by Haupt & Haupt, 2003
% © Trifecta Labs

% Takes a parameter of user_fitness_data which has the following format
% [Umax_distance Umax_climb user_fitness]

% and user_traits which has the following format
% [height mass c_rr c_d]

% and user_prefs which has the following format
% [num_acts pct_short pct_avg pct_long]

function [globalpar] = training_pso(user_fitness_data, user_traits, user_prefs, obj)
    %Initialization  
    range = [5 user_fitness_data(1)*1.25;...
            20 user_fitness_data(1)*1.25*(60/40);...
            0 user_fitness_data(2)*1.25];
        
    user_fitness = user_fitness_data(3);
    n=user_prefs(1);
    macro_varience = [floor(n*user_prefs(2)) ceil(n*user_prefs(3)) floor(n*user_prefs(4))];
    
    popsize = 10;   % Size of the swarm
    npar = n*3;     % Dimension of the problem
    maxit = 1000;   % Maximum number of iterations
    c1 = 1;         % cognitive parameter
    c2 = 4-c1;      % social parameter
    C = 1;          % constriction factor
    
    % random population of training plans
    par = [];
    for i = 1:popsize
       par = [par; reshape(G(user_fitness, macro_varience),1,npar)];
    end
    vel = rand(popsize,npar); % random velocities
    score = [];
    for i = 1:popsize
       score = [score; obj(reshape(par(i,:),n,3),user_fitness,user_traits)]; 
    end

    maxc(1) = max(score);   % max score
    meanc(1) = mean(score); % mean score
    globalmax = maxc(1);    % initialize global maximum
    localpar = par;         % location of local maxima
    localscore = score;     % cost of local maxima
    
    % Finding best particle in initial population
    [globalscore,indx] = max(score);
    globalpar = par(indx,:);

    % Start iterations
    iter = 0;
    while iter < maxit
        iter = iter + 1;
        % update velocity = vel
        w = (maxit-iter)/maxit; %inertia weiindxht
        r1 = rand(popsize,npar); % random numbers
        r2 = rand(popsize,npar); % random numbers
        vel = C*(w*vel + c1 *r1.*(localpar-par) + c2*r2.*(ones(popsize,1)*globalpar-par));
        % update particle positions
        par = par + vel;
        
        distance_par = par(:,1:n);
        distance_overlimit = distance_par<=range(1,2);
        distance_underlimit = distance_par>=range(1,1);
        distance_par = distance_par.*distance_overlimit + not(distance_overlimit)*range(1,2);
        distance_par = distance_par.*distance_underlimit + not(distance_underlimit)*range(1,1);
        
        time_par = par(:,1+n:n*2);
        time_overlimit = time_par<=range(2,2);
        time_underlimit = time_par>=range(2,1);
        time_par = time_par.*time_overlimit + not(time_overlimit)*range(2,2);
        time_par = time_par.*time_underlimit + not(time_overlimit)*range(2,1);
        
        elevation_par = par(:,1+2*n:n*3);
        elevation_overlimit = elevation_par<=range(3,2);
        elevation_underlimit = elevation_par>=range(3,1);
        elevation_par = elevation_par.*elevation_overlimit + not(elevation_overlimit)*range(3,2);
        elevation_par = elevation_par.*elevation_underlimit + not(elevation_overlimit)*range(3,1);
        
        par = [distance_par time_par elevation_par];
        % Evaluate the new swarm
        for i = 1:popsize
            score(i) = obj(reshape(par(i,:),n,3),user_fitness,user_traits);
        end
        % Updating the best local position for each particle
        betterscore = score > localscore;
        localscore = localscore.*not(betterscore) + score.*betterscore;
        localpar(find(betterscore),:) = par(find(betterscore),:);
        % Updating index g
        [temp, t] = max(localscore);
        if temp > globalscore
            globalpar = par(t,:);
            globalscore = temp;
        end
        % print output each iteration
        %iter
        %score
        %reshape(globalpar,n,3)
        %globalscore
        maxc(iter+1) = max(score); % min for this iteration
        globalmax(iter+1) = globalscore; % best max so far
        meanc(iter+1) = mean(score); % avg. cost for this iteration
    end
    figure(24)
    iters = 0:length(maxc)-1;
    plot(iters,maxc,iters,meanc,iters,globalmax,':');
    xlabel('generation');ylabel('score');
    text(0,maxc(1),'best');text(1,maxc(2),'population average')
    set(gcf,'color','w');
end