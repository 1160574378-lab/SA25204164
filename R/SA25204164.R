#' @title Horseshoe Prior Gibbs Sampler (R version)
#' @name horseshoe_gibbs_r
#' @description Pure R implementation of Gibbs sampler for Bayesian 
#'   sparse regression with horseshoe prior. The horseshoe prior provides
#'   strong shrinkage for noise coefficients while preserving large signals.
#' @param y Response vector of length n
#' @param X Design matrix of dimension n x p
#' @param niter Number of MCMC iterations (default 2000)
#' @param burnin Number of burn-in iterations (default 500)
#' @return A list containing:
#' \itemize{
#'   \item \code{beta_samples}: Matrix of posterior samples (niter-burnin) x p
#'   \item \code{tau_samples}: Vector of global shrinkage parameter samples
#'   \item \code{beta_mean}: Posterior mean estimates of beta
#' }
#' @examples
#' \dontrun{
#' set.seed(123)
#' dat <- simulate_sparse_data(n = 50, p = 10, s = 3)
#' result <- horseshoe_gibbs_r(dat$y, dat$X, niter = 1000, burnin = 200)
#' print(round(result$beta_mean, 3))
#' }
#' @export
horseshoe_gibbs_r <- function(y, X, niter = 2000, burnin = 500) {
  if (!is.matrix(X)) X <- as.matrix(X)
  n <- nrow(X)
  p <- ncol(X)
  
  # 初始化参数
  beta <- rep(0, p)
  lambda <- rep(1, p)  # 局部收缩参数
  tau <- 1             # 全局收缩参数
  sigma2 <- 1          # 误差方差
  
  # 存储后验样本
  n_samples <- niter - burnin
  beta_samples <- matrix(0, n_samples, p)
  tau_samples <- numeric(n_samples)
  
  # Gibbs采样主循环
  for (iter in 1:niter) {
    # 1. 更新 beta（逐坐标）
    for (j in 1:p) {
      resid_j <- y - X[, -j, drop = FALSE] %*% beta[-j]
      lambda_j_sq <- (lambda[j] * tau)^2
      var_j <- 1 / (sum(X[, j]^2) / sigma2 + 1 / lambda_j_sq)
      mean_j <- var_j * sum(X[, j] * resid_j) / sigma2
      beta[j] <- rnorm(1, mean_j, sqrt(var_j))
    }
    
    # 2. 更新 lambda（局部收缩参数）
    for (j in 1:p) {
      nu_j <- 1 / rgamma(1, 1, 1 + 1 / lambda[j]^2)
      lambda[j] <- sqrt(1 / rgamma(1, 1, 1/nu_j + beta[j]^2 / (2 * tau^2 * sigma2)))
    }
    
    # 3. 更新 tau（全局收缩参数）
    xi <- 1 / rgamma(1, 1, 1 + 1 / tau^2)
    sum_bl <- sum(beta^2 / lambda^2)
    tau <- sqrt(1 / rgamma(1, (p + 1) / 2, 1/xi + sum_bl / (2 * sigma2)))
    
    # 4. 更新 sigma2（误差方差）
    ss <- sum((y - X %*% beta)^2)
    sigma2 <- 1 / rgamma(1, n / 2, ss / 2)
    
    # 存储样本（burn-in之后）
    if (iter > burnin) {
      idx <- iter - burnin
      beta_samples[idx, ] <- beta
      tau_samples[idx] <- tau
    }
  }
  
  list(
    beta_samples = beta_samples, 
    tau_samples = tau_samples,
    beta_mean = colMeans(beta_samples)
  )
}

#' @title Horseshoe Estimator
#' @name horseshoe_estimate
#' @description Wrapper function for horseshoe prior estimation.
#'   Provides point estimates using posterior mean or median.
#' @param y Response vector
#' @param X Design matrix
#' @param method Point estimate method: "mean" or "median" (default "mean")
#' @param use_cpp Use C++ version for speed (default TRUE)
#' @param niter Number of MCMC iterations
#' @param burnin Burn-in iterations
#' @return Numeric vector of estimated coefficients
#' @examples
#' \dontrun{
#' dat <- simulate_sparse_data(n = 100, p = 20, s = 5)
#' beta_hat <- horseshoe_estimate(dat$y, dat$X, niter = 1000)
#' }
#' @export
horseshoe_estimate <- function(y, X, method = "mean", use_cpp = TRUE,
                               niter = 2000, burnin = 500) {
  if (use_cpp) {
    result <- horseshoe_gibbs_cpp(y, X, niter, burnin)
  } else {
    result <- horseshoe_gibbs_r(y, X, niter, burnin)
  }
  
  if (method == "mean") {
    return(result$beta_mean)
  } else {
    return(apply(result$beta_samples, 2, median))
  }
}

#' @title Simulate Sparse Regression Data
#' @name simulate_sparse_data
#' @description Generate simulation data for sparse signal recovery experiments.
#' @param n Sample size
#' @param p Number of predictors
#' @param s Number of non-zero signals
#' @param signal Magnitude of non-zero coefficients (default 3)
#' @param sigma Noise standard deviation (default 1)
#' @return A list containing:
#' \itemize{
#'   \item \code{y}: Response vector
#'   \item \code{X}: Design matrix
#'   \item \code{beta_true}: True coefficient vector
#'   \item \code{s}: Number of signals
#' }
#' @examples
#' \dontrun{
#' set.seed(123)
#' dat <- simulate_sparse_data(n = 100, p = 50, s = 5)
#' str(dat)
#' }
#' @export
simulate_sparse_data <- function(n, p, s, signal = 3, sigma = 1) {
  X <- matrix(rnorm(n * p), n, p)
  beta_true <- c(rep(signal, s), rep(0, p - s))
  y <- as.vector(X %*% beta_true + rnorm(n, sd = sigma))
  list(y = y, X = X, beta_true = beta_true, s = s)
}
#' @import microbenchmark
#' @importFrom Rcpp evalCpp
#' @importFrom stats rnorm rgamma median
#' @useDynLib SA25204164
NULL