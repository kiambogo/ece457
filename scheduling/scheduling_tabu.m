% The Tabu search implementation for scheduling a training plan. 
% Performs an optimization on schedules of activities in an attempt to find
% an optimal schedule for the training plan

% Takes a parameter of user_fitness_data which has the following format
% [Umax_distance Umax_climb user_fitness]
% and user_traits which has the following format
% [height mass c_rr c_d]

function a = scheduling_tabu(training_plan, calendar)
    % Search space has the following format:
        % [Time_min Time_max]
    search_space = [0 1344];
    
    bestSchedule = G(user_fitness_data(3));
    neighbours = generateNeighbours(bestTP, search_space);
    tabuList = zeros(8,3,100);
    for i = 1:1000
        for n = 1:50 
            neighbour = neighbours(:,:,n);
            % If the neighbour is a better training plan, select it
            % This is determined by maximizing the fitness function
            neighbour_fitness = objective(neighbour, user_fitness_data(3), user_traits);
            current_best_fitness = objective(bestTP, user_fitness_data(3), user_traits);

            if (neighbour_fitness >= current_best_fitness)
                % If the selected TP is not in the Tabu list, then choose it
                if (sum(sum(ismember(neighbour, tabuList))) < 24)
                    bestTP = neighbour;
                    tabuList(:,:,i) = bestTP;
                end
            end
            neighbours = generateNeighbours(bestTP, search_space);
        end
        a = bestTP;
    end
    output(a, user_fitness_data(3), user_traits);
end

function neighbours = generateNeighbours(trainingPlan, ss)
    neighbours = zeros(8, 3, 50);
    for n = 1:50
        for j = 1:8
            valid = false;
            while (~valid)
                neighbours(j,:,n) = [ ...
                    trainingPlan(j,1)+randn(1)*sqrt(1), ...
                    trainingPlan(j,2)+randn(1)*sqrt(4), ...
                    trainingPlan(j,2)+randn(1)*sqrt(10)];
                if (neighbours(j,1,n) >= ss(1,1) && neighbours(j,1,n) <= ss(1,2) && ...
                    neighbours(j,2,n) >= ss(2,1) && neighbours(j,2,n) <= ss(2,2) && ...
                    neighbours(j,3,n) >= ss(3,1) && neighbours(j,3,n) <= ss(3,2))
                    valid = true;
                end
            end
        end
    end
end