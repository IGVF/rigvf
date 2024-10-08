% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/catalog.R
\name{catalog}
\alias{catalog}
\alias{gene_variants}
\title{Query the 'IGVF' REST API}
\usage{
gene_variants(
  gene_id = NULL,
  hgnc = NULL,
  gene_name = NULL,
  alias = NULL,
  organism = "Homo sapiens",
  verbose = FALSE
)
}
\arguments{
\item{gene_id}{character(1) Ensembl gene identifier, e.g., "ENSG00000106633"}

\item{hgnc}{character(1) HGNC identifier.}

\item{gene_name}{character(1) Gene symbol, e.g., "GCK"}

\item{alias}{character(1) Gene alias}

\item{organism}{character(1) Either 'Homo sapiens' (default) or
'Mus musculus'.}

\item{verbose}{logical(1) return additional information about
variants and genes.}
}
\value{
\code{gene_variants()} returns a tibble describing variants
associated with the gene; use \code{verbose = TRUE} to retrieve more
extensive information.
}
\description{
This page documents functions using the IGVF 'REST'
API, documented at \url{https://api.catalog.igvf.org/#}

\code{gene_variants()} locates GTEx eQTLs and splice QTLs
associate with a gene using the IGVF 'catalog' API. Only one of
\code{gene_id}, \code{hgnc}, \code{gene_name}, or \code{alias} should be specified.
}
\examples{
gene_variants(gene_name = "GCK")

response <- gene_variants(gene_name = "GCK", verbose = TRUE)
response
response |>
    dplyr::select(`sequence variant`) |>
    tidyr::unnest_wider(`sequence variant`)

}
