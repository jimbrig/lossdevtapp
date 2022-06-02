library(lossdevtapp)

my_triangle <- dev_tri(
  origin = loss_data$accident_year,
  age = loss_data$devt,
  value = loss_data$payment,
  value_label = "paid",
  latest_eval_date = max(loss_data$eval_date)
)

class(my_triangle)
str(my_triangle)
print(my_triangle)
view.dev_tri(my_triangle)

