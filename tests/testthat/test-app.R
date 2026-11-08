test_that("Google Analytics and its cookie banner are in the page only when asked for", {
  page <- function(analytics) htmltools::renderTags(app_ui(indices, analytics = analytics))
  with <- page(TRUE)
  expect_match(with$head, "https://sedzinfo.github.io/consent.js", fixed = TRUE)
  expect_match(with$head, "www/analytics.js", fixed = TRUE)
  expect_match(with$html, "#cookie-settings", fixed = TRUE)
  without <- page(FALSE)
  expect_no_match(without$head, "consent.js", fixed = TRUE)
  expect_no_match(without$html, "cookie-settings", fixed = TRUE)
})

test_that("the keep-alive pings can be turned off", {
  page <- function(keep_alive) htmltools::renderTags(app_ui(indices, keep_alive = keep_alive))
  on <- page(TRUE)
  expect_match(on$head, "www/keep_alive.js", fixed = TRUE)
  expect_match(on$html, "id=\"keep_alive\"", fixed = TRUE)
  off <- page(FALSE)
  expect_no_match(off$head, "keep_alive.js", fixed = TRUE)
  expect_no_match(off$html, "keep_alive", fixed = TRUE)
})

test_that("the page describes the app to search engines and link previews", {
  head <- htmltools::renderTags(app_ui(indices))$head
  expect_match(head, "<meta name=\"description\" content=\"Follow the major stock market indices", fixed = TRUE)
  expect_match(head, "<meta property=\"og:url\" content=\"https://sedzinfo-golemstockindices.share.connect.posit.cloud/\"", fixed = TRUE)
  expect_match(head, "property=\"og:image\"", fixed = TRUE)
  expect_lte(nchar(app_description), 160)
})
