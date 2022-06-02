library(lossdevtapp)

data("loss_data")

string <- doc_data(losses, "Loss Data", "Claims Data", FALSE)

cat(string)
