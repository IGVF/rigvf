
<!-- README.md is generated from README.Rmd. Please edit that file -->

# rigvf

<!-- badges: start -->

[![Lifecycle:
experimental](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://lifecycle.r-lib.org/articles/stages.html#experimental)
<!-- badges: end -->

Package version: 0.0.0.9000<br/> Compiled date: 2024-09-06

This proof-of-concept uses the ArangoDB REST API to access the Impact of
Genomic Variation on Function (‘IGVF’) data portal
(<https://data.igvf.org/>).

## Installation

install the development version from [GitHub](https://github.com/) with:

``` r
## install.packages("pak")
pak::pak("mtmorgan/rigvf")
```

## Example

There is limited functionality implemented, the most useful of which is
the location of variants associated with a particular gene.

``` r
rigvf::gene_variants("ENSG00000106633", threshold = 0.85)
#> # A tibble: 40 × 9
#>    `_key`              `_id` `_from` `_to` `_rev` `score:long` source source_url
#>    <chr>               <chr> <chr>   <chr> <chr>         <dbl> <chr>  <chr>     
#>  1 genic_chr7_4415452… regu… regula… gene… _g5CU…        0.989 ENCOD… https://w…
#>  2 promoter_chr7_4415… regu… regula… gene… _g5CU…        0.869 ENCOD… https://w…
#>  3 genic_chr7_4414584… regu… regula… gene… _g5CU…        0.948 ENCOD… https://w…
#>  4 promoter_chr7_4415… regu… regula… gene… _g5CU…        1.00  ENCOD… https://w…
#>  5 promoter_chr7_4415… regu… regula… gene… _g5CU…        1.00  ENCOD… https://w…
#>  6 intergenic_chr7_44… regu… regula… gene… _g5CU…        0.959 ENCOD… https://w…
#>  7 genic_chr7_4415544… regu… regula… gene… _g5CV…        0.942 ENCOD… https://w…
#>  8 promoter_chr7_4415… regu… regula… gene… _g5CV…        0.929 ENCOD… https://w…
#>  9 intergenic_chr7_44… regu… regula… gene… _g5CV…        0.936 ENCOD… https://w…
#> 10 promoter_chr7_4415… regu… regula… gene… _g5CW…        0.966 ENCOD… https://w…
#> # ℹ 30 more rows
#> # ℹ 1 more variable: biological_context <chr>
```

The help page `?queries` outlines other available user-facing functions.
See `?arango` for more developer-oriented information.
