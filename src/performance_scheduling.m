
% Scheduling performance

weekend = [ones(1,24) zeros(1,60) ones(1,12)];
weekday = [ones(1,24) zeros(1,12) ones(1,32) zeros(1,16) ones(1,12)];
cal = [weekend weekday weekday weekday weekday weekday weekend weekend weekday weekday weekday weekday weekday weekend];
plan = [21 45 50; 22 45 75; 28 60 100; 29 60 125; 56 120 150; 57 120 175; 125 300 200; 126 300 225];

j = 10;
score_data = [];
iteration_data = [];
timing_data = [];

for f = 1:5
    scores = zeros(1,j);
    iterations = zeros(1,j);
    timings = zeros(1,j);
    
    for(i = 1:j)
        
        t1 = cputime;
        switch f
            case 1
                [sch, score, iter] = scheduling_tabu(plan, cal, @scheduling_objective);
            case 2
                [sch, score, iter] = scheduling_annealing(plan, cal, @scheduling_objective);
            case 3
                [sch, score, iter] = scheduling_genetic(plan, cal, @scheduling_objective);
            case 4
                [sch, score, iter] = scheduling_pso(plan, cal, @scheduling_objective);
            case 5
                [sch, score, iter] = schedlung_aco(plan, cal, @scheduling_objective);
            otherwise
        end
        t2 = cputime;
        scores(i) = score;
        iterations(i) = iter;
        timings(i) = t2-t1;
    end 
    score_data = [score_data ; [mean(scores) std(scores)]];
    iteration_data = [iteration_data; [mean(iterations) std(iterations)]];
    timing_data = [timing_data; [mean(timings) std(timings)]];
    
end

score_data
iteration_data
timing_data
