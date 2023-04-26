// saved as mod_cdm.stan
#include osl_data.stan
parameters {
  real delta_0;
  real<lower=0> sigma_p[sigma_known ? 0 : 1];
}
transformed parameters {
  real<lower=0> sigma;
  if (sigma_known) {
    sigma = sigma_f[1];
  } else {
    sigma = sigma_p[1];
  }
}
model {
  Y ~ normal(delta_0, sqrt(E + sigma^2));

  delta_0 ~ cauchy(0, 1);
  if (!sigma_known) {
    sigma_p ~ cauchy(0, 2);
  }
}
// For model selection
generated quantities {
  vector[N] log_lik;
  vector[N] y_rep;
  for(n in 1:N) {
    log_lik[n] = normal_lpdf(Y[n] | delta_0, sqrt(E[n]^2 + sigma^2));
    y_rep[n] = normal_rng(delta_0, sqrt(E[n]^2 + sigma^2));
  }
}
