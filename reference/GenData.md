# Simulate Data

The function simulates data using the
[`simStateSpace::SimSSMIVary()`](https://github.com/jeksterslab/simStateSpace/reference/SimSSMIVary.html)
function.

## Usage

``` r
GenData(taskid, seed = NULL)
```

## Arguments

- taskid:

  Positive integer. Task ID.

- seed:

  Integer. Random seed.

## See also

Other Data Generation Functions:
[`GenDataK4()`](https://github.com/jeksterslab/manMetaVAR/reference/GenDataK4.md)

## Examples

``` r
if (FALSE) { # \dontrun{
seed <- 42
data <- GenData(taskid = 1, seed = seed)
print(data)
summary(data)
plot(data)
} # }
```
