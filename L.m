function lvl = L(x, mass, c_rr, c_d)
    p = P(x, mass, c_rr, c_d);
    lvl = heaviside(-200/x(2) + p/5 - 9);
end