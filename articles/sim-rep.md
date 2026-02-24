# Single Replication from the Simulation Study

``` r

library(OpenMx)
library(fitVARMxID)
library(metaDyn)
library(manMetaVAR)
```

## Data Generation

``` r

taskid <- 1
seed <- 42
set.seed(seed)
data <- GenData(
  taskid = taskid,
  seed = seed
)
```

``` r

plot(data)
```

![](fig-vignettes-sim-rep-unnamed-chunk-9-1.png)![](fig-vignettes-sim-rep-unnamed-chunk-9-2.png)

``` r

summary(data)
#>        id            time             y1               y2        
#>  Min.   : 1.0   Min.   : 0.00   Min.   :-2.768   Min.   :-3.683  
#>  1st Qu.:13.0   1st Qu.:24.75   1st Qu.: 1.840   1st Qu.: 1.250  
#>  Median :25.5   Median :49.50   Median : 2.923   Median : 2.394  
#>  Mean   :25.5   Mean   :49.50   Mean   : 2.932   Mean   : 2.384  
#>  3rd Qu.:38.0   3rd Qu.:74.25   3rd Qu.: 4.086   3rd Qu.: 3.533  
#>  Max.   :50.0   Max.   :99.00   Max.   : 9.307   Max.   : 9.314
```

## MetaVAR

``` r

dtvar <- FitDTVAR(
  data = data,
  seed = seed
)
```

``` r

summary(dtvar, means = TRUE)
#> Call:
#> FitVARMxID(data = data$data, observed = paste0("y", seq_len(model$k)), 
#>     id = "id", time = NULL, ct = FALSE, center = TRUE, mu_fixed = FALSE, 
#>     mu_free = NULL, mu_values = data$mu, mu_lbound = NULL, mu_ubound = NULL, 
#>     alpha_fixed = FALSE, alpha_free = NULL, alpha_values = NULL, 
#>     alpha_lbound = NULL, alpha_ubound = NULL, beta_fixed = FALSE, 
#>     beta_free = NULL, beta_values = data$beta, beta_lbound = NULL, 
#>     beta_ubound = NULL, psi_diag = FALSE, psi_fixed = FALSE, 
#>     psi_d_free = NULL, psi_d_values = model$psi_d_ldl, psi_d_lbound = NULL, 
#>     psi_d_ubound = NULL, psi_d_equal = FALSE, psi_l_free = NULL, 
#>     psi_l_values = model$psi_l_ldl, psi_l_lbound = NULL, psi_l_ubound = NULL, 
#>     nu_fixed = TRUE, nu_free = NULL, nu_values = NULL, nu_lbound = NULL, 
#>     nu_ubound = NULL, theta_diag = TRUE, theta_fixed = TRUE, 
#>     theta_d_free = NULL, theta_d_values = NULL, theta_d_lbound = NULL, 
#>     theta_d_ubound = NULL, theta_d_equal = FALSE, theta_l_free = NULL, 
#>     theta_l_values = NULL, theta_l_lbound = NULL, theta_l_ubound = NULL, 
#>     mu0_fixed = TRUE, mu0_func = TRUE, mu0_free = NULL, mu0_values = NULL, 
#>     mu0_lbound = NULL, mu0_ubound = NULL, sigma0_fixed = TRUE, 
#>     sigma0_func = TRUE, sigma0_diag = FALSE, sigma0_d_free = NULL, 
#>     sigma0_d_values = NULL, sigma0_d_lbound = NULL, sigma0_d_ubound = NULL, 
#>     sigma0_d_equal = FALSE, sigma0_l_free = NULL, sigma0_l_values = NULL, 
#>     sigma0_l_lbound = NULL, sigma0_l_ubound = NULL, robust = FALSE, 
#>     seed = seed, tries_explore = 100, tries_local = 100, max_attempts = 10, 
#>     silent = TRUE, ncores = ncores)
#> 
#> Convergence:
#> 100.0%
#> 
#> Means of the estimated paramaters per individual.
#>   mu[1,1]   mu[2,1] beta[1,1] beta[2,1] beta[1,2] beta[2,2]  psi[1,1]  psi[2,1] 
#>    2.9323    2.3858    0.2408   -0.0854   -0.0465    0.2062    1.2439    0.5097 
#>  psi[2,2] 
#>    1.4850
```

``` r

metavar <- FitMetaVAR(
  fit = dtvar,
  seed = seed
)
```

``` r

summary(metavar)
#> Call:
#> MetaVARMx(object = fit$output, x = NULL, random = TRUE, alpha_values = model$ma_fixed, 
#>     tau_sqr_diag = FALSE, tau_sqr_d_free = TRUE, tau_sqr_d_values = model$ma_random_d_ldl, 
#>     tau_sqr_l_free = matrix(data = c(FALSE, FALSE, FALSE, FALSE, 
#>         FALSE, FALSE, TRUE, FALSE, FALSE, FALSE, FALSE, FALSE, 
#>         FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, 
#>         TRUE, FALSE, FALSE, FALSE, FALSE, FALSE, TRUE, TRUE, 
#>         FALSE, FALSE, FALSE, FALSE, TRUE, TRUE, TRUE, FALSE), 
#>         byrow = TRUE, nrow = 6, ncol = 6), tau_sqr_l_values = model$ma_random_l_ldl, 
#>     effects = TRUE, set_point = TRUE, int_meas = FALSE, int_dyn = FALSE, 
#>     cov_meas = FALSE, cov_dyn = FALSE, robust_v = FALSE, robust = FALSE, 
#>     tries_explore = 100, tries_local = 100, max_attempts = 10, 
#>     silent = TRUE, seed = seed, ncores = ncores)
#> 
#> Status code: 0
#> 
#> CI type: "normal"
#> 
#>                  est     se        z      p    2.5%   97.5%
#> alpha[1,1]    2.9332 0.1631  17.9894 0.0000  2.6136  3.2528
#> alpha[2,1]    2.3849 0.1460  16.3346 0.0000  2.0987  2.6710
#> alpha[3,1]    0.2427 0.0227  10.6776 0.0000  0.1981  0.2872
#> alpha[4,1]   -0.0868 0.0168  -5.1752 0.0000 -0.1197 -0.0539
#> alpha[5,1]   -0.0444 0.0136  -3.2634 0.0011 -0.0711 -0.0177
#> alpha[6,1]    0.2160 0.0262   8.2328 0.0000  0.1646  0.2674
#> tau_sqr[1,1]  1.3053 0.2657   4.9130 0.0000  0.7846  1.8261
#> tau_sqr[2,1]  0.5946 0.1891   3.1438 0.0017  0.2239  0.9654
#> tau_sqr[2,2]  1.0392 0.2139   4.8586 0.0000  0.6200  1.4584
#> tau_sqr[3,3]  0.0155 0.0050   3.1046 0.0019  0.0057  0.0253
#> tau_sqr[4,3]  0.0028 0.0027   1.0400 0.2984 -0.0025  0.0082
#> tau_sqr[5,3]  0.0009 0.0021   0.4359 0.6629 -0.0032  0.0050
#> tau_sqr[6,3]  0.0052 0.0042   1.2338 0.2173 -0.0031  0.0134
#> tau_sqr[4,4]  0.0019 0.0017   1.1053 0.2690 -0.0014  0.0052
#> tau_sqr[5,4]  0.0008 0.0012   0.6433 0.5200 -0.0016  0.0031
#> tau_sqr[6,4]  0.0063 0.0029   2.1862 0.0288  0.0007  0.0120
#> tau_sqr[5,5]  0.0006 0.0018   0.3619 0.7174 -0.0028  0.0041
#> tau_sqr[6,5]  0.0021 0.0025   0.8358 0.4033 -0.0028  0.0070
#> tau_sqr[6,6]  0.0241 0.0068   3.5666 0.0004  0.0109  0.0374
#> i_sqr[1,1]    0.9857 0.0029 344.1187 0.0000  0.9801  0.9913
#> i_sqr[2,1]    0.9779 0.0045 219.0696 0.0000  0.9691  0.9866
#> i_sqr[3,1]    0.6054 0.0769   7.8680 0.0000  0.4546  0.7562
#> i_sqr[4,1]    0.1689 0.1222   1.3821 0.1669 -0.0706  0.4084
#> i_sqr[5,1]    0.2604 0.1477   1.7633 0.0779 -0.0291  0.5499
#> i_sqr[6,1]    0.7643 0.0466  16.3963 0.0000  0.6729  0.8556
```

