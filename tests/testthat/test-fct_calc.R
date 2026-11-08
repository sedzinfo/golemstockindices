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

test_that("index_summary() measures the change over a week and 1, 3, 6 and 9 months too", {
  days <- as.Date("2026-01-01") + 0:60
  one <- data.frame(label = "Alpha", timestamp = days, close = seq_along(days) + 99)
  summary <- index_summary(one)
  # the last close is on 2 March, 160; a week before, on 23 February, 153; a month before, on 2 February, 132
  expect_equal(summary$week_pct, (160 / 153 - 1) * 100)
  expect_equal(summary$month_pct, (160 / 132 - 1) * 100)
  expect_equal(
    names(summary)[4:11],
    c("day_pct", "week_pct", "month_pct", "month3_pct", "month6_pct", "month9_pct", "ytd_pct", "year_pct")
  )
  # two months of history: no change over 3 months or more
  expect_true(is.na(summary$month3_pct))
  # 300 days from 1 January 2026 end on 27 October; 3, 6 and 9 months before are 27 July, 27 April
  # and 27 January, the 208th, 117th and 27th days
  long <- data.frame(label = "Alpha", timestamp = as.Date("2026-01-01") + 0:299, close = 1:300)
  months <- index_summary(long)
  expect_equal(months$month3_pct, (300 / 208 - 1) * 100)
  expect_equal(months$month6_pct, (300 / 117 - 1) * 100)
  expect_equal(months$month9_pct, (300 / 27 - 1) * 100)
})

test_that("closes_text() gives the day most indices closed on, and the others by day", {
  all <- get_indices()
  friday <- as.Date("2026-11-06")
  summary <- data.frame(label = all$label, date = friday)
  expect_equal(closes_text(summary, all), "Daily closes from Yahoo Finance, up to 6 Nov 2026")
  # the hour of trading of Mumbai on Diwali, a Sunday, puts the Sensex ahead of the rest
  summary$date[summary$label == "Sensex"] <- as.Date("2026-11-08")
  expect_equal(closes_text(summary, all), "Daily closes from Yahoo Finance, up to 6 Nov 2026; 8 Nov 2026 for Sensex")
  # a weekday morning in Europe: Asia-Pacific has closed today, and a holiday keeps the Bovespa behind
  summary$date <- as.Date("2026-11-09")
  summary$date[all$region == "Asia-Pacific"] <- as.Date("2026-11-10")
  summary$date[summary$label == "Bovespa"] <- friday
  expect_equal(
    closes_text(summary, all),
    "Daily closes from Yahoo Finance, up to 9 Nov 2026; 10 Nov 2026 for the Asia-Pacific indices; 6 Nov 2026 for Bovespa"
  )
  # more than four indices that are not a whole region are counted, as the table has their days
  summary$date <- friday
  summary$date[summary$label %in% c("DAX", "CAC 40", "IBEX 35", "FTSE MIB", "SMI")] <- as.Date("2026-11-05")
  expect_equal(closes_text(summary, all), "Daily closes from Yahoo Finance, up to 6 Nov 2026; 5 Nov 2026 for 5 indices")
})
