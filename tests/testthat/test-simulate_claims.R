test_that("claims_simulation works", {

  test_df <- simulate_claims()
  expect_equal(class(test_df), c("tbl_df", "tbl", "data.frame"))

})

test_that("claim simulation derives proper number of claims", {

  test_df <- simulate_claims(n_claims = 975)
  expect_equal(length(unique(test_df$claim_num)), 975)

})
