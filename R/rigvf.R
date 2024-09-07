#' @rdname rigvf
#'
#' @name rigvf
#'
#' @title Package configuration global variable management
#'
#' @description
#'
#' Objects documented on this page are for developer use.
#'
#' `rigvf_config` provides a simple interface to manage 'package
#' global' variables via `rigvf_config$get()`, `rigvf_config$set()`,
#' etc. The default `username` and `password` provide guest access.
#'
#' @format `rigvf_config` is a list of functions for listing
#'     (`ls()`)and manipulating (`get()`, `set()`, `unset()`)
#'     package-global variables.
rigvf_config <- local({
    ## environment & interface for ArangoDB configuration variables
    env <- new.env(parent = emptyenv())
    ls <- function() {
        base::ls(env)
    }
    get <- function(key) {
        if (!key %in% ls())
            stop("ArangoDB key '", key, "' not yet set")
        env[[key]]
    }
    set <- function(key, value) {
        if (!is.null(value)) {
            env[[key]] <- value
            get(key)
        } else {
            unset(key)
        }
    }
    unset <- function(key) {
        if (!key %in% ls()) {
            warning("ArangoDB unset key '", key, "' does not exist")
        } else {
            rm(list = key, envir = env)
        }
    }
    ## initial values
    set("catalog_host", "https://api.catalog.igvf.org")
    set("db_host", "https://db.catalog.igvf.org")
    set("db_name", "igvf")
    ## 'guest' as default user
    set("username", "guest")
    set("password", "guestigvfcatalog")
    ## functionality
    list(ls = ls, get = get, set = set)
})

rigvf_request <-
    function(base_url, path, ..., body = NULL, jwt_token = NULL)
{
    req <- request(base_url)
    req <- req_url_path_append(req, path)
    if (length(list(...)))
        req <- req_url_query(req, ...)
    if (!is.null(jwt_token))
        req <- req_auth_bearer_token(req, jwt_token)
    if (!is.null(body))
        req <- req_body_raw(req, body)
    response <- req_perform(req)

    resp_body_string(response)
}
