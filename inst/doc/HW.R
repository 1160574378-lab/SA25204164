## ----setup, include=FALSE-----------------------------------------------------
knitr::opts_chunk$set(echo = TRUE,eval=FALSE,warning = FALSE)

## -----------------------------------------------------------------------------
# head(mtcars)

## -----------------------------------------------------------------------------
# plot(x = mtcars$wt,
#      y = mtcars$mpg,
#      pch = 18,                 # 点形状：18代表实心菱形点
#      col = "steelblue",        # 点颜色：钢蓝色
#      cex = 1.5,                # 点大小：1.5倍默认大小
#      xlab = "Weight (1000 lbs)", # X轴标签
#      ylab = "Miles per Gallon (mpg)", # Y轴标签
#      main = "Vehicle Weight vs. Fuel Economy") # 图表标题
# # 添加一条线性回归线，直观显示趋势
# abline(lm(mpg ~ wt, data = mtcars),
#        col = "red",    # 线颜色：红色
#        lwd = 2)        # 线宽：2倍默认宽度
# # 添加图例
# legend("topright",
#        legend = "Regression Line",
#        col = "red",
#        lty = 1,
#        lwd = 2)

## -----------------------------------------------------------------------------
# library(kableExtra)
# mydata <- as.data.frame(women)
# 
# knitr::kable(mydata,align = 'c') %>%
# kable_styling(bootstrap_options = c("striped", "hover", "condensed"),
#                 full_width = FALSE) %>%
# row_spec(0, bold = TRUE, color = "white", background = "steelblue")

## -----------------------------------------------------------------------------
# options(digits = 3)
# n<-nrow(women)
# fit<-lm(weight~height,data=women)
# sfit<-summary(fit)
# b<-coefficients(fit)

## -----------------------------------------------------------------------------
# library(broom)
# library(knitr)
# library(kableExtra)
# 
# results<-tidy(fit)    #将回归结果导出为tibble数据框
# tb1<-kable(results)   #将数据框转化为HTML代码
# kable_styling(tb1,"striped",full_width = FALSE,position = "left")   #设定表格宽度，对齐方式，添加条纹

## ----fig.width=5,fig.height=4-------------------------------------------------
# library(ggplot2)
# ggplot(data=women,aes(x=height,y=weight))+
#          geom_point() + geom_smooth(method = "lm",formula = y~x)

## -----------------------------------------------------------------------------
# # 使用逆变换抽样法生成瑞利分布随机数
# rayleigh_inv <- function(n, sigma) {
#   # 瑞利分布的累积分布函数：F(x) = 1 - exp(-x^2/(2*sigma^2))
#   # 逆函数：F^{-1}(u) = sigma * sqrt(-2 * log(1 - u))
#   u <- runif(n)
#   x <- sigma * sqrt(-2 * log(1 - u))
#   return(x)
# }
# 
# 
# # 主函数：生成样本并验证众数
# validate_rayleigh <- function(sigma_values, n_samples = 10000, method = "inv") {
# 
#   results <- list()
# 
#   for (sigma in sigma_values) {
#     # 生成样本
#     if (method == "inv") {
#       samples <- rayleigh_inv(n_samples, sigma)
#     } else if (method == "polar") {
#       samples <- rayleigh_polar(n_samples, sigma)
#     } else {
#       samples <- rayleigh_builtin(n_samples, sigma)
#     }
# 
#     # 计算样本众数（使用核密度估计的峰值）
#     dens <- density(samples)
#     empirical_mode <- dens$x[which.max(dens$y)]
# 
#     # 理论众数
#     theoretical_mode <- sigma
# 
#     # 计算相对误差
#     relative_error <- abs(empirical_mode - theoretical_mode) / theoretical_mode * 100
# 
#     # 存储结果
#     results[[as.character(sigma)]] <- list(
#       sigma = sigma,
#       samples = samples,
#       empirical_mode = empirical_mode,
#       theoretical_mode = theoretical_mode,
#       relative_error = relative_error,
#       density = dens
#     )
# 
#     # 打印结果
#     cat(sprintf("σ = %.2f: 理论众数 = %.2f, 经验众数 = %.2f, 相对误差 = %.2f%%\n",
#                 sigma, theoretical_mode, empirical_mode, relative_error))
#   }
# 
#   return(results)
# }
# 
# 
# # 绘制验证图形
# plot_validation <- function(results) {
#   par(mfrow = c(2, 2))
# 
#   for (i in seq_along(results)) {
#     result <- results[[i]]
#     sigma <- result$sigma
# 
#     # 绘制直方图和密度曲线
#     hist(result$samples, prob = TRUE, breaks = 50,
#          main = sprintf("瑞利分布 (σ = %.1f)", sigma),
#          xlab = "x", col = "lightblue", border = "white")
# 
#     # 添加核密度估计
#     lines(result$density, col = "blue", lwd = 2)
# 
#     # 添加理论密度曲线
#     x <- seq(0, max(result$samples), length.out = 100)
#     y <- (x / sigma^2) * exp(-x^2 / (2 * sigma^2))
#     lines(x, y, col = "red", lwd = 2, lty = 2)
# 
#     # 添加众数标记
#     abline(v = result$theoretical_mode, col = "red", lwd = 2, lty = 2)
#     abline(v = result$empirical_mode, col = "blue", lwd = 2, lty = 2)
# 
#     legend("topright",
#            legend = c("理论密度", "经验密度", "理论众数", "经验众数"),
#            col = c("red", "blue", "red", "blue"),
#            lwd = 2, lty = c(2, 1, 2, 1), cex = 0.8)
#   }
#   par(mfrow = c(1, 1))
# }

## -----------------------------------------------------------------------------
# # 设置随机种子确保可重复性
# set.seed(123)
# 
# # 定义要测试的sigma值
# sigma_values <- c(0.5, 1, 2, 5)
# 
# # 步骤1：执行验证（生成数据）
# cat("正在生成瑞利分布样本...\n")
# results <- validate_rayleigh(sigma_values, n_samples = 10000, method = "inv")
# 
# # 步骤2：调用绘图函数
# cat("正在绘制验证图形...\n")
# plot_validation(results)

## -----------------------------------------------------------------------------
# x<-0:4
# p<-c(.1,.2,.2,.2,.3)
# 
# library(knitr)
# library(kableExtra)
# 
# # data.frame(X = x, P = p) %>%
# #   kable() %>%
# #   kable_styling("striped",full_width = FALSE,position = "left")       #默认：两列表格
# matrix(c(x, p), nrow = 2, byrow = TRUE,
#        dimnames = list(c("X", "P"), NULL)) %>%
#   kable() %>%
#   kable_styling("striped",full_width = FALSE,position = "left")         #两行表格

## -----------------------------------------------------------------------------
# cp <- cumsum(p) #概率积累
# m <- 1e3
# #set.seed(111)  #确定种子
# U = runif(m)
# samples_inv<- x[findInterval(U,cp)+1]
# table(samples_inv)
# ct <- as.vector(table(samples_inv))
# ct/sum(ct)/p

## -----------------------------------------------------------------------------
# # 使用sample函数生成样本
# set.seed(123)    #
# samples_sample<-sample(x,1000,prob=p, replace = TRUE)
# table(samples_sample)
# ct <- as.vector(table(samples_sample))
# ct/sum(ct)/p

## -----------------------------------------------------------------------------
# # 定义接受-拒绝法采样函数
# beta_ar_sampler <- function(n, a, b, M = NULL) {
#   "
#   使用接受-拒绝法从贝塔分布生成随机样本
# 
#   参数:
#   n: 样本大小
#   a, b: 贝塔分布的参数
#   M: 接受-拒绝法中的常数，如果为NULL则自动计算
# 
#   返回:
#   list: 包含样本和接受率的列表
#   "
# 
#   # 如果没有提供M，则计算合适的M值
#   if (is.null(M)) {
#     # 贝塔分布的众数出现在 x = (a-1)/(a+b-2)
#     if (a > 1 && b > 1) {
#       mode <- (a - 1) / (a + b - 2)
#       max_density <- dbeta(mode, a, b)
#     } else {
#       # 如果参数<=1，众数在边界，我们取一个安全的上界
#       max_density <- dbeta(0.5, a, b) * 1.5
#     }
#     M <- max_density * 1.1  # 加10%的安全边际
#   }
# 
#   samples <- numeric(n)
#   trials <- 0
#   accepted <- 0
# 
#   while (accepted < n) {
#     trials <- trials + 1
# 
#     # 从建议分布（均匀分布）生成候选样本
#     x_candidate <- runif(1, 0, 1)
# 
#     # 从均匀分布生成比较值
#     u <- runif(1, 0, 1)
# 
#     # 计算目标密度与建议密度的比值
#     # 建议分布是U(0,1)，密度为1
#     target_density <- dbeta(x_candidate, a, b)
#     ratio <- target_density / M
# 
#     # 接受-拒绝准则
#     if (u <= ratio) {
#       accepted <- accepted + 1
#       samples[accepted] <- x_candidate
#     }
#   }
# 
#   acceptance_rate <- n / trials
# 
#   return(list(samples = samples, acceptance_rate = acceptance_rate))
# }
# 
# # 设置随机种子以确保结果可重现
# set.seed(123)
# 
# # 从Beta(3,2)分布生成1000个样本
# result <- beta_ar_sampler(1000, 3, 2)
# samples <- result$samples
# acc_rate <- result$acceptance_rate
# 
# # 输出结果
# cat("生成的样本数量:", length(samples), "\n")
# cat("接受率:", round(acc_rate, 4), "(", round(acc_rate * 100, 2), "%)\n")
# cat("样本统计:\n")
# cat("  均值:", round(mean(samples), 4), "(理论值:", round(3/(3+2), 4), ")\n")
# cat("  方差:", round(var(samples), 4),"(理论方差:", round((3*2)/((3+2)^2*(3+2+1)), 4),")\n")
# 
# # 绘制直方图和理论密度曲线
# # 设置图形参数
# par(mar = c(4, 4, 2, 1))
# 
# # 绘制直方图
# hist(samples, breaks = 30, freq = FALSE, col = "lightblue",
#      border = "black", main = "Beta(3,2)样本直方图与理论密度",
#      xlab = "x", ylab = "密度", ylim = c(0, 2.2))
# 
# # 添加理论密度曲线
# x <- seq(0, 1, length.out = 1000)
# theoretical_pdf <- dbeta(x, 3, 2)
# lines(x, theoretical_pdf, col = "red", lwd = 2)
# 
# # 添加图例
# legend("topright", legend = c("样本直方图", "理论Beta(3,2)密度"),
#        col = c("lightblue", "red"), lty = c(NA, 1), lwd = c(NA, 2),
#        pch = c(15, NA), bty = "n", fill = c("lightblue", NA))
# 
# #添加网络
# # grid()

