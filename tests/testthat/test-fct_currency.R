test_that("bad_rates() finds the wild rates, but not a real jump", {
  # a jump on day 31 that lasts, as the Swiss franc's in 2015, a rate ten times too low and one 9% too high
  rate <- c(rep(1.02, 30), rep(0.86, 30))
  rate[45] <- 0.086
  rate[50] <- 0.94
  expect_equal(which(bad_rates(rate)), c(45, 50))
  # a history too short for the windows is kept as it is
  expect_false(any(bad_rates(c(1, 10, 1))))
})

test_that("currency_rates() downloads the rates against the dollar, without weekends and wild rates", {
  days <- weekdays_from("2015-01-05", 40)
  rate <- c(rep(1.02, 20), rep(0.86, 20))
  rate[30] <- 0.086
  asked <- NULL
  local_mocked_bindings(index_histories = function(indices) {
    asked <<- indices$symbol
    # and a stray rate on Saturday 10 January
    list(data.frame(
      label = "CHF", timestamp = c(days, as.Date("2015-01-10")),
      open = c(rate, 5), high = c(rate, 5), low = c(rate, 5), close = c(rate, 5), volume = 0
    ))
  })
  rates <- currency_rates(c("CHF", "USD", NA, "CHF"))
  expect_equal(asked, "CHF=X")
  expect_named(rates, c("currency", "timestamp", "per_usd"))
  expect_equal(rates$timestamp, days[-30])
  expect_equal(rates$per_usd[rates$timestamp == days[21]], 0.86)
  # no currency to download, or a download that fails, gives no rates
  expect_equal(nrow(currency_rates(c("USD", NA))), 0)
  local_mocked_bindings(index_histories = function(indices) list(NULL))
  expect_equal(nrow(currency_rates("CHF")), 0)
})

test_that("convert_prices() converts through the dollar, with the rate of the day or of the week before", {
  all <- data.frame(label = c("Alpha (A)", "Gamma (C)", "Delta (D)", "VIX"), currency = c("USD", "EUR", "JPY", NA))
  rates <- data.frame(
    currency = c("EUR", "EUR", "JPY"),
    timestamp = as.Date(c("2024-01-02", "2024-01-03", "2024-01-02")),
    per_usd = c(0.9, 0.8, 150)
  )
  history <- data.frame(
    label = c("Alpha (A)", "Alpha (A)", "Gamma (C)", "Gamma (C)", "Gamma (C)", "Delta (D)", "Delta (D)", "Delta (D)", "VIX"),
    timestamp = as.Date(c(
      "2024-01-02", "2024-01-03", "2024-01-01", "2024-01-02", "2024-01-03", "2024-01-02", "2024-01-09", "2024-01-10", "2024-01-02"
    )),
    close = c(100, 100, 50, 50, 50, 30000, 30000, 30000, 20),
    volume = 1
  )
  # Gamma has no rate before 2 January, and the rate of the yen of 2 January lasts until the 9th
  usd <- convert_prices(history, "USD", all, rates)
  expect_equal(usd$timestamp, history$timestamp[-c(3, 8)])
  expect_equal(usd$close, c(100, 100, 50 / 0.9, 50 / 0.8, 200, 200, 20))
  expect_equal(usd$volume, rep(1, 7))
  # in euros, the euro index stays as it is, even on a day without a rate
  eur <- convert_prices(history, "EUR", all, rates)
  expect_equal(eur$timestamp, history$timestamp[-8])
  expect_equal(eur$close, c(90, 80, 50, 50, 50, 180, 160, 20))
  expect_identical(convert_prices(history, "local", all, rates), history)
})

test_that("missing_rates_text() names the indices a conversion left out", {
  expect_null(missing_rates_text(c("A", "B"), c("B", "A")))
  expect_equal(missing_rates_text(c("A", "A", "B"), "B"), "No exchange rates for A right now, so it is left out.")
  expect_equal(missing_rates_text(c("A", "B", "C"), "B"), "No exchange rates for A and C right now, so they are left out.")
})
