# Simulate Four-Variable Data

The function simulates data for the four-variable feasibility analysis
using
[`simStateSpace::SimSSMVARIVary()`](https://github.com/jeksterslab/simStateSpace/reference/SimSSMVARIVary.html).
The simulation condition is obtained from `taskid`, whereas the
population model parameters are obtained from `modelk4`.

## Usage

``` r
GenDataK4(taskid, seed = NULL)
```

## Arguments

- taskid:

  Positive integer. Task ID.

- seed:

  Integer. Random seed.

## See also

Other Data Generation Functions:
[`GenData()`](https://github.com/jeksterslab/manMetaVAR/reference/GenData.md)

## Examples

``` r
if (FALSE) { # \dontrun{
seed <- 42
data <- GenDataK4(taskid = 1, seed = seed)
print(data)
summary(data)
plot(data)
} # }
```
