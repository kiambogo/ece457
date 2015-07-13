% The Tabu search implementation of the training plan generator. 
% Performs an optimization on activities that constitute a training plan in an attempt to create the best training plan. 

% Takes a parameter of user_fitness_data which has the following format
% [Umax_distance Umax_climb user_fitness]
% and user_traits which has the following format
% [height mass c_rr c_d]

function a = training_tabu(user_fitness_data, user_traits)

% Search space has the following format:
    % [Distance_min Distance_max]
    % [Time_min Time_max]
    % [Elevation_min Elevation_max]
search_space = ...
    [5 user_fitness_data(1)*1.25;...
    20 user_fitness_data(1)*1.25*(60/40);...
    0 user_fitness_data(2)*1.25];
%bestTP = init(search_space)
%bestTP = [21 45 50; 22 45 75; 28 60 100; 29 60 125; 56 120 150; 57 120 175; 84 180 200; 85 180 225];
bestTP = G(user_fitness_data(3))
neighbours = generateNeighbours(bestTP);
tabuList = zeros(8,3,100);
for i = 1:5000
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
        neighbours = generateNeighbours(bestTP);
    end
    a = bestTP;
end
    output(a, user_fitness_data(3), user_traits);
end
%%
function initTrainingPlan = init(ss)
% Training plan has the following format:
    % [Act1_distance, Act1_time, Act1_elevation]
    % [Act2_distance, Act2_time, Act2_elevation]
    % ...
    % [Act8_distance, Act8_time, Act8_elevation]
    initTrainingPlan = zeros(8,3);
    for n = 1:8
        initTrainingPlan(n,:) = [...
            (ss(1,2)-ss(1,1))*rand(1, 1)+ss(1,1),...
            (ss(2,2)-ss(2,1))*rand(1, 1)+ss(2,1),...
            (ss(3,2)-ss(3,1))*rand(1, 1)+ss(3,1)];
    end
end

function neighbours = generateNeighbours(trainingPlan)
    neighbours = zeros(8, 3, 50);
    for n = 1:50
        for j = 1:8
        neighbours(j,:,n) = [ ...
            trainingPlan(j,1)+randn(1)*sqrt(1), ...
            trainingPlan(j,2)+randn(1)*sqrt(4), ...
            trainingPlan(j,2)+randn(1)*sqrt(10)];
        end
    end
end