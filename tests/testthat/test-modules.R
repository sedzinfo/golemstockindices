light <- reactive("light")

test_that("the timeseries module reports an index it cannot download", {
  testServer(mod_timeseries_server, args = list(indices = indices, dark_mode = light), {
    expect_message(session$setInputs(index = "Unknown (X)"), "No index is labelled")
    expect_error(output$plot, "Data not available for this index")
    expect_error(output$csv)
    expect_null(session$getReturned()())
  })
})

test_that("the compare module waits for the index selection, then reports missing data", {
  testServer(mod_compare_server, args = list(indices = indices, dark_mode = light), {
    expect_message(
      {
        session$setInputs(indices = "Unknown (X)", start = as.Date("2024-01-01"))
        session$elapse(2000)
      },
      "No index is labelled"
    )
    expect_error(output$plot, "Data not available for the selected indices")
  })
})

test_that("file_stem() turns an index label into a file name", {
  expect_equal(file_stem("S&P 500"), "s-p-500")
  expect_equal(file_stem("Euro Stoxx 50"), "euro-stoxx-50")
})

test_that("the index pickers group the indices by region", {
  choices <- index_choices(get_indices())
  expect_equal(names(choices), c("US", "Americas", "Europe", "Asia-Pacific"))
  expect_true(all(c("S&P 500", "VIX") %in% choices$US))
})

test_that("the overview module shows every index and the date of the last closes", {
  # Beta's last close is the same day as Alpha's, so the line names no index as late
  local_mocked_bindings(get_history = function(labels, start_date, indices) history[history$label %in% labels, ])
  testServer(mod_overview_server, args = list(indices = indices, dark_mode = light), {
    expect_equal(output$updated, "Daily closes from Yahoo Finance, up to 28 Mar 2024")
    expect_no_error(output$table)
    csv <- utils::read.csv(output$csv)
    expect_equal(csv$label, indices$label)
    expect_equal(names(csv)[1:4], c("label", "date", "close", "day_pct"))
  })
  late <- history[!(history$label == "Beta (B)" & history$timestamp == as.Date("2024-03-28")), ]
  local_mocked_bindings(get_history = function(labels, start_date, indices) late[late$label %in% labels, ])
  testServer(mod_overview_server, args = list(indices = indices, dark_mode = light), {
    expect_match(output$updated, "; Beta (B) closed last on an earlier day", fixed = TRUE)
  })
  local_mocked_bindings(get_history = function(labels, start_date, indices) NULL)
  testServer(mod_overview_server, args = list(indices = indices, dark_mode = light), {
    expect_error(output$table, "cannot be downloaded")
  })
})

test_that("the timeseries and compare CSV downloads hold the prices", {
  local_mocked_bindings(get_history = function(labels, start_date, indices) {
    history[history$label %in% labels, ]
  })
  testServer(mod_timeseries_server, args = list(indices = indices, dark_mode = light), {
    session$setInputs(index = "Alpha (A)")
    csv <- utils::read.csv(output$csv)
    expect_equal(names(csv), c("date", "label", "open", "high", "low", "close", "volume"))
    expect_equal(csv$date, c("2024-01-31", "2024-02-29", "2024-03-01", "2024-03-28"))
  })
  testServer(mod_compare_server, args = list(indices = indices, dark_mode = light), {
    session$setInputs(indices = c("Alpha (A)", "Beta (B)"), start = as.Date("2024-01-01"))
    session$elapse(2000)
    csv <- utils::read.csv(output$csv)
    expect_equal(names(csv), c("date", "label", "close", "index"))
    expect_equal(csv$index[csv$date == "2024-02-29"], c(100, 100))
  })
})

test_that("the returns calendar CSV has a year column and one column per month", {
  alpha <- history[history$label == "Alpha (A)", ]
  testServer(mod_returns_calendar_server, args = list(history = reactive(alpha), dark_mode = light), {
    csv <- utils::read.csv(output$csv)
    expect_equal(names(csv), c("year", month.abb))
    expect_equal(csv$year, 2024)
    expect_equal(c(csv$Jan, csv$Feb, csv$Mar), c(NA, 10, 10))
  })
})

test_that("the returns calendar needs at least two months of history", {
  alpha <- history[history$label == "Alpha (A)", ]
  testServer(mod_returns_calendar_server, args = list(history = reactive(alpha), dark_mode = light), {
    expect_no_error(output$plot)
  })
  testServer(mod_returns_calendar_server, args = list(history = reactive(alpha[1, ]), dark_mode = light), {
    expect_error(output$plot, "Not enough history")
  })
})

