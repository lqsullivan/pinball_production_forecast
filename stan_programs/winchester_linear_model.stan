data {
  int<lower=0> N;
  vector[N] relic;
  vector[N] delivery;
}

parameters {
  real<lower=0> prod_delay;
  real<lower=0> prod_rate;
  real<lower=0> sigma;
}

transformed parameters {
  vector<lower=0>[N] production;
  production = prod_delay + relic * prod_rate;
}

model {
  prod_delay ~ uniform(0, 90);
  prod_rate ~ normal(0, 1);
  sigma ~ normal(0, 10);
  
  delivery ~ normal(prod_delay + prod_rate * relic, sigma);
}