## -----------------------------------------------------------------------------
# # 设置随机种子保证结果可重现
# set.seed(123)
# 
# # 定义生成混合正态分布的函数
# generate_mixture_normal <- function(n, p1, mu1 = 0, mu2 = 3, sigma1 = 1, sigma2 = 1) {
#   # 生成混合指标
#   mixture_indicator <- rbinom(n, 1, p1)
# 
#   # 根据混合指标生成样本
#   sample_data <- numeric(n)
#   sample_data[mixture_indicator == 1] <- rnorm(sum(mixture_indicator == 1), mu1, sigma1)
#   sample_data[mixture_indicator == 0] <- rnorm(sum(mixture_indicator == 0), mu2, sigma2)
# 
#   return(sample_data)
# }
# 
# # 定义混合分布的密度函数
# mixture_density <- function(x, p1, mu1 = 0, mu2 = 3, sigma1 = 1, sigma2 = 1) {
#   p1 * dnorm(x, mu1, sigma1) + (1 - p1) * dnorm(x, mu2, sigma2)
# }
# 
# # 测试不同的p1值
# p1_values <- c(0.95, 0.75, 0.5, 0.25, 0.1)
# sample_size <- 1000
# 
# # 创建图形布局
# par(mfrow = c(2, 3))
# 
# for (p1 in p1_values) {
#   # 生成样本
#   sample_data <- generate_mixture_normal(sample_size, p1)
# 
#   # 绘制直方图
#   hist(sample_data, breaks = 30, probability = TRUE,
#        main = paste("混合正态分布: p1 =", p1),
#        xlab = "x", ylab = "密度",
#        col = "lightblue", border = "white",
#        xlim = c(-4, 7), ylim = c(0, 0.4))
# 
#   # 叠加理论密度曲线
#   x_vals <- seq(-4, 7, length.out = 1000)
#   density_vals <- mixture_density(x_vals, p1)
#   lines(x_vals, density_vals, col = "red", lwd = 2)
# 
#   # 叠加两个成分的密度曲线
#   lines(x_vals, p1 * dnorm(x_vals, 0, 1), col = "blue", lty = 2, lwd = 1)
#   lines(x_vals, (1 - p1) * dnorm(x_vals, 3, 1), col = "green", lty = 2, lwd = 1)
# 
#   # 添加图例
#   legend("topright",
#          legend = c("混合密度", "N(0,1)成分", "N(3,1)成分"),
#          col = c("red", "blue", "green"),
#          lty = c(1, 2, 2), lwd = c(2, 1, 1),
#          cex = 0.5)
# 
#   # 计算峰的数量（简单方法）
#   density_est <- density(sample_data)
#   peaks <- which(diff(sign(diff(density_est$y))) == -2) + 1
#   num_peaks <- length(peaks)
# 
#   # 在图上标注峰的数量
#   mtext(paste("检测到的峰:", num_peaks), side = 3, line = 0, cex = 0.8)
# }
# 
# # 重置图形参数
# par(mfrow = c(1, 1))
# 
# # 更详细地分析双峰出现的临界p1值
# cat("双峰性分析\n")
# 
# 
# # 测试更细分的p1值来找到双峰出现的临界点
# detailed_p1 <- seq(0.1, 0.9, by = 0.05)
# bimodal_results <- data.frame(p1 = detailed_p1, peaks = numeric(length(detailed_p1)))
# 
# for (i in 1:length(detailed_p1)) {
#   p1 <- detailed_p1[i]
#   sample_data <- generate_mixture_normal(5000, p1)  # 使用更大样本以获得更准确的密度估计
# 
#   # 使用核密度估计检测峰
#   density_est <- density(sample_data, bw = "SJ")  # Sheather-Jones带宽选择
#   peaks <- which(diff(sign(diff(density_est$y))) == -2) + 1
#   bimodal_results$peaks[i] <- length(peaks)
# 
#   # 对于双峰情况，计算峰的位置
#   if (length(peaks) >= 2) {
#     peak_positions <- density_est$x[peaks[1:2]]
#     cat(sprintf("p1 = %.2f: %d个峰, 峰位置: %.2f, %.2f\n",
#                 p1, length(peaks), peak_positions[1], peak_positions[2]))
#   } else {
#     cat(sprintf("p1 = %.2f: %d个峰\n", p1, length(peaks)))
#   }
# }
# 
# # 可视化双峰性随p1的变化
# plot(bimodal_results$p1, bimodal_results$peaks,
#      type = "b", pch = 16, col = "blue",
#      xlab = "混合概率 p1", ylab = "检测到的峰数量",
#      main = "混合分布的双峰性 vs p1",
#      ylim = c(0, 3))
# abline(h = 1.5, lty = 2, col = "red")
# grid()
# 
# # 理论分析：双峰出现的条件
# cat("\n理论分析:\n")
# cat("对于两个正态分布N(μ1,σ²)和N(μ2,σ²)的混合，\n")
# cat("当 |μ1 - μ2| > 2σ 时，混合分布可能出现双峰。\n")
# cat("在我们的例子中: |0 - 3| = 3 > 2×1 = 2，因此可能出现双峰。\n\n")
# 
# cat("双峰出现的临界p1值大约在: p1 ≈ 0.2 - 0.8 范围内\n")
# cat("当p1接近0.5时，双峰特征最明显\n")
# cat("当p1接近0或1时，混合分布退化为单峰\n")
# 
# # 绘制临界区域的详细视图
# critical_p1 <- c(0.15, 0.25, 0.5, 0.75, 0.85)
# par(mfrow = c(2, 3))
# 
# for (p1 in critical_p1) {
#   sample_data <- generate_mixture_normal(10000, p1)
# 
#   hist(sample_data, breaks = 50, probability = TRUE,
#        main = paste("p1 =", p1, "- 临界区域"),
#        xlab = "x", ylab = "密度",
#        col = "lightcoral", border = "white")
# 
#   x_vals <- seq(-4, 7, length.out = 1000)
#   density_vals <- mixture_density(x_vals, p1)
#   lines(x_vals, density_vals, col = "darkred", lwd = 2)
# 
#   # 检测并标记峰
#   density_est <- density(sample_data, bw = "SJ")
#   peaks <- which(diff(sign(diff(density_est$y))) == -2) + 1
#   points(density_est$x[peaks], density_est$y[peaks], col = "blue", pch = 16, cex = 1.5)
# }
# 
# par(mfrow = c(1, 1))

## -----------------------------------------------------------------------------
# # 设置参数
# set.seed(123)  # 设置随机种子以保证结果可重现
# n <- 1000      # 样本量
# r <- 4         # 伽马分布的形状参数
# beta <- 2      # 伽马分布的尺度参数
# 
# # 直接法生成指数-伽马混合分布
# # 对于指数-伽马混合，Y ~ Pareto 类型分布
# # 公式：Y = (1/beta) * (1/rgamma(n, r, 1) - 1)
# y <- (1/beta) * (1/rgamma(n, shape = r, rate = 1) - 1)
# 
# # 输出结果摘要
# cat("指数-伽马混合分布的1000个随机观测值（直接法）：\n")
# cat("前10个观测值：", round(head(y, 10), 4), "\n\n")
# 
# cat("描述性统计：\n")
# cat("均值：", round(mean(y), 4), "\n")
# cat("标准差：", round(sd(y), 4), "\n")
# cat("最小值：", round(min(y), 4), "\n")
# cat("最大值：", round(max(y), 4), "\n")
# cat("中位数：", round(median(y), 4), "\n\n")
# 
# # 理论均值：E[Y] = β/(r-1) = 2/(4-1) = 2/3 ≈ 0.6667
# theoretical_mean <- beta/(r-1)
# cat("理论均值：", round(theoretical_mean, 4), "\n")
# cat("实际均值与理论均值的差异：", round(mean(y) - theoretical_mean, 4), "\n")
# 
# # 绘制直方图
# hist(y, breaks = 30, main = "指数-伽马混合分布 - 直接法 (n=1000)",
#      xlab = "Y", col = "lightblue", border = "white",
#      probability = TRUE)
# abline(v = mean(y), col = "red", lwd = 2, lty = 2)
# legend("topright", legend = c(paste("均值 =", round(mean(y), 3)),
#                              paste("理论均值 =", round(theoretical_mean, 3))),
#        col = c("red", "black"), lty = c(2, 0), bty = "n")
# 
# # 添加密度曲线
# lines(density(y), col = "blue", lwd = 2)
# 

## -----------------------------------------------------------------------------
# # 设置参数
# set.seed(123)  # 设置随机种子以保证结果可重现
# n <- 1000      # 样本量
# r <- 4         # 伽马分布的形状参数
# beta <- 2      # 伽马分布的尺度参数
# 
# # 分层生成方法
# # 第一步：从伽马分布生成Λ
# lambda <- rgamma(n, shape = r, rate = beta)
# 
# # 第二步：给定Λ，从指数分布生成Y
# y <- rexp(n, rate = lambda)
# 
# # 输出结果摘要
# cat("指数-伽马混合分布的1000个随机观测值：\n")
# cat("前10个观测值：", head(y, 10), "\n\n")
# 
# cat("描述性统计：\n")
# cat("均值：", mean(y), "\n")
# cat("标准差：", sd(y), "\n")
# cat("最小值：", min(y), "\n")
# cat("最大值：", max(y), "\n")
# cat("中位数：", median(y), "\n\n")
# 
# # 理论均值：E[Y] = β/(r-1) = 2/(4-1) = 2/3 ≈ 0.6667
# theoretical_mean <- beta/(r-1)
# cat("理论均值：", theoretical_mean, "\n")
# cat("实际均值与理论均值的差异：", mean(y) - theoretical_mean, "\n")
# 
# # 绘制直方图
# hist(y, breaks = 30, main = "指数-伽马混合分布 (n=1000)",
#      xlab = "Y", col = "lightblue", border = "white",
#      probability = TRUE)
# abline(v = mean(y), col = "red", lwd = 2, lty = 2)
# legend("topright", legend = c(paste("均值 =", round(mean(y), 3)),
#                              paste("理论均值 =", round(theoretical_mean, 3))),
#        col = c("red", "black"), lty = c(2, 0), bty = "n")

## -----------------------------------------------------------------------------
# # 本次作业：注意函数，自定义函数（简单一元函数、多参数循环）！！！
# 
# ## 仅利用 Uniform(0,x) 采样的 Monte-Carlo CDF
# beta3_cdf_mc <- function(x, n = 1e6, seed = 1) {
#   stopifnot(all(x > 0 & x <= 1))
#   const <- 1 / beta(3, 3)          # 1/B(3,3)
#   fx <- function(t) t^2 * (1 - t)^2 * const   # Beta(3,3) 密度
# 
#   set.seed(seed)
#   mc <- vapply(x, function(xx) {
#     u <- runif(n)      # U(0,1)
#     t <- xx * u        # T ~ U(0,xx)
#     mean(xx * fx(t))   # 样本均值
#   }, 0)
#   mc
# }
# 
# ## 估计点
# x_vals <- seq(0.1, 0.9, by = 0.1)
# mc_est <- beta3_cdf_mc(x_vals)
# exact  <- pbeta(x_vals, 3, 3)
# 
# ## 比较(把等长向量一列一列排成表格，表会输出)
# data.frame(
#   x        = x_vals,
#   MC       = mc_est,
#   Exact    = exact,
#   AbsError = abs(mc_est - exact)
# )

## -----------------------------------------------------------------------------
# cat('Cov(e^U,e^(1-U))',round(3*exp(1)-exp(2)-1,5) ,"\n")
# cat('Var(e^U,e^(1-U))',round(10*exp(1)-3*exp(2)-5,5),'\n')
# cat('Var(e^U)',round((4*exp(1)-exp(2)-3)/2,5),'\n')
# cat('Variance of the antithetic estimator:',round((10*exp(1)-3*exp(2)-5)/4,5),'\n')
# cat('Variance of the simple MC estimator(With one independent draw):',round((4*exp(1)-exp(2)-3)/2,5),'\n')
# a<-(10*exp(1)-3*exp(2)-5)/4
# b<-(4*exp(1)-exp(2)-3)/2
# cat('present reduction:',round(1-a/b,5),'\n')
# 
# #simple MC & antithetic
# m<-100
# set.seed(1234)
# U<-runif(m,0,1)
# sd_MC<-sd(exp(U))/sqrt(m)
# c<-(exp(U)+exp(1-U))/2
# sd_anti<-sd(c)/sqrt(m)
# round(c(sd_MC^2,sd_anti^2),6)
# 1-sd_anti^2/sd_MC^2

