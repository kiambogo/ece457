function buckets = bucketGenerator(calendar)
        startTimes = [];
        endTimes = [];
        j = 1;
        r = calendar(j);
        r2 = calendar(j+1);
        if (r == 0)
            startTimes = [startTimes 1];
        end
        while (j < 1342)
            while (r == r2 && j < 1342)
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
        buckets = [transpose(startTimes) transpose(endTimes) transpose(endTimes-startTimes+1)];
        buckets = sortrows(buckets, -3);
    end