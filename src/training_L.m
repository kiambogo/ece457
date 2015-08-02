function lvl = L(x, mass)
  p = training_P(x, mass);
  lvl = heaviside(-200/x(2) + p/5 - 9);
end
