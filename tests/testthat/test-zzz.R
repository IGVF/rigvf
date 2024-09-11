test_that("functions are memoized", {
    expect_true(memoise::is.memoised(arango_auth))
    expect_true(memoise::is.memoised(arango_collections))
})
