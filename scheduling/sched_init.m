function scheduled_TP = sched_init(training_plan)
    scheduled_TP = [1 45+randn(1)*5 50; 1 45+randn(1)*5 75; 1 90+randn(1)*10 100; 1 90+randn(1)*10 125; 1 90+randn(1)*10 150; 1 90+randn(1)*10 175; 1 180+randn(1)*20 200; 1 180+randn(1)*20 225];
    total_time = 0;
    for j = 1:size(training_plan, 1)
        act = training_plan(j,:);
        dur = ceil(act(2)/15);
        total_time = total_time + dur;
        scheduled_TP(j,:) = [j dur total_time+1];
    end
end