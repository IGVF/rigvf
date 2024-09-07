
<!-- README.md is generated from README.Rmd. Please edit that file -->

# rigvf

<!-- badges: start -->

[![Lifecycle:
experimental](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://lifecycle.r-lib.org/articles/stages.html#experimental)
<!-- badges: end -->

Package version: 0.0.0.9001<br/> Compiled date: 2024-09-07

This proof-of-concept illustrates how to access the Impact of Genomic
Variation on Function (‘IGVF’) data portal (<https://data.igvf.org/>).
Only limited functionality is implemented.

## Installation

Install the development version from
[GitHub](https://github.com/mtmorgan/rigvf) with:

``` r
## install.packages("pak")
pak::pak("mtmorgan/rigvf")
```

## Catalog

The IGVF offers two interfaces. The ‘catalog’
<https://api.catalog.igvf.org/#> is prefered, with optimized queries of
relevant information. Queries are simple REST requests implemented using
the httr2 package. Here we query variants associated with “GCK”; one
could also use, e.g., Ensembl identifiers.

``` r
rigvf::gene_variants(gene_name = "GCK")
#> # A tibble: 25 × 9
#>    `sequence variant`      gene  label log10pvalue effect_size source source_url
#>    <chr>                   <chr> <chr>       <dbl>       <dbl> <chr>  <chr>     
#>  1 variants/8c6a683829bcb… gene… eQTL         4.89       0.274 GTEx   https://s…
#>  2 variants/cf796b5a16212… gene… eQTL         5.76       0.221 GTEx   https://s…
#>  3 variants/9a36af4633321… gene… eQTL         6.17      -0.266 GTEx   https://s…
#>  4 variants/2fefe07a0750b… gene… eQTL         3.69       0.158 GTEx   https://s…
#>  5 variants/ab6df1152a643… gene… eQTL        16.9       -0.353 GTEx   https://s…
#>  6 variants/92833b52621e5… gene… eQTL         4.86      -0.170 GTEx   https://s…
#>  7 variants/bceca4e6ac3cd… gene… eQTL         4.63      -0.340 GTEx   https://s…
#>  8 variants/0a8ba63e5451a… gene… eQTL         4.94       0.215 GTEx   https://s…
#>  9 variants/80f639e0da643… gene… eQTL         6.59      -0.330 GTEx   https://s…
#> 10 variants/7f4ca6f1cfd70… gene… eQTL         4.10      -0.165 GTEx   https://s…
#> # ℹ 15 more rows
#> # ℹ 2 more variables: biological_context <chr>, chr <chr>

response <- rigvf::gene_variants(gene_id = "ENSG00000106633", verbose = TRUE)
response
#> # A tibble: 25 × 9
#>    `sequence variant` gene              label log10pvalue effect_size source
#>    <list>             <list>            <chr>       <dbl>       <dbl> <chr> 
#>  1 <named list [14]>  <named list [11]> eQTL         4.89       0.274 GTEx  
#>  2 <named list [14]>  <named list [11]> eQTL         5.76       0.221 GTEx  
#>  3 <named list [14]>  <named list [11]> eQTL         6.17      -0.266 GTEx  
#>  4 <named list [14]>  <named list [11]> eQTL         3.69       0.158 GTEx  
#>  5 <named list [14]>  <named list [11]> eQTL        16.9       -0.353 GTEx  
#>  6 <named list [14]>  <named list [11]> eQTL         4.86      -0.170 GTEx  
#>  7 <named list [14]>  <named list [11]> eQTL         4.63      -0.340 GTEx  
#>  8 <named list [14]>  <named list [11]> eQTL         4.94       0.215 GTEx  
#>  9 <named list [14]>  <named list [11]> eQTL         6.59      -0.330 GTEx  
#> 10 <named list [14]>  <named list [11]> eQTL         4.10      -0.165 GTEx  
#> # ℹ 15 more rows
#> # ℹ 3 more variables: source_url <chr>, biological_context <chr>, chr <chr>

response |>
    dplyr::select(`sequence variant`) |>
    tidyr::unnest_wider(`sequence variant`)
#> # A tibble: 25 × 14
#>    organism     `_id`    chr      pos rsid  ref   alt   spdi  hgvs  qual  filter
#>    <chr>        <chr>    <chr>  <int> <chr> <chr> <chr> <chr> <chr> <chr> <lgl> 
#>  1 Homo sapiens 8c6a683… chr7  4.41e7 rs25… G     A     NC_0… NC_0… .     NA    
#>  2 Homo sapiens cf796b5… chr7  4.41e7 rs29… T     C     NC_0… NC_0… .     NA    
#>  3 Homo sapiens 9a36af4… chr7  4.41e7 rs11… GT    G     NC_0… NC_0… .     NA    
#>  4 Homo sapiens 2fefe07… chr7  4.43e7 rs28… G     A     NC_0… NC_0… .     NA    
#>  5 Homo sapiens ab6df11… chr7  4.41e7 rs22… C     G     NC_0… NC_0… .     NA    
#>  6 Homo sapiens 92833b5… chr7  4.41e7 rs41… G     A     NC_0… NC_0… .     NA    
#>  7 Homo sapiens bceca4e… chr7  4.40e7 rs76… T     G     NC_0… NC_0… .     NA    
#>  8 Homo sapiens 0a8ba63… chr7  4.41e7 rs25… A     G     NC_0… NC_0… .     NA    
#>  9 Homo sapiens 80f639e… chr7  4.41e7 rs14… A     AG    NC_0… NC_0… .     NA    
#> 10 Homo sapiens 7f4ca6f… chr7  4.42e7 rs29… A     T     NC_0… NC_0… .     NA    
#> # ℹ 15 more rows
#> # ℹ 3 more variables: annotations <list>, source <chr>, source_url <chr>
```

## ArangoDB

The ‘ArangoDB’ REST API provides flexibility but requires greater
understanding of Arango Query Language and the database schema.
Documentation is available in the
[database](https://db.catalog.igvf.org/_db/igvf/_admin/aardvark/index.html#support)
under the ‘Support’ menu item ‘REST API’ tab using username ‘guest’ and
password ‘guestigvfcatalog’.

The following directly queries the database for variants of an Ensembl
gene id.

``` r
rigvf::db_gene_variants("ENSG00000106633", threshold = 0.85)
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

The AQL is

``` r
aql <- system.file(package = "rigvf", "aql", "gene_variants.aql")
readLines(aql) |> noquote()
#> [1] FOR l IN regulatory_regions_genes     
#> [2]     FILTER l._to == @geneid           
#> [3]     FILTER l.`score:long` > @threshold
#> [4]     RETURN l
```

The help page `?db_queries` outlines other available user-facing
functions. See `?arango` for more developer-oriented information.
