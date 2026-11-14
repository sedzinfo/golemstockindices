# ten trading days of Alpha, from Monday 1 January 2024
days <- weekdays_from("2024-01-01", 10)
daily <- data.frame(
  label = "Alpha (A)",
  timestamp = days,
  open = 1:10, high = 1:10, low = 1:10, close = 1:10, volume = 1e9
)

make_stale <- function(key, minutes) {
  kept <- disk_cache()$get(key)
  kept$time <- kept$time - minutes * 60
  disk_cache()$set(key, kept)
}

test_that("get_indices() lists the indices with their Yahoo Finance symbols", {
  all <- get_indices()
  expect_named(all, c("label", "symbol", "region", "currency", "type", "from"))
  expect_equal(nrow(all), 55)
  expect_false(anyDuplicated(all$label) > 0 || anyDuplicated(all$symbol) > 0)
  expect_equal(all$symbol[all$label == "S&P 500"], "^GSPC")
  expect_equal(all$symbol[all$label == "Athens General"], "GD.AT")
  expect_equal(all$symbol[all$label == "Shanghai Composite"], "000001.SS")
  # the columns line up: the indices added later, and those just after them, have their own
  # symbol, region and currency
  check <- data.frame(
    label = c("Nasdaq-100", "NYSE Composite", "FTSE All-Share", "DAX", "FTSE/JSE Top 40", "Nikkei 225",
              "Shenzhen Component", "Hang Seng", "Hang Seng China Enterprises", "KOSPI", "KOSDAQ",
              "Taiwan Weighted", "FTSE Bursa Malaysia KLCI"),
    symbol = c("^NDX", "^NYA", "^FTAS", "^GDAXI", "^J200.JO", "^N225", "399001.SZ", "^HSI", "^HSCE",
               "^KS11", "^KQ11", "^TWII", "^KLSE"),
    region = c("US", "US", "Europe", "Europe", "Africa", rep("Asia-Pacific", 8)),
    currency = c("USD", "USD", "GBP", "EUR", "ZAR", "JPY", "CNY", "HKD", "HKD", "KRW", "KRW", "TWD", "MYR")
  )
  expect_equal(all[match(check$label, all$label), names(check)], check, ignore_attr = TRUE)
  expect_true(is.na(all$currency[all$label == "VIX"]))
  # the performance indices reinvest the dividends; the VIX has no type, as it has no currency
  expect_setequal(
    all$label[all$type %in% "total return"],
    c("Bovespa", "DAX", "MDAX", "SDAX", "TecDAX", "OSEBX", "OMX Tallinn", "OMX Riga", "OMX Vilnius", "NZX 50")
  )
  expect_true(all(all$type[!is.na(all$currency)] %in% c("price", "total return")))
  expect_true(is.na(all$type[all$label == "VIX"]))
  expect_equal(unique(all$region), c("US", "Americas", "Europe", "Africa", "Asia-Pacific"))
  # only the Bovespa leaves out the start of its history
  expect_equal(all$from[all$label == "Bovespa"], as.Date("1995-01-01"))
  expect_equal(sum(!is.na(all$from)), 1)
  # every index belongs to an exchange of the strip of the open markets
  expect_setequal(unlist(lapply(exchanges, function(exchange) exchange$indices)), all$label)
})

test_that("an index with a first day to keep is downloaded from that day", {
  disk_cache()$reset()
  starts <- character()
  local_mocked_bindings(download_histories = per_index(function(index, start_date) {
    starts <<- c(starts, format(start_date))
    daily
  }))
  late <- indices
  late$from <- as.Date(c("2024-01-01", NA))
  get_history(c("Alpha (A)", "Beta (B)"), as.Date("1900-01-01"), late)
  expect_equal(starts, c("2024-01-01", "1900-01-01"))
})

test_that("parse_chart() reads the daily prices on the dates of the exchange", {
  json <- yahoo_json(days[1:3], c(4742.83, 4704.81, 4688.68), volume = c(3.7e9, 3.9e9, 3.9e9))
  history <- parse_chart(json, indices[1, ], now = as.POSIXct("2024-01-04", tz = "UTC"))
  expect_named(history, c("label", "timestamp", "open", "high", "low", "close", "volume"))
  expect_equal(history$timestamp, days[1:3])
  expect_equal(history$close, c(4742.83, 4704.81, 4688.68))
  expect_equal(history$volume[1], 3.7e9)
  expect_equal(unique(history$label), "Alpha (A)")
})

