function scheduled_TP = sched_init(training_plan, buckets)
    sortedTP = sortrows(training_plan, -2);
    scheduled_TP = zeros(size(training_plan,1), size(training_plan, 2));
    for j = 1:size(sortedTP, 1)
        act = sortedTP(j,:);
        dur = ceil(act(2)/15);
        for b = j:size(buckets, 1)
            bucket = buckets(b,:);
            if (bucket(2) - bucket(1) >= dur)
                scheduled_TP(j,:) = [j dur b];
                break;
            end
        end
    end
end