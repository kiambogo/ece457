% The Tabu search implementation for scheduling a training plan. 
% Performs an optimization on schedules of activities in an attempt to find
% an optimal schedule for the training plan

% Takes a parameter of training_plan which was output from a training plan
% optmization function
% and calendar vector which has the format of:
% 0 => free 15 minute period
% 1 => busy 15 minute period
% Takes a function obj which is the objective function

function [a, score, i] = scheduling_tabu(training_plan, calendar, obj)
    iter = 1000;
    
    % Search space has the following format:
    % [Time_min Time_max]
    search_space = [0 1344];
    range = [1+1 1344-2];
    
    buckets = bucketGenerator(calendar);
    bestSched = sched_init(training_plan, buckets);
    init_score = obj(bestSched, buckets);
    neighbours = generateNeighbours(bestSched, bucketGenerator(calendar));
    tabuList = zeros(8,3,iter);
    for i = 1:iter
        for n = 1:50 
            neighbour = neighbours(:,:,n);
            % If the neighbour is a better training plan, select it
            % This is determined by maximizing the fitness function
            neighbour_fitness = obj(neighbour, buckets);
            current_best_fitness = obj(bestSched, buckets);

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
    
    score = obj(a, buckets);
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

