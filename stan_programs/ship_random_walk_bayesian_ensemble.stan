data {
  int<lower=0> N;
}

generated quantities {
  real prod_delay;
  real<lower=0> prod_mu;
  real<lower=0> prod_sigma;
  real<lower=0> ship_lambda;
  real production[N] = rep_array(0, N);
  real delivery[N]   = rep_array(0, N);
  
  prod_delay  = normal_rng(20, 5);
  prod_mu     = scaled_inv_chi_square_rng(10, 0.75);
  prod_sigma  = fabs(normal_rng(0, 2));   //  
  // ship_sigma  ~ normal(0, 1);
  ship_lambda = fabs(normal_rng(0, 0.2));
  
  production[1] = prod_delay + normal_rng(0, 0.1);
  delivery[1]   = production[1] + exponential_rng(ship_lambda);
  for (i in 2:N) {
    production[i] = production[i-1] + normal_rng(prod_mu, prod_sigma);
    delivery[i]   = production[i] + exponential_rng(ship_lambda);
  }
}
