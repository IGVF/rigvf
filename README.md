# rigvf: IGVF Catalog from R <img id="rigvf_logo" alt="rigvf logo" src="man/figures/rigvf.png" align="right" width="125"/>

<!-- badges: start -->
[![Lifecycle: experimental](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://lifecycle.r-lib.org/articles/stages.html#experimental)
<!-- badges: end -->

*rigvf* provides access the Impact of Genomic Variation on Function (IGVF) 
Catalog from within R/Bioconductor, allowing integration with Bioconductor 
resources, classes, and methods.

Only limited functionality is currently implemented, mostly centered around
associations among genetic variants, genomic elements, and genes.

## Installation

Install the development version from
[GitHub](https://github.com/IGVF/rigvf) with:

``` r
## install.packages("BiocManager") # if not installed
BiocManager::install("IGVF/rigvf")
```

## Using `rigvf`

See the [Accessing data from the IGVF Catalog][] vignette for basic use.

See `?catalog_queries` and `?db_queries` for example functions for accessing 
IGVF data through the Catalog API and ArangoDB API, respectively.

[Accessing data from the IGVF Catalog]: https://IGVF.github.io/rigvf/articles/rigvf.html

## Data license

For IGVF Catalog data license, see the [IGVF policy page](https://data.igvf.org/policies/).