## Mplus

``` r

mplus <- FitMplus(
  data = data,
  seed = seed
)
```

``` r

summary(mplus)
#>                               est     se     R    2.5%   97.5%
#> psi[1,1]                   1.2828 0.0260 40000  1.2330  1.3353
#> psi[2,1]                   0.5253 0.0218 40000  0.4840  0.5682
#> psi[2,2]                   1.5301 0.0310 40000  1.4709  1.5925
#> mean(beta[1,1])            0.2569 0.0263 40000  0.2050  0.3083
#> mean(beta[2,1])           -0.0865 0.0200 40000 -0.1260 -0.0473
#> mean(beta[1,2])           -0.0466 0.0169 40000 -0.0801 -0.0135
#> mean(beta[2,2])            0.2252 0.0308 40000  0.1639  0.2849
#> mean(mu[1,1])              2.9339 0.1766 40000  2.5847  3.2799
#> mean(mu[2,1])              2.3835 0.1575 40000  2.0730  2.6943
#> cov(beta[1,1],beta[1,1])   0.0223 0.0105 40000  0.0114  0.0421
#> cov(beta[2,1], beta[1,1])  0.0043 0.0042 40000 -0.0026  0.0143
#> cov(beta[2,1],beta[2,1])   0.0058 0.0079 40000  0.0016  0.0154
#> cov(beta[1,2],beta[1,1])  -0.0005 0.0034 40000 -0.0081  0.0056
#> cov(beta[1,2],beta[2,1])   0.0006 0.0023 40000 -0.0040  0.0051
#> cov(beta[1,2],beta[1,2])   0.0046 0.0076 40000  0.0013  0.0121
#> cov(beta[2,2],beta[1,1])   0.0054 0.0065 40000 -0.0068  0.0191
#> cov(beta[2,2],beta[2,1])   0.0052 0.0047 40000 -0.0038  0.0152
#> cov(beta[2,2],beta[1,2])   0.0048 0.0043 40000 -0.0024  0.0147
#> cov(beta[2,2],beta[2,2])   0.0340 0.0128 40000  0.0192  0.0611
#> cov(mu[1,1],mu[1,1])       1.4813 0.3406 40000  0.9923  2.3145
#> cov(mu[2,1],mu[1,1])       0.6724 0.2413 40000  0.2995  1.2459
#> cov(mu[2,1],mu[2,1])       1.1788 0.2746 40000  0.7920  1.8497
```

``` r

coef(mplus)
#>                  psi[1,1]                  psi[2,1]                  psi[2,2] 
#>                  1.282790                  0.525280                  1.530130 
#>           mean(beta[1,1])           mean(beta[2,1])           mean(beta[1,2]) 
#>                  0.256885                 -0.086530                 -0.046640 
#>           mean(beta[2,2])             mean(mu[1,1])             mean(mu[2,1]) 
#>                  0.225250                  2.933890                  2.383510 
#>  cov(beta[1,1],beta[1,1]) cov(beta[2,1], beta[1,1])  cov(beta[2,1],beta[2,1]) 
#>                  0.022270                  0.004320                  0.005750 
#>  cov(beta[1,2],beta[1,1])  cov(beta[1,2],beta[2,1])  cov(beta[1,2],beta[1,2]) 
#>                 -0.000490                  0.000600                  0.004550 
#>  cov(beta[2,2],beta[1,1])  cov(beta[2,2],beta[2,1])  cov(beta[2,2],beta[1,2]) 
#>                  0.005390                  0.005200                  0.004750 
#>  cov(beta[2,2],beta[2,2])      cov(mu[1,1],mu[1,1])      cov(mu[2,1],mu[1,1]) 
#>                  0.034050                  1.481260                  0.672410 
#>      cov(mu[2,1],mu[2,1]) 
#>                  1.178810
```

