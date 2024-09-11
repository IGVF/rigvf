test_that("language_template() works", {
    expect_true(is_scalar_character(aql_template("gene_variants")))
    expect_true(is_scalar_character(js_template("arango_auth")))
})
