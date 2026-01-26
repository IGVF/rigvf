# Internal interface to ArangoDB REST API

Objects documented on this page are for developer use.
`arango_request()` formulates 'GET' or 'POST' to the ArangoDB API.

`arango_auth()` uses username and password to authenticate against the
database.

`arango_collections()` implements the `_api/collection` endpoint for
available collections in the IGVF database.

`arango_cursor()` implements the `_api/cursor` endpoint to allow a
user-specified query of the IGVF database.

## Usage

``` r
arango_request(path, ..., body = NULL, jwt_token = NULL)

arango_auth(
  username = rigvf_config$get("username"),
  password = rigvf_config$get("password")
)

arango_collections(
  username = rigvf_config$get("username"),
  password = rigvf_config$get("password")
)

arango_cursor(
  query,
  ...,
  username = rigvf_config$get("username"),
  password = rigvf_config$get("password")
)
```

## Arguments

- path:

  character(1) path to the API end point. Note that database-specfic
  paths are prefixed with `/_db/igvf`.

- ...:

  for `arango_request()`, named arguments to be used a query parameters.
  for `arango_cursor()`, named arguments to be interpreted as bind
  variables in the query.

- body:

  if not NULL, formulate a POST request with JSON body.

- jwt_token:

  character(1) JWT token obtained via `arango_auth()`.

- username:

  character(1) ArangoDB user name. Default: "guest".

- password:

  character(1) ArangoDB password. Default: "guestigvfcatalog". A better
  practice is to use an environment variable to record the password,
  rather than encoding in a script, so
  `password = Sys.getenv("RIGVF_ARANGODB_PASSWORD")`.

- query:

  character(1) the FILE NAME (without extension `.aql` of the query
  template.

## Value

`arango_request()` returns the JSON response as a character(1) vector.

`arango_auth()` returns a JWT token to be used for authentication in
subsequent calls.

`arango_collections()` returns a tibble with columns `name`, `type`
(either 'node' or 'edge'), and `count`.

`arango_cursor()` returns the JSON character(1) 'result' of the query.

## Details

`arango_auth()` is 'memoized', so invoked only once per hour for a
particular user and password. The memoised result can be cleared with
`memoise::forget(arango_auth)`.

`arango_cursor()` expects queries to be written in package system files
in the `inst/aql` directory. This allows rapid iteration during query
development (the package does not need to re-loaded when the query is
updated) and some opportunity for language-specific highlighting if
supported by the developer's text editor.

## Examples

``` r
## available queries
templates <- system.file(package = "rigvf", "aql")
dir(templates)
#> [1] "gene_elements.aql" "gene_variants.aql"
```