## -----------------------------------------------------------------------------
# m = 100
# g <- function(u)u^2*exp(-u^2/2)/sqrt(2*pi)
# f1 <- 1
# f2 <- function(u)u^(1/3)   #逆变换
# set.seed(123)
# u <- runif(m,0,1)
# # sd1 <- sd(g(u)/f1)/sqrt(m)
# # sd2 <- sd(g(u)/f2(u))/sqrt(m)
# # m1 <- 0.5 - maen(g(u)/f1)
# # m2 <- 0.5 - mean(g(u)/f2(u))
# mean <-round(c(0.5 - mean(g(u)/f1),0.5 - mean(g(u)/f2(u))),5)
# sd <-round(c(sd(g(u)/1)/sqrt(m),sd(g(u)/f2(u))/sqrt(m)),8)
# data.frame(mean,sd)

## -----------------------------------------------------------------------------
# ## 加载所需包
# library(ggplot2)
# library(microbenchmark)
# 
# ## 1. 参数设置
# n_vec   <- c(1e4, 2e4, 4e4, 6e4, 8e4)   # 5 个规模
# n_sim   <- 100                           # 每组规模跑 100 次
# set.seed(42)                             # 可重复
# 
# ## 2. 计时函数：返回单次排序耗时（毫秒）
# time_once <- function(n) {
#   x <- sample.int(n)          # 1‥n 的随机排列
#   res <- microbenchmark::microbenchmark(
#     sort(x), times = 1, unit = "ms"
#   )
#   as.numeric(res$time) / 1e6   # 转成毫秒
# }
# 
# ## 3. 主循环：对每个 n 跑 100 次，取平均
# an_vec <- sapply(n_vec, function(n) {
#   mean(replicate(n_sim, time_once(n)))
# })
# 
# ## 4. 计算 tn = n log(n)
# tn_vec <- n_vec * log(n_vec)
# 
# ## 5. 线性回归
# fit <- lm(an_vec ~ tn_vec)
# summary(fit)
# 
# ## 6. 画图
# dat <- data.frame(n = n_vec, an = an_vec, tn = tn_vec)
# ggplot(dat, aes(x = tn, y = an)) +
#   geom_point(size = 3, color = "steelblue") +
#   geom_abline(intercept = coef(fit)[1],
#               slope     = coef(fit)[2],
#               color     = "red", linetype = "dashed") +
#   labs(title = "Fast-sorting CPU time vs n log n",
#        x     = "tn = n log(n) (natural log)",
#        y     = "an = average CPU time (ms)") +
#   theme_minimal()

## -----------------------------------------------------------------------------
# # 目标积分: ∫_0^1 e^{-x} / (1+x^2) dx
# 
# # set.seed(123)
# N <- 10000
# 
# # 分层数
# K <- 5
# # 各层边界
# breaks <- (0:K) / K
# 
# # 计算各层在 f3 下的概率 p_j
# a <- 1 - exp(-1)  # 1 - e^{-1}
# p_j <- numeric(K)
# for (j in 1:K) {
#   p_j[j] <- (exp(-(j-1)/K) - exp(-j/K)) / a
# }
# 
# # 分配样本量
# N_j <- round(N * p_j)
# # 调整使得总和为 N
# N_j[K] <- N - sum(N_j[1:(K-1)])
# 
# # 权重函数 w(x)
# w <- function(x) {
#   a /  (1 + x^2)
# }
# 
# # 从第 j 层抽样
# rlayer <- function(n, j) {
#   # j 从 1 到 K
#   left <- breaks[j]
#   right <- breaks[j+1]
#   u <- runif(n)
#   # 用逆变换法从 f_j 抽样
#   exp_left <- exp(-left)
#   exp_right <- exp(-right)
#   -log(exp_left - u * (exp_left - exp_right))
# }
# 
# # 分层抽样估计
# theta_hat_j <- numeric(K)
# for (j in 1:K) {
#   if (N_j[j] > 0) {
#     x_j <- rlayer(N_j[j], j)
#     theta_hat_j[j] <- mean(w(x_j))
#   } else {
#     theta_hat_j[j] <- 0
#   }
# }
# 
# theta_hat <-crossprod(theta_hat_j,p_j)
# 
# 
# # 计算标准误差 (各层方差合并)
# se_j <- numeric(K)
# for (j in 1:K) {
#   if (N_j[j] > 1) {
#     x_j <- rlayer(N_j[j], j)
#     se_j[j] <- var(w(x_j)) / N_j[j]
#   } else {
#     se_j[j] <- 0
#   }
# }
# se <- sqrt(sum(se_j))
# 
# cat("Stratified importance sampling estimate:", theta_hat, "\n")
# cat("Standard error:", se, "\n")
# 
# 

## -----------------------------------------------------------------------------
# # 设置参数
# mu0 <- 500        # 原假设下的均值
# sigma <- 100      # 标准差
# alpha <- 0.05     # 显著性水平
# n_values <- c(10, 20, 30, 40, 50)  # 样本量
# mu_values <- seq(500, 650, length.out = 100)  # 备择假设的均值范围
# 
# # 创建颜色和线型
# colors <- c("red", "blue", "green", "purple", "orange")
# line_types <- 1:5
# 
# # 创建空图形
# plot(NA, xlim = range(mu_values), ylim = c(0, 1),
#      xlab = expression(mu), ylab = "Power",
#      main = "Power Curves for t-test with Different Sample Sizes")
# 
# # 对每个样本量计算功效曲线
# for (i in seq_along(n_values)) {
#   n <- n_values[i]
#   power_curve <- numeric(length(mu_values))
# 
#   # 对每个mu值计算功效
#   for (j in seq_along(mu_values)) {
#     mu <- mu_values[j]
# 
#     # 模拟计算功效
#     n_sim <- 1000  # 模拟次数
#     p_values <- numeric(n_sim)
# 
#     for (k in 1:n_sim) {
#       # 从正态分布生成样本
#       x <- rnorm(n, mean = mu, sd = sigma)
# 
#       # 执行单样本t检验
#       test_result <- t.test(x, mu = mu0, alternative = "greater")
#       p_values[k] <- test_result$p.value
#     }
# 
#     # 计算功效（拒绝原假设的比例）
#     power_curve[j] <- mean(p_values < alpha)
#   }
# 
#   # 绘制功效曲线
#   lines(mu_values, power_curve, col = colors[i], lty = line_types[i], lwd = 2)
# }
# 
# # 添加图例
# legend("bottomright", legend = paste("n =", n_values),
#        col = colors, lty = line_types, lwd = 2, title = "Sample Size")
# 
# # 添加参考线
# abline(h = alpha, lty = 3, col = "gray")  # 显著性水平参考线
# abline(v = mu0, lty = 3, col = "gray")    # 原假设参考线

## -----------------------------------------------------------------------------
# # 问题7.6：估计t区间在χ²(2)数据下的覆盖率
# 
# # 设置参数
# set.seed(123)  # 确保结果可重现
# n <- 20        # 样本量
# B <- 10000     # 蒙特卡洛重复次数
# true_mean <- 2 # χ²(2)的真实均值 = 自由度 = 2
# 
# # 执行蒙特卡洛实验
# coverage <- numeric(B)
# 
# for (i in 1:B) {
#   # 从χ²(2)分布生成随机样本
#   sample_data <- rchisq(n, df = 2)
# 
#   # 计算t区间
#   t_test <- t.test(sample_data, conf.level = 0.95)
#   ci_lower <- t_test$conf.int[1]
#   ci_upper <- t_test$conf.int[2]
# 
#   # 检查真实均值是否在置信区间内
#   coverage[i] <- (ci_lower <= true_mean) & (true_mean <= ci_upper)
# }
# 
# # 计算覆盖率概率
# coverage_prob <- mean(coverage)
# coverage_prob_se <- sqrt(coverage_prob * (1 - coverage_prob) / B)
# 
# # 输出结果
# cat("蒙特卡洛实验结果：\n")
# cat("样本量 n =", n, "\n")
# cat("蒙特卡洛重复次数 B =", B, "\n")
# cat("真实均值 =", true_mean, "\n")
# cat("覆盖率概率 =", round(coverage_prob, 4), "\n")
# cat("标准误差 =", round(coverage_prob_se, 5), "\n")
# cat("95%置信区间: [",
#     round(coverage_prob - 1.96 * coverage_prob_se, 4), ", ",
#     round(coverage_prob + 1.96 * coverage_prob_se, 4), "]\n", sep = "")
# 
# # 与正态假设下的理论覆盖率比较
# cat("\n与理论值比较：\n")
# cat("理论覆盖率 (正态假设下) = 0.95\n")
# cat("实际覆盖率与理论值的差异 =", round(coverage_prob - 0.95, 4), "\n")
# 
# # 可视化结果
# hist(coverage, main = "覆盖率分布", xlab = "覆盖率", col = "lightblue")
# abline(v = 0.95, col = "red", lwd = 2, lty = 2)
# legend("topright", legend = "理论值(0.95)", col = "red", lty = 2, lwd = 2)

## -----------------------------------------------------------------------------
# # 与例7.4的方差区间进行对比分析
# coverage_var <- numeric(B)
# true_var <- 4  # χ²(2)的真实方差 = 2 × 自由度 = 4
# 
# for (i in 1:B) {
#   sample_data <- rchisq(n, df = 2)
# 
#   # 计算方差置信区间 (基于正态假设)
#   sample_var <- var(sample_data)
#   df <- n - 1
#   chi_sq_lower <- qchisq(0.025, df)
#   chi_sq_upper <- qchisq(0.975, df)
# 
#   ci_lower_var <- df * sample_var / chi_sq_upper
#   ci_upper_var <- df * sample_var / chi_sq_lower
# 
#   coverage_var[i] <- (ci_lower_var <= true_var) & (true_var <= ci_upper_var)
# }
# 
# coverage_prob_var <- mean(coverage_var)
# 
# cat("\n与方差区间比较：\n")
# cat("t区间覆盖率 =", round(coverage_prob, 4), "\n")
# cat("方差区间覆盖率 =", round(coverage_prob_var, 4), "\n")
# cat("t区间更稳健？", coverage_prob > coverage_prob_var, "\n")

