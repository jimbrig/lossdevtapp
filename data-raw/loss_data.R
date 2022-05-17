## code to prepare `loss_data` dataset goes here

loss_data <- qs::qread("data-raw/loss_data.qs")
loss_data_all <- qs::qread("data-raw/loss_data_all.qs")


usethis::use_data(loss_data, overwrite = TRUE)
usethis::use_data(loss_data_all)
