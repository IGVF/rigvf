# Accessing data from the IGVF Catalog

## IGVF background

The [Impact of Genomic Variation on Function (IGVF)](https://igvf.org/)
Consortium,

> aims to understand how genomic variation affects genome function,
> which in turn impacts phenotype. The NHGRI is funding this
> collaborative program that brings together teams of investigators who
> will use state-of-the-art experimental and computational approaches to
> model, predict, characterize and map genome function, how genome
> function shapes phenotype, and how these processes are affected by
> genomic variation. These joint efforts will produce a catalog of the
> impact of genomic variants on genome function and phenotypes.

The *IGVF Catalog* described in the last sentence is available through a
number of interfaces, including a [web
interface](https://catalog.igvf.org/) as well as two programmatic
interfaces. In addition, there is a *Data Portal*, where raw and
processed data can be downloaded, with its own [web
interface](https://data.igvf.org/) and [client
library](https://github.com/IGVF-DACC/igvf-r-client) for R. This
package, `rigvf`, focuses on the *Catalog* and not the *Data Portal*.

### Knowledge graph of variant function

The *IGVF Catalog* is a form of *knowledge graph*, where the nodes are
biological entities such as variants, genes, pathways, etc. and edges
are relationships between such nodes, e.g. empirically measured effects
of variants on *cis*-regulatory elements (CREs) or on transcripts and
proteins. These edges may have metadata including information about cell
type context and information about how the association was measured,
e.g. which experiment or predictive model.

### The *rigvf* package

This package provides access to some of the IGVF Catalog from within
R/Bioconductor. Currently, limited functionality is implemented, with
priority towards applications and integration with Bioconductor
functionality. However, the [source code](https://github.com/IGVF/rigvf)
and internal functions can also be used to build one-off querying
functions.

### Data license

For IGVF Catalog data license, see the [IGVF policy
page](https://data.igvf.org/policies/).

## Catalog API

The IGVF Catalog offers two programmatic interfaces, the Catalog API and
an ArangoDb interface, described further below. The [Catalog
API](https://api.catalogkg.igvf.org/#) is preferred, with optimized
queries of relevant information. Queries are simple REST requests
implemented using the *httr2* package. Here we query variants associated
with “GCK”; one could also use, e.g., Ensembl identifiers.

``` r

library(rigvf)
gene_variants(gene_name = "GCK")
#> # A tibble: 25 × 18
#>    gene          sequence_variant effect_size log10pvalue posterior_inclusion_…¹
#>    <chr>         <chr>                  <dbl>       <dbl>                  <dbl>
#>  1 genes/ENSG00… variants/NC_000…      -1.01         9.06                 0.0599
#>  2 genes/ENSG00… variants/NC_000…      -0.347        7.93                 0.200 
#>  3 genes/ENSG00… variants/NC_000…      -0.565        6.93                 0.103 
#>  4 genes/ENSG00… variants/NC_000…       0.378        8.22                 0.0720
#>  5 genes/ENSG00… variants/NC_000…      -0.319        6.92                 0.0422
#>  6 genes/ENSG00… variants/NC_000…       0.349        7.54                 0.0170
#>  7 genes/ENSG00… variants/NC_000…      -1.02         9.39                 0.144 
#>  8 genes/ENSG00… variants/NC_000…      -0.340       10.2                  0.0234
#>  9 genes/ENSG00… variants/NC_000…      -0.486        7.03                 0.0129
#> 10 genes/ENSG00… variants/NC_000…       0.262        4.45                 0.138 
#> # ℹ 15 more rows
#> # ℹ abbreviated name: ¹​posterior_inclusion_probability
#> # ℹ 13 more variables: standard_error <dbl>, z_score <dbl>,
#> #   credible_set_min_r2 <dbl>, method <chr>, source <chr>, source_url <chr>,
#> #   label <chr>, p_value <dbl>, biological_context <chr>, biosample_term <chr>,
#> #   study <chr>, name <chr>, class <chr>
```

Note that we only receive a limited number of responses. We can change
both the `page` of responses we receive and the `limit` per page:

``` r

gene_variants(gene_name = "GCK", page=1L)
#> # A tibble: 25 × 18
#>    gene          sequence_variant effect_size log10pvalue posterior_inclusion_…¹
#>    <chr>         <chr>                  <dbl>       <dbl>                  <dbl>
#>  1 genes/ENSG00… variants/NC_000…      -0.661       10.0                  0.196 
#>  2 genes/ENSG00… variants/NC_000…      -0.339        7.74                 0.128 
#>  3 genes/ENSG00… variants/NC_000…      -0.486       20.2                  0.997 
#>  4 genes/ENSG00… variants/NC_000…       0.439       11.0                  0.218 
#>  5 genes/ENSG00… variants/NC_000…      -0.387       11.3                  0.873 
#>  6 genes/ENSG00… variants/NC_000…      -0.336        7.32                 0.107 
#>  7 genes/ENSG00… variants/NC_000…       0.395        9.62                 0.0801
#>  8 genes/ENSG00… variants/NC_000…      -0.315        6.35                 0.0180
#>  9 genes/ENSG00… variants/NC_000…      -0.316        6.57                 0.0299
#> 10 genes/ENSG00… variants/NC_000…      -1.02         9.40                 0.148 
#> # ℹ 15 more rows
#> # ℹ abbreviated name: ¹​posterior_inclusion_probability
#> # ℹ 13 more variables: standard_error <dbl>, z_score <dbl>,
#> #   credible_set_min_r2 <dbl>, method <chr>, source <chr>, source_url <chr>,
#> #   label <chr>, p_value <dbl>, biological_context <chr>, biosample_term <chr>,
#> #   study <chr>, name <chr>, class <chr>
gene_variants(gene_name = "GCK", limit=50L)
#> # A tibble: 50 × 18
#>    gene          sequence_variant effect_size log10pvalue posterior_inclusion_…¹
#>    <chr>         <chr>                  <dbl>       <dbl>                  <dbl>
#>  1 genes/ENSG00… variants/NC_000…      -1.01         9.06                 0.0599
#>  2 genes/ENSG00… variants/NC_000…      -0.347        7.93                 0.200 
#>  3 genes/ENSG00… variants/NC_000…      -0.565        6.93                 0.103 
#>  4 genes/ENSG00… variants/NC_000…       0.378        8.22                 0.0720
#>  5 genes/ENSG00… variants/NC_000…      -0.319        6.92                 0.0422
#>  6 genes/ENSG00… variants/NC_000…       0.349        7.54                 0.0170
#>  7 genes/ENSG00… variants/NC_000…      -1.02         9.39                 0.144 
#>  8 genes/ENSG00… variants/NC_000…      -0.340       10.2                  0.0234
#>  9 genes/ENSG00… variants/NC_000…      -0.486        7.03                 0.0129
#> 10 genes/ENSG00… variants/NC_000…       0.262        4.45                 0.138 
#> # ℹ 40 more rows
#> # ℹ abbreviated name: ¹​posterior_inclusion_probability
#> # ℹ 13 more variables: standard_error <dbl>, z_score <dbl>,
#> #   credible_set_min_r2 <dbl>, method <chr>, source <chr>, source_url <chr>,
#> #   label <chr>, p_value <dbl>, biological_context <chr>, biosample_term <chr>,
#> #   study <chr>, name <chr>, class <chr>
```

We can also pass thresholds on the negative log10 p-value or the effect
size, using the following letter combinations,
`gt (>), gte (>=), lt (<), lte (<=)`, followed by a `:` and a value. See
examples below:

``` r

gene_variants(gene_name = "GCK", log10pvalue="gt:5.0")
#> # A tibble: 25 × 18
#>    gene          sequence_variant effect_size log10pvalue posterior_inclusion_…¹
#>    <chr>         <chr>                  <dbl>       <dbl>                  <dbl>
#>  1 genes/ENSG00… variants/NC_000…      -1.01         9.06                 0.0599
#>  2 genes/ENSG00… variants/NC_000…      -0.347        7.93                 0.200 
#>  3 genes/ENSG00… variants/NC_000…      -0.565        6.93                 0.103 
#>  4 genes/ENSG00… variants/NC_000…       0.378        8.22                 0.0720
#>  5 genes/ENSG00… variants/NC_000…      -0.319        6.92                 0.0422
#>  6 genes/ENSG00… variants/NC_000…       0.349        7.54                 0.0170
#>  7 genes/ENSG00… variants/NC_000…      -1.02         9.39                 0.144 
#>  8 genes/ENSG00… variants/NC_000…      -0.340       10.2                  0.0234
#>  9 genes/ENSG00… variants/NC_000…      -0.486        7.03                 0.0129
#> 10 genes/ENSG00… variants/NC_000…      -0.325        6.55                 0.0185
#> # ℹ 15 more rows
#> # ℹ abbreviated name: ¹​posterior_inclusion_probability
#> # ℹ 13 more variables: standard_error <dbl>, z_score <dbl>,
#> #   credible_set_min_r2 <dbl>, method <chr>, source <chr>, source_url <chr>,
#> #   label <chr>, p_value <dbl>, biological_context <chr>, biosample_term <chr>,
#> #   study <chr>, name <chr>, class <chr>
gene_variants(gene_name = "GCK", effect_size="gt:0.5")
#> # A tibble: 0 × 0
```

The help page
[`?catalog_queries`](https://IGVF.github.io/rigvf/reference/catalog_queries.md)
outlines other available user-facing functions.

Note that nested columns in the response can be widen-ed using *tidyr*.
For example, when querying genomic elements that are associated with a
gene, we get back nested output:

``` r

res <- gene_elements(gene_id = "ENSG00000187961", verbose = TRUE)
res
#> # A tibble: 25 × 13
#>    name   label method class source source_url biological_context biosample_term
#>    <chr>  <chr> <chr>  <chr> <chr>  <chr>      <chr>              <chr>         
#>  1 expre… regu… Pertu… obse… IGVF   https://d… CD8-positive, alp… ontology_term…
#>  2 expre… regu… Pertu… obse… IGVF   https://d… CD8-positive, alp… ontology_term…
#>  3 expre… regu… Pertu… obse… IGVF   https://d… CD8-positive, alp… ontology_term…
#>  4 expre… regu… Pertu… obse… IGVF   https://d… CD8-positive, alp… ontology_term…
#>  5 expre… regu… Pertu… obse… IGVF   https://d… CD8-positive, alp… ontology_term…
#>  6 expre… regu… Pertu… obse… IGVF   https://d… CD8-positive, alp… ontology_term…
#>  7 expre… regu… Pertu… obse… IGVF   https://d… CD8-positive, alp… ontology_term…
#>  8 expre… regu… Pertu… obse… IGVF   https://d… CD8-positive, alp… ontology_term…
#>  9 expre… regu… Pertu… obse… IGVF   https://d… CD8-positive, alp… ontology_term…
#> 10 expre… regu… Pertu… obse… IGVF   https://d… CD8-positive, alp… ontology_term…
#> # ℹ 15 more rows
#> # ℹ 5 more variables: files_filesets <chr>, score <dbl>, p_value <int>,
#> #   genomic_element <list>, gene <list>

#res |>
#    tidyr::unnest_longer(elements) |>
#    tidyr::unnest_wider(elements)
```

### GRanges-based queries

The functions
[`elements()`](https://IGVF.github.io/rigvf/reference/catalog_queries.md)
and
[`element_genes()`](https://IGVF.github.io/rigvf/reference/catalog_queries.md)
take *GRanges* input ranges, and
[`elements()`](https://IGVF.github.io/rigvf/reference/catalog_queries.md)
provides back the response as *GRanges*. Note that IGVF uses hg38 and
USCS-style chromosome names, e.g., chr1.

## ArangoDB API

The ArangoDB API provides flexibility but requires greater understanding
of Arango Query Language and the database schema. Documentation is
available in the
[database](https://db.catalog.igvf.org/_db/igvf/_admin/aardvark/index.html#support)
under the ‘Support’ menu item ‘REST API’ tab using username ‘guest’ and
password ‘guestigvfcatalog’.

The following directly queries the database for variants of an Ensembl
gene id.

``` r

db_gene_variants("ENSG00000106633", threshold = 0.85)
#> # A tibble: 82 × 33
#>    `_key`     `_id` `_from` `_to` `_rev` biosample_term biological_process study
#>    <chr>      <chr> <chr>   <chr> <chr>  <chr>          <chr>              <chr>
#>  1 cc4bdbbd9… vari… varian… gene… _lSEo… ontology_term… ontology_terms/GO… stud…
#>  2 c30b4a47f… vari… varian… gene… _lSEo… ontology_term… ontology_terms/GO… stud…
#>  3 98f84be97… vari… varian… gene… _lSEo… ontology_term… ontology_terms/GO… stud…
#>  4 0ac0b3302… vari… varian… gene… _lSEo… ontology_term… ontology_terms/GO… stud…
#>  5 8038cc8af… vari… varian… gene… _lSEo… ontology_term… ontology_terms/GO… stud…
#>  6 6b425d3f4… vari… varian… gene… _lSEo… ontology_term… ontology_terms/GO… stud…
#>  7 bcd7b389b… vari… varian… gene… _lSEo… ontology_term… ontology_terms/GO… stud…
#>  8 facd9b8cc… vari… varian… gene… _lSEu… ontology_term… ontology_terms/GO… stud…
#>  9 dd2f2af11… vari… varian… gene… _lSEu… ontology_term… ontology_terms/GO… stud…
#> 10 448c345a9… vari… varian… gene… _lSEu… ontology_term… ontology_terms/GO… stud…
#> # ℹ 72 more rows
#> # ℹ 25 more variables: biological_context <chr>, label <chr>, class <chr>,
#> #   method <chr>, source <chr>, source_url <chr>, name <chr>,
#> #   inverse_name <chr>, molecular_trait_id <chr>, gene_id <chr>,
#> #   credible_set_id <chr>, variant_chromosome_position_ref_alt <chr>,
#> #   rsid <chr>, credible_set_size <int>, posterior_inclusion_probability <dbl>,
#> #   p_value <dbl>, log10pvalue <dbl>, standard_error <dbl>, z_score <dbl>, …
```

The AQL is

``` r

aql <- system.file(package = "rigvf", "aql", "gene_variants.aql")
readLines(aql) |> noquote()
#> [1] FOR l IN variants_genes                
#> [2]     FILTER l._to == @geneid            
#> [3]     FILTER l.`log10pvalue` > @threshold
#> [4]     RETURN l
```

The help page
[`?db_queries`](https://IGVF.github.io/rigvf/reference/db_queries.md)
outlines other available user-facing functions. See
[`?arango`](https://IGVF.github.io/rigvf/reference/arango.md) for more
developer-oriented information.

## Use with Bioconductor

### Compute overlap with *plyranges*

We can query genomic elements using
[`elements()`](https://IGVF.github.io/rigvf/reference/catalog_queries.md)
and then compute overlaps with the *plyranges* package as below. See the
[plyranges](https://github.com/tidyomics/plyranges) package
documentation for more examples.

``` r

library(plyranges)
library(tibble)
rng <- data.frame(seqnames="chr1", start=10e6+1, end=10.1e6) |>
  as_granges()

e <- elements(rng, limit=200L) |>
  filter(source != "ENCODE_EpiRaction")
e
#> GRanges object with 200 ranges and 5 metadata columns:
#>         seqnames            ranges strand |                   name
#>            <Rle>         <IRanges>  <Rle> |            <character>
#>     [1]     chr1 10001018-10001351      * |           EH38E1317660
#>     [2]     chr1 10001823-10002161      * |           EH38E3954141
#>     [3]     chr1 10002812-10003022      * |           EH38E3954142
#>     [4]     chr1 10006462-10006688      * |           EH38E3954143
#>     [5]     chr1 10007231-10007550      * |           EH38E2785201
#>     ...      ...               ...    ... .                    ...
#>   [196]     chr1 10000983-10001482      * | genic_chr1_10000982_..
#>   [197]     chr1 10000983-10001482      * | genic_chr1_10000982_..
#>   [198]     chr1 10000983-10001482      * | genic_chr1_10000982_..
#>   [199]     chr1 10000983-10001482      * | genic_chr1_10000982_..
#>   [200]     chr1 10000983-10001482      * | genic_chr1_10000982_..
#>              source_annotation                   type      source
#>                    <character>            <character> <character>
#>     [1] dELS: distal Enhance.. candidate cis regula..      ENCODE
#>     [2]         TF: TF binding candidate cis regula..      ENCODE
#>     [3] dELS: distal Enhance.. candidate cis regula..      ENCODE
#>     [4] CA: chromatin access.. candidate cis regula..      ENCODE
#>     [5] dELS: distal Enhance.. candidate cis regula..      ENCODE
#>     ...                    ...                    ...         ...
#>   [196]                  genic accessible dna eleme..      ENCODE
#>   [197]                  genic accessible dna eleme..      ENCODE
#>   [198]                  genic accessible dna eleme..      ENCODE
#>   [199]                  genic accessible dna eleme..      ENCODE
#>   [200]                  genic accessible dna eleme..      ENCODE
#>                     source_url
#>                    <character>
#>     [1] https://www.encodepr..
#>     [2] https://www.encodepr..
#>     [3] https://www.encodepr..
#>     [4] https://www.encodepr..
#>     [5] https://www.encodepr..
#>     ...                    ...
#>   [196] https://www.encodepr..
#>   [197] https://www.encodepr..
#>   [198] https://www.encodepr..
#>   [199] https://www.encodepr..
#>   [200] https://www.encodepr..
#>   -------
#>   seqinfo: 1 sequence from hg38 genome; no seqlengths
```

``` r

tiles <- tile_ranges(rng, width=10e3) %>%
  select(-partition) %>%
  mutate(id = letters[seq_along(.)])

# count overlaps of central basepair of elements in tiles
e |>
  anchor_center() |>
  mutate(width = 1) |>
  join_overlap_left(tiles) |>
  tibble::as_tibble() |>
  dplyr::count(id)
#> # A tibble: 10 × 2
#>    id        n
#>    <chr> <int>
#>  1 a       100
#>  2 b        13
#>  3 c        10
#>  4 d        15
#>  5 e        11
#>  6 f        15
#>  7 g        12
#>  8 h        12
#>  9 i         7
#> 10 j         5
```

### Plot variants with *plotgardener*

Below we show a simple example of plotting variants and elements in a
gene context, using the *plotgardener* package.

First selecting some variants around the gene *GCK* (reminder that we
only obtain the first `limit` number of variants, see ?catalog_queries
for more details).

``` r

# up to 200 variants:
v <- gene_variants(gene_name = "GCK", limit=200L, verbose=TRUE) |>
  dplyr::select(-c(gene, source, source_url)) |>
  tidyr::unnest_wider(sequence_variant) |>
  dplyr::rename(seqnames = chr) |>
  dplyr::mutate(start = pos + 1, end = pos + 1) |>
  as_granges()
```

We then load *plotgardener* and define some default parameters.

``` r

library(plotgardener)
par <- pgParams(
  chrom = "chr7",
  chromstart = 44.1e6,
  chromend = 44.25e6,
  assembly = "hg38",
  just = c("left", "bottom")
)
```

Renaming some columns:

``` r

v_for_plot <- v |>
  select(snp = rsid, p = log10pvalue, effect_size)
```

To match with the correct gene annotation, we could explicitly define
the transcript database using
[`plotgardener::assembly()`](https://phanstiellab.github.io/plotgardener/reference/assembly.html),
where we would provide a database built by running
`GenomicFeatures::makeTxDbFromGFF()` on a GENCODE GTF file. Here we use
one of the standard hg38 TxDb with UCSC-style chromosome names.

``` r

library(TxDb.Hsapiens.UCSC.hg38.knownGene)
#> Loading required package: GenomicFeatures
#> Loading required package: AnnotationDbi
#> Loading required package: Biobase
#> Welcome to Bioconductor
#> 
#>     Vignettes contain introductory material; view with
#>     'browseVignettes()'. To cite Bioconductor, see
#>     'citation("Biobase")', and for packages 'citation("pkgname")'.
#> Registered S3 method overwritten by 'bit64':
#>   method          from 
#>   print.bitstring tools
#> 
#> Attaching package: 'AnnotationDbi'
#> The following object is masked from 'package:dplyr':
#> 
#>     select
library(org.Hs.eg.db)
#> 
```

Below we build the page and populate it with annotation from the *TxDb*
used by *plotgardener* and from IGVF Catalog.

``` r

pageCreate(width = 5, height = 4, showGuides = FALSE)
plotGenes(
  params = par, x = 0.5, y = 3.5, width = 4, height = 1
)
#> genes[genes1]
plotGenomeLabel(
  params = par,
  x = 0.5, y = 3.5, length = 4,
  just = c("left", "top")
)
#> genomeLabel[genomeLabel1]
mplot <- plotManhattan(
  params = par, x = 0.5, y = 2.5, width = 4, height = 2,
  v_for_plot, trans = "",
  sigVal = -log10(5e-8), sigLine = TRUE, col = "grey", lty = 2
)
#> manhattan[manhattan1]
annoYaxis(
    plot = mplot, at=0:4 * 4, axisLine = TRUE, fontsize = 8
)
#> yaxis[yaxis1]
annoXaxis(
    plot = mplot, axisLine = TRUE, label = FALSE
)
#> xaxis[xaxis1]
plotText(
    params = par,
    label = "-log10(p-value)", x = 0.2, y = 2, rot = 90,
    fontsize = 8, fontface = "bold",
    default.units = "inches"
)
```

![Manhattan of IGVF annotated
variants](rigvf_files/figure-html/plotgardener-1.png)

    #> text[text1]

## Session info

``` r

sessionInfo()
#> R Under development (unstable) (2026-04-12 r89873)
#> Platform: x86_64-pc-linux-gnu
#> Running under: Ubuntu 24.04.4 LTS
#> 
#> Matrix products: default
#> BLAS:   /usr/lib/x86_64-linux-gnu/openblas-pthread/libblas.so.3 
#> LAPACK: /usr/lib/x86_64-linux-gnu/openblas-pthread/libopenblasp-r0.3.26.so;  LAPACK version 3.12.0
#> 
#> locale:
#>  [1] LC_CTYPE=en_US.UTF-8       LC_NUMERIC=C              
#>  [3] LC_TIME=en_US.UTF-8        LC_COLLATE=en_US.UTF-8    
#>  [5] LC_MONETARY=en_US.UTF-8    LC_MESSAGES=en_US.UTF-8   
#>  [7] LC_PAPER=en_US.UTF-8       LC_NAME=C                 
#>  [9] LC_ADDRESS=C               LC_TELEPHONE=C            
#> [11] LC_MEASUREMENT=en_US.UTF-8 LC_IDENTIFICATION=C       
#> 
#> time zone: UTC
#> tzcode source: system (glibc)
#> 
#> attached base packages:
#> [1] stats4    stats     graphics  grDevices utils     datasets  methods  
#> [8] base     
#> 
#> other attached packages:
#>  [1] org.Hs.eg.db_3.23.1                     
#>  [2] TxDb.Hsapiens.UCSC.hg38.knownGene_3.22.0
#>  [3] GenomicFeatures_1.63.2                  
#>  [4] AnnotationDbi_1.73.1                    
#>  [5] Biobase_2.71.0                          
#>  [6] plotgardener_1.17.0                     
#>  [7] tibble_3.3.1                            
#>  [8] plyranges_1.31.7                        
#>  [9] dplyr_1.2.1                             
#> [10] GenomicRanges_1.63.2                    
#> [11] Seqinfo_1.1.0                           
#> [12] IRanges_2.45.0                          
#> [13] S4Vectors_0.49.1-1                      
#> [14] BiocGenerics_0.57.0                     
#> [15] generics_0.1.4                          
#> [16] rigvf_1.3.7                             
#> 
#> loaded via a namespace (and not attached):
#>  [1] tidyselect_1.2.1            blob_1.3.0                 
#>  [3] farver_2.1.2                Biostrings_2.79.5          
#>  [5] S7_0.2.1-1                  bitops_1.0-9               
#>  [7] fastmap_1.2.0               RCurl_1.98-1.18            
#>  [9] GenomicAlignments_1.47.0    XML_3.99-0.23              
#> [11] digest_0.6.39               lifecycle_1.0.5            
#> [13] KEGGREST_1.51.1             RSQLite_2.4.6              
#> [15] magrittr_2.0.5              compiler_4.7.0             
#> [17] rlang_1.2.0                 sass_0.4.10                
#> [19] tools_4.7.0                 utf8_1.2.6                 
#> [21] yaml_2.3.12                 data.table_1.18.2.1        
#> [23] rtracklayer_1.71.3          knitr_1.51                 
#> [25] S4Arrays_1.11.1             htmlwidgets_1.6.4          
#> [27] bit_4.6.0                   curl_7.0.0                 
#> [29] DelayedArray_0.37.1         RColorBrewer_1.1-3         
#> [31] abind_1.4-8                 BiocParallel_1.45.0        
#> [33] withr_3.0.2                 purrr_1.2.2                
#> [35] desc_1.4.3                  grid_4.7.0                 
#> [37] Rhdf5lib_1.33.6             ggplot2_4.0.2              
#> [39] scales_1.4.0                SummarizedExperiment_1.41.1
#> [41] cli_3.6.6                   rmarkdown_2.31             
#> [43] crayon_1.5.3                ragg_1.5.2                 
#> [45] otel_0.2.0                  httr_1.4.8                 
#> [47] rjson_0.2.23                DBI_1.3.0                  
#> [49] cachem_1.1.0                rhdf5_2.55.16              
#> [51] parallel_4.7.0              ggplotify_0.1.3            
#> [53] XVector_0.51.0              restfulr_0.0.16            
#> [55] matrixStats_1.5.0           vctrs_0.7.3                
#> [57] yulab.utils_0.2.4           Matrix_1.7-5               
#> [59] jsonlite_2.0.0              gridGraphics_0.5-1         
#> [61] bit64_4.6.0-1               systemfonts_1.3.2          
#> [63] strawr_0.0.92               tidyr_1.3.2                
#> [65] jquerylib_0.1.4             glue_1.8.1                 
#> [67] pkgdown_2.2.0.9000          codetools_0.2-20           
#> [69] gtable_0.3.6                GenomeInfoDb_1.47.2        
#> [71] BiocIO_1.21.0               UCSC.utils_1.7.1           
#> [73] pillar_1.11.1               rhdf5filters_1.23.3        
#> [75] rappdirs_0.3.4              htmltools_0.5.9            
#> [77] R6_2.6.1                    httr2_1.2.2                
#> [79] textshaping_1.0.5           evaluate_1.0.5             
#> [81] lattice_0.22-9              png_0.1-9                  
#> [83] Rsamtools_2.27.2            cigarillo_1.1.0            
#> [85] memoise_2.0.1               bslib_0.10.0               
#> [87] rjsoncons_1.3.2             Rcpp_1.1.1-1               
#> [89] SparseArray_1.11.13         whisker_0.4.1              
#> [91] xfun_0.57                   fs_2.0.1                   
#> [93] MatrixGenerics_1.23.0       pkgconfig_2.0.3
```
