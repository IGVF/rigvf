#' @rdname db_queries
#' 
#' @name db_queries
#'
#' @title Query the IGVF Catalog via ArangoDB
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
#' db_edges()
#'
#' @export
db_edges <-
    function(
        username = rigvf_config$get("username"),
        password = rigvf_config$get("password"))
{
    stopifnot(
        is_scalar_character(username),
        is_scalar_character(password)
    )

    collections <- arango_collections(username, password)
    tbl <- filter(collections, .data$type == "edge")
    tbl <- select(tbl, "name", "count")
    arrange(tbl, desc(.data$count))
}

#' @rdname db_queries
#'
#' @examples
#' db_nodes()
#'
#' @export
db_nodes <-
    function(
        username = rigvf_config$get("username"),
        password = rigvf_config$get("password"))
{
    stopifnot(
        is_scalar_character(username),
        is_scalar_character(password)
    )

    collections <- arango_collections(username, password)
    tbl <- filter(
        collections, .data$type == "node", !startsWith(.data$name, "_")
    )
    tbl <- select(tbl, "name", "count")
    arrange(tbl, desc(.data$count))
}

#' @rdname db_queries
#'
#' @description `db_gene_variants()` locates variants associated with a
#'     (Ensembl) gene identifier.
#'
#' @param gene_id character(1) Ensembl gene identifier
#'
#' @param threshold numeric(1) minimum association statistic, minus log10 
#'     p-value for variants, and score for elements
#'
#' @return `db_gene_variants()` returns a tibble summarizing variants
#'     associated with the gene.
#' 
#' @importFrom rjsoncons j_pivot
#'
#' @examples
#' db_gene_variants("ENSG00000106633", threshold = 4.0)
#'
#' @export
db_gene_variants <-
    function(
        gene_id, threshold,
        username = rigvf_config$get("username"),
        password = rigvf_config$get("password")
    )
{
    stopifnot(
        is_scalar_character(gene_id),
        is_scalar_integer(threshold) || is_scalar_double(threshold),
        is_scalar_character(username),
        is_scalar_character(password)
    )

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

#' @rdname db_queries
#'
#' @description `db_gene_elements()` locates genomic elements associated with a
#'     (Ensembl) gene identifier.
#'
#' @return `db_gene_elements()` returns a tibble summarizing genomic elements
#'     associated with the gene.
#'
#' @examples
#' db_gene_elements("ENSG00000106633", threshold = 0.5)
#'
#' @export
db_gene_elements <-
    function(
        gene_id, threshold,
        username = rigvf_config$get("username"),
        password = rigvf_config$get("password")
    )
{
    stopifnot(
        is_scalar_character(gene_id),
        is_scalar_integer(threshold) || is_scalar_double(threshold),
        is_scalar_character(username),
        is_scalar_character(password)
    )

    query <- paste(aql_template("gene_elements"), collapse = "\n")
    response <- arango_cursor(
        query,
        geneid  = paste0("genes/", gene_id),
        threshold = threshold,
        username = username, password = password
    )

    ## FIXME: what if there are no results?
    j_pivot(response, as = "tibble")
}
