% The Tabu search implementation of the training plan generator. 
% Performs an optimization on activities that constitute a training plan in an attempt to create the best training plan. 

% Takes a parameter of user_fitness_data which has the following format
% [Umax_distance Umax_climb user_fitness]
% and user_traits which has the following format
% [height mass c_rr c_d]
% and user_prefs which has the following format
% [num_acts pct_short pct_avg pct_long]

% Takes a function obj which is the objective function

function [best_plan, best_score, i] = training_tabu(user_fitness_data, user_traits, user_prefs, obj)
    global iter;
    
    iter = 1000;
    % Search space has the following format:
        % [Distance_min Distance_max]
        % [Time_min Time_max]
        % [Elevation_min Elevation_max]
    search_space = ...
        [5 user_fitness_data(1)*1.25;...
        20 user_fitness_data(1)*1.25*(60/40);...
        0 user_fitness_data(2)*1.25];
    user_fitness = user_fitness_data(3);
    
    a = user_prefs(1);  % Number of activities
    macro_varience = [...           
        floor(a*user_prefs(2))...   % Number of short activities
        ceil(a*user_prefs(3))...    % Number of average actvities
        floor(a*user_prefs(4))];    % Number of long activities
    bestTP = training_init(user_fitness, macro_varience); % Initial training plan
    neighbours = generateNeighbours(bestTP, search_space); % Generate neighbours of initial solution
    tabuList = zeros(8,3,iter); % initialize tabu list
    
    for i = 1:iter
        for n = 1:50 
            neighbour = neighbours(:,:,n);
            % If the neighbour is a better training plan, select it
            % This is determined by maximizing the fitness function
            neighbour_fitness = obj(neighbour, user_fitness, user_traits);
            current_best_fitness = obj(bestTP, user_fitness, user_traits);

            if (neighbour_fitness >= current_best_fitness)
                % If the selected TP is not in the Tabu list, then choose it
                if (sum(sum(ismember(neighbour, tabuList))) < 24)
                    bestTP = neighbour;
                    tabuList(:,:,i) = bestTP;
                end
            end
            neighbours = generateNeighbours(bestTP, search_space);
        end
        best_plan = bestTP;
    end
    best_score = obj(best_plan, user_fitness, user_traits);
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
