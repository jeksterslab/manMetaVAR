# Empirical Illustration: Meta-Analysis of Daily Affect Dynamics

## Stage 1: Person-Specific VAR

``` r

library(OpenMx)
library(fitVARMxID)
stage1 <- FitVARMxID(
  data = data,
  observed = c("na", "pa"),
  id = "id",
  center = TRUE,
  ncores = parallel::detectCores()
)
```

``` r

summary(stage1, means = TRUE)
#>    Length     Class      Mode 
#>         1 character character
```

## Stage 2: Multivariate Random-Effects Meta-Analysis of the Dynamic Parameter System

``` r

library(metaDyn)
stage2 <- MetaVARMx(
  object = stage1,
  random = TRUE,
  ncores = parallel::detectCores()
)
```

``` r

summary(stage2)
#>    Length     Class      Mode 
#>         1 character character
```