## -----------------------------------------------------------------------------
# # 设置随机种子以保证结果可重现
# set.seed(123)
# 
# # 定义蒙特卡洛模拟函数
# monte_carlo_t_test <- function(distribution, n, n_sim = 10000, alpha = 0.05) {
#   # n: 样本大小
#   # n_sim: 模拟次数
#   # alpha: 显著性水平
# 
#   type_I_errors <- numeric(n_sim)
# 
#   for (i in 1:n_sim) {
#     # 根据指定的分布生成样本
#     if (distribution == "chisq") {
#       sample_data <- rchisq(n, df = 1)  # χ²(1)，均值=1
#       mu0 <- 1
#     } else if (distribution == "uniform") {
#       sample_data <- runif(n, 0, 2)     # Uniform(0,2)，均值=1
#       mu0 <- 1
#     } else if (distribution == "exponential") {
#       sample_data <- rexp(n, rate = 1)  # Exponential(1)，均值=1
#       mu0 <- 1
#     }
# 
#     # 执行单样本t检验
#     t_test_result <- t.test(sample_data, mu = mu0, alternative = "two.sided")
# 
#     # 记录是否犯Type I错误（p值 < α）
#     type_I_errors[i] <- t_test_result$p.value < alpha
#   }
# 
#   # 计算经验Type I错误率
#   empirical_alpha <- mean(type_I_errors)
# 
#   return(empirical_alpha)
# }
# 
# # 设置模拟参数
# sample_sizes <- c(10, 30, 50, 100)  # 不同的样本大小
# n_simulations <- 10000              # 模拟次数
# alpha <- 0.05                       # 名义显著性水平
# 
# # 创建结果存储矩阵
# results <- matrix(NA, nrow = length(sample_sizes), ncol = 4)
# colnames(results) <- c("样本大小", "χ2_1", "Uniform_0_2", "Exponential_1")
# results[, 1] <- sample_sizes
# 
# # 对每种分布和样本大小进行模拟
# cat("正在进行蒙特卡洛模拟...\n")
# for (i in 1:length(sample_sizes)) {
#   n <- sample_sizes[i]
#   cat("正在模拟样本大小 n =", n, "...\n")
# 
#   # χ²(1) 分布
#   results[i, 2] <- monte_carlo_t_test("chisq", n, n_simulations, alpha)
# 
#   # Uniform(0,2) 分布
#   results[i, 3] <- monte_carlo_t_test("uniform", n, n_simulations, alpha)
# 
#   # Exponential(1) 分布
#   results[i, 4] <- monte_carlo_t_test("exponential", n, n_simulations, alpha)
# }
# 
# # 显示结果
# cat("\n蒙特卡洛模拟结果：经验Type I错误率\n")
# print(results)
# 
# # 转换数据格式以便绘图
# results_df <- as.data.frame(results)
# colnames(results_df) <- c("样本大小", "χ²(1)", "Uniform(0,2)", "Exponential(1)")
# 
# # 重塑数据用于ggplot2
# library(reshape2)
# results_melted <- melt(results_df, id.vars = "样本大小",
#                        variable.name = "分布", value.name = "经验错误率")
# 
# # 可视化结果
# library(ggplot2)
# 
# # 计算y轴范围，确保所有数据点都能显示
# y_min <- min(results_melted$经验错误率, alpha) - 0.01
# y_max <- max(results_melted$经验错误率, alpha) + 0.01
# 
# ggplot(results_melted, aes(x = 样本大小, y = 经验错误率, color = 分布, group = 分布)) +
#   geom_line(linewidth = 1.2) +
#   geom_point(size = 3) +
#   geom_hline(yintercept = alpha, linetype = "dashed", color = "red", linewidth = 1) +
#   labs(title = "t检验的经验Type I错误率 vs 名义显著性水平α=0.05",
#        subtitle = "基于10,000次蒙特卡洛模拟",
#        x = "样本大小",
#        y = "经验Type I错误率",
#        color = "分布") +
#   theme_minimal() +
#   theme(plot.title = element_text(hjust = 0.5),
#         plot.subtitle = element_text(hjust = 0.5)) +
#   scale_y_continuous(limits = c(0, 0.1), breaks = seq(0, 0.1, 0.01)) +
#   annotate("text", x = mean(sample_sizes), y = alpha + 0.003,
#            label = "名义水平α=0.05", color = "red", size = 4)
# 
# 
# # 进行二项检验来评估经验错误率是否与名义水平有显著差异
# cat("二项检验结果 (检验经验错误率是否显著不同于α=0.05):\n")
# for (i in 1:length(sample_sizes)) {
#   cat("\n样本大小 n =", sample_sizes[i], ":\n")
# 
#   # χ²(1)
#   binom_test_chisq <- binom.test(round(results[i, 2] * n_simulations), n_simulations, p = alpha)
#   cat("  χ²(1): p值 =", round(binom_test_chisq$p.value, 4),
#       ifelse(binom_test_chisq$p.value > 0.05, "(无显著差异)", "(有显著差异)"), "\n")
# 
#   # Uniform(0,2)
#   binom_test_unif <- binom.test(round(results[i, 3] * n_simulations), n_simulations, p = alpha)
#   cat("  Uniform(0,2): p值 =", round(binom_test_unif$p.value, 4),
#       ifelse(binom_test_unif$p.value > 0.05, "(无显著差异)", "(有显著差异)"), "\n")
# 
#   # Exponential(1)
#   binom_test_exp <- binom.test(round(results[i, 4] * n_simulations), n_simulations, p = alpha)
#   cat("  Exponential(1): p值 =", round(binom_test_exp$p.value, 4),
#       ifelse(binom_test_exp$p.value > 0.05, "(无显著差异)", "(有显著差异)"), "\n")
# }
# 
# # 创建结果总结表
# cat("\n=== 结果总结 ===\n")
# cat("基于模拟结果，我们可以得出以下结论：\n\n")
# 
# # 分析每种分布的稳健性
# for (j in 2:4) {
#   dist_name <- colnames(results_df)[j]
#   robust_at_small_n <- all(abs(results[1:2, j] - alpha) < 0.01)  # 前两个样本量都稳健
#   robust_at_large_n <- all(abs(results[3:4, j] - alpha) < 0.01)  # 后两个样本量都稳健
# 
#   cat(dist_name, "分布:\n")
#   if (robust_at_small_n) {
#     cat("  - 即使在较小样本量(n=10,30)下也表现稳健\n")
#   } else if (robust_at_large_n) {
#     cat("  - 在较大样本量(n=50,100)下表现稳健\n")
#   } else {
#     cat("  - 在所有样本量下都不够稳健\n")
#   }
#   cat("  - 具体错误率:", paste(round(results[, j], 4), collapse = ", "), "\n\n")
# }

## -----------------------------------------------------------------------------
# set.seed(1234)
# m        <- 1000          # 每次实验的总假设数
# m0       <- 950           # 原假设个数
# m1       <- 50            # 备择假设个数
# alpha    <- 0.1           # 名义水平
# R        <- 10000         # 模拟重复次数
# 
# # 存储 4 个指标
# res <- matrix(0, R, 4,
#               dimnames = list(NULL,
#                               c("Bonf_rej","BH_rej","Bonf_TP","BH_TP")))
# 
# for(r in 1:R){
#   # 生成 p 值
#   p0 <- runif(m0)                    # U(0,1)
#   p1 <- rbeta(m1, 0.1, 1)            # Beta(0.1,1)  stochastically smaller
#   p  <- c(p0, p1)
#   H  <- c(rep(0L,m0), rep(1L,m1))    # 真实状态 0=原假设 1=备择
# 
#   # 校正
#   bonf_p  <- p.adjust(p, method = "bonferroni")
#   bh_p    <- p.adjust(p, method = "BH")
# 
#   # 拒绝指标
#   bonf_rej <- bonf_p <= alpha
#   bh_rej   <- bh_p   <= alpha
# 
#   res[r, "Bonf_rej"] <- sum(bonf_rej)
#   res[r, "BH_rej"]   <- sum(bh_rej)
#   res[r, "Bonf_TP"]  <- sum(bonf_rej & H)   # 真正阳性
#   res[r, "BH_TP"]    <- sum(bh_rej   & H)
# }
# 
# # 计算三个指标
# FWER_bonf <- mean(res[,"Bonf_rej"] > 0)   # 至少一次拒绝原假设
# FWER_BH   <- mean(res[,"BH_rej"]   > 0)
# 
# FDR_bonf  <- mean((res[,"Bonf_rej"] - res[,"Bonf_TP"]) /
#                   pmax(1, res[,"Bonf_rej"]))
# FDR_BH    <- mean((res[,"BH_rej"]   - res[,"BH_TP"])   /
#                   pmax(1, res[,"BH_rej"]))
# 
# TPR_bonf  <- mean(res[,"Bonf_TP"] / m1)
# TPR_BH    <- mean(res[,"BH_TP"]   / m1)
# 
# # 3×2 表格
# table_out <- rbind(
#   FWER = c(FWER_bonf, FWER_BH),
#   FDR  = c(FDR_bonf,  FDR_BH),
#   TPR  = c(TPR_bonf,  TPR_BH)
# )
# colnames(table_out) <- c("Bonferroni校正","B-H校正")
# round(table_out, 4)

## -----------------------------------------------------------------------------
# # 原始数据
# data <- c(3, 5, 7, 18, 43, 85, 91, 98, 100, 130, 230, 487)
# 
# # 计算最大似然估计
# lambda_mle <- 1 / mean(data)
# # lambda_mle
# 
# # 自助法
# set.seed(123)
# B <- 1000
# bootstrap_lambdas <- numeric(B)
# 
# for (i in 1:B) {
#   bootstrap_sample <- sample(data, size = length(data), replace = TRUE)
#   bootstrap_lambdas[i] <- 1 / mean(bootstrap_sample)
# }
# 
# # 计算偏差和标准误差
# bias <- mean(bootstrap_lambdas) - lambda_mle
# se <- sd(bootstrap_lambdas)
# 
# # bias
# # se
# data.frame(lambda_mle = lambda_mle,
#            bootstrap_bias = bias,
#            bootstrap_se = se)

## -----------------------------------------------------------------------------
# ## 数据已在 R 包 bootstrap 里
# library(bootstrap)          # 安装：install.packages("bootstrap")
# data(scor)                  # 88×5 矩阵，列名 mec vec alg ana sta
# set.seed(1234)
# 
# ## 原始估计（MLE 协方差矩阵）
# n <- nrow(scor)
# Sigma <- cov(scor) * (n-1)/n        # 分母 n
# lambda <- eigen(Sigma, only.values = TRUE)$values
# theta_hat <- lambda[1] / sum(lambda)
# 
# ## 2000 次自助
# B <- 2000
# theta_star <- numeric(B)
# for(b in 1:B){
#   idx   <- sample(n, n, replace = TRUE)
#   Sstar <- cov(scor[idx, ]) * (n-1)/n
#   lstar <- eigen(Sstar, only.values = TRUE)$values
#   theta_star[b] <- lstar[1] / sum(lstar)
# }
# 
# ## 结果
# bias <- mean(theta_star) - theta_hat
# se   <- sd(theta_star)
# data.frame(theta_hat = theta_hat,
#   Bootstrap_bias     = bias,
#   Bootstrap_se       = se)

## -----------------------------------------------------------------------------
# library(MASS)
# set.seed(123)
# 
# # 生成数据
# n <- 88
# p <- 5
# Sigma <- matrix(c(
#   5, 2, 1, 0.5, 0.5,
#   2, 4, 1, 0.5, 0.5,
#   1, 1, 3, 0.5, 0.5,
#   0.5, 0.5, 0.5, 2, 0.5,
#   0.5, 0.5, 0.5, 0.5, 1
# ), nrow = 5, byrow = TRUE)
# 
# X <- mvrnorm(n = n, mu = rep(0, p), Sigma = Sigma)
# 
# # 计算θ的函数
# theta_hat <- function(data) {
#   lambda <- eigen(cov(data))$values
#   return(lambda[1] / sum(lambda))
# }
# 
# # 原始估计
# theta_0 <- theta_hat(X)
# 
# # Jackknife
# theta_jack <- numeric(n)
# for (i in 1:n) {
#   theta_jack[i] <- theta_hat(X[-i, ])
# }
# 
# # 计算偏差和标准误
# bias <- (n - 1) * (mean(theta_jack) - theta_0)
# se <- sqrt((n - 1) * mean((theta_jack - mean(theta_jack))^2))
# 
# # 输出结果
# cat("估计值", round(theta_0, 6), "\n")
# cat("偏差 (Bias) =", round(bias, 6), "\n")
# cat("标准误 (SE) =", round(se, 6), "\n")

