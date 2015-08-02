% Training Plan Initialization
% © Trifecta Labs

% Helper function for initilizating the training plan generators.

% Creates a very easy, rudimentary training plan with a psuedorandom 
% element. 

% The training plan is then made more difficult until it reaches a
% difficulty appropriate to the users' level. 

function training_plan = training_init(lvl, user_traits, macro_varience)
    % Define the number of short, average, and long activities to generate
    short = macro_varience(1);
    avg = macro_varience(2);
    acts = sum(macro_varience);
    training_plan = zeros(acts,3);
    % Create psuedorandom activities
    for i = 1:acts
       if (short - i >= 0)
           training_plan(i,:) = [1 45+randn(1)*5 100+randn(1)*25];
       elseif (short + avg - i >= 0)
           training_plan(i,:) = [1 90+randn(1)*10 200+randn(1)*50];
       else
           training_plan(i,:) = [1 180+randn(1)*20 300+randn(1)*75];
       end
    end
    % Adjust the generated activities to match the users' level
    for j = 1:acts
        l = 0;
        while (l < lvl)
            l = training_L(training_plan(j,:), user_traits);
            training_plan(j,1) = training_plan(j,1) + 1;
        end
    end
end
