function v = V(training_plan)
        short = 0;
        average = 0;
        long = 0;
        penalty = 0;
        for j = 1:8
            activity = training_plan(j,:);
            duration = activity(2);
            if duration >= 30 && duration <= 60
                short = short + 1;
            elseif duration >= 60 && duration <= 120
                average = average + 1;
            elseif duration >= 120
                long = long + 1;
            end
        end
        short_p = short/8;
        if (short_p >= 0.35)
            penalty = penalty + (short_p - 0.35)*2000;
        elseif (short_p <= 0.15)
            penalty = penalty + (0.15 - short_p)*2000;
        end
        avg_p = average/8;
        if (avg_p >= 0.6)
            penalty = penalty + (avg_p - 0.6)*2000;
        elseif (avg_p <= 0.4)
            penalty = penalty + (0.4 - avg_p)*2000;
        end
        long_p = long/8;
        if (long_p >= 0.37)
            penalty = penalty + (long_p - 0.35)*2000;
        elseif (long_p <= 0.15)
            penalty = penalty + (0.15 - long_p)*2000;
        end
        v = penalty;
    end