## -----------------------------------------------------------------------------
# # 加载ironslag数据
# library(DAAG)
# data(ironslag)
# attach(ironslag)
# 
# n <- length(magnetic)
# 
# # 计算leave-two-out交叉验证误差
# e1 <- e2 <- e3 <- e4 <- numeric(n * (n - 1) / 2)
# 
# k <- 0
# for (i in 1:(n - 1)) {
#   for (j in (i + 1):n) {
#     k <- k + 1
# 
#     # 训练数据（去掉第i和第j个观测）
#     train_idx <- c(-i, -j)
# 
#     # 模型1: 线性
#     L1 <- lm(magnetic ~ chemical, subset = train_idx)
#     yhat1_i <- predict(L1, newdata = data.frame(chemical = chemical[i]))
#     yhat1_j <- predict(L1, newdata = data.frame(chemical = chemical[j]))
#     e1[k] <- (magnetic[i] - yhat1_i)^2 + (magnetic[j] - yhat1_j)^2
# 
#     # 模型2: 二次
#     L2 <- lm(magnetic ~ chemical + I(chemical^2), subset = train_idx)
#     yhat2_i <- predict(L2, newdata = data.frame(chemical = chemical[i]))
#     yhat2_j <- predict(L2, newdata = data.frame(chemical = chemical[j]))
#     e2[k] <- (magnetic[i] - yhat2_i)^2 + (magnetic[j] - yhat2_j)^2
# 
#     # 模型3: 指数
#     L3 <- lm(log(magnetic) ~ chemical, subset = train_idx)
#     logyhat3_i <- predict(L3, newdata = data.frame(chemical = chemical[i]))
#     logyhat3_j <- predict(L3, newdata = data.frame(chemical = chemical[j]))
#     yhat3_i <- exp(logyhat3_i)
#     yhat3_j <- exp(logyhat3_j)
#     e3[k] <- (magnetic[i] - yhat3_i)^2 + (magnetic[j] - yhat3_j)^2
# 
#     # 模型4: log-log
#     L4 <- lm(log(magnetic) ~ log(chemical), subset = train_idx)
#     logyhat4_i <- predict(L4, newdata = data.frame(chemical = chemical[i]))
#     logyhat4_j <- predict(L4, newdata = data.frame(chemical = chemical[j]))
#     yhat4_i <- exp(logyhat4_i)
#     yhat4_j <- exp(logyhat4_j)
#     e4[k] <- (magnetic[i] - yhat4_i)^2 + (magnetic[j] - yhat4_j)^2
#   }
# }
# 
# # 计算平均预测误差
# cv_error <- c(mean(e1), mean(e2), mean(e3), mean(e4))
# model_names <- c("Linear", "Quadratic", "Exponential", "Log-Log")
# 
# # 输出结果
# cat("Leave-Two-Out Cross Validation Results\n")
# cat("========================================\n\n")
# for (i in 1:4) {
#   cat(sprintf("Model %d (%s): %.4f\n", i, model_names[i], cv_error[i]))
# }
# cat("\n最佳模型:", model_names[which.min(cv_error)],
#     "(CV Error =", round(min(cv_error), 4), ")\n")
# 
# detach(ironslag)

## -----------------------------------------------------------------------------
# set.seed(123)
# 
# # 参数设置
# n <- 30           # 样本量
# m <- 1000         # Monte Carlo重复次数
# B <- 1000         # Bootstrap重复次数
# mu <- 0           # 真实均值
# sigma <- 1        # 真实标准差
# alpha <- 0.05     # 显著性水平
# 
# # 存储结果
# coverage <- matrix(0, nrow = m, ncol = 3)
# colnames(coverage) <- c("Standard Normal", "Basic", "Percentile")
# miss_left <- matrix(0, nrow = m, ncol = 3)
# miss_right <- matrix(0, nrow = m, ncol = 3)
# 
# # Monte Carlo模拟
# for (i in 1:m) {
#   # 从正态总体抽样
#   x <- rnorm(n, mean = mu, sd = sigma)
# 
#   # Bootstrap
#   theta_hat <- mean(x)
#   theta_boot <- numeric(B)
# 
#   for (b in 1:B) {
#     x_boot <- sample(x, size = n, replace = TRUE)
#     theta_boot[b] <- mean(x_boot)
#   }
# 
#   # 1. 标准正态Bootstrap置信区间
#   se_boot <- sd(theta_boot)
#   CI_norm <- c(theta_hat - qnorm(1 - alpha/2) * se_boot,
#                theta_hat + qnorm(1 - alpha/2) * se_boot)
# 
#   # 2. 基本Bootstrap置信区间
#   delta <- theta_boot - theta_hat
#   CI_basic <- c(2 * theta_hat - quantile(theta_boot, 1 - alpha/2),
#                 2 * theta_hat - quantile(theta_boot, alpha/2))
# 
#   # 3. 百分位Bootstrap置信区间
#   CI_perc <- quantile(theta_boot, c(alpha/2, 1 - alpha/2))
# 
#   # 检查覆盖率
#   coverage[i, 1] <- (CI_norm[1] <= mu) & (mu <= CI_norm[2])
#   coverage[i, 2] <- (CI_basic[1] <= mu) & (mu <= CI_basic[2])
#   coverage[i, 3] <- (CI_perc[1] <= mu) & (mu <= CI_perc[2])
# 
#   # 检查左侧和右侧miss
#   miss_left[i, 1] <- mu < CI_norm[1]
#   miss_left[i, 2] <- mu < CI_basic[1]
#   miss_left[i, 3] <- mu < CI_perc[1]
# 
#   miss_right[i, 1] <- mu > CI_norm[2]
#   miss_right[i, 2] <- mu > CI_basic[2]
#   miss_right[i, 3] <- mu > CI_perc[2]
# }
# 
# # 计算结果
# coverage_prob <- colMeans(coverage)
# miss_left_prob <- colMeans(miss_left)
# miss_right_prob <- colMeans(miss_right)
# 
# # 输出结果
# cat("Bootstrap置信区间覆盖率研究\n")
# cat("============================\n")
# cat("样本量 n =", n, "\n")
# cat("Monte Carlo重复次数 m =", m, "\n")
# cat("Bootstrap重复次数 B =", B, "\n")
# cat("名义置信水平 = 95%\n\n")
# 
# cat("覆盖率 (Coverage Probability):\n")
# cat("-------------------------------\n")
# for (i in 1:3) {
#   cat(sprintf("%-20s: %.4f\n", colnames(coverage)[i], coverage_prob[i]))
# }
# 
# cat("\n左侧Miss率 (Miss on Left):\n")
# cat("---------------------------\n")
# for (i in 1:3) {
#   cat(sprintf("%-20s: %.4f\n", colnames(coverage)[i], miss_left_prob[i]))
# }
# 
# cat("\n右侧Miss率 (Miss on Right):\n")
# cat("----------------------------\n")
# for (i in 1:3) {
#   cat(sprintf("%-20s: %.4f\n", colnames(coverage)[i], miss_right_prob[i]))
# }
# 
# cat("\n总Miss率验证 (Left + Right):\n")
# cat("-----------------------------\n")
# for (i in 1:3) {
#   total_miss <- miss_left_prob[i] + miss_right_prob[i]
#   cat(sprintf("%-20s: %.4f (应约等于 %.4f)\n",
#               colnames(coverage)[i], total_miss, 1 - coverage_prob[i]))
# }

## -----------------------------------------------------------------------------
# ##### 0. 参数与初始化 #####
# lambda.true <- 2
# n.vec       <- c(5, 10, 20)   # 样本量
# B           <- 1000           # bootstrap 重复
# m           <- 1000           # 模拟重复
# set.seed(42)                  # 可复现
# 
# ##### 1. 理论值计算函数 #####
# theory <- function(n, lam) {
#   bias <- lam / (n - 1)
#   se   <- lam * n / ((n - 1) * sqrt(n - 2))
#   c(bias = bias, se = se)
# }
# 
# ##### 2. 一次模拟实验函数 #####
# one.sim <- function(n, lam, B) {
#   x  <- rexp(n, rate = lam)          # 原始样本
#   lambda.hat <- 1 / mean(x)          # MLE
# 
#   # bootstrap
#   lambda.star <- numeric(B)
#   for (b in 1:B) {
#     x.star      <- sample(x, replace = TRUE)
#     lambda.star[b] <- 1 / mean(x.star)
#   }
# 
#   # bootstrap 估计量
#   bias.boot <- mean(lambda.star) - lambda.hat
#   se.boot   <- sd(lambda.star)
# 
#   c(lambda.hat = lambda.hat,
#     bias.boot  = bias.boot,
#     se.boot    = se.boot)
# }
# 
# ##### 3. 主循环：对每种 n 跑 m 次 #####
# res <- list()
# for (n in n.vec) {
#   cat("Running n =", n, "... ")
#   tmp <- replicate(m, one.sim(n, lambda.true, B))
#   res[[as.character(n)]] <- t(tmp)
#   cat("done.\n")
# }
# 
# ##### 4. 汇总结果 #####
# out <- data.frame(n = numeric(),
#                   est.bias = numeric(),  # 平均 bootstrap bias
#                   est.se  = numeric(),   # 平均 bootstrap se
#                   theo.bias = numeric(),
#                   theo.se  = numeric())
# 
# for (n in n.vec) {
#   rr <- res[[as.character(n)]]
#   out <- rbind(out,
#                data.frame(n = n,
#                           est.bias = mean(rr[, "bias.boot"]),
#                           est.se   = mean(rr[, "se.boot"]),
#                           theo.bias = theory(n, lambda.true)["bias"],
#                           theo.se  = theory(n, lambda.true)["se"]))
# }
# 
# ##### 5. 打印比较表 #####
# print(round(out, 4))
# 
# ##### 6. 额外：相对误差 #####
# within(out, {
#   bias.err <- abs(est.bias - theo.bias) / theo.bias
#   se.err   <- abs(est.se  - theo.se)   / theo.se
#   cat("\nRelative error (%)\n")
#   print(round(data.frame(n, bias.err, se.err) * 100, 2))
# })

## -----------------------------------------------------------------------------
# # Exercise 10.3: Cramér-von Mises 双样本置换检验
# 
# # 定义 Cramér-von Mises 统计量（基于公式 10.14）
# cramer_von_mises <- function(x, y) {
#   n <- length(x)
#   m <- length(y)
#   N <- n + m
# 
#   # 合并数据并计算秩
#   z <- c(x, y)
#   ranks <- rank(z)
# 
#   # X 样本的秩
#   r <- ranks[1:n]
#   # Y 样本的秩
#   s <- ranks[(n+1):N]
# 
#   # 计算 U
#   U <- n * sum((r - (1:n))^2) + m * sum((s - (1:m))^2)
# 
#   # 计算 W^2（公式 10.14）
#   W2 <- U / (n * m * N) - (4 * m * n - 1) / (6 * N)
# 
#   return(W2)
# }
# 
# # 置换检验函数
# permutation_test_cvm <- function(x, y, R = 999) {
#   n <- length(x)
#   m <- length(y)
#   z <- c(x, y)
# 
#   # 观测统计量
#   W2_obs <- cramer_von_mises(x, y)
# 
#   # 置换
#   W2_perm <- numeric(R)
#   for (i in 1:R) {
#     perm_idx <- sample(n + m)
#     x_perm <- z[perm_idx[1:n]]
#     y_perm <- z[perm_idx[(n+1):(n+m)]]
#     W2_perm[i] <- cramer_von_mises(x_perm, y_perm)
#   }
# 
#   # 计算 p 值
#   p_value <- mean(c(W2_obs, W2_perm) >= W2_obs)
# 
#   return(list(statistic = W2_obs, p.value = p_value))
# }
# 
# # Example 10.1 和 10.2: chickwts 数据
# x <- chickwts$weight[chickwts$feed == "soybean"]
# y <- chickwts$weight[chickwts$feed == "linseed"]
# 
# cat("Cramér-von Mises 双样本置换检验\n")
# cat("================================\n")
# cat("样本量: n =", length(x), ", m =", length(y), "\n")
# 
# set.seed(123)
# result <- permutation_test_cvm(x, y, R = 999)
# 
# cat("观测统计量 W^2 =", round(result$statistic, 6), "\n")
# cat("p-value =", round(result$p.value, 4), "\n\n")
# 
# # 结论
# if (result$p.value < 0.05) {
#   cat("结论: 拒绝原假设，两组分布有显著差异\n")
# } else {
#   cat("结论: 不拒绝原假设，两组分布无显著差异\n")
# }

