portal_request <-
    function(path, ...)
{
    rigvf_request(
        rigvf_config$get("portal_host"), path, ...
    )
}

#' @rdname portal_queries
#'
#' @name portal_queries
#'
#' @title Query the IGVF Data Portal
#'
#' @description `portal_files()` searches for files on the IGVF Data
#'     Portal by content type and optional additional filters. The API
#'     is documented at <https://data.igvf.org/help/igvf-api-spec/>.
#'
#' @param content_type character(1) the content type of files to
#'     retrieve, e.g. `"reporter genomic variant effects"`.
#'
#' @param frame character(1) `"object"` (default) returns full
#'     properties with embedded objects as URI paths; `"embedded"`
#'     fully expands nested objects.
#'
#' @param limit integer(1) or `"all"` to return all matching results.
#'     Defaults to 25L. Note the portal rate limit is 10 requests/sec.
#'
#' @param ... additional filter parameters passed as query parameters
#'     to `/search/`, e.g. `status = "released"`. Use the syntax
#'     `field != "value"` filters via named arguments where needed.
#'
#' @return `portal_files()` returns a tibble of matching files, with
#'     columns derived from the `@@graph` array of the JSON-LD response.
#'
#' @details Some columns in the returned tibble are list-columns 
#'     where each element is a length-1 character vector. Use
#'     `purrr::map_chr(column, 1)` to flatten these before further
#'     manipulation.
#'
#' @importFrom rjsoncons j_query j_pivot
#'
#' @examples
#' portal_files("reporter genomic variant effects")
#'
#' portal_files("reporter genomic variant effects", limit = 5L)
#'
#' @export
portal_files <-
    function(
        content_type,
        frame = "object",
        limit = 25L,
        ...)
{
    stopifnot(
        is_scalar_character(content_type),
        is_scalar_character(frame),
        is_scalar_integer(limit) || identical(limit, "all")
    )

    json <- portal_request(
        "/search/",
        type = "File",
        content_type = content_type,
        frame = frame,
        limit = limit,
        ...
    )

    j_pivot(j_query(json, '"@graph"'), as = "tibble")
}
