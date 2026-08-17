# Query the IGVF Catalog via ArangoDB

`edges()` and `nodes()` identify edges or nodes in the data base.

`db_gene_variants()` locates variants associated with a (Ensembl) gene
identifier.

`db_gene_elements()` locates genomic elements associated with a
(Ensembl) gene identifier.

## Usage

``` r
db_edges(
  username = rigvf_config$get("username"),
  password = rigvf_config$get("password")
)

db_nodes(
  username = rigvf_config$get("username"),
  password = rigvf_config$get("password")
)

db_gene_variants(
  gene_id,
  threshold,
  username = rigvf_config$get("username"),
  password = rigvf_config$get("password")
)

db_gene_elements(
  gene_id,
  threshold,
  username = rigvf_config$get("username"),
  password = rigvf_config$get("password")
)
```

## Arguments

- username:

  character(1) ArangoDB user name. Default: "guest".

- password:

  character(1) ArangoDB password. Default: "guestigvfcatalog". A better
  practice is to use an environment variable to record the password,
  rather than encoding in a script, so
  `password = Sys.getenv("RIGVF_ARANGODB_PASSWORD")`.

- gene_id:

  character(1) Ensembl gene identifier

- threshold:

  numeric(1) minimum association statistic, minus log10 p-value for
  variants, and score for elements

## Value

`edges()` and `nodes()` return a tibble with the edge or node name and
count of occurrences in the database.

`db_gene_variants()` returns a tibble summarizing variants associated
with the gene.

`db_gene_elements()` returns a tibble summarizing genomic elements
associated with the gene.

## Examples

``` r
db_edges()
#> # A tibble: 35 × 2
#>    name                                   count
#>    <chr>                                  <dbl>
#>  1 variants_variants                 5926156444
#>  2 coding_variants_phenotypes        1096014005
#>  3 variants_coding_variants           942433097
#>  4 variants_proteins                  363608815
#>  5 genomic_elements_genes             187515481
#>  6 variants_biosamples                 76034335
#>  7 variants_genes                      18926583
#>  8 proteins_proteins                   11486365
#>  9 transcripts_genes_structure          4819495
#> 10 mm_transcripts_mm_genes_structure    3142359
#> # ℹ 25 more rows

db_nodes()
#> # A tibble: 27 × 2
#>    name                     count
#>    <chr>                    <dbl>
#>  1 variants            1870948004
#>  2 coding_variants      942423560
#>  3 genomic_elements      93483021
#>  4 mm_variants           53413453
#>  5 variants_IGVF         17338787
#>  6 genes_structure        4819495
#>  7 mm_genes_structure     3142359
#>  8 mm_genomic_elements     926843
#>  9 ontology_terms          869236
#> 10 mm_transcripts          278375
#> # ℹ 17 more rows

db_gene_variants("ENSG00000106633", threshold = 4.0)
#> # A tibble: 0 × 0

db_gene_elements("ENSG00000106633", threshold = 0.5)
#> # A tibble: 1,000 × 17
#>    `_key`              `_id` `_from` `_to` `_rev` method score source source_url
#>    <chr>               <chr> <chr>   <chr> <chr>  <chr>  <dbl> <chr>  <chr>     
#>  1 genic_chr7_4414528… geno… genomi… gene… _lSmr… ENCOD… 0.991 ENCODE https://w…
#>  2 genic_chr7_4415493… geno… genomi… gene… _lSmr… ENCOD… 0.836 ENCODE https://w…
#>  3 promoter_chr7_4415… geno… genomi… gene… _lSmr… ENCOD… 1.000 ENCODE https://w…
#>  4 genic_chr7_4414530… geno… genomi… gene… _lSms… ENCOD… 0.945 ENCODE https://w…
#>  5 genic_chr7_4414594… geno… genomi… gene… _lSms… ENCOD… 0.980 ENCODE https://w…
#>  6 genic_chr7_4414649… geno… genomi… gene… _lSms… ENCOD… 0.680 ENCODE https://w…
#>  7 genic_chr7_4415740… geno… genomi… gene… _lSms… ENCOD… 0.689 ENCODE https://w…
#>  8 promoter_chr7_4415… geno… genomi… gene… _lSms… ENCOD… 1.000 ENCODE https://w…
#>  9 intergenic_chr7_44… geno… genomi… gene… _lSms… ENCOD… 0.824 ENCODE https://w…
#> 10 intergenic_chr7_44… geno… genomi… gene… _lSms… ENCOD… 0.503 ENCODE https://w…
#> # ℹ 990 more rows
#> # ℹ 8 more variables: files_filesets <chr>, biological_context <chr>,
#> #   treatments_term_ids <list>, name <chr>, inverse_name <chr>, class <chr>,
#> #   label <chr>, biosample_term <chr>
```