test_that("parse_chart() rounds off the errors of single precision, but keeps the digits of exchange rates", {
  prices <- "[4554.97998046875,0.9049599766731262,130123.453125]"
  json <- paste0(
    '{"chart":{"result":[{"meta":{"gmtoffset":0},"timestamp":[1704067200,1704153600,1704240000],',
    '"indicators":{"quote":[{"open":', prices, ',"high":', prices, ',"low":', prices, ',"close":', prices,
    ',"volume":[3743050000,0,0]}]}}],"error":null}}'
  )
  history <- parse_chart(json, indices[1, ])
  # an index keeps its 2 decimals, and the euros a dollar buys their 5, which 2 decimals would make 0.9
  expect_equal(history$close, c(4554.98, 0.90496, 130123.45), tolerance = 0)
  expect_equal(history$volume, c(3743050000, 0, 0))
})

test_that("parse_chart() leaves out the days without a close and the day still trading", {
  json <- yahoo_json(days[1:4], c(1, NA, 3, 4))
  closed <- parse_chart(json, indices[1, ], now = as.POSIXct(paste(days[4], "23:00"), tz = "UTC"))
  expect_equal(closed$timestamp, days[c(1, 3, 4)])
  # at 15:00 in New York the session of the last day has not ended
  open <- parse_chart(json, indices[1, ], now = as.POSIXct(paste(days[4], "20:00"), tz = "UTC"))
  expect_equal(open$timestamp, days[c(1, 3)])
  # before it opens, the last day is the day before, which has ended
  session <- c(start = as.numeric(as.POSIXct(paste(days[5], "14:30"), tz = "UTC")), end = 0)
  session[["end"]] <- session[["start"]] + 6.5 * 3600
  early <- parse_chart(yahoo_json(days[1:4], 1:4, session = session), indices[1, ], now = as.POSIXct(paste(days[5], "12:00"), tz = "UTC"))
  expect_equal(early$timestamp, days[1:4])
})

test_that("parse_chart() reports an error of Yahoo Finance, and an answer without days", {
  error <- '{"chart":{"result":null,"error":{"code":"Not Found","description":"No data found, symbol may be delisted"}}}'
  expect_error(parse_chart(error, indices[1, ]), "symbol may be delisted")
  empty <- '{"chart":{"result":[{"meta":{"gmtoffset":0},"indicators":{"quote":[{}]}}],"error":null}}'
  expect_null(parse_chart(empty, indices[1, ]))
})

test_that("download_history() asks Yahoo Finance for the symbol, and says when it fails", {
  asked <- character()
  answer <- list(status_code = 200, content = charToRaw(yahoo_json(days[1:2], c(10, 11))))
  local_mocked_bindings(fetch_all = function(urls) {
    asked <<- c(asked, urls)
    rep(list(answer), length(urls))
  })
  downloaded <- download_history(indices[1, ], as.Date("2024-01-01"))
  expect_equal(downloaded$close, c(10, 11))
  expect_match(asked, "chart/%5EALPHA?period1=1704067200&", fixed = TRUE)
  answer$status_code <- 429
  expect_message(failed <- download_history(indices[1, ], as.Date("2024-01-01")), "The download of Alpha \\(A\\) failed: .*429")
  expect_null(failed)
  answer <- list(error = "Could not resolve host")
  expect_message(failed <- download_history(indices[1, ], as.Date("2024-01-01")), "Could not resolve host")
  expect_null(failed)
})

test_that("the indices are downloaded together, and one failing leaves the others", {
  asked <- list()
  local_mocked_bindings(fetch_all = function(urls) {
    asked <<- c(asked, list(urls))
    list(list(status_code = 200, content = charToRaw(yahoo_json(days[1:2], c(10, 11)))), list(status_code = 404, content = raw()))
  })
  expect_message(both <- download_histories(indices, as.Date(c("2024-01-01", "2024-01-02"))), "Beta \\(B\\) failed: .*404")
  # one call with both addresses, in the order of the indices
  expect_length(asked, 1)
  expect_match(asked[[1]][1], "%5EALPHA?period1=1704067200&", fixed = TRUE)
  expect_match(asked[[1]][2], "BETA.X?period1=1704153600&", fixed = TRUE)
  expect_equal(both[[1]]$close, c(10, 11))
  expect_null(both[[2]])
})

