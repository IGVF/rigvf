library(rigvf)

files <- portal_files("reporter genomic variant effects", limit = 50L)

# bird : /documents/90f3e124-10d5-462c-8d54-981faf391595/
# FG spec : /documents/435a7653-996b-49cc-b8e3-ee790d1d7510/
# FG spec (additional PDF): /documents/e30fd259-68eb-4d9a-b82d-026938613515/

library(dplyr)
library(purrr)

files <- files |>
    mutate(
        file_format_specifications = factor(case_match(
            purrr::map_chr(file_format_specifications, 1),
            "/documents/90f3e124-10d5-462c-8d54-981faf391595/" ~ "bird",
            "/documents/435a7653-996b-49cc-b8e3-ee790d1d7510/" ~ "FG spec",
            "/documents/e30fd259-68eb-4d9a-b82d-026938613515/" ~ "FG spec"
        ))
    )

files |>
    count(status, file_format_specifications)

fg_released <- files |>
    filter(file_format_specifications == "FG spec", status == "released")

hrefs <- fg_released |>
    pull(href)

dest_dir <- "inst/scripts/portal_files"
dir.create(dest_dir, showWarnings = FALSE)

portal_host <- rigvf_config$get("portal_host")
to_download <- hrefs[!file.exists(file.path(dest_dir, basename(hrefs)))]
n_downloaded <- 0L
if (length(to_download) > 0) {
    for (href in to_download) {
        destfile <- file.path(dest_dir, basename(href))
        url <- paste0(portal_host, href)
        download.file(url, destfile, mode = "wb")
        n_downloaded <- n_downloaded + 1L
        message(n_downloaded, " / ", length(to_download), " downloaded: ", basename(href))
    }
}

read_spdi <- function(path) {
    readr::read_delim(
        path, delim = "\t", col_names = FALSE, show_col_types = FALSE
    ) |>
        dplyr::pull(4)
}

accessions <- fg_released |> pull(accession)
paths <- file.path(dest_dir, basename(hrefs))
spdi_list <- set_names(map(paths, read_spdi), accessions)

# check if they all look like SPDI
map_chr(spdi_list, 1)

# variants per file
sort(lengths(spdi_list))

all_spdi <- reduce(spdi_list, union)
length(all_spdi)

library(UpSetR)
top3_idx <- order(lengths(spdi_list), decreasing = TRUE)[1:3]
top3 <- spdi_list[top3_idx]

fg_released |>
    filter(accession %in% names(top3)) |>
    select(accession, lab)

upset(fromList(top3), nsets = 3)

