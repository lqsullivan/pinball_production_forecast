data {
  int<lower=0> N;
  int<lower=0> K;
  matrix[N, K] X;
  vector[N] delay;
}

parameters {
  real<lower=0> intercept;
  vector[K] beta;
  real<lower=0> sigma;
}

model {
  intercept ~ normal(30, 20);
  beta ~ normal(0, 1);
  sigma ~ normal(0, 10);
  
  delay ~ normal(intercept + X * beta, sigma);
}
