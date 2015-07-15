function buckets = bucketGenerator(calendar)
        buckets = [];
        startTimes = [];
        endTimes = [];
        % 6:00 - 21:00 daily
        validWindows = [24 84; 120 180; 216 276; 312 372; 408 468; 504 564; 600 660;...
            696 756; 792 852; 888 948; 984 1044; 1080 1140; 1176 1236; 1272 1332];
        j = 1;
        r = calendar(j);
        r2 = calendar(j+1);
        if (r == 0)
            startTimes = [startTimes 1];
        end
        while (j < 1342)
            while (r == r2 & j < 1342)
                j = j + 1;
                r = calendar(j);
                r2 = calendar(j+1); 
            end
            if (r == 0 && r2 == 1)
                endTimes = [endTimes j];
            elseif (r == 1 && r2 == 0)
                startTimes = [startTimes j+1];
            end
            r = calendar(j+1);
            r2 = calendar(j+2); 
        end
        buckets = [transpose(startTimes) transpose(endTimes)];
    end