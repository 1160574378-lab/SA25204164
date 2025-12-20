## ----eval=FALSE---------------------------------------------------------------
# simulate_sparse_data <- function(n, p, s, signal = 3, sigma = 1) {
#   X <- matrix(rnorm(n * p), n, p)
#   beta_true <- c(rep(signal, s), rep(0, p - s))
#   y <- as.vector(X %*% beta_true + rnorm(n, sd = sigma))
#   list(y = y, X = X, beta_true = beta_true, s = s)
# }

## ----eval=FALSE---------------------------------------------------------------
# horseshoe_gibbs_r <- function(y, X, niter = 2000, burnin = 500) {
#   if (!is.matrix(X)) X <- as.matrix(X)
#   n <- nrow(X)
#   p <- ncol(X)
# 
#   # Initialize parameters
#   beta <- rep(0, p)
#   lambda <- rep(1, p)
#   tau <- 1
#   sigma2 <- 1
# 
#   # Storage for posterior samples
#   n_samples <- niter - burnin
#   beta_samples <- matrix(0, n_samples, p)
#   tau_samples <- numeric(n_samples)
# 
#   # Gibbs sampling loop
#   for (iter in 1:niter) {
#     # Update beta
#     for (j in 1:p) {
#       resid_j <- y - X[, -j, drop = FALSE] %*% beta[-j]
#       lambda_j_sq <- (lambda[j] * tau)^2
#       var_j <- 1 / (sum(X[, j]^2) / sigma2 + 1 / lambda_j_sq)
#       mean_j <- var_j * sum(X[, j] * resid_j) / sigma2
#       beta[j] <- rnorm(1, mean_j, sqrt(var_j))
#     }
# 
#     # Update lambda
#     for (j in 1:p) {
#       nu_j <- 1 / rgamma(1, 1, 1 + 1 / lambda[j]^2)
#       lambda[j] <- sqrt(1 / rgamma(1, 1, 1/nu_j + beta[j]^2 / (2 * tau^2 * sigma2)))
#     }
# 
#     # Update tau
#     xi <- 1 / rgamma(1, 1, 1 + 1 / tau^2)
#     sum_bl <- sum(beta^2 / lambda^2)
#     tau <- sqrt(1 / rgamma(1, (p + 1) / 2, 1/xi + sum_bl / (2 * sigma2)))
# 
#     # Update sigma2
#     ss <- sum((y - X %*% beta)^2)
#     sigma2 <- 1 / rgamma(1, n / 2, ss / 2)
# 
#     # Store samples after burn-in
#     if (iter > burnin) {
#       idx <- iter - burnin
#       beta_samples[idx, ] <- beta
#       tau_samples[idx] <- tau
#     }
#   }
# 
#   list(
#     beta_samples = beta_samples,
#     tau_samples = tau_samples,
#     beta_mean = colMeans(beta_samples)
#   )
# }

## ----eval=FALSE---------------------------------------------------------------
# horseshoe_gibbs_cpp <- function(y, X, niter = 2000, burnin = 500) {
#   # C++ implementation (compiled from src/horseshoe_gibbs.cpp)
#   # Provides identical results to R version with significant speedup
# }

## ----eval=FALSE---------------------------------------------------------------
# horseshoe_estimate <- function(y, X, method = "mean", use_cpp = TRUE,
#                                 niter = 2000, burnin = 500) {
#   if (use_cpp) {
#     result <- horseshoe_gibbs_cpp(y, X, niter, burnin)
#   } else {
#     result <- horseshoe_gibbs_r(y, X, niter, burnin)
#   }
# 
#   if (method == "mean") {
#     return(result$beta_mean)
#   } else {
#     return(apply(result$beta_samples, 2, median))
#   }
# }

## ----eval= TRUE---------------------------------------------------------------
library(SA25204164)
library(microbenchmark)
set.seed(123)
dat <- simulate_sparse_data(n = 50, p = 20, s = 3)

tm <- microbenchmark(
  R_version = horseshoe_gibbs_r(dat$y, dat$X, niter = 500, burnin = 100),
  Cpp_version = horseshoe_gibbs_cpp(dat$y, dat$X, 500, 100),
  times = 10
)

knitr::kable(summary(tm)[, c("expr", "median")])

