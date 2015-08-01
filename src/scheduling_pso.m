% Scheduling PSO
% Based on PSO by Haupt & Haupt, 2003
% © Trifecta Labs

% Takes a parameter of user_fitness_data which has the following format
% [Umax_distance Umax_climb user_fitness]
% and user_traits which has the following format
% [height mass c_rr c_d]

function scheduling_pso(training_plan, calendar, obj)
    %Initialization
    search_space = [0 1344];
    buckets = bucketGenerator(calendar);
    range = [1 size(buckets,1)];
    n = size(training_plan, 1);
    nsbit=floor(log2(range(2))+1);
    % Initializing variables
    popsize = 10; % Size of the swarm
    npar = n * 3; % Dimension of the problem
    maxit = 100; % Maximum number of iterations
    c1 = 1; % cognitive parameter
    c2 = 4-c1; % social parameter
    C=1; % constriction factor
    % Initializing swarm and velocities
    par = [];
    for i = 1:popsize
      par = [par; reshape(scheduling_init(training_plan, buckets),1,npar)];
    end
    vel = rand(n,nsbit,popsize); % random velocities for each bit
    score = [];
    for i = 1:popsize
       score = [score; obj(reshape(par(i,:),n,3), buckets)]; 
    end

    minc(1)=min(score);   % min cost
    meanc(1)=mean(score); % mean cost
    globalmin=minc(1);    % initialize global minimum
    localpar = par;       % location of local minima
    localcost = score;    % cost of local minima

    % Finding best particle in initial population
    [globalcost,indx] = min(score);
    globalpar=par(indx,:);

    % Start iterations
    iter = 0;
    while iter < maxit
      tmp_par = [];
      valid = false;
      iter = iter + 1;
      % update velocity = vel
      w=(maxit-iter)/maxit; %inertia weiindxht
      while (~valid)
        iter
        valid = false;
        tmp_par = par;
        r1 = rand(n,nsbit,popsize); % random numbers, 8 for bit count 
        r2 = rand(n,nsbit,popsize); % random numbers
        localparBinary = [];
        parBinary = [];
        for q = 1:popsize
          for w = 1:8
            localparBinary(w,:,q) = dectobin(localpar(q,w+2*n));
            parBinary(w,:,q) = dectobin(par(q,w+2*n));
            globalparBinary = dectobin(globalpar(w));
          end
        end
        vel = vel + c1 *r1.*(localparBinary-parBinary) + c2*r2.*(repmat(globalparBinary,8,1,10)-parBinary);
        sig = 1./(1+exp(-vel));
        r = rand(n, nsbit, popsize);
        update = r > sig;

        % update particle positions
        for a = 1:popsize
          for b = 1:n
            tmp_par(a,b+2*n:3*n) = bintodec(update(b,:,a));
          end
        end
        if sum(sum(tmp_par == 0)) == 0
          valid = true;
        end
        for u = 1:popsize
          if (size(unique(tmp_par(u,1+2*n:3*n)),2) == size(tmp_par(u,1+2*n:3*n),2))
            valid = valid && true;
          else
            valid = false;
          end
        end
      end
      par = tmp_par;

      bucket_par = par(:,1+2*n:3*n);
      overlimit = bucket_par<=range(2);
      underlimit = bucket_par>=range(1);
      bucket_par=bucket_par.*overlimit+not(overlimit);
      bucket_par=bucket_par.*underlimit;

      par(:,1+2*n:3*n) = bucket_par;

      % Evaluate the new swarm
      for i = 1:popsize
        score(i) = obj(reshape(par(i,:),n,3), buckets);
      end

      % Updating the best local position for each particle
      bettercost = score < localcost;
      localcost = localcost.*not(bettercost) + score.*bettercost;
      localpar(find(bettercost),:) = par(find(bettercost),:);

      % Updating index g
      [temp, t] = min(localcost);
      if temp<globalcost
        globalpar=par(t,:); indx=t; globalcost=temp;
      end
      [iter globalpar globalcost]; % print output each iteration
      minc(iter+1)=min(score); % min for this iteration
      globalmin(iter+1)=globalcost; % best min so far
      meanc(iter+1)=mean(score); % avg. cost for this iteration
    end
    globalcost
    globalpar
    figure(24)
    iters=0:length(minc)-1;
    plot(iters,minc,iters,meanc,iters,globalmin,':');
    xlabel('generation');ylabel('cost');
    text(0,minc(1),'best');text(1,minc(2),'population average')
    set(gcf,'color','w');

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
end

