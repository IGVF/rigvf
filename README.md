# rigvf

<!-- badges: start -->
[![Lifecycle: experimental](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://lifecycle.r-lib.org/articles/stages.html#experimental)
<!-- badges: end -->

This proof-of-concept illustrates how to access the Impact of Genomic
Variation on Function ('IGVF') Catalog from R.
Only limited functionality is currently implemented.

## Installation

Install the development version from
[GitHub](https://github.com/IGVF/rigvf) with:

``` r
## install.packages("BiocManager") # if not installed
BiocManager::install("IGVF/rigvf")
```

## Use

See the [Accessing data from the IGVF Catalog][] vignette for basic use.

See `?catalog_queries` and `?db_queries` for example functions for accessing 
IGVF data through the Catalog API and ArangoDB API, respectively.

[Accessing data from the IGVF Catalog]: https://IGVF.github.io/rigvf/articles/use.html