``` r

vcov(mplus)
#>                                psi[1,1]      psi[2,1]      psi[2,2]
#> psi[1,1]                   6.765263e-04  2.777638e-04  1.156358e-04
#> psi[2,1]                   2.777638e-04  4.743537e-04  3.335835e-04
#> psi[2,2]                   1.156358e-04  3.335835e-04  9.626985e-04
#> mean(beta[1,1])            7.876212e-06  4.953115e-06 -2.001507e-06
#> mean(beta[2,1])            8.422323e-06  6.760165e-06  4.381393e-06
#> mean(beta[1,2])            2.600892e-06  9.205979e-06  9.922007e-06
#> mean(beta[2,2])           -3.470167e-06  7.321864e-06  1.262619e-05
#> mean(mu[1,1])              2.269330e-05  1.390717e-05  2.180355e-05
#> mean(mu[2,1])              2.641654e-05  2.019703e-05 -8.404029e-06
#> cov(beta[1,1],beta[1,1])  -1.561874e-06 -2.620740e-05 -6.334357e-06
#> cov(beta[2,1], beta[1,1]) -1.751098e-06 -2.129343e-06 -1.445320e-08
#> cov(beta[2,1],beta[2,1])   3.364204e-06 -2.722231e-05 -1.048814e-05
#> cov(beta[1,2],beta[1,1])   1.161643e-07  8.649918e-08 -3.498848e-07
#> cov(beta[1,2],beta[2,1])  -1.846741e-07 -1.871570e-08  3.919626e-07
#> cov(beta[1,2],beta[1,2])   1.227550e-06 -2.712595e-05 -8.823666e-06
#> cov(beta[2,2],beta[1,1])  -5.569296e-07  4.304338e-07  6.022697e-07
#> cov(beta[2,2],beta[2,1])  -4.145449e-07 -3.203127e-07 -6.223756e-07
#> cov(beta[2,2],beta[1,2])  -1.086456e-06 -2.257210e-06 -1.565375e-06
#> cov(beta[2,2],beta[2,2])   2.315990e-06 -2.618952e-05 -1.446179e-05
#> cov(mu[1,1],mu[1,1])       3.905377e-06 -6.681851e-05 -6.497403e-05
#> cov(mu[2,1],mu[1,1])       2.054062e-05 -2.034808e-05 -2.676026e-05
#> cov(mu[2,1],mu[2,1])       3.301370e-05  1.913473e-05  1.205315e-06
#>                           mean(beta[1,1]) mean(beta[2,1]) mean(beta[1,2])
#> psi[1,1]                     7.876212e-06    8.422323e-06    2.600892e-06
#> psi[2,1]                     4.953115e-06    6.760165e-06    9.205979e-06
#> psi[2,2]                    -2.001507e-06    4.381393e-06    9.922007e-06
#> mean(beta[1,1])              6.910519e-04    1.876465e-04   -8.663372e-05
#> mean(beta[2,1])              1.876465e-04    3.997066e-04   -1.671620e-05
#> mean(beta[1,2])             -8.663372e-05   -1.671620e-05    2.865017e-04
#> mean(beta[2,2])              8.209928e-05    1.585096e-05    1.766902e-04
#> mean(mu[1,1])               -2.755496e-05   -1.976099e-05    1.246027e-05
#> mean(mu[2,1])               -6.931760e-06   -1.237629e-05    1.235836e-05
#> cov(beta[1,1],beta[1,1])    -2.003763e-05    1.291168e-06    5.371903e-06
#> cov(beta[2,1], beta[1,1])   -2.343874e-06   -5.229494e-06    6.559392e-07
#> cov(beta[2,1],beta[2,1])    -1.346985e-05    3.198884e-06    1.996567e-06
#> cov(beta[1,2],beta[1,1])     3.685721e-06    2.415051e-06   -2.226097e-06
#> cov(beta[1,2],beta[2,1])     3.697831e-07    1.038032e-07   -7.830874e-07
#> cov(beta[1,2],beta[1,2])    -1.319604e-05    3.162266e-06    2.356954e-06
#> cov(beta[2,2],beta[1,1])     1.582580e-06    2.815446e-06   -6.726504e-07
#> cov(beta[2,2],beta[2,1])     2.220445e-07   -2.131502e-06   -9.046385e-07
#> cov(beta[2,2],beta[1,2])     4.514591e-07    1.360075e-07   -1.074958e-06
#> cov(beta[2,2],beta[2,2])    -1.113504e-05    7.066334e-06    1.494108e-06
#> cov(mu[1,1],mu[1,1])        -1.077318e-04   -9.297186e-05   -2.239178e-06
#> cov(mu[2,1],mu[1,1])        -5.177934e-06   -3.120119e-05   -1.277208e-05
#> cov(mu[2,1],mu[2,1])        -2.933345e-05   -7.198650e-06   -2.020579e-05
#>                           mean(beta[2,2]) mean(mu[1,1]) mean(mu[2,1])
#> psi[1,1]                    -3.470167e-06  2.269330e-05  2.641654e-05
#> psi[2,1]                     7.321864e-06  1.390717e-05  2.019703e-05
#> psi[2,2]                     1.262619e-05  2.180355e-05 -8.404029e-06
#> mean(beta[1,1])              8.209928e-05 -2.755496e-05 -6.931760e-06
#> mean(beta[2,1])              1.585096e-05 -1.976099e-05 -1.237629e-05
#> mean(beta[1,2])              1.766902e-04  1.246027e-05  1.235836e-05
#> mean(beta[2,2])              9.470889e-04 -1.928003e-05 -5.367768e-05
#> mean(mu[1,1])               -1.928003e-05  3.120083e-02  1.411751e-02
#> mean(mu[2,1])               -5.367768e-05  1.411751e-02  2.481884e-02
#> cov(beta[1,1],beta[1,1])    -1.053157e-05 -2.560790e-06 -1.024531e-05
#> cov(beta[2,1], beta[1,1])    2.321479e-06 -2.199049e-06 -5.889959e-06
#> cov(beta[2,1],beta[2,1])    -1.143630e-05  2.683282e-06 -2.109085e-06
#> cov(beta[1,2],beta[1,1])    -1.133379e-06 -2.386888e-06 -5.052750e-07
#> cov(beta[1,2],beta[2,1])    -1.420028e-07  3.817362e-08  7.479047e-07
#> cov(beta[1,2],beta[1,2])    -1.102504e-05 -7.590026e-07  1.725872e-06
#> cov(beta[2,2],beta[1,1])    -2.086516e-06  3.637660e-06 -6.012077e-06
#> cov(beta[2,2],beta[2,1])    -3.134106e-08 -1.749743e-07 -6.176165e-07
#> cov(beta[2,2],beta[1,2])    -5.211385e-07 -1.680932e-06 -1.770680e-06
#> cov(beta[2,2],beta[2,2])    -1.693606e-05  3.881368e-06 -8.339683e-06
#> cov(mu[1,1],mu[1,1])        -5.737096e-05 -3.596270e-04 -7.645134e-05
#> cov(mu[2,1],mu[1,1])        -4.543712e-05 -2.267448e-04  7.815435e-05
#> cov(mu[2,1],mu[2,1])        -7.954162e-05 -4.350626e-04 -4.951454e-05
#>                           cov(beta[1,1],beta[1,1]) cov(beta[2,1], beta[1,1])
#> psi[1,1]                             -1.561874e-06             -1.751098e-06
#> psi[2,1]                             -2.620740e-05             -2.129343e-06
#> psi[2,2]                             -6.334357e-06             -1.445320e-08
#> mean(beta[1,1])                      -2.003763e-05             -2.343874e-06
#> mean(beta[2,1])                       1.291168e-06             -5.229494e-06
#> mean(beta[1,2])                       5.371903e-06              6.559392e-07
#> mean(beta[2,2])                      -1.053157e-05              2.321479e-06
#> mean(mu[1,1])                        -2.560790e-06             -2.199049e-06
#> mean(mu[2,1])                        -1.024531e-05             -5.889959e-06
#> cov(beta[1,1],beta[1,1])              1.099454e-04              1.575939e-05
#> cov(beta[2,1], beta[1,1])             1.575939e-05              1.803455e-05
#> cov(beta[2,1],beta[2,1])              5.313868e-05              7.114663e-06
#> cov(beta[1,2],beta[1,1])             -6.571431e-06             -1.440628e-06
#> cov(beta[1,2],beta[2,1])             -1.467187e-06             -1.044539e-06
#> cov(beta[1,2],beta[1,2])              4.964798e-05             -3.018670e-07
#> cov(beta[2,2],beta[1,1])              8.001503e-06              3.087867e-06
#> cov(beta[2,2],beta[2,1])              2.231432e-06              3.409565e-06
#> cov(beta[2,2],beta[1,2])             -8.966984e-07             -5.414780e-07
#> cov(beta[2,2],beta[2,2])              5.035958e-05              3.759803e-07
#> cov(mu[1,1],mu[1,1])                 -3.687812e-05             -1.430224e-05
#> cov(mu[2,1],mu[1,1])                 -5.504178e-05             -1.222783e-05
#> cov(mu[2,1],mu[2,1])                 -1.229521e-05             -8.895939e-06
#>                           cov(beta[2,1],beta[2,1]) cov(beta[1,2],beta[1,1])
#> psi[1,1]                              3.364204e-06             1.161643e-07
#> psi[2,1]                             -2.722231e-05             8.649918e-08
#> psi[2,2]                             -1.048814e-05            -3.498848e-07
#> mean(beta[1,1])                      -1.346985e-05             3.685721e-06
#> mean(beta[2,1])                       3.198884e-06             2.415051e-06
#> mean(beta[1,2])                       1.996567e-06            -2.226097e-06
#> mean(beta[2,2])                      -1.143630e-05            -1.133379e-06
#> mean(mu[1,1])                         2.683282e-06            -2.386888e-06
#> mean(mu[2,1])                        -2.109085e-06            -5.052750e-07
#> cov(beta[1,1],beta[1,1])              5.313868e-05            -6.571431e-06
#> cov(beta[2,1], beta[1,1])             7.114663e-06            -1.440628e-06
#> cov(beta[2,1],beta[2,1])              6.243564e-05            -3.255074e-07
#> cov(beta[1,2],beta[1,1])             -3.255074e-07             1.186078e-05
#> cov(beta[1,2],beta[2,1])              1.703313e-07             2.544106e-06
#> cov(beta[1,2],beta[1,2])              4.954902e-05            -2.132586e-06
#> cov(beta[2,2],beta[1,1])              1.143474e-06             6.930850e-06
#> cov(beta[2,2],beta[2,1])              3.830264e-06             1.676279e-06
#> cov(beta[2,2],beta[1,2])             -2.199214e-07             9.309473e-07
#> cov(beta[2,2],beta[2,2])              4.856089e-05             1.579419e-06
#> cov(mu[1,1],mu[1,1])                 -9.893714e-06            -7.348436e-06
#> cov(mu[2,1],mu[1,1])                 -3.737067e-05            -1.541584e-07
#> cov(mu[2,1],mu[2,1])                  2.305676e-06            -3.901024e-06
#>                           cov(beta[1,2],beta[2,1]) cov(beta[1,2],beta[1,2])
#> psi[1,1]                             -1.846741e-07             1.227550e-06
#> psi[2,1]                             -1.871570e-08            -2.712595e-05
#> psi[2,2]                              3.919626e-07            -8.823666e-06
#> mean(beta[1,1])                       3.697831e-07            -1.319604e-05
#> mean(beta[2,1])                       1.038032e-07             3.162266e-06
#> mean(beta[1,2])                      -7.830874e-07             2.356954e-06
#> mean(beta[2,2])                      -1.420028e-07            -1.102504e-05
#> mean(mu[1,1])                         3.817362e-08            -7.590026e-07
#> mean(mu[2,1])                         7.479047e-07             1.725872e-06
#> cov(beta[1,1],beta[1,1])             -1.467187e-06             4.964798e-05
#> cov(beta[2,1], beta[1,1])            -1.044539e-06            -3.018670e-07
#> cov(beta[2,1],beta[2,1])              1.703313e-07             4.954902e-05
#> cov(beta[1,2],beta[1,1])              2.544106e-06            -2.132586e-06
#> cov(beta[1,2],beta[2,1])              5.120863e-06             1.628545e-07
#> cov(beta[1,2],beta[1,2])              1.628545e-07             5.761185e-05
#> cov(beta[2,2],beta[1,1])              1.448678e-06            -1.744717e-06
#> cov(beta[2,2],beta[2,1])              3.829347e-06            -2.941573e-07
#> cov(beta[2,2],beta[1,2])              1.117264e-06             5.272172e-06
#> cov(beta[2,2],beta[2,2])              7.643677e-07             5.286779e-05
#> cov(mu[1,1],mu[1,1])                  6.049960e-07            -5.313657e-06
#> cov(mu[2,1],mu[1,1])                 -2.960783e-06            -3.764516e-05
#> cov(mu[2,1],mu[2,1])                 -3.703778e-06             4.311969e-06
#>                           cov(beta[2,2],beta[1,1]) cov(beta[2,2],beta[2,1])
#> psi[1,1]                             -5.569296e-07            -4.145449e-07
#> psi[2,1]                              4.304338e-07            -3.203127e-07
#> psi[2,2]                              6.022697e-07            -6.223756e-07
#> mean(beta[1,1])                       1.582580e-06             2.220445e-07
#> mean(beta[2,1])                       2.815446e-06            -2.131502e-06
#> mean(beta[1,2])                      -6.726504e-07            -9.046385e-07
#> mean(beta[2,2])                      -2.086516e-06            -3.134106e-08
#> mean(mu[1,1])                         3.637660e-06            -1.749743e-07
#> mean(mu[2,1])                        -6.012077e-06            -6.176165e-07
#> cov(beta[1,1],beta[1,1])              8.001503e-06             2.231432e-06
#> cov(beta[2,1], beta[1,1])             3.087867e-06             3.409565e-06
#> cov(beta[2,1],beta[2,1])              1.143474e-06             3.830264e-06
#> cov(beta[1,2],beta[1,1])              6.930850e-06             1.676279e-06
#> cov(beta[1,2],beta[2,1])              1.448678e-06             3.829347e-06
#> cov(beta[1,2],beta[1,2])             -1.744717e-06            -2.941573e-07
#> cov(beta[2,2],beta[1,1])              4.212312e-05             1.091578e-05
#> cov(beta[2,2],beta[2,1])              1.091578e-05             2.236820e-05
#> cov(beta[2,2],beta[1,2])             -3.878727e-06             2.037098e-07
#> cov(beta[2,2],beta[2,2])              1.094186e-05             4.134958e-06
#> cov(mu[1,1],mu[1,1])                 -1.960586e-05            -2.412119e-06
#> cov(mu[2,1],mu[1,1])                 -1.278231e-06            -7.470814e-06
#> cov(mu[2,1],mu[2,1])                  5.924230e-07             3.013606e-06
#>                           cov(beta[2,2],beta[1,2]) cov(beta[2,2],beta[2,2])
#> psi[1,1]                             -1.086456e-06             2.315990e-06
#> psi[2,1]                             -2.257210e-06            -2.618952e-05
#> psi[2,2]                             -1.565375e-06            -1.446179e-05
#> mean(beta[1,1])                       4.514591e-07            -1.113504e-05
#> mean(beta[2,1])                       1.360075e-07             7.066334e-06
#> mean(beta[1,2])                      -1.074958e-06             1.494108e-06
#> mean(beta[2,2])                      -5.211385e-07            -1.693606e-05
#> mean(mu[1,1])                        -1.680932e-06             3.881368e-06
#> mean(mu[2,1])                        -1.770680e-06            -8.339683e-06
#> cov(beta[1,1],beta[1,1])             -8.966984e-07             5.035958e-05
#> cov(beta[2,1], beta[1,1])            -5.414780e-07             3.759803e-07
#> cov(beta[2,1],beta[2,1])             -2.199214e-07             4.856089e-05
#> cov(beta[1,2],beta[1,1])              9.309473e-07             1.579419e-06
#> cov(beta[1,2],beta[2,1])              1.117264e-06             7.643677e-07
#> cov(beta[1,2],beta[1,2])              5.272172e-06             5.286779e-05
#> cov(beta[2,2],beta[1,1])             -3.878727e-06             1.094186e-05
#> cov(beta[2,2],beta[2,1])              2.037098e-07             4.134958e-06
#> cov(beta[2,2],beta[1,2])              1.853111e-05             2.106650e-05
#> cov(beta[2,2],beta[2,2])              2.106650e-05             1.629356e-04
#> cov(mu[1,1],mu[1,1])                  1.103148e-05            -4.009200e-06
#> cov(mu[2,1],mu[1,1])                  1.720529e-06            -2.974262e-05
#> cov(mu[2,1],mu[2,1])                 -3.506650e-06             1.819065e-06
#>                           cov(mu[1,1],mu[1,1]) cov(mu[2,1],mu[1,1])
#> psi[1,1]                          3.905377e-06         2.054062e-05
#> psi[2,1]                         -6.681851e-05        -2.034808e-05
#> psi[2,2]                         -6.497403e-05        -2.676026e-05
#> mean(beta[1,1])                  -1.077318e-04        -5.177934e-06
#> mean(beta[2,1])                  -9.297186e-05        -3.120119e-05
#> mean(beta[1,2])                  -2.239178e-06        -1.277208e-05
#> mean(beta[2,2])                  -5.737096e-05        -4.543712e-05
#> mean(mu[1,1])                    -3.596270e-04        -2.267448e-04
#> mean(mu[2,1])                    -7.645134e-05         7.815435e-05
#> cov(beta[1,1],beta[1,1])         -3.687812e-05        -5.504178e-05
#> cov(beta[2,1], beta[1,1])        -1.430224e-05        -1.222783e-05
#> cov(beta[2,1],beta[2,1])         -9.893714e-06        -3.737067e-05
#> cov(beta[1,2],beta[1,1])         -7.348436e-06        -1.541584e-07
#> cov(beta[1,2],beta[2,1])          6.049960e-07        -2.960783e-06
#> cov(beta[1,2],beta[1,2])         -5.313657e-06        -3.764516e-05
#> cov(beta[2,2],beta[1,1])         -1.960586e-05        -1.278231e-06
#> cov(beta[2,2],beta[2,1])         -2.412119e-06        -7.470814e-06
#> cov(beta[2,2],beta[1,2])          1.103148e-05         1.720529e-06
#> cov(beta[2,2],beta[2,2])         -4.009200e-06        -2.974262e-05
#> cov(mu[1,1],mu[1,1])              1.159775e-01         5.305228e-02
#> cov(mu[2,1],mu[1,1])              5.305228e-02         5.824661e-02
#> cov(mu[2,1],mu[2,1])              2.565849e-02         4.262378e-02
#>                           cov(mu[2,1],mu[2,1])
#> psi[1,1]                          3.301370e-05
#> psi[2,1]                          1.913473e-05
#> psi[2,2]                          1.205315e-06
#> mean(beta[1,1])                  -2.933345e-05
#> mean(beta[2,1])                  -7.198650e-06
#> mean(beta[1,2])                  -2.020579e-05
#> mean(beta[2,2])                  -7.954162e-05
#> mean(mu[1,1])                    -4.350626e-04
#> mean(mu[2,1])                    -4.951454e-05
#> cov(beta[1,1],beta[1,1])         -1.229521e-05
#> cov(beta[2,1], beta[1,1])        -8.895939e-06
#> cov(beta[2,1],beta[2,1])          2.305676e-06
#> cov(beta[1,2],beta[1,1])         -3.901024e-06
#> cov(beta[1,2],beta[2,1])         -3.703778e-06
#> cov(beta[1,2],beta[1,2])          4.311969e-06
#> cov(beta[2,2],beta[1,1])          5.924230e-07
#> cov(beta[2,2],beta[2,1])          3.013606e-06
#> cov(beta[2,2],beta[1,2])         -3.506650e-06
#> cov(beta[2,2],beta[2,2])          1.819065e-06
#> cov(mu[1,1],mu[1,1])              2.565849e-02
#> cov(mu[2,1],mu[1,1])              4.262378e-02
#> cov(mu[2,1],mu[2,1])              7.538556e-02
```