test_that("get_history() downloads only what is missing or old, all at once", {
  disk_cache()$reset()
  calls <- list()
  local_mocked_bindings(download_histories = function(indices, starts) {
    calls <<- c(calls, list(indices$label))
    lapply(seq_len(nrow(indices)), function(i) daily)
  })
  get_history("Alpha (A)", as.Date("2024-01-01"), indices)
  get_history(c("Alpha (A)", "Beta (B)"), as.Date("2024-01-01"), indices)
  make_stale("history_alpha", history_minutes)
  make_stale("history_betax", history_minutes)
  get_history(c("Alpha (A)", "Beta (B)"), as.Date("2024-01-01"), indices)
  get_history(c("Alpha (A)", "Beta (B)"), as.Date("2024-01-01"), indices)
  # Alpha alone, then only Beta (Alpha is kept), then both together (both an hour old), then nothing
  expect_equal(calls, list("Alpha (A)", "Beta (B)", c("Alpha (A)", "Beta (B)")))
})

test_that("get_history() names the labels that match no index", {
  expect_message(result <- get_history("Unknown (X)", indices = indices), "No index is labelled \"Unknown \\(X\\)\"")
  expect_null(result)
})

test_that("get_history() keeps the whole history on disk and later downloads the last two weeks", {
  disk_cache()$reset()
  available <- daily
  starts <- character()
  local_mocked_bindings(download_histories = per_index(function(index, start_date) {
    starts <<- c(starts, format(start_date))
    available[available$timestamp >= start_date, ]
  }))

  expect_equal(nrow(get_history("Alpha (A)", as.Date("2024-01-01"), indices)), 10)
  later <- get_history("Alpha (A)", as.Date("2024-01-05"), indices)
  expect_equal(starts, "1900-01-01")
  expect_equal(later$timestamp, days[days >= as.Date("2024-01-05")])

  # an hour later, with two new days and a corrected last day
  new_days <- weekdays_from(days[10] + 1, 2)
  available <- rbind(daily, data.frame(label = "Alpha (A)", timestamp = new_days, open = 11:12, high = 11:12, low = 11:12, close = 11:12, volume = 1e9))
  available$close[available$timestamp == days[10]] <- 99
  make_stale("history_alpha", history_minutes)

  updated <- get_history("Alpha (A)", as.Date("2024-01-01"), indices)
  expect_equal(starts, c("1900-01-01", format(days[10] - 14)))
  expect_equal(updated$timestamp, c(days, new_days))
  expect_equal(updated$close[updated$timestamp == days[10]], 99)
})

test_that("get_history() uses the kept history when bringing it up to date fails", {
  disk_cache()$reset()
  offline <- FALSE
  local_mocked_bindings(download_histories = per_index(function(index, start_date) {
    if (offline) NULL else daily[daily$timestamp >= start_date, ]
  }))
  get_history("Alpha (A)", as.Date("2024-01-01"), indices)
  make_stale("history_alpha", history_minutes)
  offline <- TRUE
  expect_equal(nrow(get_history("Alpha (A)", as.Date("2024-01-01"), indices)), 10)
  # and keeps nothing when even the first download fails
  disk_cache()$reset()
  expect_null(get_history("Alpha (A)", as.Date("2024-01-01"), indices))
  expect_false(disk_cache()$exists("history_alpha"))
})

test_that("get_history() combines several indices and leaves out the ones that fail", {
  disk_cache()$reset()
  local_mocked_bindings(download_histories = per_index(function(index, start_date) {
    if (index$label == "Beta (B)") NULL else daily
  }))
  result <- get_history(c("Beta (B)", "Alpha (A)"), as.Date("2024-01-01"), indices)
  expect_equal(unique(result$label), "Alpha (A)")
  expect_equal(rownames(result), as.character(1:10))
})
