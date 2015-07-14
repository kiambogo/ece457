function v = V(training_plan)
    short = 0;
    average = 0;
    long = 0;
    penalty = 0;
    row = size(training_plan, 1);
    for j = 1:row
        activity = training_plan(j,:);
        duration = activity(2);
        if duration >= 30 && duration < 60
            short = short + 1;
        elseif duration >= 60 && duration <= 120
            average = average + 1;
        elseif duration > 120
            long = long + 1;
        end
    end
    short_p = short/row;
    if (short_p >= 0.35)
        penalty = penalty + (short_p - 0.35)*3000;
    elseif (short_p <= 0.15)
        penalty = penalty + (0.15 - short_p)*3000;
    end
    avg_p = average/row;
    if (avg_p >= 0.6)
        penalty = penalty + (avg_p - 0.6)*3000;
    elseif (avg_p <= 0.4)
        penalty = penalty + (0.4 - avg_p)*3000;
    end
    long_p = long/row;
    if (long_p >= 0.37)
        penalty = penalty + (long_p - 0.35)*3000;
    elseif (long_p <= 0.15)
        penalty = penalty + (0.15 - long_p)*3000;
    end
    v = penalty;
end