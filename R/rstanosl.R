# Format OSL data for Stan
# 
# This function formats OSL data for use with Stan. It is not exported but is used by the other functions in this package.
#
# @param data data\[,1\] are the dose values, data\[,2\] are the standard errors
# @param logged are supplied doses (and associated standard errors) logged (logged = T)
# @param sigma fixed overdispersion valued (optional)
# @param messages print messages to the console (messages = T)
#
# @return a list of data for Stan
#
get_standat <- function(data, logged = F, sigma = NULL, messages = T) {
  if(!logged){
    if(sum(data[,1])<=0) stop("Unlogged dose data must not contain negative dose values")
    d <- log(data[,1])
    se <- data[,2]/data[,1]
    if(messages) message("Supplied dose data: unlogged")
  } else {
    d <- data[,1]
    se <- data[,2]
    if(messages) message("Supplied dose data: logged")
  }
  if(is.null(sigma) || sigma <= 0 || !is.numeric(sigma)) {
    sigma <- numeric(0)
    sigma_known <- 0
  } else {
    sigma <- array(sigma, 1)
    sigma_known <- 1
  }
  d <- as.array(d)
  se <- as.array(se)
  stan_dat <- NULL
  stan_dat <- list(N = nrow(data),
                   Y = d,
                   E = se,
                   sigma_f = sigma,
                   sigma_known = sigma_known)
  stan_dat
}

# Fit OSL models with Stan
#
# This function fits OSL data to a Stan model. It is not exported but is used by the other functions in this package.
#
# @param data data\[,1\] are the dose values, data\[,2\] are the standard errors
# @param model the OSL model to use: almm, mxdm3, mxdm4, cdm
# @param logged specifies if the supplied doses (and associated standard errors) are logged (logged = T)
# @param sigma specifies a fixed overdispersion value (optional - if set to NULL the parameter is estimated)
#
# @return a fitted STAN object
#
fit_osl <- function(data, model = "cdm", logged = F, sigma = NULL, messages = T, ...){
  data <- as.data.frame(data)
  if(messages) {
    if(!is.null(sigma) && sigma > 0 && is.numeric(sigma)) message("Overdispersion (sigma): fixed (user supplied)") 
    else message("Overdispersion (sigma): to be estimated")
  }
  if(!model %in% c("cdm", "almm", "mxdm3", "mxdm4")) stop("model must be 'cdm', 'almm', 'mxdm3' or 'mxdm4'")
  #in_mod <- paste0("./R/models/mod_", model, ".stan")
  in_mod <- system.file(paste0("models/mod_", model, ".stan"), package = "rstanosl")
  stan_dat <- get_standat(data, logged, sigma, messages)
  fit_dat <- suppressWarnings(rstan::stan(in_mod,
    data = stan_dat,
    ...
  ))
  fit_dat
}

#' Fit an ALMM model to OSL data
#'
#' This function fits an OSL Asymmetric Laplacian Mixture Model (ALMM) using Stan. 
#'
#' @param data data\[,1\] are the dose values, data\[,2\] are the standard errors
#' @param logged specifies if the supplied doses (and associated standard errors) are logged (logged = T)
#' @param sigma specifies a fixed overdispersion valued (optional)
#' @param messages print status messages to the console (messages = T)
#' @param ... additional arguments passed to \code{\link[rstan]{stan}}
#'
#' @return a fitted Stan object
#' @export
#' @seealso \code{\link{rstanosl}}
almm <- function(data, logged = F, sigma = NULL, messages = T, ...){
  if(messages) message("Fitting ALMM dose model")
  fit_osl(data, model = "almm", logged = logged, sigma = sigma, messages = messages, ...)
}

#' Fit a CDM moodel to OSL data
#'
#' This function fits an OSL Central Dose Model (CDM) using Stan.
#'
#' @param data data\[,1\] are the dose values, data\[,2\] are the standard errors
#' @param logged specifies if the supplied doses (and associated standard errors) are logged (logged = T)
#' @param sigma specifies a fixed overdispersion value (optional - if set to NULL the parameter is estimated)
#' @param messages print status messages to the console (messages = T)
#' @param ... additional arguments passed to \code{\link[rstan]{stan}}
#'
#' @return a fitted Stan object
#' @export
#' @seealso \code{\link{rstanosl}}
cdm <- function(data, logged = F, sigma = NULL, messages = T, ...){
  if(messages) message("Fitting CDM dose model")
  fit_osl(data, model = "cdm", logged = logged, sigma = sigma, messages = messages, ...)
}

#' Fit a MXDM3 model to OSL data
#'
#' This function fits an OSL 3 parameter Maximum Dose Model (MXDM3) using Stan.
#'
#' @param data data\[,1\] are the dose values, data\[,2\] are the standard errors
#' @param logged specifies if the supplied doses (and associated standard errors) are logged (logged = T)
#' @param sigma specifies a fixed overdispersion value (optional - if set to NULL the parameter is estimated)
#' @param messages print status messages to the console (messages = T)
#' @param ... additional arguments passed to \code{\link[rstan]{stan}}
#'
#' @return a fitted Stan object
#' @export
#' @seealso \code{\link{rstanosl}}
mxdm3 <- function(data, logged = F, sigma = NULL, messages = T, ...){
  if(messages) message("Fitting MXDM3 dose model")
  fit_osl(data, model = "mxdm3", logged = logged, sigma = sigma, messages = T, ...)
}

#' Fit a MDXM4 model to OSL data
#'
#' This function fits an OSL 4 parameter Maximum Dose Model (MXDM4) using Stan.
#'
#' @param data data\[,1\] are the dose values, data\[,2\] are the standard errors
#' @param logged specifies if the supplied doses (and associated standard errors) are logged (logged = T)
#' @param sigma specifies a fixed overdispersion value (optional - if set to NULL the parameter is estimated)
#' @param messages print status messages to the console (messages = T)
#' @param ... additional arguments passed to \code{\link[rstan]{stan}}
#'
#' @return a fitted Stan object
#' @export
#' @seealso \code{\link{rstanosl}}
mxdm4 <- function(data, logged = F, sigma = NULL, messages = T, ...){
  if(messages) message("Fitting MXDM4 dose model")
  fit_osl(data, model = "mxdm4", logged = logged, sigma = sigma, messages = T, ...)
}
