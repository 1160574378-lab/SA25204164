#include <Rcpp.h>
using namespace Rcpp;

// 辅助函数：逆Gamma采样（非用户水平，不加comments）
double rinvgamma_cpp(double shape, double rate) {
  return 1.0 / R::rgamma(shape, 1.0 / rate);
}

//' @title Horseshoe Prior Gibbs Sampler (Cpp version)
//' @name horseshoe_gibbs_cpp
//' @description Fast C++ implementation of Gibbs sampler for Bayesian 
//'   sparse regression with horseshoe prior. This function is significantly
//'   faster than the pure R version for large datasets.
//' @param y Response vector of length n
//' @param X Design matrix of dimension n x p
//' @param niter Number of MCMC iterations (default 2000)
//' @param burnin Number of burn-in iterations (default 500)
//' @return A list containing:
//' \itemize{
//'   \item \code{beta_samples}: Matrix of posterior samples (niter-burnin) x p
//'   \item \code{tau_samples}: Vector of global shrinkage parameter samples
//'   \item \code{beta_mean}: Posterior mean estimates of beta
//' }
//' @examples
//' \dontrun{
//' set.seed(123)
//' n <- 50; p <- 20
//' X <- matrix(rnorm(n * p), n, p)
//' beta_true <- c(3, -2, 0, 0, 1.5, rep(0, p - 5))
//' y <- as.vector(X %*% beta_true + rnorm(n, sd = 0.5))
//' result <- horseshoe_gibbs_cpp(y, X, niter = 1000, burnin = 200)
//' print(round(result$beta_mean, 3))
//' }
//' @export
// [[Rcpp::export]]
List horseshoe_gibbs_cpp(NumericVector y, NumericMatrix X, 
                        int niter = 2000, int burnin = 500) {
 
 int n = X.nrow();
 int p = X.ncol();
 int n_samples = niter - burnin;
 
 // 预计算 X'X 对角元素
 NumericVector XtX_diag(p);
 for (int j = 0; j < p; j++) {
   double sum = 0.0;
   for (int i = 0; i < n; i++) {
     sum += X(i, j) * X(i, j);
   }
   XtX_diag[j] = sum;
 }
 
 // 初始化参数
 NumericVector beta(p, 0.0);
 NumericVector lambda(p, 1.0);  // 局部收缩参数
 double tau = 1.0;               // 全局收缩参数
 double sigma2 = 1.0;            // 误差方差
 
 // 存储后验样本
 NumericMatrix beta_samples(n_samples, p);
 NumericVector tau_samples(n_samples);
 
 // Gibbs 采样主循环
 for (int iter = 0; iter < niter; iter++) {
   
   // 1. 更新 beta（逐坐标）
   for (int j = 0; j < p; j++) {
     double sum_xy_j = 0.0;
     for (int i = 0; i < n; i++) {
       double fitted_minus_j = 0.0;
       for (int k = 0; k < p; k++) {
         if (k != j) fitted_minus_j += X(i, k) * beta[k];
       }
       sum_xy_j += X(i, j) * (y[i] - fitted_minus_j);
     }
     
     double lambda_j_sq = lambda[j] * lambda[j] * tau * tau;
     double var_j = 1.0 / (XtX_diag[j] / sigma2 + 1.0 / lambda_j_sq);
     double mean_j = var_j * sum_xy_j / sigma2;
     beta[j] = R::rnorm(mean_j, sqrt(var_j));
   }
   
   // 2. 更新 lambda（局部收缩参数）
   for (int j = 0; j < p; j++) {
     double nu_j = rinvgamma_cpp(1.0, 1.0 + 1.0 / (lambda[j] * lambda[j]));
     double rate_lam = 1.0/nu_j + beta[j]*beta[j] / (2.0*tau*tau*sigma2);
     lambda[j] = sqrt(rinvgamma_cpp(1.0, rate_lam));
   }
   
   // 3. 更新 tau（全局收缩参数）
   double xi = rinvgamma_cpp(1.0, 1.0 + 1.0 / (tau * tau));
   double sum_bl = 0.0;
   for (int j = 0; j < p; j++) {
     sum_bl += beta[j] * beta[j] / (lambda[j] * lambda[j]);
   }
   tau = sqrt(rinvgamma_cpp((p + 1.0) / 2.0, 1.0/xi + sum_bl / (2.0*sigma2)));
   
   // 4. 更新 sigma2（误差方差）
   double ss = 0.0;
   for (int i = 0; i < n; i++) {
     double fitted = 0.0;
     for (int j = 0; j < p; j++) fitted += X(i, j) * beta[j];
     ss += (y[i] - fitted) * (y[i] - fitted);
   }
   sigma2 = rinvgamma_cpp(n / 2.0, ss / 2.0);
   
   // 存储样本（burn-in之后）
   if (iter >= burnin) {
     int idx = iter - burnin;
     for (int j = 0; j < p; j++) {
       beta_samples(idx, j) = beta[j];
     }
     tau_samples[idx] = tau;
   }
 }
 
 // 计算后验均值
 NumericVector beta_mean(p, 0.0);
 for (int j = 0; j < p; j++) {
   for (int i = 0; i < n_samples; i++) {
     beta_mean[j] += beta_samples(i, j);
   }
   beta_mean[j] /= n_samples;
 }
 
 return List::create(
   Named("beta_samples") = beta_samples,
   Named("tau_samples") = tau_samples,
   Named("beta_mean") = beta_mean
 );
}