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
#> # A tibble: 25 × 19
#>    gene     sequence_variant effect_size neg_log10_pvalue posterior_inclusion_…¹
#>    <chr>    <chr>                  <dbl>            <dbl>                  <dbl>
#>  1 genes/E… variants/NC_000…      -1.01              9.06                 0.0599
#>  2 genes/E… variants/NC_000…      -0.347             7.93                 0.200 
#>  3 genes/E… variants/NC_000…      -0.565             6.93                 0.103 
#>  4 genes/E… variants/NC_000…       0.378             8.22                 0.0720
#>  5 genes/E… variants/NC_000…      -0.319             6.92                 0.0422
#>  6 genes/E… variants/NC_000…       0.349             7.54                 0.0170
#>  7 genes/E… variants/NC_000…      -1.02              9.39                 0.144 
#>  8 genes/E… variants/NC_000…      -0.340            10.2                  0.0234
#>  9 genes/E… variants/NC_000…      -0.486             7.03                 0.0129
#> 10 genes/E… variants/NC_000…       0.262             4.45                 0.138 
#> # ℹ 15 more rows
#> # ℹ abbreviated name: ¹​posterior_inclusion_probability
#> # ℹ 14 more variables: standard_error <dbl>, z_score <dbl>,
#> #   credible_set_min_r2 <dbl>, method <chr>, source <chr>, source_url <chr>,
#> #   label <chr>, p_value <dbl>, biological_context <chr>, biosample_term <chr>,
#> #   study <chr>, name <chr>, class <chr>, files_filesets <chr>

rigvf::gene_variants(gene_name = "GCK", effect_size="gt:0.5")
#> # A tibble: 0 × 0

rigvf::gene_variants(gene_name = "GCK", verbose = TRUE)
#> # A tibble: 25 × 19
#>    gene              sequence_variant  effect_size neg_log10_pvalue
#>    <list>            <list>                  <dbl>            <dbl>
#>  1 <named list [15]> <named list [15]>      -1.01              9.06
#>  2 <named list [15]> <named list [15]>      -0.347             7.93
#>  3 <named list [15]> <named list [15]>      -0.565             6.93
#>  4 <named list [15]> <named list [15]>       0.378             8.22
#>  5 <named list [15]> <named list [15]>      -0.319             6.92
#>  6 <named list [15]> <named list [15]>       0.349             7.54
#>  7 <named list [15]> <named list [15]>      -1.02              9.39
#>  8 <named list [15]> <named list [15]>      -0.340            10.2 
#>  9 <named list [15]> <named list [15]>      -0.486             7.03
#> 10 <named list [15]> <named list [15]>       0.262             4.45
#> # ℹ 15 more rows
#> # ℹ 15 more variables: posterior_inclusion_probability <dbl>,
#> #   standard_error <dbl>, z_score <dbl>, credible_set_min_r2 <dbl>,
#> #   method <chr>, source <chr>, source_url <chr>, label <chr>, p_value <dbl>,
#> #   biological_context <chr>, biosample_term <chr>, study <list>, name <chr>,
#> #   class <chr>, files_filesets <chr>

rigvf::variant_genes(spdi = "NC_000001.11:920568:G:A")
#> # A tibble: 0 × 0

rigvf::gene_elements(gene_id = "ENSG00000187961")
#> # A tibble: 25 × 27
#>    name   label method class source source_url biological_context biosample_term
#>    <chr>  <chr> <chr>  <chr> <chr>  <chr>      <chr>              <chr>         
#>  1 expre… regu… Pertu… obse… IGVF   https://d… HCASMC-hTERT       ontology_term…
#>  2 expre… regu… Pertu… obse… IGVF   https://d… HCASMC-hTERT       ontology_term…
#>  3 expre… regu… Pertu… obse… IGVF   https://d… HCASMC-hTERT       ontology_term…
#>  4 expre… regu… Pertu… obse… IGVF   https://d… HCASMC-hTERT       ontology_term…
#>  5 expre… regu… Pertu… obse… IGVF   https://d… HCASMC-hTERT       ontology_term…
#>  6 expre… regu… Pertu… obse… IGVF   https://d… HCASMC-hTERT       ontology_term…
#>  7 expre… regu… Pertu… obse… IGVF   https://d… HCASMC-hTERT       ontology_term…
#>  8 expre… regu… Pertu… obse… IGVF   https://d… HCASMC-hTERT       ontology_term…
#>  9 expre… regu… Pertu… obse… IGVF   https://d… HCASMC-hTERT       ontology_term…
#> 10 expre… regu… Pertu… obse… IGVF   https://d… HCASMC-hTERT       ontology_term…
#> # ℹ 15 more rows
#> # ℹ 19 more variables: cell_annotation <list>, cell_annotation_term <list>,
#> #   files_filesets <chr>, crispr_modality <chr>, score <list>,
#> #   transcription_start_site <list>, rna_pseudobulk_tpm <list>, log2FC <dbl>,
#> #   effect_size <list>, z_score <list>, t_score <list>, idr <list>,
#> #   p_value <dbl>, p_value_adj <dbl>, neg_log10_pvalue <dbl>,
#> #   neg_log10_pvalue_adj <dbl>, significant <lgl>, genomic_element <chr>, …

