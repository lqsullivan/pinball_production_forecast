data {
  int<lower=0> N;
}

generated quantities {
  real production[N] = rep_array(0, N);
  real delivery[N]   = rep_array(0, N);
  
  production[1] = normal_rng(1, 0.5);
  delivery[1]   = production[1] + exponential_rng(2);
  for (i in 2:N) {
    production[i] = production[i-1] + normal_rng(1, 0.5);
    delivery[i]   = production[i] + exponential_rng(1);
  }
}
