% The Tabu search implementation for scheduling a training plan. 
% Performs an optimization on schedules of activities in an attempt to find
% an optimal schedule for the training plan

% Takes a parameter of user_fitness_data which has the following format
% [Umax_distance Umax_climb user_fitness]
% and user_traits which has the following format
% [height mass c_rr c_d]

function a = scheduling_tabu(training_plan, calendar)
    global iter;
    
    iter = 1000;
    % Search space has the following format:
        % [Time_min Time_max]
    search_space = [0 1344];
    
    range = [1+1 1344-2];
    
    bestSched = sched_init(training_plan, bucketGenerator(calendar));
    score = scheduling_objective(bestSched, calendar)
    neighbours = generateNeighbours(bestSched, bucketGenerator(calendar));
    tabuList = zeros(8,3,iter);
    for i = 1:iter
        i
        for n = 1:50 
            neighbour = neighbours(:,:,n);
            % If the neighbour is a better training plan, select it
            % This is determined by maximizing the fitness function
            neighbour_fitness = scheduling_objective(neighbour, calendar);
            current_best_fitness = scheduling_objective(bestSched, calendar);

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
%     output(a, user_fitness_data(3), user_traits);
score = scheduling_objective(bestSched, calendar)
display_sched(a, calendar)
end

% function neighbours = generabuteNeighbours(scheduled_tp, ss)
%     neighbours = zeros(8, 3, 50);
%     for n = 1:50
%         for j = 1:8
%             valid = false;
%             while (~valid)
%                 neighbours(j,:,n) = [ ...
%                     scheduled_tp(j,1) ...
%                     scheduled_tp(j,2) ...
%                     floor(scheduled_tp(j,3)+randn(1)*sqrt(10))];
%                 if (neighbours(j,3,n) >= ss(1,1) && neighbours(j,3,n) <= ss(1,2))
%                     valid = true;
%                 end
%             end
%         end
%     end
% end
function neighbours = generateNeighbours(scheduled_tp, buckets)
    neighbours = zeros(8, 3, 50);
    validList = zeros(8,1);
    for n = 1:50
        valid = false;
        while (~valid)
            for j = 1:8
                neighbours(j,:,n) = [ ...
                    scheduled_tp(j,1) ...
                    scheduled_tp(j,2) ...
                    buckets(randi(size(buckets,1)),1)];
                a=buckets(find(buckets(:,1) == neighbours(j,3,n)),2);
                b=neighbours(j,3,n);
                if(a - b >= neighbours(j,2,n))
                    validList(j) = 1;
                end 
            end
            for k=1:8
                if (size(find(neighbours(k,3,n)==neighbours(:,3,n)),1) ~= 1)
                    validList(k)=0;
                end
            end
            
            if (sum(find(validList==0)) == 0)
                valid = true;
            else
                valid = false;
            end
        end
    end
end