rng <- GenomicRanges::GRanges("chr1", IRanges::IRanges(1157520,1158189))

rigvf::elements(range = rng)
#> GRanges object with 25 ranges and 5 metadata columns:
#>        seqnames          ranges strand |                   name
#>           <Rle>       <IRanges>  <Rle> |            <character>
#>    [1]     chr1 1157437-1157782      * |           EH38E2777055
#>    [2]     chr1 1157886-1158053      * |           EH38E2777056
#>    [3]     chr1 1158136-1158445      * |           EH38E1310547
#>    [4]     chr1 1156965-1157764      * | enhancer_chr1_115696..
#>    [5]     chr1 1156972-1157746      * | enhancer_chr1_115697..
#>    ...      ...             ...    ... .                    ...
#>   [21]     chr1 1156585-1157825      * | intergenic_chr1_1156..
#>   [22]     chr1 1156586-1158733      * | intergenic_chr1_1156..
#>   [23]     chr1 1156595-1157836      * | intergenic_chr1_1156..
#>   [24]     chr1 1156595-1158733      * | intergenic_chr1_1156..
#>   [25]     chr1 1156609-1158905      * | intergenic_chr1_1156..
#>             source_annotation                   type      source
#>                   <character>            <character> <character>
#>    [1] dELS: distal Enhance.. candidate cis regula..      ENCODE
#>    [2] dELS: distal Enhance.. candidate cis regula..      ENCODE
#>    [3] dELS: distal Enhance.. candidate cis regula..      ENCODE
#>    [4]               enhancer accessible dna eleme..        IGVF
#>    [5]               enhancer accessible dna eleme..        IGVF
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
#>    [4] https://data.igvf.or..
#>    [5] https://data.igvf.or..
#>    ...                    ...
#>   [21] https://www.encodepr..
#>   [22] https://www.encodepr..
#>   [23] https://www.encodepr..
#>   [24] https://www.encodepr..
#>   [25] https://www.encodepr..
#>   -------
#>   seqinfo: 1 sequence from hg38 genome; no seqlengths

rigvf::element_genes(range = rng)
#> # A tibble: 25 × 27
#>    name   label method class source source_url biological_context biosample_term
#>    <chr>  <chr> <chr>  <chr> <chr>  <chr>      <list>             <list>        
#>  1 regul… pred… scE2G  pred… IGVF   https://d… <chr [1]>          <chr [1]>     
#>  2 regul… pred… scE2G  pred… IGVF   https://d… <chr [1]>          <chr [1]>     
#>  3 regul… pred… scE2G  pred… IGVF   https://d… <NULL>             <NULL>        
#>  4 regul… pred… ENCOD… pred… ENCODE https://w… <chr [1]>          <chr [1]>     
#>  5 regul… pred… ENCOD… pred… ENCODE https://w… <chr [1]>          <chr [1]>     
#>  6 regul… pred… ENCOD… pred… ENCODE https://w… <chr [1]>          <chr [1]>     
#>  7 regul… pred… ENCOD… pred… ENCODE https://w… <chr [1]>          <chr [1]>     
#>  8 regul… pred… ENCOD… pred… ENCODE https://w… <chr [1]>          <chr [1]>     
#>  9 regul… pred… ENCOD… pred… ENCODE https://w… <chr [1]>          <chr [1]>     
#> 10 regul… pred… ENCOD… pred… ENCODE https://w… <chr [1]>          <chr [1]>     
#> # ℹ 15 more rows
#> # ℹ 19 more variables: cell_annotation <list>, cell_annotation_term <list>,
#> #   files_filesets <chr>, crispr_modality <list>, score <dbl>,
#> #   transcription_start_site <list>, rna_pseudobulk_tpm <list>, log2FC <list>,
#> #   effect_size <list>, z_score <list>, t_score <list>, idr <list>,
#> #   p_value <list>, p_value_adj <list>, neg_log10_pvalue <list>,
#> #   neg_log10_pvalue_adj <list>, significant <list>, genomic_element <chr>, …
```
