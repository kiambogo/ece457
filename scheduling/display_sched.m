function display_sched(sched, cal)
    for i=1:size(sched,1)
        [sched(i,3) sched(i,3)+sched(i,2)-1]
        cal(sched(i,3):sched(i,3)+sched(i,2)-1)
    end
end