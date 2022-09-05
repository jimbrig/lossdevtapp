usethis::use_vignette("data")
usethis::use_data_raw("claims_transactional")
golem::add_fct("simulate_claims")
usethis::use_r("dev-doc_data")


usethis::use_test("simulate_claims")
usethis::use_r("tri_tibble")

usethis::use_pkgdown_github_pages()

fs::dir_create("inst/db")
fs::file_copy("Dockerfile", "inst/app/Dockerfile")

usethis::use_r("app_header")
usethis::use_r("app_sidebar")
