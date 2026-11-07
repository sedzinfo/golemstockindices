# an index with a close every weekday from `from`
trading <- function(close, from = "2024-01-01") {
  data.frame(label = "Alpha (A)", timestamp = weekdays_from(from, length(close)), close = close)
}

# an index whose return on weekday k, from Tuesday 2 January 2024, is returns[k]
with_returns <- function(returns) trading(100 * cumprod(c(1, 1 + returns / 100)))

test_that("iso_week() and period_bounds() follow ISO 8601 weeks, Monday to Sunday", {
  expect_equal(iso_week(as.Date(c("2021-01-03", "2021-01-04", "2024-01-01", "2024-12-30", "2026-12-31"))), c(53, 1, 1, 1, 53))
  weeks <- period_bounds(as.Date(c("2024-02-14", "2024-02-29", "2024-12-31")), "week")
  expect_equal(weeks$start, as.Date(c("2024-02-12", "2024-02-26", "2024-12-30")))
  expect_equal(weeks$end, weeks$start + 6)
  months <- period_bounds(as.Date(c("2024-02-14", "2024-12-31")), "month")
  expect_equal(months$start, as.Date(c("2024-02-01", "2024-12-01")))
  expect_equal(months$end, as.Date(c("2024-02-29", "2024-12-31")))
})

test_that("seasonal_returns() keeps the complete periods of trading days", {
  # the weekdays from 1 January to Friday 10 May 2024: January has no month before it and May has
  # not ended
  history <- trading(seq(100, by = 1, length.out = 95))
  expect_equal(max(history$timestamp), as.Date("2024-05-10"))
  last_close <- function(month) utils::tail(history$close[format(history$timestamp, "%Y-%m") == month], 1)
  months <- seasonal_returns(history, "month")
  expect_equal(as.character(months$group), c("Feb", "Mar", "Apr"))
  expect_equal(levels(months$group), month.abb)
  expect_equal(months$start, as.Date(c("2024-02-01", "2024-03-01", "2024-04-01")))
  # March ended on Friday the 29th, its last weekday
  expect_equal(months$return_pct[2], (last_close("2024-03") / last_close("2024-02") - 1) * 100)
  # a day's return runs from the trading day before, so Monday's from Friday's close
  days <- seasonal_returns(history, "day")
  expect_equal(nrow(days), 94)
  expect_equal(levels(days$group), c("Monday", "Tuesday", "Wednesday", "Thursday", "Friday"))
  expect_equal(as.character(days$group[1:5]), c("Tuesday", "Wednesday", "Thursday", "Friday", "Monday"))
  expect_equal(days$return_pct[1], 1)
  # week 1 has no week before it, and the week of Friday 10 May ended with it
  weeks <- seasonal_returns(history, "week")
  expect_equal(as.integer(as.character(weeks$group)), 2:19)
  expect_equal(max(weeks$end), as.Date("2024-05-12"))
})

test_that("seasonal_returns() leaves out a day after a gap in the data, and sorts the history", {
  # Wednesday 3 to Tuesday 9 January are missing, but a holiday on Thursday 11 January is not a gap
  history <- trading(seq(100, by = 1, length.out = 12))[-c(3:7, 9), ]
  days <- seasonal_returns(history[c(6, 1:5), ], "day")
  expect_equal(days$start, as.Date(c("2024-01-02", "2024-01-12", "2024-01-15", "2024-01-16")))
  expect_false(is.unsorted(days$start))
})

test_that("seasonal_returns() puts the years in the US presidential cycle", {
  ends <- as.Date(paste0(2015:2021, "-12-31"))
  years <- seasonal_returns(data.frame(timestamp = ends, close = c(1, 2, 4, 2, 1, 3, 9)), "year")
  expect_equal(
    as.character(years$group),
    c("Election year", "Post-election", "Midterm", "Pre-election", "Election year", "Post-election")
  )
  expect_equal(levels(years$group), c("Post-election", "Midterm", "Pre-election", "Election year"))
  expect_equal(years$return_pct, c(100, 100, -50, -50, 200, 200))
  expect_error(seasonal_returns(trading(1:3), "decade"))
  expect_error(seasonal_returns(history, "day"), "indices")
})