### Posterior Distributions

``` r

plot(mplus, what = "posterior")
```

![](fig-vignettes-sim-rep-unnamed-chunk-18-1.png)![](fig-vignettes-sim-rep-unnamed-chunk-18-2.png)![](fig-vignettes-sim-rep-unnamed-chunk-18-3.png)![](fig-vignettes-sim-rep-unnamed-chunk-18-4.png)![](fig-vignettes-sim-rep-unnamed-chunk-18-5.png)![](fig-vignettes-sim-rep-unnamed-chunk-18-6.png)![](fig-vignettes-sim-rep-unnamed-chunk-18-7.png)![](fig-vignettes-sim-rep-unnamed-chunk-18-8.png)![](fig-vignettes-sim-rep-unnamed-chunk-18-9.png)![](fig-vignettes-sim-rep-unnamed-chunk-18-10.png)![](fig-vignettes-sim-rep-unnamed-chunk-18-11.png)![](fig-vignettes-sim-rep-unnamed-chunk-18-12.png)![](fig-vignettes-sim-rep-unnamed-chunk-18-13.png)![](fig-vignettes-sim-rep-unnamed-chunk-18-14.png)![](fig-vignettes-sim-rep-unnamed-chunk-18-15.png)![](fig-vignettes-sim-rep-unnamed-chunk-18-16.png)![](fig-vignettes-sim-rep-unnamed-chunk-18-17.png)![](fig-vignettes-sim-rep-unnamed-chunk-18-18.png)![](fig-vignettes-sim-rep-unnamed-chunk-18-19.png)![](fig-vignettes-sim-rep-unnamed-chunk-18-20.png)![](fig-vignettes-sim-rep-unnamed-chunk-18-21.png)![](fig-vignettes-sim-rep-unnamed-chunk-18-22.png)

