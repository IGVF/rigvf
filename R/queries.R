#' @rdname queries
#'
#' @title Query the 'IGVF' 'ArangoDB'
#'
#' @description `edges()` and `nodes()` identify edges or nodes in the
#'     data base.
#'
#' @inheritParams arango_auth
#'
#' @return `edges()` and `nodes()` return a tibble with the edge or
#'     node name and count of occurrences in the database.
#'
#' @examples
#' edges()
#'
#' @export
edges <-
    function(
        username = arango_config$get("username"),
        password = arango_config$get("password"))
{
    collections <- arango_collections(username, password)
    tbl <- filter(collections, .data$type == "edge")
    tbl <- select(tbl, "name", "count")
    arrange(tbl, desc(.data$count))
}

#' @rdname queries
#'
#' @examples
#' nodes()
#'
#' @export
nodes <-
    function(
        username = arango_config$get("username"),
        password = arango_config$get("password"))
{
    collections <- arango_collections(username, password)
    tbl <- filter(
        collections, .data$type == "node", !startsWith(.data$name, "_")
    )
    tbl <- select(tbl, "name", "count")
    arrange(tbl, desc(.data$count))
}

#' @rdname queries
#'
#' @description `gene_variants()` locates variants associated with a
#'     (Ensembl) gene identifier.
#'
#' @param gene_id character(1) Ensembl gene identifier.
#'
#' @param threshold numeric(1) minimum score associated with the
#'     variant.
#'
#' @return `gene_variants()` returns a tibble summarizing variants
#'     associated with the gene.
#' 
#' @importFrom rjsoncons j_pivot
#'
#' @examples
#' gene_variants("ENSG00000106633", 0.85)
#'
#' @export
gene_variants <-
    function(
        gene_id, threshold,
        username = arango_config$get("username"),
        password = arango_config$get("password")
    )
{
    query <- paste(aql_template("gene_variants"), collapse = "\n")
    response <- arango_cursor(
        query,
        geneid  = paste0("genes/", gene_id),
        threshold = threshold,
        username = username, password = password
    )

    ## FIXME: what if there are no results?
    j_pivot(response, as = "tibble")
}
