# Small offline data shaped like the downloads, so the tests need no internet

# keep the downloads of the tests out of the user's cache folder
options(stockindices.cache_dir = tempfile("stockindices-cache-"))

indices <- data.frame(
  label = c("Alpha (A)", "Beta (B)"),
  symbol = c("^ALPHA", "BETA.X"),
  region = c("US", "Europe"),
  currency = c("USD", NA)
)

# Beta starts a month after Alpha
history <- data.frame(
  label = rep(c("Alpha (A)", "Beta (B)"), c(4, 3)),
  timestamp = as.Date(c(
    "2024-01-31", "2024-02-29", "2024-03-01", "2024-03-28",
    "2024-02-29", "2024-03-01", "2024-03-28"
  )),
  close = c(100, 110, 99, 121, 50, 55, 25)
)
history$open <- history$close
history$high <- history$close * 1.1
history$low <- history$close * 0.9
history$volume <- 1000

# a mock of download_histories() from one of a single index: the indices are downloaded
# together, each as `one(index, start_date)` answers
per_index <- function(one) {
  function(indices, starts) lapply(seq_len(nrow(indices)), function(i) one(indices[i, ], starts[i]))
}

# the first n weekdays from a date on
weekdays_from <- function(start, n) {
  days <- as.Date(start) + 0:(2 * n + 7)
  utils::head(days[as.POSIXlt(days)$wday %in% 1:5], n)
}

# an index of 900 trading days whose returns follow a GARCH(1,1) model, so the analysis has a
# model to find
garch_history <- function(days = 900, last = NULL, seed = 1) {
  set.seed(seed)
  r <- numeric(days)
  variance <- 4
  for (t in seq_len(days)) {
    r[t] <- sqrt(variance) * stats::rt(1, df = 5) / sqrt(5 / 3)
    variance <- 0.2 + 0.1 * r[t]^2 + 0.85 * variance
  }
  if (!is.null(last)) r[days - seq_along(last) + 1] <- rev(last)
  data.frame(
    label = "Alpha (A)",
    timestamp = weekdays_from("2022-01-03", days + 1),
    close = 100 * exp(cumsum(c(0, r / 100)))
  )
}

# an answer of Yahoo Finance with these daily prices, opening at 09:30 in New York
yahoo_json <- function(dates, close, volume = rep(1e9, length(dates)), session = NULL) {
  timestamps <- as.numeric(as.POSIXct(paste(dates, "14:30:00"), tz = "UTC"))
  if (is.null(session)) session <- c(start = max(timestamps), end = max(timestamps) + 6.5 * 3600)
  number <- function(x) paste0("[", paste(ifelse(is.na(x), "null", format(x, scientific = FALSE)), collapse = ","), "]")
  paste0(
    '{"chart":{"result":[{"meta":{"currency":"USD","gmtoffset":-18000,',
    '"currentTradingPeriod":{"regular":{"start":', format(session[["start"]], scientific = FALSE),
    ',"end":', format(session[["end"]], scientific = FALSE), "}}},",
    '"timestamp":', number(timestamps), ',"indicators":{"quote":[{',
    '"open":', number(close), ',"high":', number(close), ',"low":', number(close),
    ',"close":', number(close), ',"volume":', number(volume), "}]}}],",
    '"error":null}}'
  )
}
