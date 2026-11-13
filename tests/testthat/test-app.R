test_that("Google Analytics and its cookie banner are in the page only when asked for", {
  page <- function(analytics) htmltools::renderTags(app_ui(indices, analytics = analytics))
  with <- page(TRUE)
  expect_match(with$head, "https://sedzinfo.github.io/consent.js", fixed = TRUE)
  expect_match(with$head, "https://sedzinfo.github.io/shiny/analytics.js", fixed = TRUE)
  expect_match(with$html, "#cookie-settings", fixed = TRUE)
  without <- page(FALSE)
  expect_no_match(without$head, "consent.js", fixed = TRUE)
  expect_no_match(without$html, "cookie-settings", fixed = TRUE)
})

test_that("the keep-alive pings can be turned off", {
  page <- function(keep_alive) htmltools::renderTags(app_ui(indices, keep_alive = keep_alive))
  on <- page(TRUE)
  expect_match(on$head, "https://sedzinfo.github.io/shiny/keep_alive.js", fixed = TRUE)
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

test_that("the stylesheet shared by the apps is in the page, before the app's own", {
  rendered <- htmltools::renderTags(app_ui(indices))
  # as shiny draws the head: the dependencies first (the shared stylesheet is one; those with only
  # a local folder, such as jQuery, shiny serves itself), then the rest of the head
  deps <- Filter(function(d) !is.null(d$src$href), htmltools::resolveDependencies(rendered$dependencies))
  page <- paste(htmltools::renderDependencies(deps, "href"), rendered$head)
  shared <- regexpr("https://sedzinfo.github.io/shiny/apps.css", page, fixed = TRUE)
  expect_gt(shared, 0)
  own <- regexpr("href=\"www/[A-Za-z0-9_.-]+\\.css\"", page)
  if (own > 0) expect_lt(shared, own)
})
