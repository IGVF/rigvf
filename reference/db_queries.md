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
#>    name                             count
#>    <chr>                            <dbl>
#>  1 variants_variants           5926156444
#>  2 coding_variants_phenotypes  1095997277
#>  3 variants_coding_variants     942649625
#>  4 variants_proteins            363274276
#>  5 genomic_elements_genes       118801843
#>  6 variants_biosamples           63552990
#>  7 variants_genes                18926336
#>  8 proteins_proteins             11486365
#>  9 variants_genomic_elements      8044057
#> 10 transcripts_genes_structure    4819495
#> # ℹ 25 more rows

db_nodes()
#> # A tibble: 25 × 2
#>    name                       count
#>    <chr>                      <dbl>
#>  1 variants              1870809859
#>  2 coding_variants        942423560
#>  3 genomic_elements        84155155
#>  4 mm_variants             53413453
#>  5 genes_structure          4819495
#>  6 json_schema_test         3538462
#>  7 mm_genes_structure       3142359
#>  8 genomic_elements_keep    2542843
#>  9 mm_genomic_elements       926843
#> 10 ontology_terms            620208
#> # ℹ 15 more rows

db_gene_variants("ENSG00000106633", threshold = 4.0)
#> # A tibble: 82 × 31
#>    `_key` `_id` `_from` `_to` `_rev` biological_context biological_process study
#>    <chr>  <chr> <chr>   <chr> <chr>  <chr>              <chr>              <chr>
#>  1 4d57e… vari… varian… gene… _kqEy… ontology_terms/UB… ontology_terms/GO… stud…
#>  2 ed83d… vari… varian… gene… _kqEy… ontology_terms/UB… ontology_terms/GO… stud…
#>  3 6b383… vari… varian… gene… _kqEy… ontology_terms/UB… ontology_terms/GO… stud…
#>  4 ee07e… vari… varian… gene… _kqEy… ontology_terms/UB… ontology_terms/GO… stud…
#>  5 9ecd9… vari… varian… gene… _kqEy… ontology_terms/UB… ontology_terms/GO… stud…
#>  6 cb382… vari… varian… gene… _kqE5… ontology_terms/UB… ontology_terms/GO… stud…
#>  7 1ae95… vari… varian… gene… _kqE5… ontology_terms/UB… ontology_terms/GO… stud…
#>  8 d2855… vari… varian… gene… _kqE5… ontology_terms/UB… ontology_terms/GO… stud…
#>  9 800da… vari… varian… gene… _kqE5… ontology_terms/UB… ontology_terms/GO… stud…
#> 10 3e45d… vari… varian… gene… _kqE5… ontology_terms/UB… ontology_terms/GO… stud…
#> # ℹ 72 more rows
#> # ℹ 23 more variables: simple_sample_summaries <list>, label <chr>,
#> #   source <chr>, source_url <chr>, name <chr>, inverse_name <chr>,
#> #   molecular_trait_id <chr>, gene_id <chr>, credible_set_id <chr>,
#> #   variant_chromosome_position_ref_alt <chr>, rsid <chr>,
#> #   credible_set_size <int>, posterior_inclusion_probability <dbl>,
#> #   p_value <dbl>, log10pvalue <dbl>, beta <dbl>, standard_error <dbl>, …

db_gene_elements("ENSG00000106633", threshold = 0.5)
#> # A tibble: 1,000 × 17
#>    `_key`              `_id` `_from` `_to` `_rev` method score source source_url
#>    <chr>               <chr> <chr>   <chr> <chr>  <chr>  <dbl> <chr>  <chr>     
#>  1 genic_chr7_4414528… geno… genomi… gene… _kspG… ENCOD… 0.991 ENCODE https://w…
#>  2 genic_chr7_4415493… geno… genomi… gene… _kspG… ENCOD… 0.836 ENCODE https://w…
#>  3 promoter_chr7_4415… geno… genomi… gene… _kspG… ENCOD… 1.000 ENCODE https://w…
#>  4 genic_chr7_4414530… geno… genomi… gene… _kspG… ENCOD… 0.945 ENCODE https://w…
#>  5 genic_chr7_4414594… geno… genomi… gene… _kspG… ENCOD… 0.980 ENCODE https://w…
#>  6 genic_chr7_4414649… geno… genomi… gene… _kspG… ENCOD… 0.680 ENCODE https://w…
#>  7 genic_chr7_4415740… geno… genomi… gene… _kspG… ENCOD… 0.689 ENCODE https://w…
#>  8 promoter_chr7_4415… geno… genomi… gene… _kspG… ENCOD… 1.000 ENCODE https://w…
#>  9 intergenic_chr7_44… geno… genomi… gene… _kspG… ENCOD… 0.824 ENCODE https://w…
#> 10 intergenic_chr7_44… geno… genomi… gene… _kspG… ENCOD… 0.503 ENCODE https://w…
#> # ℹ 990 more rows
#> # ℹ 8 more variables: files_filesets <chr>, biological_context <chr>,
#> #   treatments_term_ids <list>, name <chr>, inverse_name <chr>, class <chr>,
#> #   label <chr>, biosample_term <chr>
```
