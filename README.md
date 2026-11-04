# SA25204164

基于 **Horseshoe Prior（马蹄先验）** 的贝叶斯稀疏回归 R 包，提供纯 R 和 Rcpp/C++ 两种 Gibbs 采样实现，用于学习稀疏信号恢复、后验采样与 R/C++ 性能比较。

仓库同时保留了统计计算课程的作业文档。包的核心用法见下文，完整函数说明和课程内容见[文档入口](#文档入口)。

## 主要功能

| 函数 | 用途 |
| --- | --- |
| `simulate_sparse_data()` | 生成带有已知稀疏系数的模拟回归数据 |
| `horseshoe_gibbs_r()` | 使用纯 R 实现进行 Gibbs 采样 |
| `horseshoe_gibbs_cpp()` | 使用 Rcpp/C++ 实现进行 Gibbs 采样 |
| `horseshoe_estimate()` | 选择 R 或 C++ 实现，返回系数的后验均值或中位数估计 |

## 安装

需要 R，以及能够编译 R 扩展的 C++ 工具链。Windows 可使用与 R 版本匹配的 [Rtools](https://cran.r-project.org/bin/windows/Rtools/)，macOS 可参考 [R for macOS 的开发工具说明](https://mac.r-project.org/tools/)，Linux 需要相应的编译器和 R 开发环境。

在 R 或 RStudio 中运行：

```r
install.packages("remotes")  # 已安装时可跳过
remotes::install_github(
  "1160574378-lab/SA25204164",
  build_vignettes = FALSE,
  upgrade = "never"
)

library(SA25204164)
```

`Rcpp` 和 `microbenchmark` 是包声明的运行依赖，安装时会按需补齐。上述命令跳过重新构建 vignette，并保留已有依赖的版本；参数含义见 [remotes 官方文档](https://remotes.r-lib.org/reference/install_github.html)。

## 快速开始

生成 80 个观测、20 个特征，其中前 4 个系数非零；运行 1,000 次迭代，丢弃前 200 次预热样本：

```r
library(SA25204164)

set.seed(123)
dat <- simulate_sparse_data(n = 80, p = 20, s = 4, signal = 3, sigma = 1)

fit <- horseshoe_gibbs_cpp(
  y = dat$y,
  X = dat$X,
  niter = 1000,
  burnin = 200
)

# 比较真实系数与后验均值
comparison <- data.frame(
  beta_true = dat$beta_true,
  beta_estimate = fit$beta_mean
)
print(round(comparison, 3))

# 系数估计的均方根误差（模拟数据中才知道真实系数）
sqrt(mean((fit$beta_mean - dat$beta_true)^2))

# 检查输出结构；这不等于检验 MCMC 收敛
stopifnot(
  all(dim(fit$beta_samples) == c(800, 20)),
  length(fit$tau_samples) == 800,
  length(fit$beta_mean) == 20,
  all(is.finite(fit$beta_samples)),
  all(is.finite(fit$tau_samples))
)
```

如果只需要系数点估计：

```r
# C++ 实现，返回后验均值
beta_mean <- horseshoe_estimate(
  dat$y, dat$X, method = "mean", use_cpp = TRUE,
  niter = 1000, burnin = 200
)

# R 实现，返回后验中位数
beta_median <- horseshoe_estimate(
  dat$y, dat$X, method = "median", use_cpp = FALSE,
  niter = 1000, burnin = 200
)
```

## 参数与返回值

- `X`：具有 `n` 行、`p` 列的数值设计矩阵；`y`：长度为 `n` 的数值响应向量。输入不应包含 `NA`、`NaN` 或无穷值。
- `niter`：总迭代次数，默认 `2000`；`burnin`：丢弃的预热次数，默认 `500`。两者应为整数，`burnin` 不小于 `0`，且小于 `niter`。
- 模拟函数的 `n`、`p` 应为正整数，`s` 为不小于 `0`、不大于 `p` 的整数；`signal` 控制前 `s` 个非零系数的大小，`sigma` 为噪声标准差。
- `horseshoe_estimate()` 的 `method` 请使用 `"mean"` 或 `"median"`，`use_cpp` 默认 `TRUE`。

两个采样函数均返回以下列表：

| 字段 | 含义 | 维度 |
| --- | --- | --- |
| `beta_samples` | 预热后的回归系数样本 | 行数为 `niter - burnin`，列数为 `p` |
| `tau_samples` | 预热后的全局收缩参数样本 | 长度为 `niter - burnin` 的向量 |
| `beta_mean` | 各系数的样本均值 | 长度为 `p` 的向量 |

`simulate_sparse_data()` 返回 `y`、`X`、`beta_true` 和 `s`；`horseshoe_estimate()` 直接返回长度为 `p` 的系数向量。

## R 与 C++ 运行时间比较

在相同数据和迭代设置下，可以自行测量本机运行时间：

```r
set.seed(123)
bench_dat <- simulate_sparse_data(n = 50, p = 20, s = 3)

microbenchmark::microbenchmark(
  R_version = horseshoe_gibbs_r(
    bench_dat$y, bench_dat$X, niter = 500, burnin = 100
  ),
  Cpp_version = horseshoe_gibbs_cpp(
    bench_dat$y, bench_dat$X, niter = 500, burnin = 100
  ),
  times = 5L
)
```

实际耗时取决于数据维度、迭代次数、硬件和编译环境。两种实现使用随机采样，不应仅凭一次结果或相同随机种子要求输出逐项相等。

## 仓库结构

```text
SA25204164/
├── DESCRIPTION              # 包信息、版本与依赖
├── NAMESPACE                # 导出函数与动态库声明
├── R/
│   ├── SA25204164.R          # R 采样器、点估计接口和模拟数据
│   └── RcppExports.R         # Rcpp 生成的 R 调用接口
├── src/
│   ├── SA25204164.cpp        # C++ 采样器
│   └── RcppExports.cpp       # Rcpp 生成的 C++ 调用接口
├── man/                     # R 帮助文档
├── vignettes/
│   ├── intro.Rmd            # 包介绍与性能比较示例
│   └── HW.Rmd               # 统计计算课程作业
├── inst/doc/                # 随仓库保存的文档源文件、R 代码和 HTML
└── SA25204164.Rproj          # RStudio 项目
```

## 文档入口

- [包介绍与示例](vignettes/intro.Rmd)
- [统计计算课程作业](vignettes/HW.Rmd)
- [已生成的包介绍 HTML](inst/doc/intro.html)和[作业 HTML](inst/doc/HW.html)：可下载后在浏览器中打开。
- [函数帮助源文件](man/)：安装后也可在 R 中运行 `?horseshoe_gibbs_cpp`、`?horseshoe_estimate` 或 `?simulate_sparse_data`。

## 使用边界

- 本项目用于学习和模拟实验。采样更新式与目标后验的一致性、MCMC 收敛性仍需进一步核验；示例运行成功不代表统计推断已经得到完整验证。
- 当前函数不自动添加截距、中心化或标准化，也没有系统的输入检查。使用真实数据前应自行完成数据处理并核对输入与迭代设置。
- 包中保存全部预热后的系数样本，内存需求随特征数和保留迭代数增加；大规模数据的运行时间与内存占用需要单独测量。

## 许可

根据 [DESCRIPTION](DESCRIPTION)，本包采用 **GPL (>= 2)** 许可。
