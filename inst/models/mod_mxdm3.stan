// saved as mod_mxdm3.stan - this is the 3 parameter version
#include osl_functions.stan
#include osl_data.stan
parameters {
  real delta_0;  
  real<lower=0> sigma_p[sigma_known ? 0 : 1];
  real<lower=0, upper=1> p0;
  real<lower=0> sigma_t;
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
  p0 ~ beta(0.5, 0.5); // Jeffrey's 
  if (!sigma_known) {
    sigma_p ~ cauchy(0, 1);
  }
  sigma_t ~ cauchy(0, 1);
  delta_0 ~ cauchy(0, 1);
  for(n in 1:N) {
      target += calcMAM(Y[n], sqrt(E[n]^2 + sigma^2), delta_0, p0, delta_0, sigma_t);
  }
}
// For model selection
generated quantities {
  vector[N] log_lik;
  vector[N] y_rep;
  for(n in 1:N) {
    log_lik[n] = calcMAM(Y[n], sqrt(E[n]^2 + sigma^2), delta_0, p0, delta_0, sigma_t);
    y_rep[n] = rmam_rng(delta_0, delta_0, sigma_t, p0, sqrt(E[n]^2 + sigma^2));
  }
}
