


arg1 = [170, 1400, 24];
arg2 = [180, 69, 0.004, 1.0];
arg3 = [8 0.25 0.5 0.25];

j = 10;
score_data = [];
iteration_data = [];
timing_data = [];

for f = 5:5
    scores = zeros(1,j);
    iterations = zeros(1,j);
    timings = zeros(1,j);
    
    for(i = 1:j)
        i
        t1 = cputime;
        switch f
            case 1
                [plan, score, iter] = training_tabu(arg1, arg2, arg3, @training_objective);
            case 2
                [plan, score, iter] = training_annealing(arg1, arg2, arg3, @training_objective);
            case 3
                [plan, score, iter] = training_genetic(arg1, arg2, arg3, @training_objective);
            case 4
                [plan, score, iter] = training_pso(arg1, arg2, arg3, @training_objective);
            case 5
                [plan, score, iter] = training_aco(arg1, arg2, arg3, @training_objective);
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
beep on
beep
