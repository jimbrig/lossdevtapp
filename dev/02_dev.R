
## Dependencies ----
## Amend DESCRIPTION with dependencies read from package code parsing
attachment::att_amend_desc()

## Add modules ----
## Create a module infrastructure in R/
golem::add_module(name = "triangles", with_test = TRUE) # Name of the module
golem::add_module(name = "ldf_modal", with_test = TRUE) # Name of the module
golem::add_module(name = "name_of_module2", with_test = TRUE)

## Add helper functions ----
## Creates fct_* and utils_*
golem::add_fct("aggregate_loss_data", with_test = TRUE)
golem::add_fct("derive_triangles", with_test = TRUE)
golem::add_fct("create_triangle_bundle", with_test = TRUE)
golem::add_utils("triangles", with_test = TRUE)
golem::add_utils("tables", module = "triangles", with_test = TRUE)

golem::add_utils("dates")

## External resources
## Creates .js and .css files at inst/app/www
golem::add_js_file("script")
golem::add_js_handler("handlers")
golem::add_css_file("custom")
golem::add_sass_file("custom")

## Add internal datasets ----
## If you have data in your package
usethis::use_data_raw(name = "loss_data", open = FALSE)

## Tests ----
## Add one line by test you want to create
usethis::use_test("app")

# Documentation

## Vignette ----
usethis::use_vignette("lossdevtapp")
devtools::build_vignettes()

## Code Coverage----
## Set the code coverage service ("codecov" or "coveralls")
usethis::use_coverage()
usethis::use_github_action("test-coverage")

# Create a summary readme for the testthat subdirectory
covrpage::covrpage()

## CI ----
## Use this part of the script if you need to set up a CI
## service for your application
##
## (You'll need GitHub there)
usethis::use_github()

# GitHub Actions
usethis::use_github_action()
# Chose one of the three
# See https://usethis.r-lib.org/reference/use_github_action.html
usethis::use_github_action_check_release()
usethis::use_github_action_check_standard()
usethis::use_github_action_check_full()
# Add action for PR
usethis::use_github_action_pr_commands()

# Travis CI
usethis::use_travis()
usethis::use_travis_badge()

# AppVeyor
usethis::use_appveyor()
usethis::use_appveyor_badge()

# Circle CI
usethis::use_circleci()
usethis::use_circleci_badge()

# Jenkins
usethis::use_jenkins()

# GitLab CI
usethis::use_gitlab_ci()

# You're now set! ----
# go to dev/03_deploy.R
rstudioapi::navigateToFile("dev/03_deploy.R")

library(templateeR)
templateeR::use_gh_labels()
templateeR::use_git_cliff()
templateeR::use_git_cliff_action()
