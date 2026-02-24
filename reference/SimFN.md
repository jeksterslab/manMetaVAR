# Simulation File Name

Simulation File Name

## Usage

``` r
SimFN(output_type, output_folder, suffix)
```

## Arguments

- output_type:

  Character string. Output type. Valid values include `"data"`,
  `"fit-dt-var-mx"`, `"fit-meta-var-mx"`, and `"fit-mplus"`.

- output_folder:

  Character string. Output folder.

- suffix:

  Character string. Output of `manCTMed:::.SimSuffix()`.

## Value

Returns a character string file name with the `output_folder` in the
OS-specific format.
