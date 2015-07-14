function w = W(x)
        if (x(2)*15 >= 30 && x(2)*15 < 60)
            w=120+randn(1)*15;
        elseif (x(2)*15 >= 60 && x(2)*15 <= 120)
            w=250+randn(1)*30;
        else
            w=2.75*x(2)*15;
        end
    end