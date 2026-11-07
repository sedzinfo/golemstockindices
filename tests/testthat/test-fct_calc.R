test_that("normalize_prices() starts every index at 100 on the first common date", {
  prices <- normalize_prices(history)
  expect_equal(min(prices$timestamp), as.Date("2024-02-29"))
  expect_equal(prices$index[prices$label == "Alpha (A)"], c(100, 90, 110))
  expect_equal(prices$index[prices$label == "Beta (B)"], c(100, 110, 50))
})

test_that("monthly_returns() compares the last close of each month", {
  calendar <- monthly_returns(history[history$label == "Alpha (A)", ])
  expect_equal(dimnames(calendar), list("2024", month.abb))
  expect_equal(unname(calendar["2024", c("Jan", "Feb", "Mar")]), c(NA, 10, 10))
  expect_true(all(is.na(calendar["2024", 4:12])))
})

test_that("moving_average() averages the last days once there are enough of them", {
  expect_equal(moving_average(c(1, 2, 3, 4, 5), days = 3), c(NA, NA, 2, 3, 4))
  expect_equal(moving_average(c(1, 2, 3), days = 1), c(1, 2, 3))
  expect_true(all(is.na(moving_average(1:5, days = 10))))
})

test_that("drawdown() measures how far each close is below the high so far", {
  expect_equal(drawdown(c(100, 120, 90, 130, 65)), c(0, 0, -25, 0, -50))
})

test_that("monthly_returns() refuses a history of several indices", {
  expect_error(monthly_returns(history), "holds 2 indices")
})

test_that("index_summary() says where each index stands against the day, year and high before", {
  one <- data.frame(
    label = "Alpha",
    timestamp = as.Date(c("2024-12-31", "2025-06-30", "2025-12-31", "2026-01-02", "2026-01-05")),
    close = c(100, 150, 120, 126, 132)
  )
  summary <- index_summary(one[c(5, 1:4), ])
  expect_equal(summary$date, as.Date("2026-01-05"))
  expect_equal(summary$close, 132)
  expect_equal(summary$day_pct, (132 / 126 - 1) * 100)
  # against the last close of 2025, and the last close on or before 5 January 2025
  expect_equal(summary$ytd_pct, 10)
  expect_equal(summary$year_pct, 32)
  expect_equal(c(summary$high, summary$from_high_pct), c(150, -12))
  expect_equal(summary$high_date, as.Date("2025-06-30"))
  expect_equal(summary$first_date, as.Date("2024-12-31"))
  # a history too short for a year has no change over a year, and the rows follow the history
  both <- index_summary(history)
  expect_equal(both$label, c("Alpha (A)", "Beta (B)"))
  expect_true(all(is.na(both$year_pct)))
})
