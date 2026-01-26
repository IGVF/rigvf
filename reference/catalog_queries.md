# Query the IGVF Catalog via REST API

This page documents functions using the IGVF REST API, documented at
<https://api.catalogkg.igvf.org/#>.

Note that functions will only return a limited number of responses, see
`limit` and `page` arguments below for control over number of responses.

`gene_variants()` locates variants associated with a gene. Only one of
`gene_id`, `hgnc`, `gene_name`, or `alias` should be specified.

`variant_genes()` locates genes associated with a variant. Only one of
`spdi`, `hgvs`, `rsid`, `variant_id`, or `chr + position` should be
specified.

`gene_elements()` locates elements associated with a gene.

`elements()` locates genomic elements based on a genomic range query.

`element_genes()` locates genomic elements and associated genes based on
a genomic range query.

## Usage

``` r
gene_variants(
  gene_id = NULL,
  hgnc = NULL,
  gene_name = NULL,
  alias = NULL,
  organism = "Homo sapiens",
  log10pvalue = NULL,
  effect_size = NULL,
  page = 0L,
  limit = 25L,
  verbose = FALSE
)

variant_genes(
  spdi = NULL,
  hgvs = NULL,
  rsid = NULL,
  variant_id = NULL,
  chr = NULL,
  position = NULL,
  organism = "Homo sapiens",
  log10pvalue = NULL,
  effect_size = NULL,
  page = 0L,
  limit = 25L,
  verbose = FALSE
)

gene_elements(gene_id = NULL, page = 0L, limit = 25L, verbose = FALSE)

elements(range = NULL, page = 0L, limit = 25L)

element_genes(range = NULL, page = 0L, limit = 25L, verbose = FALSE)
```

## Arguments

- gene_id:

  character(1) Ensembl gene identifier, e.g., "ENSG00000106633"

- hgnc:

  character(1) HGNC identifier

- gene_name:

  character(1) Gene symbol, e.g., "GCK"

- alias:

  character(1) Gene alias

- organism:

  character(1) Either 'Homo sapiens' (default) or 'Mus musculus'

- log10pvalue:

  character(1) The following can be used to set thresholds on the
  negative log10pvalue: gt (\>), gte (\>=), lt (\<), lte (\<=), with a
  ":" following and a value, e.g., "gt:5.0"

- effect_size:

  character(1) Optional string used for thresholding on the effect size
  of the variant on the gene. See 'log10pvalue'. E.g., "gt:0.5"

- page:

  integer(1) when there are more response items than `limit`, offers
  pagination. starts on page 0L, next is 1L, ...

- limit:

  integer(1) the limit parameter controls the page size and can not
  exceed 1000

- verbose:

  logical(1) return additional information about variants and genes

- spdi:

  character(1) SPDI of variant

- hgvs:

  character(1) HGVS of variant

- rsid:

  character(1) RSID of variant

- variant_id:

  character(1) IGVF variant ID

- chr:

  character(1) UCSC-style chromosome name of variant, e.g. "chr1"

- position:

  character(1) 0-based position of variant

- range:

  the query GRanges (expects 1-based start position)

## Value

`gene_variants()` returns a tibble describing variants associated with
the gene; use `verbose = TRUE` to retrieve more extensive information.

`variant_genes()` returns a tibble describing genes associated with a
variant; use `verbose = TRUE` to retrieve more extensive information.

`gene_elements()` returns a tibble describing elements associated with
the gene; use `verbose = TRUE` to retrieve more extensive information.

`elements()` returns a GRanges object describing elements.

`element_genes()` returns a tibble describing genomic element and gene
pairs.

## Examples

