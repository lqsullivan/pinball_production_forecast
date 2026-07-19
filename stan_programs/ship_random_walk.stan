data {
  int<lower=0> N;
  int<lower=0> N_obs;
  array[N_obs]   int<lower=1> relic_obs;
  array[N-N_obs] int<lower=1> relic_unobs;
  vector[N_obs] delivery_obs;
}
parameters {
  real<lower=0> prod_mu;
  real<lower=0> prod_sigma;
  real<lower=0> ship_lambda;
  
  vector<lower=0>[N-N_obs] delivery_unobs;
  vector<lower=0, upper=delivery_obs>[N_obs] production_obs;
  vector<lower=0, upper=delivery_unobs>[N-N_obs] production_unobs;
}

transformed parameters {
  vector[N] production;
  production[relic_obs] = production_obs;
  production[relic_unobs] = production_unobs;
}
model {
  production[1] ~ normal(20, 5);
  prod_mu       ~ scaled_inv_chi_square(10, 0.75);
  prod_sigma    ~ normal(0, 1);
  ship_lambda   ~ normal(0, 0.5);

  delivery_obs[1] - production_obs[1] ~ normal(prod_mu, prod_sigma);
  production[2:N] - production[1:N - 1] ~ normal(prod_mu, prod_sigma);
  delivery_obs - production_obs ~ exponential(ship_lambda);
  delivery_unobs - production_unobs ~ exponential(ship_lambda);
}