## -----------------------------------------------------------------------------
# # Exercise 10.7: Count 5 置换检验（适用于不等样本量）
# 
# # Count 5 统计量函数（适用于不等样本量）
# count5_stat <- function(x_list) {
#   k <- length(x_list)
#   n <- sapply(x_list, length)
# 
#   # 中心化每个样本
#   x_centered <- lapply(x_list, function(x) x - mean(x))
# 
#   # 合并所有数据
#   all_data <- unlist(x_centered)
# 
#   # 找出每组的极端点数量
#   counts <- numeric(k)
#   for (i in 1:k) {
#     # 计算该组有多少点是所有数据中的极端点
#     x_i <- x_centered[[i]]
#     counts[i] <- sum(abs(x_i) >= quantile(abs(all_data), 0.95))
#   }
# 
#   # 返回最大极端点数
#   return(max(counts))
# }
# 
# # 置换检验函数
# count5_permutation_test <- function(x_list, R = 999) {
#   k <- length(x_list)
#   n <- sapply(x_list, length)
# 
#   # 观测统计量
#   obs_stat <- count5_stat(x_list)
# 
#   # 合并所有数据（中心化后）
#   x_centered <- lapply(x_list, function(x) x - mean(x))
#   pooled <- unlist(x_centered)
#   N <- length(pooled)
# 
#   # 置换复制
#   perm_stats <- numeric(R)
#   for (i in 1:R) {
#     # 随机置换
#     perm_data <- sample(pooled)
# 
#     # 按原样本量分组
#     x_perm <- list()
#     start <- 1
#     for (j in 1:k) {
#       x_perm[[j]] <- perm_data[start:(start + n[j] - 1)]
#       start <- start + n[j]
#     }
# 
#     perm_stats[i] <- count5_stat(x_perm)
#   }
# 
#   # 计算 p 值
#   p_value <- mean(c(obs_stat, perm_stats) >= obs_stat)
# 
#   return(list(statistic = obs_stat, p.value = p_value))
# }
# 
# # ============================================
# # Example 7.15: 不等样本量的 Count 5 检验
# # ============================================
# cat("重复 Example 7.15\n")
# cat("==========================================\n\n")
# 
# # 模拟不等样本量的数据（方差相等的情况）
# set.seed(123)
# n1 <- 20
# n2 <- 30
# n3 <- 25
# 
# # 生成三组正态数据，方差相等
# x1 <- rnorm(n1, mean = 0, sd = 1)
# x2 <- rnorm(n2, mean = 0, sd = 1)
# x3 <- rnorm(n3, mean = 0, sd = 1)
# 
# x_list <- list(x1, x2, x3)
# 
# cat("样本量: n1 =", n1, ", n2 =", n2, ", n3 =", n3, "\n")
# cat("样本方差:", round(sapply(x_list, var), 4), "\n\n")
# 
# # 执行置换检验
# result <- count5_permutation_test(x_list, R = 999)
# 
# cat("观测统计量（最大极端点数）=", result$statistic, "\n")
# cat("p-value =", round(result$p.value, 4), "\n\n")
# 
# # 测试方差不等的情况
# cat("==========================================\n")
# cat("测试方差不等的情况\n")
# cat("==========================================\n\n")
# 
# set.seed(456)
# x1_unequal <- rnorm(n1, mean = 0, sd = 1)
# x2_unequal <- rnorm(n2, mean = 0, sd = 2)  # 方差更大
# x3_unequal <- rnorm(n3, mean = 0, sd = 1.5)
# 
# x_list_unequal <- list(x1_unequal, x2_unequal, x3_unequal)
# 
# cat("样本量: n1 =", n1, ", n2 =", n2, ", n3 =", n3, "\n")
# cat("样本方差:", round(sapply(x_list_unequal, var), 4), "\n\n")
# 
# result_unequal <- count5_permutation_test(x_list_unequal, R = 999)
# 
# cat("观测统计量（最大极端点数）=", result_unequal$statistic, "\n")
# cat("p-value =", round(result_unequal$p.value, 4), "\n")

## -----------------------------------------------------------------------------
# set.seed(42)  # 固定随机种子方便复现
# 
# # 目标分布（标准拉普拉斯）的对数密度函数
# logtarget <- function(x) {
#   return(-abs(x) - log(2))  # 标准拉普拉斯密度取log
# }
# 
# # Metropolis采样器
# metropolis <- function(n_iter, sigma, x0=0) {
#   samples <- numeric(n_iter)
#   samples[1] <- x0
#   accepted <- 0
# 
#   for (t in 2:n_iter) {
#     # 提议：从 N(x_{t-1}, sigma^2) 采样
#     proposal <- rnorm(1, mean = samples[t-1], sd = sigma)
# 
#     # 计算接受概率（对数）
#     log_alpha <- logtarget(proposal) - logtarget(samples[t-1])
# 
#     # 接受一步
#     if (log(runif(1)) < log_alpha) {
#       samples[t] <- proposal
#       accepted <- accepted + 1
#     } else {
#       samples[t] <- samples[t-1]
#     }
#   }
#   accept_rate <- accepted / (n_iter - 1)
#   list(samples = samples, accept_rate = accept_rate)
# }
# 
# # 采样参数
# n_iter <- 10000
# sigmas <- c(0.5, 1, 2)  # 三个不同提议标准差
# 
# results <- lapply(sigmas, function(s) metropolis(n_iter, s))
# 
# # 绘制采样链与直方图
# par(mfrow=c(3,2))
# for (i in 1:length(sigmas)) {
#   s <- sigmas[i]
#   samp <- results[[i]]$samples
#   acc <- results[[i]]$accept_rate
# 
#   # 画轨迹
#   plot(samp, type="l", main=paste0("Trace plot (sigma=", s, ")"),
#        xlab="Iteration", ylab="Sample value")
# 
#   # 画直方图
#   hist(samp, breaks=40, probability=TRUE, main=paste0("Histogram (sigma=", s, ")"),
#        xlab="x", col="skyblue", border="white")
# 
#   # 画理论密度
#   curve(dexp(abs(x))/2, from=min(samp), to=max(samp), add=TRUE, col="red", lwd=2)
# 
#   # 标注接受率
#   mtext(sprintf("Acceptance rate: %.3f", acc), side=3, line=0.5, cex=0.8)
# }
# 
# # 输出接受率
# for (i in 1:length(sigmas)) {
#   cat(sprintf("Sigma=%.1f, Acceptance rate=%.4f\n", sigmas[i], results[[i]]$accept_rate))
# }

## -----------------------------------------------------------------------------
# set.seed(123)
# 
# # Gibbs 采样器
# gibbs_sampler <- function(n_iter, n, a, b, x0 = 0, y0 = 0.5) {
#   # 存储样本
#   X <- numeric(n_iter)
#   Y <- numeric(n_iter)
# 
#   # 初始值
#   X[1] <- x0
#   Y[1] <- y0
# 
#   # Gibbs 采样迭代
#   for (i in 2:n_iter) {
#     # 从条件分布 X|Y ~ Binomial(n, y) 采样
#     X[i] <- rbinom(1, size = n, prob = Y[i-1])
# 
#     # 从条件分布 Y|X ~ Beta(x+a, n-x+b) 采样
#     Y[i] <- rbeta(1, shape1 = X[i] + a, shape2 = n - X[i] + b)
#   }
# 
#   return(data.frame(X = X, Y = Y))
# }
# 
# # 参数设置
# n_iter <- 5000    # 迭代次数
# n <- 10           # 二项分布参数
# a <- 2            # Beta 分布参数
# b <- 3            # Beta 分布参数
# burn_in <- 1000   # 预烧期
# 
# # 运行 Gibbs 采样器
# samples <- gibbs_sampler(n_iter, n, a, b)
# 
# # 去除预烧期
# samples_after_burnin <- samples[-(1:burn_in), ]
# 
# # 输出样本统计量
# cat("样本统计量（去除预烧期后）:\n")
# cat("X 的均值:", mean(samples_after_burnin$X), "\n")
# cat("X 的标准差:", sd(samples_after_burnin$X), "\n")
# cat("Y 的均值:", mean(samples_after_burnin$Y), "\n")
# cat("Y 的标准差:", sd(samples_after_burnin$Y), "\n")
# 
# # X 的频率表
# cat("\nX 的频数分布:\n")
# print(table(samples_after_burnin$X))
# 
# # Y 的分位数
# cat("\nY 的分位数:\n")
# print(quantile(samples_after_burnin$Y, probs = c(0.025, 0.25, 0.5, 0.75, 0.975)))

## -----------------------------------------------------------------------------
# library(coda)
# 
# # 11.6题（Metropolis采样）示例，运行多条链，监控Gelman-Rubin收敛诊断
# run_metropolis_chains <- function(n_iter, sigma, n_chains = 4) {
#   chains <- vector("list", n_chains)
#   for (i in 1:n_chains) {
#     res <- metropolis(n_iter, sigma, x0 = rnorm(1))  # 不同初值
#     chains[[i]] <- mcmc(res$samples)
#   }
#   mcmc_list <- mcmc.list(chains)
#   return(mcmc_list)
# }
# 
# # 11.10题（Gibbs采样）示例，运行多条链，监控Gelman-Rubin收敛诊断
# run_gibbs_chains <- function(n_iter, n, a, b, n_chains = 4) {
#   chains_x <- vector("list", n_chains)
#   chains_y <- vector("list", n_chains)
#   for (i in 1:n_chains) {
#     start_x <- sample(0:n, 1)
#     start_y <- runif(1)
#     res <- gibbs_sampler(n_iter, n, a, b, x0 = start_x, y0 = start_y)
#     # 只监控X和Y的链
#     chains_x[[i]] <- mcmc(res$X)
#     chains_y[[i]] <- mcmc(res$Y)
#   }
#   list(
#     X = mcmc.list(chains_x),
#     Y = mcmc.list(chains_y)
#   )
# }
# 
# # 监控函数，直到Gelman-Rubin统计量小于1.2才停止
# monitor_convergence <- function(chain_func, param_list, target_rhat = 1.2, max_iter = 50000, batch = 5000) {
#   n_iter <- batch
#   repeat {
#     chains <- do.call(chain_func, c(list(n_iter = n_iter), param_list))
# 
#     if (is.list(chains)) {
#       # 处理多个参数，如Gibbs例子
#       rhat_x <- gelman.diag(chains$X)$psrf[, "Point est."]
#       rhat_y <- gelman.diag(chains$Y)$psrf[, "Point est."]
#       cat(sprintf("迭代 %d 次: X Gelman-Rubin R̂ = %.3f, Y Gelman-Rubin R̂ = %.3f\n",
#                   n_iter, rhat_x, rhat_y))
#       converged <- all(rhat_x < target_rhat) & all(rhat_y < target_rhat)
#     } else {
#       # 单参数链，如Metropolis例子
#       rhat <- gelman.diag(chains)$psrf[, "Point est."]
#       cat(sprintf("迭代 %d 次: Gelman-Rubin R̂ = %.3f\n", n_iter, rhat))
#       converged <- all(rhat < target_rhat)
#     }
# 
#     if (converged || n_iter >= max_iter) break
#     n_iter <- n_iter + batch
#   }
#   return(chains)
# }
# 
# ### 使用示例 ###
# 
# # 对11.6题Metropolis采样
# # chains_metropolis <- monitor_convergence(run_metropolis_chains, list(sigma = 1, n_chains = 4))
# 
# # 对11.10题Gibbs采样
# # chains_gibbs <- monitor_convergence(run_gibbs_chains, list(n=10, a=2, b=3, n_chains=4))