test_that("seasonality_analysis() sums up each group and finds a real difference", {
  # ten weeks from Tuesday 2 January 2024: Mondays rise by 10%, the other days fall by 1%
  dates <- weekdays_from("2024-01-01", 51)[-1]
  monday <- as.POSIXlt(dates)$wday == 1
  analysis <- seasonality_analysis(with_returns(ifelse(monday, 10, -1)), "day")
  groups <- analysis$groups
  expect_equal(as.character(groups$group), weekday_names)
  expect_equal(groups$returns, rep(10, 5))
  expect_equal(groups$mean_pct, c(10, rep(-1, 4)))
  expect_equal(groups$median_pct, c(10, rep(-1, 4)))
  expect_equal(groups$up_pct, c(100, rep(0, 4)))
  expect_equal(c(groups$best_pct[1], groups$worst_pct[2]), c(10, -1))
  expect_equal(analysis$all$returns, 50)
  expect_lt(analysis$p_value, 0.001)
  text <- seasonality_text(analysis)
  expect_match(text$groups$headline, "Best day: Monday, mean +10.00%", fixed = TRUE)
  expect_match(text$groups$points[1], "Monday: mean +10.00%, median +10.00%, up 10 of 10 times (100%).", fixed = TRUE)
  expect_match(text$chance$headline, "differ by more than chance usually gives (p < 0.001)", fixed = TRUE)
})

test_that("seasonality_analysis() finds no difference where every day gets the same returns", {
  # 35 weekdays: as 5 and 7 have no common factor, each day of the week gets each of the 7 returns
  # once (returns that binary fractions hold exactly, so that the ties stay ties)
  analysis <- seasonality_analysis(with_returns(c(100, 50, 0, -50, -25, 300, -75)[(1:35 - 1) %% 7 + 1]), "day")
  expect_equal(analysis$groups$mean_pct, rep(300 / 7, 5))
  expect_equal(analysis$p_value, 1)
  expect_match(seasonality_text(analysis)$chance$headline, "could well be chance (p = 1)", fixed = TRUE)
  # returns that are all the same do not break the test
  expect_equal(seasonality_analysis(trading(rep(100, 20)), "day")$p_value, 1)
})

test_that("seasonality_analysis() needs a complete period, and says when it cannot test", {
  expect_null(seasonality_analysis(trading(1:15), "month"))
  # the weekdays of January and February 2024: one return, of February
  analysis <- seasonality_analysis(trading(seq(100, by = 1, length.out = 44)), "month")
  expect_equal(nrow(analysis$groups), 1)
  expect_true(is.na(analysis$p_value))
  text <- seasonality_text(analysis)
  expect_match(text$groups$headline, "Only February so far", fixed = TRUE)
  expect_equal(text$chance$headline, "Too few months to test")
})

test_that("the best and the worst leave out groups with few returns, such as week 53", {
  analysis <- seasonality_analysis(garch_history(2000, seed = 2), "week")
  expect_true("53" %in% analysis$groups$group)
  analysis$groups$mean_pct[analysis$groups$group == "53"] <- 1000
  text <- seasonality_text(analysis)$groups
  expect_no_match(text$headline, "week 53")
  expect_match(text$points, "Left out of the best and the worst, with fewer than half the returns of the others: week 53", fixed = TRUE, all = FALSE)
})

test_that("seasonality_csv() names the group column after the period", {
  analysis <- seasonality_analysis(garch_history(800), "month")
  csv <- seasonality_csv(analysis)
  expect_equal(names(csv), c("month", "returns", "mean_pct", "median_pct", "up_pct", "best_pct", "worst_pct"))
  expect_equal(as.character(csv$month), month.abb)
})
