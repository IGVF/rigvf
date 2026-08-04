# Query the IGVF Data Portal

`portal_files()` searches for files on the IGVF Data Portal by content
type and optional additional filters. The API is documented at
<https://data.igvf.org/help/igvf-api-spec/>.

## Usage

``` r
portal_files(content_type, frame = "object", limit = 25L, ...)
```

## Arguments

- content_type:

  character(1) the content type of files to retrieve, e.g.
  `"reporter genomic variant effects"`.

- frame:

  character(1) `"object"` (default) returns full properties with
  embedded objects as URI paths; `"embedded"` fully expands nested
  objects.

- limit:

  integer(1) or `"all"` to return all matching results. Defaults to 25L.
  Note the portal rate limit is 10 requests/sec.

- ...:

  additional filter parameters passed as query parameters to `/search/`,
  e.g. `status = "released"`. Use the syntax `field != "value"` filters
  via named arguments where needed.

## Value

`portal_files()` returns a tibble of matching files, with columns
derived from the `@graph` array of the JSON-LD response.

## Details

Some columns in the returned tibble are list-columns where each element
is a length-1 character vector. Use `purrr::map_chr(column, 1)` to
flatten these before further manipulation.

## Examples

``` r
portal_files("reporter genomic variant effects")
#> # A tibble: 25 × 50
#>    `@id`      `@type` accession aliases analysis_step_version assay_titles award
#>    <chr>      <list>  <chr>     <list>  <list>                <list>       <chr>
#>  1 /tabular-… <chr>   IGVFFI12… <chr>   <chr [1]>             <chr [1]>    /awa…
#>  2 /tabular-… <chr>   IGVFFI33… <chr>   <chr [1]>             <chr [1]>    /awa…
#>  3 /tabular-… <chr>   IGVFFI31… <chr>   <chr [1]>             <chr [1]>    /awa…
#>  4 /tabular-… <chr>   IGVFFI66… <chr>   <chr [1]>             <chr [1]>    /awa…
#>  5 /tabular-… <chr>   IGVFFI84… <chr>   <chr [1]>             <chr [1]>    /awa…
#>  6 /tabular-… <chr>   IGVFFI22… <chr>   <chr [1]>             <chr [1]>    /awa…
#>  7 /tabular-… <chr>   IGVFFI10… <chr>   <chr [1]>             <chr [1]>    /awa…
#>  8 /tabular-… <chr>   IGVFFI76… <chr>   <NULL>                <chr [1]>    /awa…
#>  9 /tabular-… <chr>   IGVFFI24… <chr>   <chr [1]>             <chr [1]>    /awa…
#> 10 /tabular-… <chr>   IGVFFI02… <chr>   <NULL>                <chr [1]>    /awa…
#> # ℹ 15 more rows
#> # ℹ 43 more variables: checkfiles_version <chr>, content_md5sum <chr>,
#> #   content_type <chr>, controlled_access <lgl>, creation_timestamp <chr>,
#> #   derived_from <list>, derived_manually <lgl>, file_format <chr>,
#> #   file_format_specifications <list>, file_set <chr>, file_size <int>,
#> #   href <chr>, input_file_for <list>, lab <chr>, md5sum <chr>, notes <list>,
#> #   preferred_assay_slims <list>, preferred_assay_titles <list>, …

portal_files("reporter genomic variant effects", limit = 5L)
#> # A tibble: 5 × 44
#>   `@id`       `@type` accession aliases analysis_step_version assay_titles award
#>   <chr>       <list>  <chr>     <list>  <chr>                 <list>       <chr>
#> 1 /tabular-f… <chr>   IGVFFI12… <chr>   /analysis-step-versi… <chr [1]>    /awa…
#> 2 /tabular-f… <chr>   IGVFFI33… <chr>   /analysis-step-versi… <chr [1]>    /awa…
#> 3 /tabular-f… <chr>   IGVFFI31… <chr>   /analysis-step-versi… <chr [1]>    /awa…
#> 4 /tabular-f… <chr>   IGVFFI66… <chr>   /analysis-step-versi… <chr [1]>    /awa…
#> 5 /tabular-f… <chr>   IGVFFI84… <chr>   /analysis-step-versi… <chr [1]>    /awa…
#> # ℹ 37 more variables: checkfiles_version <chr>, content_md5sum <chr>,
#> #   content_type <chr>, controlled_access <lgl>, creation_timestamp <chr>,
#> #   derived_from <list>, derived_manually <lgl>, file_format <chr>,
#> #   file_format_specifications <list>, file_set <chr>, file_size <int>,
#> #   href <chr>, input_file_for <list>, lab <chr>, md5sum <chr>, notes <list>,
#> #   preferred_assay_slims <list>, preferred_assay_titles <list>,
#> #   release_timestamp <chr>, revoke_detail <list>, s3_uri <chr>, …
```