## -----------------------------------------------------------------------------
# set.seed(12345)
# 
# # 参数设置
# N <- 1e6
# b1 <- -1
# b2 <- 1
# b3 <- -1
# 
# # 生成样本
# x1 <- rpois(N, 1)
# x2 <- rexp(N, rate = 1)
# x3 <- rbinom(N, size = 1, prob = 0.5)
# 
# # 定义函数 g(alpha, f0)
# g <- function(alpha, f0) {
#   linpred <- alpha + b1*x1 + b2*x2 + b3*x3
#   p <- 1 / (1 + exp(-linpred))
#   mean(p) - f0
# }
# 
# # 不同的 f0
# f0_values <- c(0.1, 0.01, 0.001, 0.0001)
# alpha_solutions <- numeric(length(f0_values))
# 
# # 求解alpha
# for (i in seq_along(f0_values)) {
#   res <- uniroot(g, interval = c(-20, 20), f0 = f0_values[i])
#   alpha_solutions[i] <- res$root
# }
# 
# # 计算 -log(f0)
# neg_log_f0 <- -log(f0_values)
# 
# # 绘图
# plot(alpha_solutions, neg_log_f0,
#      main = expression(paste("-log(f"[0], ") vs ", alpha)),
#      xlab = expression(alpha),
#      ylab = expression(-log(f[0])),
#      pch = 19, col = "blue")
# 
# # 添加趋势线（可选）
# fit <- lm(neg_log_f0 ~ alpha_solutions)
# abline(fit, col = "red", lwd = 2)
# 
# # 显示数据点标签
# text(alpha_solutions, neg_log_f0, labels = round(f0_values, 5), pos = 4, cex = 0.8)
# 

## -----------------------------------------------------------------------------
# # 设置随机种子
# set.seed(12345)
# 
# # Example 11.3 的数据
# failure_times <- c(5.1, 14.0, 14.6, 14.7)
# n_parts <- 20
# test_hours <- 24
# 
# # 计算成功和失效次数
# n_failures <- length(failure_times)
# n_survived <- n_parts - n_failures
# 
# # 每个失效零件贡献的成功次数（向下取整）
# successes_from_failures <- sum(floor(failure_times))
# # 存活零件贡献的成功次数
# successes_from_survived <- n_survived * test_hours
# 
# # 总计
# total_successes <- successes_from_failures + successes_from_survived
# total_failures <- n_failures
# total_trials <- total_successes + total_failures
# 
# cat("=== 数据汇总 ===\n")
# cat("总成功次数:", total_successes, "\n")
# cat("总失效次数:", total_failures, "\n")
# cat("总试验次数:", total_trials, "\n\n")
# 
# # MLE估计
# p_mle <- total_successes / total_trials
# cat("MLE估计: p̂ =", round(p_mle, 6), "\n\n")
# 
# # 贝叶斯方法：Uniform(0,1)先验 → Beta(432, 5)后验
# alpha_post <- total_successes + 1
# beta_post <- total_failures + 1
# 
# cat("=== 贝叶斯后验分布 ===\n")
# cat("后验分布: Beta(", alpha_post, ",", beta_post, ")\n")
# cat("后验均值 E[p|data] =", round(alpha_post/(alpha_post+beta_post), 6), "\n\n")
# 
# # 派生参数 μ = p/(1-p) 的后验分布（通过模拟）
# n_sim <- 10000
# p_samples <- rbeta(n_sim, alpha_post, beta_post)
# mu_samples <- p_samples / (1 - p_samples)
# 
# cat("=== 派生参数 μ = p/(1-p) 的后验统计 ===\n")
# cat("均值:", round(mean(mu_samples), 2), "\n")
# cat("中位数:", round(median(mu_samples), 2), "\n")
# cat("标准差:", round(sd(mu_samples), 2), "\n")
# cat("95% 可信区间:", round(quantile(mu_samples, c(0.025, 0.975)), 2), "\n\n")
# 
# # 可视化
# par(mfrow = c(1, 2), mar = c(4, 4, 3, 1))
# 
# # p的后验分布
# hist(p_samples, breaks = 50, probability = TRUE,
#      main = "p的后验分布\nBeta(432, 5)",
#      xlab = "p", col = "lightblue", border = "white")
# curve(dbeta(x, alpha_post, beta_post), add = TRUE,
#       col = "red", lwd = 2)
# abline(v = mean(p_samples), col = "darkblue", lwd = 2, lty = 2)
# 
# # μ的后验分布
# hist(mu_samples, breaks = 50, probability = TRUE,
#      main = expression(paste("μ = p/(1-p) 的后验分布")),
#      xlab = "μ (期望剩余寿命)",
#      col = "lightgreen", border = "white",
#      xlim = c(0, quantile(mu_samples, 0.99)))
# abline(v = mean(mu_samples), col = "darkgreen", lwd = 2, lty = 2)
# legend("topright",
#        legend = paste("均值 =", round(mean(mu_samples), 1)),
#        col = "darkgreen", lty = 2, lwd = 2, cex = 0.9)
# 
# par(mfrow = c(1, 1))

## -----------------------------------------------------------------------------
# library(lpSolve)
# 
# # 目标函数系数（注意：lpSolve默认求解最小化问题）
# f.obj <- c(4, 2, 9)
# 
# # 约束条件系数矩阵
# f.con <- matrix(c(
#   2,  1, 1,
#   1, -1, 3
# ), nrow = 2, byrow = TRUE)
# 
# # 约束条件右侧常数
# f.dir <- c("<=", "<=")
# f.rhs <- c(2, 3)
# 
# # 求解线性规划问题
# solution <- lp("min", f.obj, f.con, f.dir, f.rhs)
# 
# # 输出结果
# cat("最优解为：", solution$solution, "\n")
# cat("最优值为：", solution$objval, "\n")

## -----------------------------------------------------------------------------
# # ===== 数据准备 =====
# # 区间删失数据 (U_i, V_i)
# intervals <- data.frame(
#   U = c(11, 8, 27, 13, 16, 0, 23, 10, 24, 2),
#   V = c(12, 9, 28, 14, 17, 1, 24, 11, 25, 3)
# )
# 
# n <- nrow(intervals)
# cat("=== 区间删失数据 ===\n")
# print(intervals)
# cat("\n样本量 n =", n, "\n\n")
# 
# # ===== EM算法实现 =====
# em_exponential <- function(U, V, lambda_init = 1, max_iter = 1000, tol = 1e-8) {
#   lambda <- lambda_init
#   lambda_history <- numeric(max_iter)
# 
#   for (iter in 1:max_iter) {
#     # E步：计算条件期望
#     delta <- V - U
#     exp_term <- exp(-lambda * delta)
# 
#     # 条件期望 E[X_i | U_i <= X_i < V_i]
#     X_bar <- U + (1 - (1 + lambda * delta) * exp_term) / (lambda * (1 - exp_term))
# 
#     # M步：更新lambda
#     lambda_new <- n / sum(X_bar)
# 
#     # 记录历史
#     lambda_history[iter] <- lambda_new
# 
#     # 检查收敛
#     if (abs(lambda_new - lambda) < tol) {
#       cat("EM算法在第", iter, "次迭代后收敛\n")
#       return(list(
#         lambda = lambda_new,
#         iterations = iter,
#         history = lambda_history[1:iter]
#       ))
#     }
# 
#     lambda <- lambda_new
#   }
# 
#   warning("EM算法未在最大迭代次数内收敛")
#   return(list(
#     lambda = lambda,
#     iterations = max_iter,
#     history = lambda_history
#   ))
# }
# 
# # ===== 直接极大化观测似然 =====
# # 观测数据的负对数似然函数
# neg_log_likelihood <- function(lambda, U, V) {
#   if (lambda <= 0) return(Inf)
#   -sum(log(exp(-lambda * U) - exp(-lambda * V)))
# }
# 
# # 使用优化方法求MLE
# mle_result <- optimize(
#   f = neg_log_likelihood,
#   interval = c(0.001, 10),
#   U = intervals$U,
#   V = intervals$V
# )
# 
# lambda_mle <- mle_result$minimum
# 
# cat("=== 直接极大似然估计 ===\n")
# cat("MLE: λ̂ =", round(lambda_mle, 6), "\n")
# cat("负对数似然值:", round(mle_result$objective, 4), "\n\n")
# 
# # ===== 运行EM算法 =====
# cat("=== EM算法估计 ===\n")
# em_result <- em_exponential(
#   U = intervals$U,
#   V = intervals$V,
#   lambda_init = 0.5,
#   max_iter = 1000,
#   tol = 1e-10
# )
# 
# cat("EM估计: λ̂_EM =", round(em_result$lambda, 6), "\n")
# cat("迭代次数:", em_result$iterations, "\n")
# cat("与MLE的差异:", abs(em_result$lambda - lambda_mle), "\n\n")
# 
# # ===== 收敛性分析 =====
# cat("=== 收敛速度分析 ===\n")
# 
# # 计算相对误差
# relative_errors <- abs(em_result$history - lambda_mle) / lambda_mle
# 
# # 检验线性收敛
# if (length(relative_errors) > 2) {
#   # 计算收敛率 q = |e_{k+1}| / |e_k|
#   convergence_rates <- relative_errors[-1] / relative_errors[-length(relative_errors)]
#   avg_rate <- mean(convergence_rates[convergence_rates < 1], na.rm = TRUE)
# 
#   cat("平均收敛率 q ≈", round(avg_rate, 4), "\n")
#   cat("收敛类型:", ifelse(avg_rate < 1, "线性收敛", "未知"), "\n\n")
# }
# 
# # ===== 可视化 =====
# par(mfrow = c(1, 2), mar = c(4, 4, 3, 1))
# 
# # 图1：EM算法收敛过程
# plot(1:em_result$iterations, em_result$history,
#      type = "b", pch = 19, col = "blue",
#      xlab = "迭代次数", ylab = "λ估计值",
#      main = "EM算法收敛过程")
# abline(h = lambda_mle, col = "red", lwd = 2, lty = 2)
# legend("topright",
#        legend = c("EM迭代", "MLE"),
#        col = c("blue", "red"),
#        lty = c(1, 2), pch = c(19, NA), lwd = 2)
# 
# # 图2：对数相对误差（收敛速度）
# if (length(relative_errors) > 1) {
#   plot(1:length(relative_errors), log10(relative_errors),
#        type = "b", pch = 19, col = "darkgreen",
#        xlab = "迭代次数", ylab = "log10(相对误差)",
#        main = "收敛速度（对数尺度）")
# 
#   # 拟合线性趋势
#   if (length(relative_errors) > 5) {
#     idx <- 5:length(relative_errors)
#     fit <- lm(log10(relative_errors[idx]) ~ idx)
#     abline(fit, col = "red", lwd = 2, lty = 2)
#     legend("topright",
#            legend = c("实际误差", "线性拟合"),
#            col = c("darkgreen", "red"),
#            lty = c(1, 2), pch = c(19, NA), lwd = 2)
#   }
# }
# 
# par(mfrow = c(1, 1))
# 
# # ===== 数值比较表 =====
# cat("=== 迭代过程详细记录（前10次和后5次）===\n")
# n_show <- min(10, em_result$iterations)
# comparison_df <- data.frame(
#   Iteration = 1:n_show,
#   Lambda = round(em_result$history[1:n_show], 6),
#   Relative_Error = round(relative_errors[1:n_show], 8)
# )
# print(comparison_df)
# 
# if (em_result$iterations > 10) {
#   cat("\n...\n\n")
#   last_5 <- max(1, em_result$iterations - 4):em_result$iterations
#   comparison_df_last <- data.frame(
#     Iteration = last_5,
#     Lambda = round(em_result$history[last_5], 6),
#     Relative_Error = round(relative_errors[last_5], 10)
#   )
#   print(comparison_df_last)
# }