### Trace Plots

``` r

plot(mplus, what = "trace")
```

![](fig-vignettes-sim-rep-unnamed-chunk-19-1.png)![](fig-vignettes-sim-rep-unnamed-chunk-19-2.png)![](fig-vignettes-sim-rep-unnamed-chunk-19-3.png)![](fig-vignettes-sim-rep-unnamed-chunk-19-4.png)![](fig-vignettes-sim-rep-unnamed-chunk-19-5.png)![](fig-vignettes-sim-rep-unnamed-chunk-19-6.png)![](fig-vignettes-sim-rep-unnamed-chunk-19-7.png)![](fig-vignettes-sim-rep-unnamed-chunk-19-8.png)![](fig-vignettes-sim-rep-unnamed-chunk-19-9.png)![](fig-vignettes-sim-rep-unnamed-chunk-19-10.png)![](fig-vignettes-sim-rep-unnamed-chunk-19-11.png)![](fig-vignettes-sim-rep-unnamed-chunk-19-12.png)![](fig-vignettes-sim-rep-unnamed-chunk-19-13.png)![](fig-vignettes-sim-rep-unnamed-chunk-19-14.png)![](fig-vignettes-sim-rep-unnamed-chunk-19-15.png)![](fig-vignettes-sim-rep-unnamed-chunk-19-16.png)![](fig-vignettes-sim-rep-unnamed-chunk-19-17.png)![](fig-vignettes-sim-rep-unnamed-chunk-19-18.png)![](fig-vignettes-sim-rep-unnamed-chunk-19-19.png)![](fig-vignettes-sim-rep-unnamed-chunk-19-20.png)![](fig-vignettes-sim-rep-unnamed-chunk-19-21.png)![](fig-vignettes-sim-rep-unnamed-chunk-19-22.png)

