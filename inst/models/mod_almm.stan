// saved as mod_almm.stan
#include osl_functions.stan
#include osl_data.stan
parameters {
  real delta_0;
  real<lower=0> sigma_p[sigma_known ? 0 : 1];
  real<lower=0> tau;
  real<lower=0> eta;
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
  delta_0 ~ cauchy(0, 1);
  if (!sigma_known) {
    sigma_p ~ cauchy(0, 1);
  }
  tau ~ cauchy(0, 1);
  eta ~ cauchy(0, 1);
  {
    for(n in 1:N) {
      real partA;
      real partB;
      real partC;
      partA = calcA(tau, eta);
      partB = calcB(Y[n], delta_0, sqrt(E[n]^2 + sigma^2), tau);
      partC = calcC(Y[n], delta_0, sqrt(E[n]^2 + sigma^2), eta);
      target += log_sum_exp(partA + partB, partA + partC);
    }
  }
}
// For model selection
generated quantities {
  vector[N] log_lik;
  vector[N] y_rep;
  {
    for(n in 1:N) {
      real partA;
      real partB;
      real partC;
      partA = calcA(tau, eta);
      partB = calcB(Y[n], delta_0, sqrt(E[n]^2 + sigma^2), tau);
      partC = calcC(Y[n], delta_0, sqrt(E[n]^2 + sigma^2), eta);
      log_lik[n] = log_sum_exp(partA + partB, partA + partC);
      y_rep[n] = alosl_rng(delta_0, tau, eta, E[n], sigma);
    }
  }  
}