``` r

rigvf::gene_variants(gene_name = "GCK")
#> # A tibble: 25 × 12
#>    sequence_variant      gene  study label log10pvalue effect_size method source
#>    <chr>                 <chr> <chr> <chr>       <dbl> <list>      <list> <chr> 
#>  1 variants/NC_000007.1… gene… stud… spli…        9.06 <NULL>      <NULL> EBI e…
#>  2 variants/NC_000007.1… gene… stud… eQTL         7.93 <NULL>      <NULL> EBI e…
#>  3 variants/NC_000007.1… gene… stud… eQTL         6.93 <NULL>      <NULL> EBI e…
#>  4 variants/NC_000007.1… gene… stud… eQTL         8.22 <NULL>      <NULL> EBI e…
#>  5 variants/NC_000007.1… gene… stud… eQTL         6.92 <NULL>      <NULL> EBI e…
#>  6 variants/NC_000007.1… gene… stud… eQTL         7.54 <NULL>      <NULL> EBI e…
#>  7 variants/NC_000007.1… gene… stud… spli…        9.39 <NULL>      <NULL> EBI e…
#>  8 variants/NC_000007.1… gene… stud… eQTL        10.2  <NULL>      <NULL> EBI e…
#>  9 variants/NC_000007.1… gene… stud… eQTL         7.03 <NULL>      <NULL> EBI e…
#> 10 variants/NC_000007.1… gene… stud… eQTL         4.45 <NULL>      <NULL> EBI e…
#> # ℹ 15 more rows
#> # ℹ 4 more variables: source_url <chr>, biological_context <chr>, chr <list>,
#> #   name <chr>

rigvf::gene_variants(gene_name = "GCK", effect_size="gt:0.5")
#> # A tibble: 0 × 0

rigvf::gene_variants(gene_name = "GCK", verbose = TRUE)
#> # A tibble: 25 × 12
#>    sequence_variant  gene         study        label     log10pvalue effect_size
#>    <list>            <list>       <list>       <chr>           <dbl> <list>     
#>  1 <named list [16]> <named list> <named list> splice_Q…        9.06 <NULL>     
#>  2 <named list [16]> <named list> <named list> eQTL             7.93 <NULL>     
#>  3 <named list [16]> <named list> <named list> eQTL             6.93 <NULL>     
#>  4 <named list [16]> <named list> <named list> eQTL             8.22 <NULL>     
#>  5 <named list [16]> <named list> <named list> eQTL             6.92 <NULL>     
#>  6 <named list [16]> <named list> <named list> eQTL             7.54 <NULL>     
#>  7 <named list [16]> <named list> <named list> splice_Q…        9.39 <NULL>     
#>  8 <named list [16]> <named list> <named list> eQTL            10.2  <NULL>     
#>  9 <named list [16]> <named list> <named list> eQTL             7.03 <NULL>     
#> 10 <named list [16]> <named list> <named list> eQTL             4.45 <NULL>     
#> # ℹ 15 more rows
#> # ℹ 6 more variables: method <list>, source <chr>, source_url <chr>,
#> #   biological_context <chr>, chr <list>, name <chr>

rigvf::variant_genes(spdi = "NC_000001.11:920568:G:A")
#> # A tibble: 0 × 0

res <- rigvf::gene_elements(gene_id = "ENSG00000187961")
res
#> # A tibble: 1 × 2
#>   gene             elements   
#>   <list>           <list>     
#> 1 <named list [5]> <list [25]>
res |>
    tidyr::unnest_longer(elements) |>
    tidyr::unnest_wider(elements)
#> # A tibble: 25 × 14
#>    gene             id    cell_type score model dataset element_type element_chr
#>    <list>           <chr> <chr>     <lgl> <chr> <chr>   <chr>        <chr>      
#>  1 <named list [5]> geno… CD8-posi… NA    IGVF  https:… tested elem… chr1       
#>  2 <named list [5]> geno… CD8-posi… NA    IGVF  https:… tested elem… chr1       
#>  3 <named list [5]> geno… CD8-posi… NA    IGVF  https:… tested elem… chr1       
#>  4 <named list [5]> geno… CD8-posi… NA    IGVF  https:… tested elem… chr1       
#>  5 <named list [5]> geno… CD8-posi… NA    IGVF  https:… tested elem… chr1       
#>  6 <named list [5]> geno… CD8-posi… NA    IGVF  https:… tested elem… chr1       
#>  7 <named list [5]> geno… CD8-posi… NA    IGVF  https:… tested elem… chr1       
#>  8 <named list [5]> geno… CD8-posi… NA    IGVF  https:… tested elem… chr1       
#>  9 <named list [5]> geno… CD8-posi… NA    IGVF  https:… tested elem… chr10      
#> 10 <named list [5]> geno… CD8-posi… NA    IGVF  https:… tested elem… chr10      
#> # ℹ 15 more rows
#> # ℹ 6 more variables: element_start <int>, element_end <int>, name <chr>,
#> #   method <chr>, class <chr>, files_filesets <chr>

rng <- GenomicRanges::GRanges("chr1", IRanges::IRanges(1157520,1158189))

rigvf::elements(range = rng)
#> GRanges object with 25 ranges and 5 metadata columns:
#>        seqnames          ranges strand |                   name
#>           <Rle>       <IRanges>  <Rle> |            <character>
#>    [1]     chr1 1157437-1157782      * |           EH38E2777055
#>    [2]     chr1 1157886-1158053      * |           EH38E2777056
#>    [3]     chr1 1158136-1158445      * |           EH38E1310547
#>    [4]     chr1 1156360-1158596      * | intergenic_chr1_1156..
#>    [5]     chr1 1156375-1158325      * | intergenic_chr1_1156..
#>    ...      ...             ...    ... .                    ...
#>   [21]     chr1 1156595-1158733      * | intergenic_chr1_1156..
#>   [22]     chr1 1156609-1158905      * | intergenic_chr1_1156..
#>   [23]     chr1 1156629-1157810      * | intergenic_chr1_1156..
#>   [24]     chr1 1156631-1157834      * | intergenic_chr1_1156..
#>   [25]     chr1 1156638-1159033      * | intergenic_chr1_1156..
#>             source_annotation                   type      source
#>                   <character>            <character> <character>
#>    [1] dELS: distal Enhance.. candidate cis regula..      ENCODE
#>    [2] dELS: distal Enhance.. candidate cis regula..      ENCODE
#>    [3] dELS: distal Enhance.. candidate cis regula..      ENCODE
#>    [4]             intergenic accessible dna eleme..      ENCODE
#>    [5]             intergenic accessible dna eleme..      ENCODE
#>    ...                    ...                    ...         ...
#>   [21]             intergenic accessible dna eleme..      ENCODE
#>   [22]             intergenic accessible dna eleme..      ENCODE
#>   [23]             intergenic accessible dna eleme..      ENCODE
#>   [24]             intergenic accessible dna eleme..      ENCODE
#>   [25]             intergenic accessible dna eleme..      ENCODE
#>                    source_url
#>                   <character>
#>    [1] https://www.encodepr..
#>    [2] https://www.encodepr..
#>    [3] https://www.encodepr..
#>    [4] https://www.encodepr..
#>    [5] https://www.encodepr..
#>    ...                    ...
#>   [21] https://www.encodepr..
#>   [22] https://www.encodepr..
#>   [23] https://www.encodepr..
#>   [24] https://www.encodepr..
#>   [25] https://www.encodepr..
#>   -------
#>   seqinfo: 1 sequence from hg38 genome; no seqlengths

rigvf::element_genes(range = rng)
#> # A tibble: 25 × 11
#>    score source source_url     significant genomic_element gene  biosample name 
#>    <dbl> <chr>  <chr>          <list>      <chr>           <chr> <chr>     <chr>
#>  1 0.335 ENCODE https://www.e… <NULL>      genomic_elemen… gene… stomach … regu…
#>  2 0.431 ENCODE https://www.e… <NULL>      genomic_elemen… gene… stomach … regu…
#>  3 0.971 ENCODE https://www.e… <NULL>      genomic_elemen… gene… stomach … regu…
#>  4 0.501 ENCODE https://www.e… <NULL>      genomic_elemen… gene… stomach … regu…
#>  5 0.869 ENCODE https://www.e… <NULL>      genomic_elemen… gene… stomach … regu…
#>  6 0.886 ENCODE https://www.e… <NULL>      genomic_elemen… gene… stomach … regu…
#>  7 0.773 ENCODE https://www.e… <NULL>      genomic_elemen… gene… stomach … regu…
#>  8 0.372 ENCODE https://www.e… <NULL>      genomic_elemen… gene… ovary fr… regu…
#>  9 0.730 ENCODE https://www.e… <NULL>      genomic_elemen… gene… T-helper… regu…
#> 10 0.564 ENCODE https://www.e… <NULL>      genomic_elemen… gene… T-helper… regu…
#> # ℹ 15 more rows
#> # ℹ 3 more variables: method <chr>, class <chr>, files_filesets <chr>
```