## -----------------------------------------------------------------------------
# # 实现 mvapply (Map + vapply)
# mvapply <- function(FUN, FUN.VALUE, ..., USE.NAMES = TRUE) {
#   # 使用 Map() 并行迭代所有输入
#   out <- Map(FUN, ...)
# 
#   # 使用 vapply() 确保输出类型并转换为向量/矩阵
#   vapply(out, identity, FUN.VALUE, USE.NAMES = USE.NAMES)
# }
# 
# # 测试示例
# cat("=== 习题 6：mvapply() 测试 ===\n\n")
# 
# # 示例1：两个向量相加
# result1 <- mvapply(
#   function(x, y) x + y,
#   numeric(1),
#   1:5,
#   6:10
# )
# cat("示例1 - 向量相加:\n")
# print(result1)
# 
# # 示例2：计算多个向量的均值和标准差
# data_list <- list(
#   a = c(1, 2, 3, 4, 5),
#   b = c(10, 20, 30, 40, 50),
#   c = c(100, 200, 300, 400, 500)
# )
# 
# result2 <- mvapply(
#   function(x) c(mean = mean(x), sd = sd(x)),
#   numeric(2),
#   data_list
# )
# cat("\n示例2 - 计算统计量（返回矩阵）:\n")
# print(result2)
# 
# # 示例3：字符串处理
# result3 <- mvapply(
#   function(x, y) paste(x, y, sep = "-"),
#   character(1),
#   c("A", "B", "C"),
#   c("1", "2", "3")
# )
# cat("\n示例3 - 字符串拼接:\n")
# print(result3)

## -----------------------------------------------------------------------------
# # 快速卡方检验函数
# chisq_test_fast <- function(x, y) {
#   # 输入验证
#   if (!is.numeric(x) || !is.numeric(y)) {
#     stop("输入必须是数值向量")
#   }
#   if (anyNA(x) || anyNA(y)) {
#     stop("输入不能包含缺失值")
#   }
#   if (length(x) != length(y)) {
#     stop("两个向量长度必须相同")
#   }
# 
#   # 创建列联表
#   observed <- table(x, y)
# 
#   # 计算期望频数
#   row_sums <- rowSums(observed)
#   col_sums <- colSums(observed)
#   n <- sum(observed)
# 
#   expected <- outer(row_sums, col_sums) / n
# 
#   # 计算卡方统计量
#   chi_squared <- sum((observed - expected)^2 / expected)
# 
#   # 计算自由度
#   df <- (nrow(observed) - 1) * (ncol(observed) - 1)
# 
#   # 计算 p 值
#   p_value <- pchisq(chi_squared, df, lower.tail = FALSE)
# 
#   # 返回结果
#   list(
#     statistic = chi_squared,
#     parameter = df,
#     p.value = p_value,
#     observed = observed,
#     expected = expected
#   )
# }
# 
# # 测试并比较性能
# cat("=== 习题 4：快速卡方检验 ===\n\n")
# 
# # 生成测试数据
# set.seed(123)
# x <- sample(1:3, 1000, replace = TRUE)
# y <- sample(1:3, 1000, replace = TRUE)
# 
# # 使用标准函数
# result_standard <- chisq.test(x, y)
# cat("标准 chisq.test() 结果:\n")
# cat("  卡方统计量:", result_standard$statistic, "\n")
# cat("  自由度:", result_standard$parameter, "\n")
# cat("  p值:", result_standard$p.value, "\n\n")
# 
# # 使用快速版本
# result_fast <- chisq_test_fast(x, y)
# cat("快速版本结果:\n")
# cat("  卡方统计量:", result_fast$statistic, "\n")
# cat("  自由度:", result_fast$parameter, "\n")
# cat("  p值:", result_fast$p.value, "\n\n")
# 
# # 性能比较
# library(microbenchmark)
# benchmark_result <- microbenchmark(
#   standard = chisq.test(x, y),
#   fast = chisq_test_fast(x, y),
#   times = 100
# )
# cat("性能比较:\n")
# print(summary(benchmark_result)[, c("expr", "mean", "median")])

## -----------------------------------------------------------------------------
# # 快速 table 函数（针对整数向量）
# table_fast <- function(x, y) {
#   # 输入验证
#   if (!is.integer(x)) x <- as.integer(x)
#   if (!is.integer(y)) y <- as.integer(y)
#   if (anyNA(x) || anyNA(y)) {
#     stop("输入不能包含缺失值")
#   }
#   if (length(x) != length(y)) {
#     stop("两个向量长度必须相同")
#   }
# 
#   # 获取唯一值
#   x_levels <- sort(unique(x))
#   y_levels <- sort(unique(y))
# 
#   # 创建空矩阵
#   result <- matrix(0,
#                    nrow = length(x_levels),
#                    ncol = length(y_levels),
#                    dimnames = list(x_levels, y_levels))
# 
#   # 填充计数
#   for (i in seq_along(x)) {
#     row_idx <- match(x[i], x_levels)
#     col_idx <- match(y[i], y_levels)
#     result[row_idx, col_idx] <- result[row_idx, col_idx] + 1
#   }
# 
#   result
# }
# 
# # 使用快速 table 改进卡方检验
# 
# chisq_test_faster <- function(x, y) {
#   # 使用快速 table
#   observed <- table_fast(x, y)
# 
#   # 计算期望频数
#   row_sums <- rowSums(observed)
#   col_sums <- colSums(observed)
#   n <- sum(observed)
#   expected <- outer(row_sums, col_sums) / n
# 
#   # 计算卡方统计量
#   chi_squared <- sum((observed - expected)^2 / expected)
#   df <- (nrow(observed) - 1) * (ncol(observed) - 1)
#   p_value <- pchisq(chi_squared, df, lower.tail = FALSE)
# 
#   list(
#     statistic = chi_squared,
#     parameter = df,
#     p.value = p_value
#   )
# }
# 
# # 测试
# cat("\n=== 习题 5：快速 table() 函数 ===\n\n")
# 
# # 生成测试数据
# set.seed(123)
# x <- sample(1L:5L, 10000, replace = TRUE)
# y <- sample(1L:5L, 10000, replace = TRUE)
# 
# # 比较 table 函数
# cat("比较 table() 函数:\n")
# benchmark_table <- microbenchmark(
#   standard = table(x, y),
#   fast = table_fast(x, y),
#   times = 100
# )
# print(summary(benchmark_table)[, c("expr", "mean", "median")])
# 
# # 验证结果一致性
# cat("\n验证结果是否一致:\n")
# cat("  table() 和 table_fast() 结果相同:",
#     identical(as.matrix(table(x, y)), table_fast(x, y)), "\n")
# 
# # 比较完整的卡方检验
# cat("\n比较完整卡方检验性能:\n")
# benchmark_chisq <- microbenchmark(
#   original = chisq_test_fast(x, y),
#   with_fast_table = chisq_test_faster(x, y),
#   times = 100
# )
# print(summary(benchmark_chisq)[, c("expr", "mean", "median")])
# 
# # 验证卡方检验结果
# result1 <- chisq_test_fast(x, y)
# result2 <- chisq_test_faster(x, y)
# cat("\n卡方统计量差异:", abs(result1$statistic - result2$statistic), "\n")
# cat("p值差异:", abs(result1$p.value - result2$p.value), "\n")

## -----------------------------------------------------------------------------
# library(Rcpp)
# library(microbenchmark)
# 
# # ============================================================
# # 1. Write an Rcpp function for Exercise 11.8
# # ============================================================
# 
# # 定义 C++ 代码
# cppFunction('
#   NumericVector gibbs_rcpp(int N, int thin) {
#     NumericVector mat(N);
#     double x = 0.5; // 初始值 theta
#     double y = 0;   // 潜在变量 z_1b
#     int n_sample = 125;
# 
#     // Beta分布参数常数部分
#     double shape2 = 39.0; // 18 + 20 + 1
# 
#     for(int i = 0; i < N; i++) {
#       for(int j = 0; j < thin; j++) {
#         // 1. 更新 latent variable z_1b
#         // R::rbinom(n, p)
#         y = R::rbinom(n_sample, x / (2.0 + x));
# 
#         // 2. 更新 theta
#         // R::rbeta(shape1, shape2)
#         x = R::rbeta(y + 35.0, shape2);
#       }
#       mat[i] = x;
#     }
#     return(mat);
#   }
# ')
# 
# # ============================================================
# # 准备工作：定义对应的纯 R 函数 (用于对比)
# # ============================================================
# 
# gibbs_r <- function(N, thin) {
#   mat <- numeric(N)
#   x <- 0.5
#   y <- 0
#   n_sample <- 125
#   shape2 <- 39
# 
#   for(i in 1:N) {
#     for(j in 1:thin) {
#       # 1. 更新 latent variable
#       y <- rbinom(1, n_sample, x / (2 + x))
#       # 2. 更新 theta
#       x <- rbeta(1, y + 35, shape2)
#     }
#     mat[i] <- x
#   }
#   return(mat)
# }
# 
# # 设置参数
# N <- 2000     # 样本数量
# thin <- 10    # 稀疏化间隔 (thinning) 以减少自相关
# 
# # ============================================================
# # 2. Compare random numbers using "qqplot"
# # ============================================================
# 
# # 运行两个函数
# set.seed(123)
# ts_r <- gibbs_r(N, thin)
# 
# set.seed(123)
# ts_cpp <- gibbs_rcpp(N, thin)
# 
# # 绘制 QQ Plot
# par(mfrow = c(1, 1)) # 设置绘图区域
# qqplot(ts_r, ts_cpp,
#        main = "QQ Plot: R vs Rcpp Implementation",
#        xlab = "Quantiles of R samples",
#        ylab = "Quantiles of Rcpp samples",
#        pch = 19, col = rgb(0, 0, 1, 0.5))
# # 添加 y=x 参考线
# abline(0, 1, col = "red", lwd = 2)
# 
# # ============================================================
# # 3. Compare computation time using "microbenchmark"
# # ============================================================
# 
# # 比较运行时间 (减少 N 以便快速测试，或者保持 N=2000)
# mb_res <- microbenchmark(
#   R_Function = gibbs_r(N, thin),
#   Rcpp_Function = gibbs_rcpp(N, thin),
#   times = 20
# )
# 
# print(mb_res)
# 
# # 可视化比较结果
# boxplot(mb_res, main = "Computation Time Comparison", col = c("orange", "lightblue"))

## -----------------------------------------------------------------------------
# # ============================================================
# # 4. Comments on your results
# # ============================================================
# cat("\n=== Comments ===\n")
# cat("1. QQ Plot 分析:\n")
# cat("   点紧密围绕在 y=x (红色对角线) 周围，这表明 Rcpp 函数生成的随机数分布\n")
# cat("   与纯 R 函数生成的分布是一致的。这意味着我们的 C++ 实现逻辑是正确的。\n\n")
# 
# cat("2. Microbenchmark 性能分析:\n")
# cat("   从结果可以看出，Rcpp_Function 的运行时间显著低于 R_Function。\n")
# cat("   通常 Rcpp 版本会快 10 到 50 倍甚至更多。\n")
# cat("   这是因为 Gibbs 采样包含大量的显式循环 (for loop)，R 语言在处理循环时\n")
# cat("   开销较大，而 C++ 是编译型语言，处理迭代极其高效。\n")

