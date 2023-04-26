// saved as osl_functions.stan
// uses tau eta parameterisation
functions {
  real calcA(real tau, real eta) {
    real A;
    A = log(1 / (2 * tau + 2 * eta));   // same as (tau + eta)^-1   / 2
    return(A);
  }
  real calcB(real x, real del0, real sigma, real tau) {
    real B1;
    real B2;
    real B;
    B1 = (1 / (2 * tau)) * (2 * x + sigma^2 / tau - 2 * del0);
    B2 = log(erfc((-del0 + x + sigma^2 / tau) / (sqrt(2) * sigma)));
    B = B1 + B2;
    return(B);
  }
  real calcC(real x, real del0, real sigma, real eta) {
    real C1;
    real C2;
    real C;
    C1 = (1 / (2 * eta)) * (-2 * x + sigma^2 / eta + 2 * del0);
    C2 = log(erfc((del0 - x + sigma^2 / eta) / (sqrt(2) * sigma)));
    C = C1 + C2;
    return(C);
  }
  real calcMAM(real x, real sigma, real gam, real p0, real mu_t, real sigma_t) {
    real s2;
    real sigma_0;
    real logsqrt2pi;
    real lf1i;
    real lf2i;
    real mu_0;
    real res_0;
    real res_1;
    real llik;
    s2 = sigma_t^2 + sigma^2;
    sigma_0 = 1 / sqrt(1 / sigma_t^2 + 1 / sigma^2);
    logsqrt2pi = 0.5 * log(2 * pi());
    lf1i = log(p0) - log(sigma) - 0.5 * ((x - gam) / sigma)^2 - 
      logsqrt2pi;
    lf2i = log(1 - p0) - 0.5 * log(s2) - 0.5 * (x - mu_t)^2 / s2 - 
      logsqrt2pi; 
    mu_0 = (mu_t / sigma_t^2 + x / sigma^2) / (1 / sigma_t^2 + 1 / sigma^2);
    res_0 = (gam - mu_0) / sigma_0;
    res_1 = (gam - mu_t) / sigma_t;
    lf2i = lf2i + normal_lcdf(res_0 | 0, 1) - normal_lcdf(res_1 | 0, 1);
    llik = log_sum_exp(lf1i, lf2i);
    return(llik);
  }
  real ral_rng(real delta_0, real tau, real eta) {
    real nu = sqrt(tau*eta);
    real kappa = sqrt(tau/eta);
    real delta = delta_0+nu*log(uniform_rng(0,1)^kappa / uniform_rng(0,1)^(1/kappa))/sqrt(2);
    return(delta);
  }
  real rcam_rng(real delta, real rel_err, real sigma) {
    real x1 = normal_rng(delta, sqrt(rel_err^2+sigma^2));
    return(x1);
  }
  real alosl_rng(real delta_0, real tau, real eta, real rel_err, real sigma) {
    real delta = ral_rng(delta_0, tau, eta);
    real x1 = rcam_rng(delta, rel_err, sigma);
    return(x1);
  }
  // See 18.10 in the Stan Users Guide
  real rmam_rng(real delta_0, real mu_t, real sigma_t, real p0, real sigma) {
    real x1;
    if(uniform_rng(0,1) < p0) {
      x1 = normal_rng(delta_0, sigma);
    } else {
      // truncated normal with ub delta_0
      real p_ub = normal_cdf(delta_0, mu_t, sqrt(sigma_t^2 + sigma^2));
      real u = uniform_rng(0, p_ub);
      x1 = mu_t + sqrt(sigma_t^2 + sigma^2) * inv_Phi(u);
      // x1 = delta_0;
      // while(x1 >= delta_0) {
      //   x1 = normal_rng(mu_t, sqrt(sigma_t^2 + sigma^2));
      // }
    }
  return(x1);
  }
  real mam_helper(real y, real delta_0, real mu_t, real sigma2) {
    real x1;
    x1 = normal_lpdf(y | mu_t, sigma2);
    if(x1 > delta_0) x1 = negative_infinity();
    else x1 = x1 - normal_lcdf(delta_0 | mu_t, sigma2);
    return(x1);
  }
}