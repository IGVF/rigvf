devtools::load_all()

portal_limit <- 100L
files <- portal_files("reporter genomic variant effects", limit = portal_limit)

nrow(files)
stopifnot(nrow(files) < portal_limit)

# bird : /documents/90f3e124-10d5-462c-8d54-981faf391595/
# FG spec : /documents/435a7653-996b-49cc-b8e3-ee790d1d7510/
# FG spec (additional PDF): /documents/e30fd259-68eb-4d9a-b82d-026938613515/

library(dplyr)
library(purrr)

spec_map <- c(
    "/documents/90f3e124-10d5-462c-8d54-981faf391595/" = "bird",
    "/documents/435a7653-996b-49cc-b8e3-ee790d1d7510/" = "FG spec",
    "/documents/e30fd259-68eb-4d9a-b82d-026938613515/" = "FG spec"
)

files <- files |>
    mutate(
        file_format_specifications = factor(
            spec_map[purrr::map_chr(file_format_specifications, 1)]
        )
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

if (getOption("timeout") < 300)
    options(timeout = 300)

if (length(to_download) > 0) {
    for (href in to_download) {
        destfile <- file.path(dest_dir, basename(href))
        url <- paste0(portal_host, href)
        download.file(url, destfile, mode = "wb", 
        method = "wget", extra = "--progress=dot:mega")
        n_downloaded <- n_downloaded + 1L
        message(n_downloaded, " / ", length(to_download), 
        " downloaded: ", basename(href))
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

# get the big variant list
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

# this spec file downloaded on Aug 3 2026 from 
# https://data.igvf.org/documents/435a7653-996b-49cc-b8e3-ee790d1d7510/
spec_lines <- readLines("inst/scripts/portal_specs/mpra_fg_spec_2026-08-03.txt")
field_lines <- grep("^(string|uint|char|float)\\b", spec_lines, value = TRUE)
col_names <- sub("^\\S+\\s+(\\S+);.*", "\\1", field_lines)

read_fg <- function(path) {
    readr::read_delim(path, delim = "\t", col_names = col_names, show_col_types = FALSE)
}

coverage_summary <- map2_dfr(paths, accessions, \(path, acc) {
    dat <- read_fg(path)
    dat |>
        mutate(
            inputTotal  = inputCountRef  + inputCountAlt,
            outputTotal = outputCountRef + outputCountAlt
        ) |>
        summarize(
            accession  = acc,
            n_variants = n(),
            med_input  = median(inputTotal),
            med_output = median(outputTotal)
        )
})

fg_coverage <- fg_released |>
    select(accession, lab, status, href) |>
    left_join(coverage_summary, by = "accession")

fg_coverage

readr::write_csv(fg_coverage, "inst/scripts/fg_coverage.csv")

library(ggplot2)
library(ggrepel)
library(tidyr)

fg_coverage |>
    drop_na() |>
    mutate(lab_name = gsub("^/labs/|/$", "", lab)) |>
    pivot_longer(c(med_input, med_output), names_to = "measure", values_to = "median_coverage") |>
    mutate(measure = recode(measure, med_input = "Input", med_output = "Output")) |>
    ggplot(aes(n_variants, median_coverage, label = lab_name, color = lab_name)) +
    geom_point() +
    geom_text_repel(size = 3, max.overlaps = Inf) +
    facet_wrap(~measure, nrow = 1) +
    scale_x_log10() +
    scale_y_log10() +
    labs(
        x = "Number of variants (log10)", 
        y = "Median coverage (log10)", 
        title = "FG file coverage vs variant count") +
    theme_bw()

##########

# Annotate files with associated phenotypes via CLS
# Focus on files with < 1e5 variants (these are the designed assays)

fg_small <- fg_coverage |> filter(n_variants < 1e5)

# construct_library_sets is embedded in the analysis set response as a data frame;
# associated_phenotypes is a list column — [[1]]$term_name gives the character vector.

get_cls_info <- function(acc) {
    file_obj  <- jsonlite::fromJSON(portal_request(paste0("/files/", acc, "/")))
    aset_path <- file_obj$file_set$`@id`
    if (!grepl("^/analysis-sets/", aset_path))
        stop(acc, ": file_set is not an analysis set: ", aset_path)

    aset_obj <- jsonlite::fromJSON(portal_request(aset_path))
    cls_df   <- aset_obj$construct_library_sets

    list(
        n_cls       = NROW(cls_df),
        cls_summary = paste(cls_df$summary, collapse = "; "),
        phenotypes  = unique(unlist(map(cls_df$associated_phenotypes, \(ap) ap$term_name)))
    )
}

fg_phenotypes <- fg_small |>
    mutate(
        cls_info    = map(accession, get_cls_info),
        n_cls       = map_int(cls_info, "n_cls"),
        cls_summary = map_chr(cls_info, "cls_summary"),
        phenotypes  = map(cls_info, "phenotypes")
    ) |>
    select(-cls_info)

cls_summary_map <- readr::read_csv("inst/scripts/cls_summary_map.csv", show_col_types = FALSE)

fg_phenotypes <- fg_phenotypes |>
    left_join(cls_summary_map, by = "cls_summary")

fg_phenotypes |>
    filter(n_cls > 0) |>
    select(accession, lab, n_variants, n_cls, cls_short_summary, phenotypes)

fg_phenotypes |>
    filter(n_cls > 0) |>
    filter(!is.na(med_output)) |>
    mutate(lab_name = gsub("^/labs/|/$", "", lab)) |>
    ggplot(aes(n_variants, med_output, label = cls_short_summary, color = lab_name)) +
    geom_point() +
    geom_text_repel(size = 3, max.overlaps = Inf) +
    scale_x_log10() +
    scale_y_log10() +
    labs(x = "Number of variants (log10)", y = "Median output coverage (log10)",
         color = "Lab") +
    theme_bw()


##########

# Trace analysis set -> alignment file -> read_count

# Step 1: get the file object and extract its analysis set
file_obj <- jsonlite::fromJSON(portal_request("/files/IGVFFI8452UFGC/"))
analysis_set_path <- file_obj$file_set$`@id`

# Step 2: get the analysis set; files is a data frame of embedded file objects
aset_obj <- jsonlite::fromJSON(portal_request(analysis_set_path))
aln_accessions <- aset_obj$files |>
    filter(file_format == "bam", status == "released") |>
    pull(accession)

# Step 3: fetch each alignment file to get read_count
aln_objs <- lapply(aln_accessions, \(acc) 
jsonlite::fromJSON(portal_request(paste0("/files/", acc, "/"))))
map_dfr(aln_objs, \(f) tibble(accession = f$accession, 
    assembly = f$assembly, read_count = f$read_count))
