# lossdevtapp 0.0.0.9000

## Bug Fixes

- Fix globals with rlang

## Configuration

- Add examples directory to Rbuildignore
- Bump roxygen version in DESCRIPTION
- Use custom github labels
- Git ignore html files
- Add cliff.toml for git-cliff
- Update Rbuildignore
- New covr package dep
- Re-configure cliff.toml for conventional commits
- Replace all magrittr pipe's (`%>%`) with new R pipe (`|>`)
- Import rlang's `.env` and `.data` for globalVariables
- Replace magrittr pipe
- Remove summaryrow dep

## Documentation

- Document the triangle bundle function
- Add initial CHANGELOG.md
- Update README with badges and installation instructions
- Add dataset documentation for issue #8
- Render data docs man pages
- Added a `NEWS.md` file to track changes to the package.

## Features

- Initialize the create_triangle_bundle function (#1, #2, #3)
- Create the triangle bundle function and export to NAMESPACE
- Add dependencies.R
- Add examples directory and example for triangle bundle
- Add git-cliff GHA
- Add code coverage and GHA
- Add R CMD Check GHA for issue #6
- Add PR Commands GHA for issue #6


