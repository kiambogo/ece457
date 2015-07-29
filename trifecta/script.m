% Initialization
user_fitness_data = [170, 1400, 24];
user_traits = [180 69 0.004, 1.0];
user_pref = [8 0.25 0.5 0.25];
weekend = [ones(1,24) zeros(1,60) ones(1,12)];
weekday = [ones(1,24) zeros(1,12) ones(1,32) zeros(1,16) ones(1,12)];
cal = [weekend weekday weekday weekday weekday weekday weekend weekend weekday weekday weekday weekday weekday weekend];
TP = [21 45 50; 22 45 75; 28 60 100; 29 60 125; 56 120 150; 57 120 175; 125 300 200; 126 300 225];


[bestplan, bestfun, count] = training_genetic([170, 1400, 24], [180 69 0.004, 1.0], [8 0.25 0.5 0.25], @training_objective);
training_plan = fix(reshape(bestplan(100,:),8,3));
Activities = {'1';'2';'3';'4';'5';'6';'7';'8'};
ColNames = {'Distance_km';'Duration_min'; 'Elevation_m'};
Distance = training_plan(:,1);
Duration = training_plan(:,2);
Elevation = training_plan(:,3);
Training_Plan = table(Distance, Duration, Elevation, 'RowNames', Activities, 'VariableNames', ColNames)


buckets = bucketGenerator(cal);
schedule = scheduling_tabu(TP, cal);
sorted_sched = zeros(8,4);
for p = 1:size(schedule,1)
    sorted_sched(p,:) = [schedule(p,1) schedule(p,2) schedule(p,3) buckets(schedule(p,3),1)];
end
schedule = sortrows(sorted_sched, 4);
schedule = schedule(:,1:3);

Activities = {'a';'b';'c';'d';'e';'f';'g';'h'};
Duration = schedule(:,2)*15;
Start_Time = [];
for p = 1:size(schedule,1)
    day = 12+floor((buckets(schedule(p,3),1)-1)/96);
    hour = floor(mod(buckets(schedule(p,3),1)-1, 96)/4);
    minute = floor(mod(mod(buckets(schedule(p,3),1)-1, 96), 4)*15);
    Start_Time = [Start_Time; {datestr(datenum(2015, 7, day, hour, minute, 0),0)}];
end
schedule = [schedule; Start_Time];
ColNames = {'Duration_min'; 'Start_Time'};
Schedule = table(Duration, Start_Time, 'RowNames', Activities, 'VariableNames', ColNames)
