function training_plan = G(lvl)
        training_plan = [1 45 50; 1 45 75; 1 60 100; 1 60 125; 1 120 150; 1 120 175; 1 180 200; 1 180 225];
        for j = 1:8
            l = L(training_plan(j,:));
            while floor(l) ~= floor(lvl)
                training_plan(j,1) = training_plan(j,1) + 1;
                l = L(training_plan(j,:));
            end
        end   
        training_plan
        output(training_plan, lvl, [180 69 0.004 1.0])
end