Command-line Instructions
=========================

The training functions take a parameter of user_fitness_data which has the following format [Umax_distance Umax_climb user_fitness] and user_traits which has the following format [height mass c_rr c_d] and user_prefs which has the following format [num_acts pct_short pct_avg pct_long] and take a function obj which is the objective function. Examples of this are shown below.

training_tabu([170, 1400, 24], [180 69 0.004, 1.0], [8 0.25 0.5 0.25], @training_objective);
training_annealing([170, 1400, 24], [180 69 0.004, 1.0], [8 0.25 0.5 0.25], @training_objective);
training_genetic([170, 1400, 24], [180 69 0.004, 1.0], [8 0.25 0.5 0.25], @training_objective);
training_pso([170, 1400, 24], [180 69 0.004, 1.0], [8 0.25 0.5 0.25], @training_objective);
training_aco([170, 1400, 24], [180 69 0.004, 1.0], [8 0.25 0.5 0.25], @training_objective);

The scheduling functions takes a parameter of training_plan which was output from a training plan optimization function and calendar vector which has the format of:
	0 => free 15 minute period
	1 => busy 15 minute period
They also take a function obj which is the objective function. Examples of this are shown below.

weekend = [ones(1,24) zeros(1,60) ones(1,12)];
weekday = [ones(1,24) zeros(1,12) ones(1,32) zeros(1,16) ones(1,12)];
cal = [weekend weekday weekday weekday weekday weekday weekend weekend weekday weekday weekday weekday weekday weekend];
TP = [21 45 50; 22 45 75; 28 60 100; 29 60 125; 56 120 150; 57 120 175; 125 300 200; 126 300 225];

scheduling_tabu(TP, cal, @scheduling_objective);
scheduling_annealing(TP, cal, @scheduling_objective);
scheduling_genetic(TP, cal, @scheduling_objective);
scheduling_pso(TP, cal, @scheduling_objective);
scheduling_aco(TP, cal, @scheduling_objective);

GUI Instructions
================