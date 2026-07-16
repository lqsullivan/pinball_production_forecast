data {
  int<lower=0> N;
  int<lower=0> N_obs;
  int<lower=1> relic_obs[N_obs];
  int<lower=1> relic_unobs[N - N_obs];
  vector[N_obs] delivery_obs;
}

parameters {
  real<lower=0> prod_delay;
  real<lower=0> prod_mu;
  real<lower=0> prod_sigma;
  real<lower=0> ship_lambda;
  
  vector[N-1] production_after_first;
  vector[N-N_obs] delivery_unobs;
  vector<lower=0>[N-N_obs] shipping_time_unobs;
}

transformed parameters {
  vector[N] production;
  production[1] = prod_delay;
  production[2:N] = production_after_first;
  
  vector<lower=0>[N] shipping_time;
  shipping_time[relic_obs] = delivery_obs - production[relic_obs];
  shipping_time[relic_unobs] = shipping_time_unobs;
  
  vector[N] delivery;
  delivery[relic_obs] = delivery_obs;
  delivery[relic_unobs] = production[relic_unobs] + shipping_time[relic_unobs];
}

model {
  prod_delay  ~ normal(20, 5);
  prod_mu     ~ scaled_inv_chi_square(10, 0.75);
  prod_sigma  ~ normal(0, 1);
  ship_lambda ~ normal(0, 0.5);
  
  // if this degenerate exp_mod_normal doesn't work try shipping error first?
  production[2:N] ~ normal(prod_mu + production[1:(N-1)], prod_sigma);
  shipping_time ~ exponential(ship_lambda);
}
