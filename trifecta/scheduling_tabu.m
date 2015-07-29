% The Tabu search implementation for scheduling a training plan. 
% Performs an optimization on schedules of activities in an attempt to find
% an optimal schedule for the training plan

% Takes a parameter of user_fitness_data which has the following format
% [Umax_distance Umax_climb user_fitness]
% and user_traits which has the following format
% [height mass c_rr c_d]

function [a, score] = scheduling_tabu(training_plan, calendar)
    iter = 1000;
    
    % Search space has the following format:
    % [Time_min Time_max]
    search_space = [0 1344];
    range = [1+1 1344-2];
    
    buckets = bucketGenerator(calendar);
    bestSched = sched_init(training_plan, buckets);
    init_score = scheduling_objective(bestSched, calendar, buckets);
    neighbours = generateNeighbours(bestSched, bucketGenerator(calendar));
    tabuList = zeros(8,3,iter);
    for i = 1:iter
        for n = 1:50 
            neighbour = neighbours(:,:,n);
            % If the neighbour is a better training plan, select it
            % This is determined by maximizing the fitness function
            neighbour_fitness = scheduling_objective(neighbour, calendar, buckets);
            current_best_fitness = scheduling_objective(bestSched, calendar, buckets);

            if (neighbour_fitness <= current_best_fitness)
                % If the selected schedule is not in the Tabu list, then choose it
                if (sum(sum(ismember(neighbour, tabuList))) < 24)
                    bestSched = neighbour;
                    tabuList(:,:,i) = bestSched;
                end
            end
        end
        neighbours = generateNeighbours(bestSched, bucketGenerator(calendar));
        a = bestSched;
    end
%   output(a, user_fitness_data(3), user_traits);
    score = scheduling_objective(a, calendar, buckets);
    b = a;
    for p = 1:size(a,1)
        b(p,3) = buckets(a(p,3),1);
    end
%    display_sched(b, calendar)
end

function neighbours = generateNeighbours(scheduled_tp, buckets)
    neighbours = zeros(8, 3, 50);
    for n = 1:50
        valid = false;
        while (~valid)
            validList = ones(8,1);
            for j = 1:8
                neighbours(j,:,n) = [ ...
                    scheduled_tp(j,1) ...
                    scheduled_tp(j,2) ...
                    randi(min([find(buckets(:,3)<scheduled_tp(j,2), 1)-1 size(buckets,1)]))];
            end
            for k=1:8
                if (size(find(neighbours(k,3,n)==neighbours(:,3,n)),1) ~= 1)
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
end
