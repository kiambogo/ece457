function lvl = L(x)
    p = P(x, 69, 0.004, 1.0);
    lvl = heaviside(-200/x(2) + p/5 - 9);
end