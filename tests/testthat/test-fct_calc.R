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

test_that("months_back() keeps the day of the month, or takes the last day of a shorter month", {
  expect_equal(
    months_back(as.Date(c("2025-03-31", "2025-05-31", "2025-12-31", "2024-03-31", "2026-01-15", "2025-03-15")), c(1, 3, 1, 1, 1, 0)),
    as.Date(c("2025-02-28", "2025-02-28", "2025-11-30", "2024-02-29", "2025-12-15", "2025-03-15"))
  )
  # a year is 12 months, so a year before 29 February is 28 February, not 1 March
  expect_equal(months_back(as.Date("2024-02-29"), 12), as.Date("2023-02-28"))
})

test_that("index_summary() counts back from the end of a month to the end of a shorter month", {
  # a close every day, 1 point higher each day, so that each day has a close of its own
  days <- seq(as.Date("2023-01-01"), as.Date("2025-05-31"), by = "day")
  one <- data.frame(label = "Alpha", timestamp = days, close = seq_along(days) + 99)
  close_on <- function(day) one$close[one$timestamp == as.Date(day)]
  up_to <- function(day) index_summary(one[one$timestamp <= as.Date(day), ])
  # a month before 31 March 2025 is 28 February, not 3 March
  expect_equal(up_to("2025-03-31")$month_pct, (close_on("2025-03-31") / close_on("2025-02-28") - 1) * 100)
  # 3 months before 31 May 2025 is 28 February too
  expect_equal(up_to("2025-05-31")$month3_pct, (close_on("2025-05-31") / close_on("2025-02-28") - 1) * 100)
  # a year before 29 February 2024 is 28 February 2023, not 1 March
  expect_equal(up_to("2024-02-29")$year_pct, (close_on("2024-02-29") / close_on("2023-02-28") - 1) * 100)
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

test_that("streak() counts the closes in a row that rose or fell", {
  expect_equal(streak(c(100, 99, 101, 102, 103)), 3L)
  expect_equal(streak(c(100, 101, 99, 98)), -2L)
  expect_equal(streak(c(1, 2, 3)), 2L)
  # a close that did not move ends a run, and a single close has none
  expect_equal(streak(c(1, 2, 2)), 0L)
  expect_equal(streak(c(1, 1, 2)), 1L)
  expect_equal(streak(5), 0L)
})

test_that("index_summary() measures the distance from the 200-day average and the 52-week low and high", {
  trading <- function(close) data.frame(label = "Alpha (A)", timestamp = weekdays_from("2024-01-01", length(close)), close = close)
  one <- trading(c(seq(100, 299), 250, 260))
  summary <- index_summary(one)
  last <- 260
  expect_equal(summary$streak, 1L)
  expect_equal(summary$average200, mean(utils::tail(one$close, 200)))
  expect_equal(summary$from_average200_pct, (last / mean(utils::tail(one$close, 200)) - 1) * 100)
  # 202 weekdays are less than a year: all of the history counts
  expect_equal(c(summary$low52, summary$high52), c(100, 299))
  expect_equal(summary$from_high52_pct, (last / 299 - 1) * 100)
  expect_equal(summary$from_low52_pct, (last / 100 - 1) * 100)
  # younger than 200 days: no average
  expect_true(is.na(index_summary(trading(1:50))$from_average200_pct))
  # the 52 weeks leave out the closes a year or more before
  long <- trading(c(1000, seq(100, by = 0.1, length.out = 299)))
  expect_equal(index_summary(long)$high52, max(long$close[-1]))
})

test_that("bollinger_bands() puts the bands two standard deviations of the window from its average", {
  close <- c(10, 11, 12, 11, 10, 12, 14)
  bands <- bollinger_bands(close, days = 3)
  window <- close[5:7]
  spread <- 2 * sqrt(mean((window - mean(window))^2))
  expect_equal(bands$middle[7], mean(window))
  expect_equal(c(bands$upper[7], bands$lower[7]), mean(window) + c(spread, -spread))
  expect_true(all(is.na(bands[1:2, ])))
  # flat prices give bands on the average
  expect_equal(bollinger_bands(rep(50, 25))$upper[25], 50)
  expect_equal(bollinger_bands(rep(4321.123, 25))$upper[25], 4321.123)
  # fewer closes than the window
  expect_true(all(is.na(bollinger_bands(1:5)$upper)))
})

test_that("rsi() follows Wilder's smoothing", {
  close <- garch_history(200)$close
  change <- diff(close)
  rise <- pmax(change, 0)
  fall <- pmax(-change, 0)
  up <- mean(rise[1:14])
  down <- mean(fall[1:14])
  expected <- rep(NA_real_, length(close))
  expected[15] <- 100 - 100 / (1 + up / down)
  for (i in 15:length(change)) {
    up <- (up * 13 + rise[i]) / 14
    down <- (down * 13 + fall[i]) / 14
    expected[i + 1] <- 100 - 100 / (1 + up / down)
  }
  expect_equal(rsi(close), expected)
  expect_equal(rsi(1:10, 3)[4:10], rep(100, 7))
  expect_equal(rsi(rep(5, 6), 3)[4:6], rep(50, 3))
  expect_true(all(is.na(rsi(1:3, 3))))
})

test_that("relative_prices() divides by the base, carrying its last close over its holidays", {
  prices <- data.frame(
    label = rep(c("Alpha (A)", "Beta (B)"), c(3, 2)),
    timestamp = as.Date("2024-01-01") + c(0:2, 0, 2),
    close = c(10, 12, 15, 100, 50),
    index = c(100, 120, 150, 100, 50)
  )
  relative <- relative_prices(prices, "Beta (B)")
  expect_equal(relative$label, rep("Alpha (A)", 3))
  # on 2 January Beta has no close, so its close of 1 January stands in
  expect_equal(relative$index, c(100, 120, 300))
  expect_equal(relative$base_index, c(100, 100, 50))
  expect_equal(unique(relative$base), "Beta (B)")
  expect_error(relative_prices(prices, "Gamma"), "base")
})
