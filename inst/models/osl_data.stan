// saved as osl_data.stan
data {
  int<lower=0> N;   // maximum number of observations 
  vector[N] Y;      // De value
  vector[N] E;      // rel.err value
  int<lower=0,upper=1> sigma_known; // 1 if sigma is known, 0 if unknown
  real<lower=0> sigma_f[sigma_known ? 1 : 0]; // fixed value of sigma
}