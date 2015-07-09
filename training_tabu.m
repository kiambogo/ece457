% The Tabu search implementation of the training plan generator. 
% Performs an optimization on activities that constitute a training plan in an attempt to create the best training plan. 

% Takes a parameter of user_data which has the following format
% [Umax_distance Umax_climb]

function a = training_tabu(user_data)

% Search space has the following format:
    % [Distance_min Distance_max]
    % [Time_min Time_max]
    % [Elevation_min Elevation_max]
search_space = ...
    [5 user_data(1)*1.25;...
    20 user_data(1)*1.25*(60/40);...
    0 user_data(2)*1.25];
a=init(search_space);
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
            (ss(3,2)-ss(3,1))*rand(1, 1)+ss(3,1)...
            ];
    end
end

