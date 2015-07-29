% macro_varience = [short avg long] => number of short/avg/long activities

function training_plan = G(lvl, macro_varience)
    short = macro_varience(1);
    avg = macro_varience(2);
    acts = sum(macro_varience);
    training_plan = zeros(acts,3);
    for i = 1:acts
       if (short - i >= 0)
           training_plan(i,:) = [1 45+randn(1)*5 100+randn(1)*25];
       elseif (short + avg - i >= 0)
           training_plan(i,:) = [1 90+randn(1)*10 200+randn(1)*50];
       else
           training_plan(i,:) = [1 180+randn(1)*20 300+randn(1)*75];
       end
    end
    for j = 1:acts
        l = 0;
        while (l < lvl)
            l = L(training_plan(j,:));
            training_plan(j,1) = training_plan(j,1) + 1;
        end
    end
    %output(training_plan, lvl, [180 69 0.004 1.0])
end