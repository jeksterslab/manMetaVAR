# manMetaVAR

Ivan Jacob Agaloos Pesigan 2026-03-25

## Description

Research compendium for the manuscript Pesigan, I. J. A., et al. (In
Preparation). From Person-Specific Dynamics to Population Inference: A
Meta-Analytic Structural Equation Modeling Framework for Multilevel
Dynamic Models. <https://doi.org/10.0000/0000000000>

## Acknowledgments

This research was made possible by the Prevention and Methodology
Training Program (PAMT) funded by a T32 training grant (T32 DA017629
Multiple Principal Investigators: J. Maggs & S. Lanza) from the National
Institute on Drug Abuse (NIDA).

Computations for this research were performed on the Pennsylvania State
University’s Institute for Computational and Data Sciences’ Roar
supercomputer using SLURM for job scheduling (Yoo et al., 2003), GNU
Parallel to run the simulations in parallel (Tange, 2021), and Apptainer
to ensure a reproducible software stack (Kurtzer et al., 2017, 2021).
See `.sim/README.md` and the scripts in the `.sim` folder in the
[GitHub](https://github.com/jeksterslab/manMetaVAR) repository for more
details on how the simulations were performed.

## Installation

You can install `manMetaVAR` from
[GitHub](https://github.com/jeksterslab/manMetaVAR) with:

``` r

if (!require("pak")) install.packages("pak")
pak::pkg_install("jeksterslab/manMetaVAR")
```

See
[Containers](https://jeksterslab.github.io/manMetaVAR/articles/containers.html)
for containerized versions of the package.

## R Packages

Person-specific discrete-time and continuous-time vector autoregressive
models for multiple individuals are available in the `fitVARMxID`
package on the Comprehensive R Archive Network (CRAN)
(<https://CRAN.R-project.org/package=fitVARMxID>). Documentation and
examples can be found on the accompanying website
(<https://jeksterslab.github.io/fitVARMxID/>). Meta-analytic synthesis
of dynamic model estimates, including fixed-, random-, and mixed-effects
multivariate meta-analysis models, is available in the `metaDyn` package
on the Comprehensive R Archive Network (CRAN)
(<https://CRAN.R-project.org/package=metaDyn>). Documentation and
examples can be found on the accompanying website
(<https://jeksterslab.github.io/metaDyn/>).

## More Information

See [GitHub Pages](https://jeksterslab.github.io/manMetaVAR/index.html)
for package documentation.
