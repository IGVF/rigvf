catalog_request <-
    function(query, ...)
{
    rigvf_request(
        paste0(rigvf_config$get("catalog_host"), "/api"),
        query, ...
    )
}

#' @rdname catalog
#'
#' @name catalog
#'
#' @title Query the 'IGVF' REST API
#'
#' @description This page documents functions using the IGVF 'REST'
#'     API, documented at <https://api.catalog.igvf.org/#>
#'
#' @description `gene_variants()` locates GTEx eQTLs and splice QTLs
#'     associate with a gene using the IGVF 'catalog' API. Only one of
#'     `gene_id`, `hgnc`, `gene_name`, or `alias` should be specified.
#'
#' @param gene_id character(1) Ensembl gene identifier, e.g., "ENSG00000106633"
#'
#' @param hgnc character(1) HGNC identifier.
#'
#' @param gene_name character(1) Gene symbol, e.g., "GCK"
#'
#' @param alias character(1) Gene alias
#'
#' @param organism character(1) Either 'Homo sapiens' (default) or
#'     'Mus musculus'.
#'
#' @param verbose logical(1) return additional information about
#'     variants and genes.
#'
#' @return `gene_variants()` returns a tibble describing variants
#'     associated with the gene; use `verbose = TRUE` to retrieve more
#'     extensive information.
#'
#' @examples
#' gene_variants(gene_name = "GCK")
#'
#' response <- gene_variants(gene_name = "GCK", verbose = TRUE)
#' response
#' response |>
#'     dplyr::select(`sequence variant`) |>
#'     tidyr::unnest_wider(`sequence variant`)
#'
#' @export
gene_variants <-
    function(
        gene_id = NULL,
        hgnc = NULL,
        gene_name = NULL,
        alias = NULL,
        organism = "Homo sapiens",
        verbose = FALSE)
{
    organism <- match.arg(organism)
    stopifnot(
        `only one of 'gene_id', 'hgnc', 'gene_name', 'alias' must be non-NULL` =
            oneof_is_scalar_character(gene_id, hgnc, gene_name, alias),
        is_scalar_logical(verbose)
    )
        
    response <- catalog_request(
        "genes/variants",
        gene_id = gene_id,
        hgnc = hgnc,
        gene_name = gene_name,
        alias = alias,
        organism = organism,
        verbose = tolower(as.character(verbose))
    )
    j_pivot(response, as = "tibble")
}
