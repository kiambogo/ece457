function scheduled_TP = sched_init(training_plan, search_space)
    scheduled_TP = zeros(size(training_plan,1), size(training_plan, 2));
    for j = 1:size(training_plan, 1)
        act = training_plan(j,:);
        dur = ceil(act(2)/15);
        range = [search_space(1) search_space(2)-dur];
        time = randi(range);
        scheduled_TP(j,:) = [j dur time];
    end
end