### Mplus Output

    Mplus VERSION 9 (Linux)
    MUTHEN & MUTHEN
    02/24/2026   6:16 AM

    INPUT INSTRUCTIONS

          TITLE:
            Multilevel Vector Autoregressive Model
          DATA:
            FILE = mplus_cOyAJKESetHBNc5GPxDQ_data.dat;
          VARIABLE:
            NAMES = ID TIME Y1 Y2;
            USEVARIABLES = Y1 Y2;
            CLUSTER = ID;
            LAGGED = Y1(1) Y2(1);
          ANALYSIS:
            TYPE = TWOLEVEL RANDOM;
            ESTIMATOR = BAYES;
            CHAINS = 2;
            FBITER = (20000);
            PROCESSORS = 1;
            BSEED = 42;
          MODEL:
            %WITHIN%
              ! transition matrix (beta)
              BETA11 | Y1 ON Y1&1;
              BETA21 | Y2 ON Y1&1;
              BETA12 | Y1 ON Y2&1;
              BETA22 | Y2 ON Y2&1;
              ! process noise covariance matrix (psi)
              Y1;
              Y2 WITH Y1;
              Y2;
            %BETWEEN%
              ! person-specific means (mu)
              [Y1];
              [Y2];
              Y1;
              Y2 WITH Y1;
              Y2;
              ! person-specific lagged effects (beta)
              [BETA11];
              [BETA21];
              [BETA12];
              [BETA22];
              BETA11;
              BETA21 WITH BETA11;
              BETA12 WITH BETA11;
              BETA22 WITH BETA11;
              BETA21;
              BETA12 WITH BETA21;
              BETA22 WITH BETA21;
              BETA12;
              BETA22 WITH BETA12;
              BETA22;
          OUTPUT:
            TECH1 TECH8;
          SAVEDATA:
            BPARAMETERS = mplus_cOyAJKESetHBNc5GPxDQ_posterior.dat;



    INPUT READING TERMINATED NORMALLY




    Multilevel Vector Autoregressive Model

    SUMMARY OF ANALYSIS

    Number of groups                                                 1
    Number of observations                                        5000

    Number of dependent variables                                    2
    Number of independent variables                                  2
    Number of continuous latent variables                            4

    Observed dependent variables

      Continuous
       Y1          Y2

    Observed independent variables
       Y1&1        Y2&1

    Continuous latent variables
       BETA11      BETA21      BETA12      BETA22

    Variables with special functions

      Cluster variable      ID

      Within variables
       Y1&1        Y2&1


    Estimator                                                    BAYES
    Specifications for Bayesian Estimation
      Point estimate                                            MEDIAN
      Number of Markov chain Monte Carlo (MCMC) chains               2
      Random seed for the first chain                               42
      Starting value information                           UNPERTURBED
      Algorithm used for Markov chain Monte Carlo           GIBBS(PX1)
      Fixed number of iterations                                 20000
      K-th iteration used for thinning                               1

    Input data file(s)
      mplus_cOyAJKESetHBNc5GPxDQ_data.dat
    Input data format  FREE


    SUMMARY OF DATA

         Number of clusters                         50

           Size (s)    Cluster ID with Size s

            100        1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21
                       22 23 24 25 26 27 28 29 30 31 32 33 34 35 36 37 38 39
                       40 41 42 43 44 45 46 47 48 49 50



    COVARIANCE COVERAGE OF DATA

    Minimum covariance coverage value   0.100

         Number of missing data patterns             2

         PROPORTION OF DATA PRESENT

               Covariance Coverage
                  Y1            Y2
                  ________      ________
     Y1             1.000
     Y2             1.000         1.000



    UNIVARIATE SAMPLE STATISTICS

         UNIVARIATE HIGHER-ORDER MOMENT DESCRIPTIVE STATISTICS

             Variable/         Mean/     Skewness/   Minimum/ % with                Percentiles
            Sample Size      Variance    Kurtosis    Maximum  Min/Max      20%/60%    40%/80%    Median

         Y1                    2.932      -0.029      -2.768    0.02%       1.550      2.521      2.923
                5000.000       2.705      -0.165       9.307    0.02%       3.335      4.344
         Y2                    2.384       0.014      -3.683    0.02%       0.996      1.980      2.394
                5000.000       2.711       0.071       9.314    0.02%       2.778      3.797


    THE MODEL ESTIMATION TERMINATED NORMALLY

         USE THE FBITERATIONS OPTION TO INCREASE THE NUMBER OF ITERATIONS BY A FACTOR
         OF AT LEAST TWO TO CHECK CONVERGENCE AND THAT THE PSR VALUE DOES NOT INCREASE.



    MODEL FIT INFORMATION

    Number of Free Parameters                              22

    Information Criteria

              Deviance (DIC)                        31200.338
              Estimated Number of Parameters (pD)     216.449



    MODEL RESULTS

                                    Posterior  One-Tailed         95% C.I.
                        Estimate       S.D.      P-Value   Lower 2.5%  Upper 2.5%  Significance

    Within Level

     Y2       WITH
        Y1                 0.525       0.022      0.000       0.484       0.569      *

     Residual Variances
        Y1                 1.283       0.026      0.000       1.233       1.335      *
        Y2                 1.530       0.031      0.000       1.470       1.593      *

    Between Level

     BETA21   WITH
        BETA11             0.004       0.004      0.101      -0.002       0.014
        BETA12             0.001       0.002      0.388      -0.004       0.005
        BETA22             0.005       0.005      0.111      -0.004       0.015

     BETA12   WITH
        BETA11            -0.001       0.003      0.424      -0.008       0.006
        BETA22             0.005       0.004      0.094      -0.002       0.015

     BETA22   WITH
        BETA11             0.005       0.006      0.174      -0.007       0.019

     Y2       WITH
        Y1                 0.671       0.240      0.000       0.303       1.240      *

     Means
        Y1                 2.934       0.177      0.000       2.584       3.279      *
        Y2                 2.382       0.157      0.000       2.076       2.693      *
        BETA11             0.257       0.026      0.000       0.205       0.309      *
        BETA21            -0.087       0.020      0.000      -0.126      -0.048      *
        BETA12            -0.047       0.017      0.004      -0.081      -0.014      *
        BETA22             0.225       0.031      0.000       0.164       0.285      *

     Variances
        Y1                 1.480       0.340      0.000       0.995       2.315      *
        Y2                 1.176       0.275      0.000       0.792       1.854      *
        BETA11             0.022       0.008      0.000       0.011       0.042      *
        BETA21             0.006       0.004      0.000       0.002       0.015      *
        BETA12             0.005       0.003      0.000       0.001       0.012      *
        BETA22             0.034       0.011      0.000       0.019       0.061      *


    TECHNICAL 1 OUTPUT

         PARAMETER SPECIFICATION FOR WITHIN

               NU
                  Y1            Y2            Y1&1          Y2&1
                  ________      ________      ________      ________
                        0             0             0             0

               LAMBDA
                  Y1            Y2            Y1&1          Y2&1
                  ________      ________      ________      ________
     Y1                 0             0             0             0
     Y2                 0             0             0             0
     Y1&1               0             0             0             0
     Y2&1               0             0             0             0

               THETA
                  Y1            Y2            Y1&1          Y2&1
                  ________      ________      ________      ________
     Y1                 0
     Y2                 0             0
     Y1&1               0             0             0
     Y2&1               0             0             0             0

               ALPHA
                  Y1            Y2            Y1&1          Y2&1
                  ________      ________      ________      ________
                        0             0             0             0

               BETA
                  Y1            Y2            Y1&1          Y2&1
                  ________      ________      ________      ________
     Y1                 0             0             0             0
     Y2                 0             0             0             0
     Y1&1               0             0             0             0
     Y2&1               0             0             0             0

               PSI
                  Y1            Y2            Y1&1          Y2&1
                  ________      ________      ________      ________
     Y1                 1
     Y2                 2             3
     Y1&1               0             0             0
     Y2&1               0             0             0             0

         PARAMETER SPECIFICATION FOR BETWEEN

               NU
                  Y1            Y2
                  ________      ________
                        0             0

               LAMBDA
                  BETA11        BETA21        BETA12        BETA22        Y1
                  ________      ________      ________      ________      ________
     Y1                 0             0             0             0             0
     Y2                 0             0             0             0             0

               LAMBDA
                  Y2
                  ________
     Y1                 0
     Y2                 0

               THETA
                  Y1            Y2
                  ________      ________
     Y1                 0
     Y2                 0             0

               ALPHA
                  BETA11        BETA21        BETA12        BETA22        Y1
                  ________      ________      ________      ________      ________
                        4             5             6             7             8

               ALPHA
                  Y2
                  ________
                        9

               BETA
                  BETA11        BETA21        BETA12        BETA22        Y1
                  ________      ________      ________      ________      ________
     BETA11             0             0             0             0             0
     BETA21             0             0             0             0             0
     BETA12             0             0             0             0             0
     BETA22             0             0             0             0             0
     Y1                 0             0             0             0             0
     Y2                 0             0             0             0             0

               BETA
                  Y2
                  ________
     BETA11             0
     BETA21             0
     BETA12             0
     BETA22             0
     Y1                 0
     Y2                 0

               PSI
                  BETA11        BETA21        BETA12        BETA22        Y1
                  ________      ________      ________      ________      ________
     BETA11            10
     BETA21            11            12
     BETA12            13            14            15
     BETA22            16            17            18            19
     Y1                 0             0             0             0            20
     Y2                 0             0             0             0            21

               PSI
                  Y2
                  ________
     Y2                22

         STARTING VALUES FOR WITHIN

               NU
                  Y1            Y2            Y1&1          Y2&1
                  ________      ________      ________      ________
                    0.000         0.000         0.000         0.000

               LAMBDA
                  Y1            Y2            Y1&1          Y2&1
                  ________      ________      ________      ________
     Y1             1.000         0.000         0.000         0.000
     Y2             0.000         1.000         0.000         0.000
     Y1&1           0.000         0.000         1.000         0.000
     Y2&1           0.000         0.000         0.000         1.000

               THETA
                  Y1            Y2            Y1&1          Y2&1
                  ________      ________      ________      ________
     Y1             0.000
     Y2             0.000         0.000
     Y1&1           0.000         0.000         0.000
     Y2&1           0.000         0.000         0.000         0.000

               ALPHA
                  Y1            Y2            Y1&1          Y2&1
                  ________      ________      ________      ________
                    0.000         0.000         0.000         0.000

               BETA
                  Y1            Y2            Y1&1          Y2&1
                  ________      ________      ________      ________
     Y1             0.000         0.000         0.000         0.000
     Y2             0.000         0.000         0.000         0.000
     Y1&1           0.000         0.000         0.000         0.000
     Y2&1           0.000         0.000         0.000         0.000

               PSI
                  Y1            Y2            Y1&1          Y2&1
                  ________      ________      ________      ________
     Y1             1.353
     Y2             0.000         1.355
     Y1&1           0.000         0.000         1.352
     Y2&1           0.000         0.000         0.000         1.353

         STARTING VALUES FOR BETWEEN

               NU
                  Y1            Y2
                  ________      ________
                    0.000         0.000

               LAMBDA
                  BETA11        BETA21        BETA12        BETA22        Y1
                  ________      ________      ________      ________      ________
     Y1             0.000         0.000         0.000         0.000         1.000
     Y2             0.000         0.000         0.000         0.000         0.000

               LAMBDA
                  Y2
                  ________
     Y1             0.000
     Y2             1.000

               THETA
                  Y1            Y2
                  ________      ________
     Y1             0.000
     Y2             0.000         0.000

               ALPHA
                  BETA11        BETA21        BETA12        BETA22        Y1
                  ________      ________      ________      ________      ________
                    0.000         0.000         0.000         0.000         2.932

               ALPHA
                  Y2
                  ________
                    2.384

               BETA
                  BETA11        BETA21        BETA12        BETA22        Y1
                  ________      ________      ________      ________      ________
     BETA11         0.000         0.000         0.000         0.000         0.000
     BETA21         0.000         0.000         0.000         0.000         0.000
     BETA12         0.000         0.000         0.000         0.000         0.000
     BETA22         0.000         0.000         0.000         0.000         0.000
     Y1             0.000         0.000         0.000         0.000         0.000
     Y2             0.000         0.000         0.000         0.000         0.000

               BETA
                  Y2
                  ________
     BETA11         0.000
     BETA21         0.000
     BETA12         0.000
     BETA22         0.000
     Y1             0.000
     Y2             0.000

               PSI
                  BETA11        BETA21        BETA12        BETA22        Y1
                  ________      ________      ________      ________      ________
     BETA11         1.000
     BETA21         0.000         1.000
     BETA12         0.000         0.000         1.000
     BETA22         0.000         0.000         0.000         1.000
     Y1             0.000         0.000         0.000         0.000         1.353
     Y2             0.000         0.000         0.000         0.000         0.000

               PSI
                  Y2
                  ________
     Y2             1.355

         PRIORS FOR ALL PARAMETERS            PRIOR MEAN      PRIOR VARIANCE     PRIOR STD. DEV.

         Parameter 1~IW(0.000,-3)              infinity            infinity            infinity
         Parameter 2~IW(0.000,-3)              infinity            infinity            infinity
         Parameter 3~IW(0.000,-3)              infinity            infinity            infinity
         Parameter 4~N(0.000,infinity)           0.0000            infinity            infinity
         Parameter 5~N(0.000,infinity)           0.0000            infinity            infinity
         Parameter 6~N(0.000,infinity)           0.0000            infinity            infinity
         Parameter 7~N(0.000,infinity)           0.0000            infinity            infinity
         Parameter 8~N(0.000,infinity)           0.0000            infinity            infinity
         Parameter 9~N(0.000,infinity)           0.0000            infinity            infinity
         Parameter 10~IW(0.000,-5)             infinity            infinity            infinity
         Parameter 11~IW(0.000,-5)             infinity            infinity            infinity
         Parameter 12~IW(0.000,-5)             infinity            infinity            infinity
         Parameter 13~IW(0.000,-5)             infinity            infinity            infinity
         Parameter 14~IW(0.000,-5)             infinity            infinity            infinity
         Parameter 15~IW(0.000,-5)             infinity            infinity            infinity
         Parameter 16~IW(0.000,-5)             infinity            infinity            infinity
         Parameter 17~IW(0.000,-5)             infinity            infinity            infinity
         Parameter 18~IW(0.000,-5)             infinity            infinity            infinity
         Parameter 19~IW(0.000,-5)             infinity            infinity            infinity
         Parameter 20~IW(0.000,-3)             infinity            infinity            infinity
         Parameter 21~IW(0.000,-3)             infinity            infinity            infinity
         Parameter 22~IW(0.000,-3)             infinity            infinity            infinity


    TECHNICAL 8 OUTPUT


       TECHNICAL 8 OUTPUT FOR BAYES ESTIMATION

         CHAIN    BSEED
         1        42
         2        564124

                         POTENTIAL       PARAMETER WITH
         ITERATION    SCALE REDUCTION      HIGHEST PSR
         100              1.428               5
         200              1.097               6
         300              1.014               12
         400              1.023               6
         500              1.032               6
         600              1.043               6
         700              1.057               6
         800              1.031               6
         900              1.022               19
         1000             1.018               19
         1100             1.012               7
         1200             1.009               19
         1300             1.011               18
         1400             1.007               18
         1500             1.005               19
         1600             1.008               19
         1700             1.003               11
         1800             1.007               7
         1900             1.004               7
         2000             1.004               5
         2100             1.004               7
         2200             1.013               5
         2300             1.015               5
         2400             1.021               5
         2500             1.027               5
         2600             1.030               5
         2700             1.027               5
         2800             1.027               5
         2900             1.027               5
         3000             1.024               5
         3100             1.023               5
         3200             1.025               5
         3300             1.016               5
         3400             1.017               5
         3500             1.011               5
         3600             1.006               12
         3700             1.007               12
         3800             1.007               12
         3900             1.005               12
         4000             1.004               12
         4100             1.004               12
         4200             1.003               12
         4300             1.004               12
         4400             1.003               12
         4500             1.002               12
         4600             1.002               12
         4700             1.001               4
         4800             1.002               4
         4900             1.002               4
         5000             1.003               4
         5100             1.004               4
         5200             1.003               4
         5300             1.002               4
         5400             1.001               4
         5500             1.002               4
         5600             1.001               4
         5700             1.001               4
         5800             1.002               4
         5900             1.002               4
         6000             1.002               4
         6100             1.002               4
         6200             1.002               6
         6300             1.002               10
         6400             1.001               10
         6500             1.002               10
         6600             1.001               10
         6700             1.002               6
         6800             1.004               5
         6900             1.004               5
         7000             1.003               6
         7100             1.004               6
         7200             1.004               6
         7300             1.003               5
         7400             1.003               5
         7500             1.002               6
         7600             1.002               6
         7700             1.003               6
         7800             1.004               6
         7900             1.005               6
         8000             1.005               6
         8100             1.005               6
         8200             1.006               6
         8300             1.006               5
         8400             1.007               6
         8500             1.008               6
         8600             1.006               6
         8700             1.005               6
         8800             1.005               6
         8900             1.006               5
         9000             1.008               5
         9100             1.008               5
         9200             1.009               5
         9300             1.011               5
         9400             1.010               5
         9500             1.009               5
         9600             1.008               5
         9700             1.007               5
         9800             1.007               5
         9900             1.006               5
         10000            1.006               5
         10100            1.006               5
         10200            1.005               6
         10300            1.006               5
         10400            1.004               5
         10500            1.005               5
         10600            1.005               5
         10700            1.004               5
         10800            1.004               5
         10900            1.004               5
         11000            1.005               5
         11100            1.005               5
         11200            1.005               5
         11300            1.006               5
         11400            1.004               5
         11500            1.003               5
         11600            1.004               5
         11700            1.003               5
         11800            1.003               5
         11900            1.002               5
         12000            1.002               5
         12100            1.002               5
         12200            1.002               5
         12300            1.002               5
         12400            1.002               5
         12500            1.002               5
         12600            1.002               5
         12700            1.002               5
         12800            1.002               5
         12900            1.002               5
         13000            1.002               5
         13100            1.002               5
         13200            1.001               5
         13300            1.001               19
         13400            1.001               19
         13500            1.001               19
         13600            1.000               19
         13700            1.000               19
         13800            1.000               19
         13900            1.000               19
         14000            1.000               19
         14100            1.000               6
         14200            1.001               5
         14300            1.000               5
         14400            1.000               5
         14500            1.000               5
         14600            1.000               5
         14700            1.001               5
         14800            1.001               5
         14900            1.000               5
         15000            1.000               10
         15100            1.000               18
         15200            1.000               18
         15300            1.000               18
         15400            1.000               18
         15500            1.000               18
         15600            1.000               18
         15700            1.000               6
         15800            1.000               6
         15900            1.001               6
         16000            1.001               6
         16100            1.001               6
         16200            1.001               6
         16300            1.001               6
         16400            1.001               6
         16500            1.001               6
         16600            1.001               6
         16700            1.001               6
         16800            1.001               6
         16900            1.001               6
         17000            1.001               6
         17100            1.001               6
         17200            1.001               6
         17300            1.001               6
         17400            1.000               6
         17500            1.000               6
         17600            1.001               6
         17700            1.000               6
         17800            1.000               6
         17900            1.000               6
         18000            1.000               6
         18100            1.000               6
         18200            1.001               6
         18300            1.000               6
         18400            1.000               6
         18500            1.000               6
         18600            1.000               6
         18700            1.000               6
         18800            1.000               5
         18900            1.000               10
         19000            1.000               7
         19100            1.000               7
         19200            1.000               5
         19300            1.000               7
         19400            1.000               5
         19500            1.000               5
         19600            1.000               5
         19700            1.000               5
         19800            1.000               5
         19900            1.000               5
         20000            1.000               5

         MCMC EFFECTIVE SAMPLE SIZE (ESS) IN ASCENDING ORDER
            LOWEST 10 PARAMETERS
            PARAMETER    ESS
                14       554
                12       963
                 5      1162
                11      1284
                15      1286
                17      1360
                13      1615
                18      2360
                 6      2473
                10      4177


    SAVEDATA INFORMATION


      Bayesian Parameters

      Save file
        mplus_cOyAJKESetHBNc5GPxDQ_posterior.dat
      Save format      Free

      Order of parameters saved

        Chain number
        Iteration number
        Parameter 1, %WITHIN%: Y1
        Parameter 2, %WITHIN%: Y2 WITH Y1
        Parameter 3, %WITHIN%: Y2
        Parameter 4, %BETWEEN%: [ BETA11 ]
        Parameter 5, %BETWEEN%: [ BETA21 ]
        Parameter 6, %BETWEEN%: [ BETA12 ]
        Parameter 7, %BETWEEN%: [ BETA22 ]
        Parameter 8, %BETWEEN%: [ Y1 ]
        Parameter 9, %BETWEEN%: [ Y2 ]
        Parameter 10, %BETWEEN%: BETA11
        Parameter 11, %BETWEEN%: BETA21 WITH BETA11
        Parameter 12, %BETWEEN%: BETA21
        Parameter 13, %BETWEEN%: BETA12 WITH BETA11
        Parameter 14, %BETWEEN%: BETA12 WITH BETA21
        Parameter 15, %BETWEEN%: BETA12
        Parameter 16, %BETWEEN%: BETA22 WITH BETA11
        Parameter 17, %BETWEEN%: BETA22 WITH BETA21
        Parameter 18, %BETWEEN%: BETA22 WITH BETA12
        Parameter 19, %BETWEEN%: BETA22
        Parameter 20, %BETWEEN%: Y1
        Parameter 21, %BETWEEN%: Y2 WITH Y1
        Parameter 22, %BETWEEN%: Y2

         Beginning Time:  06:16:08
            Ending Time:  06:19:53
           Elapsed Time:  00:03:45



    MUTHEN & MUTHEN
    3463 Stoner Ave.
    Los Angeles, CA  90066

    Tel: (310) 391-9971
    Fax: (310) 391-8971
    Web: www.StatModel.com
    Support: Support@StatModel.com

    Copyright (c) 1998-2025 Muthen & Muthen
