library(lossdevtapp)
library(dplyr)

# create default paid triangle bundle
tri_paid_bundle <- create_triangle_bundle(loss_data_all)

# check out the structure
str(tri_paid_bundle)

# derive a similar bundle for reported dollars and counts
tri_rept_bundle <- create_triangle_bundle(loss_data_all, value_col = "reported")
tri_cnts_bundle <- create_triangle_bundle(loss_data_all, value_col = "n_claims")
