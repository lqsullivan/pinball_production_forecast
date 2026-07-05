data {
  int<lower=0> N;
  int<lower=0> N_obs;
  int<lower=1> relic_obs[N_obs];
  int<lower=1> relic_unobs[N - N_obs];
  vector[N_obs] delivery_obs;
}

parameters {
  real<lower=0> prod_mu;
  real<lower=0> prod_sigma;
  real<lower=0> ship_sigma;
  real<lower=0> ship_lambda;
  
  vector[N - N_obs] delivery_unobs;
  vector[N] production;
}

transformed parameters {
  vector[N] delivery;
  delivery[relic_obs] = delivery_obs;
  delivery[relic_unobs] = delivery_unobs;
}

model {
  prod_mu     ~ normal(1, 0.5);
  prod_sigma  ~ normal(0, 2);
  ship_sigma  ~ normal(0, 0.5);
  ship_lambda ~ normal(0, 0.5);
  
  // if this degenerate exp_mod_normal doesn't work try shipping error first?
  production[1]   ~ normal(prod_mu, prod_sigma);
  production[2:N] ~ normal(prod_mu + production[1:(N-1)], prod_sigma);
  delivery ~ exp_mod_normal(production, ship_sigma, ship_lambda);
}