test_that("the about tab explains every tab, every column of the overview and every index", {
  page <- htmltools::renderTags(mod_about_ui("about"))$html
  for (tab in c("Overview", "Timeseries", "Compare", "Returns calendar", "Seasonality", "Volatility", "Drawdowns")) {
    expect_match(page, paste0(">", tab, "</h3>"), fixed = TRUE, label = tab)
  }
  for (column in names(overview_table(index_summary(history), indices)$x$data)) {
    expect_match(page, paste0("<code>", column, "</code>"), fixed = TRUE, label = column)
  }
  for (index in get_indices()$label) {
    expect_match(page, gsub("&", "&amp;", index, fixed = TRUE), fixed = TRUE, label = index)
  }
  # the refresh intervals are filled in, and the example chart sits in the text
  expect_no_match(page, "{{", fixed = TRUE)
  expect_match(page, "id=\"about-example\"", fixed = TRUE)
  ids <- regmatches(page, gregexpr("id=\"[^\"]+\"", page))[[1]]
  expect_false(anyDuplicated(ids) > 0)
  testServer(mod_about_server, args = list(dark_mode = light), {
    expect_no_error(output$example)
  })
})

test_that("the volatility module explains and charts the selected index", {
  long <- garch_history(800)
  testServer(mod_volatility_server, args = list(history = reactive(long), dark_mode = light), {
    expect_match(output$summary$html, "Volatility of the last 21 trading days")
    expect_match(output$summary$html, "Expected move on")
    expect_no_error(output$plot)
    csv <- utils::read.csv(output$csv)
    expect_equal(names(csv), c(
      "date", "close", "volume", "return_pct", "volume_ratio", "volatility_month", "garch_sigma", "garch_z", "garch_var",
      "forecast_sigma", "forecast_low", "forecast_low_50", "forecast_median", "forecast_high_50", "forecast_high"
    ))
    expect_equal(nrow(csv), 801 + 5)
    session$setInputs(month_days = "5", recent_days = "1")
    expect_match(output$summary$html, "Volatility of the last 5 trading days")
    expect_match(output$summary$html, "Last day, ")
    expect_no_error(output$plot)
  })
  short <- reactive(history[history$label == "Alpha (A)", ])
  testServer(mod_volatility_server, args = list(history = short, dark_mode = light), {
    expect_error(output$plot, "Not enough history")
  })
})

test_that("the drawdowns module explains, charts and lists the falls of the selected index", {
  long <- garch_history(800)
  testServer(mod_drawdowns_server, args = list(history = reactive(long), dark_mode = light), {
    expect_match(output$summary$html, "from the all-time high|at an all-time high")
    expect_match(output$summary$html, "falls? of 20% or more")
    expect_no_error(output$plot)
    expect_no_error(output$table)
    csv <- utils::read.csv(output$csv)
    expect_equal(names(csv)[c(1, 6)], c("rank", "fall_pct"))
    expect_true(all(csv$fall_pct <= -20))
    session$setInputs(min_depth = "10")
    expect_gt(nrow(utils::read.csv(output$csv)), nrow(csv))
  })
  one_day <- reactive(history[history$label == "Alpha (A)", ][1, ])
  testServer(mod_drawdowns_server, args = list(history = one_day, dark_mode = light), {
    expect_error(output$plot, "Not enough history")
  })
})

test_that("the seasonality module explains, charts and lists the returns of the selected index", {
  long <- garch_history(800)
  testServer(mod_seasonality_server, args = list(history = reactive(long), dark_mode = light), {
    expect_match(output$summary$html, "Best month")
    expect_match(output$summary$html, "Kruskal-Wallis")
    expect_no_error(output$plot)
    expect_no_error(output$table)
    csv <- utils::read.csv(output$csv)
    expect_equal(names(csv), c("month", "returns", "mean_pct", "median_pct", "up_pct", "best_pct", "worst_pct"))
    expect_equal(csv$month, month.abb)
    session$setInputs(period = "day")
    expect_match(output$summary$html, "Best day")
    expect_equal(utils::read.csv(output$csv)$day_of_the_week, weekday_names)
  })
  short <- reactive(history[history$label == "Alpha (A)", ])
  testServer(mod_seasonality_server, args = list(history = short, dark_mode = light), {
    session$setInputs(period = "year")
    expect_error(output$plot, "Not enough history: the returns need at least two complete years in a row")
  })
})

test_that("the overview shows the open exchanges and the performance over the period picked", {
  local_mocked_bindings(get_history = function(labels, start_date, indices) history[history$label %in% labels, ])
  testServer(mod_overview_server, args = list(indices = indices, dark_mode = light), {
    expect_match(output$markets$html, "New York")
    expect_match(output$markets$html, "Hong Kong")
    # the test history has no close of the year before, so no change this year: an empty chart
    expect_no_error(output$performance)
    session$setInputs(period = "day")
    expect_match(output$performance, "Change on the day", fixed = TRUE)
  })
})
