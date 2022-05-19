## code to prepare `loss_data` dataset goes here

loss_data <- qs::qread("data-raw/loss_data.qs")
loss_data_all <- qs::qread("data-raw/loss_data_all.qs")


usethis::use_data(loss_data, overwrite = TRUE)
usethis::use_data(loss_data_all)
cat(docthis::doc_this("loss_data"), file = "R/data.R")
cat(paste0("\n\n\n", docthis::doc_this("loss_data_all")), file = "R/data.R", append = TRUE)
