function training_plan = G(lvl)
    training_plan = [1 45+randn(1)*5 50; 1 45+randn(1)*5 75; 1 90+randn(1)*10 100; 1 90+randn(1)*10 125; 1 90+randn(1)*10 150; 1 90+randn(1)*10 175; 1 180+randn(1)*20 200; 1 180+randn(1)*20 225];
    for j = 1:8
        l = 0;
        while (l < lvl)
            l = L(training_plan(j,:));
            training_plan(j,1) = training_plan(j,1) + 1;
        end
    end
    %output(training_plan, lvl, [180 69 0.004 1.0])
end