status_at <- function(time) {
  status <- market_status(as.POSIXct(time, tz = "UTC"))
  stats::setNames(paste(status$local_time, status$text), status$exchange)
}

test_that("market_status() says which exchanges are open on a weekday, in their local time", {
  # Monday 9 November 2026 at 15:00 UTC, after the end of summer time on both sides of the Atlantic
  now <- status_at("2026-11-09 15:00")
  expect_equal(now[["New York"]], "10:00 open until 16:00")
  expect_equal(now[["London"]], "15:00 open until 16:30")
  expect_equal(now[["Frankfurt"]], "16:00 open until 17:30")
  expect_equal(now[["Athens"]], "17:00 open until 17:20")
  # midnight in Tokyo is before Tuesday's session, and 23:00 in Hong Kong after Monday's
  expect_equal(now[["Tokyo"]], "00:00 opens 09:00")
  expect_equal(now[["Hong Kong"]], "23:00 opens Tue 09:30")
  expect_equal(market_status(as.POSIXct("2026-11-09 15:00", tz = "UTC"))$state[1], "open")
})

test_that("market_status() knows the lunch breaks of Tokyo and Hong Kong, and the weekend", {
  lunch <- market_status(as.POSIXct("2026-11-09 03:00", tz = "UTC"))
  tokyo <- lunch[lunch$exchange == "Tokyo", ]
  expect_equal(c(tokyo$state, tokyo$text), c("lunch", "lunch break until 12:30"))
  expect_equal(status_at("2026-11-09 04:30")[["Hong Kong"]], "12:30 lunch break until 13:00")
  # Saturday: every exchange is closed until Monday
  weekend <- market_status(as.POSIXct("2026-11-07 12:00", tz = "UTC"))
  expect_true(all(weekend$state == "closed"))
  expect_equal(weekend$text[weekend$exchange == "New York"], "opens Mon 09:30")
  # Friday evening in New York is already Saturday in Tokyo
  expect_equal(status_at("2026-11-06 22:00")[["Tokyo"]], "07:00 opens Mon 09:00")
})

test_that("market_strip() shows an exchange per label, with the indices on hover", {
  html <- as.character(market_strip(market_status(as.POSIXct("2026-11-09 15:00", tz = "UTC"))))
  expect_match(html, "class=\"market open\" title=\"S&amp;P 500, Dow Jones, Nasdaq Composite, Russell 2000, VIX\"", fixed = TRUE)
  expect_match(html, "class=\"market closed\" title=\"Nikkei 225\"", fixed = TRUE)
  expect_match(html, "holidays are not shown", fixed = TRUE)
})

test_that("sparkline_svg() draws the last year, green when it rose and red when it fell", {
  days <- as.Date("2025-01-01") + 0:500
  up <- sparkline_svg(days, seq(100, 200, length.out = 501), "S&P 500")
  expect_match(up, "^<svg width=\"110\" height=\"26\"")
  expect_match(up, "stroke=\"#198754\"", fixed = TRUE)
  expect_match(up, "aria-label=\"S&amp;P 500 over the last year: +", fixed = TRUE)
  # at most 100 points, from the last 365 days only
  points <- strsplit(sub(".*points=\"([^\"]+)\".*", "\1", up), " ")[[1]]
  expect_lte(length(points), 100)
  expect_match(sparkline_svg(days, seq(200, 100, length.out = 501), "Alpha"), "stroke=\"#dc3545\"", fixed = TRUE)
  expect_equal(sparkline_svg(days[1], 100, "Alpha"), "")
})
