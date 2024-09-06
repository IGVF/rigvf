## `js_template()` separates JavaScript snippets from R code. JS
## snippets are in inst/js. They are templated following the
## 'mustache' convention, and the template populated using the
## {whisker} package.

## @param name the name of the template file, without the '.aql' or
##     '.js' extension, e.g., `'gene_variants'`.
##
## @param ... name-value pair used for template substitution following
##     the 'mustache' scheme as implemented by the {whisker} package,
##     e.g., `db_file_name = 'db file name'`.
##
#' @importFrom whisker whisker.render
js_template <-
    function(name, ...)
{
    language_template("js", name, ...)
}

aql_template <-
    function(name, ...)
{
    language_template("aql", name, ..., collapse = "\\n")
}

language_template <-
    function(language, name, ..., collapse = "\n")
{
    file <- paste0(name, ".", language)
    path <- system.file(package = "rigvf", language, file)
    lines <- readLines(path)
    template <- paste(lines, collapse = collapse)
    whisker.render(template, list(...))
}
