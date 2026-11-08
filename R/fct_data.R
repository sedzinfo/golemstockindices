##########################################################################################
#
##########################################################################################
#' @title Minutes before a kept price history is brought up to date
#' @noRd
history_minutes <- 60
##########################################################################################
#
##########################################################################################
#' @title Address of the daily prices of Yahoo Finance
#' @noRd
yahoo_url <- "https://query1.finance.yahoo.com/v8/finance/chart/"
##########################################################################################
#
##########################################################################################
#' @title User agent of the downloads
#' @description Yahoo Finance refuses requests that do not look like they
#' come from a browser.
#' @noRd
user_agent <- "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0 Safari/537.36"
##########################################################################################
#
##########################################################################################
#' @title Folder and object of the disk cache, see `disk_cache()`
#' @noRd
disk <- new.env(parent = emptyenv())
##########################################################################################
#
##########################################################################################
#' @title The downloads kept between R sessions
#' @description The price histories are kept on disk, so they survive R
#' restarts: by default in the cache folder of the package from
#' [tools::R_user_dir()], or in the folder set with
#' `options(stockindices.cache_dir = )`. Delete the folder to start over.
#' @return A [cachem::cache_disk()] object.
#' @keywords internal
#' @examples
#' \dontrun{
#' golemstockindices:::disk_cache()$keys()
#' }
disk_cache <- function() {
  dir <- getOption("stockindices.cache_dir", tools::R_user_dir("golemstockindices", which = "cache"))
  if (!identical(disk$dir, dir)) {
    disk$cache <- cachem::cache_disk(dir, max_size = 200 * 1024^2)
    disk$dir <- dir
  }
  disk$cache
}
##########################################################################################
#
##########################################################################################
#' @title The stock market indices of the app
#' @description The major indices of the US, the rest of the Americas,
#' Europe and Asia-Pacific, and the VIX, with their symbols on Yahoo Finance.
#' The `label` column holds the names, such as "S&P 500", that pick indices
#' in [get_history()].
#' @return A data frame with a row per index: `label`, `symbol` on Yahoo
#'   Finance, `region` ("US", "Americas", "Europe" or "Asia-Pacific"), the
#'   `currency` of the shares in it, and `from`, the first day to keep, or
#'   `NA` to keep all of the history. The VIX is a measure of the expected
#'   volatility of the S&P 500, in percent a year, so its currency is `NA`.
#'   The Bovespa starts in 1995: in the hyperinflation of Brazil before the
#'   real, its returns of thousands of percent a year in the money of the time would swamp
#'   every analysis.
#' @export
#' @examples
#' get_indices()
get_indices <- function() {
  indices <- data.frame(
    label = c("S&P 500", "Dow Jones", "Nasdaq Composite", "NYSE Composite",
              "Russell 2000", "VIX",
              
              "S&P/TSX Composite", "Bovespa", "IPC Mexico",
              
              "STOXX Europe 600", "Euro Stoxx 50", "FTSE 100", "DAX",
              "CAC 40", "IBEX 35", "FTSE MIB", "SMI",
              "Euronext 100", "BEL 20", "Athens General",
              
              "Nikkei 225", "Shanghai Composite", "Hang Seng",
              "KOSPI", "Taiwan Weighted", "Sensex",
              "Straits Times", "ASX 200", "All Ordinaries",
              "NZX 50", "IDX Composite", "FTSE Bursa Malaysia KLCI"),
    
    symbol = c("^GSPC", "^DJI", "^IXIC", "^NYA",
               "^RUT", "^VIX",
               
               "^GSPTSE", "^BVSP", "^MXX",
               
               "^STOXX", "^STOXX50E", "^FTSE", "^GDAXI",
               "^FCHI", "^IBEX", "FTSEMIB.MI", "^SSMI",
               "^N100", "^BFX", "GD.AT",
               
               "^N225", "000001.SS", "^HSI",
               "^KS11", "^TWII", "^BSESN",
               "^STI", "^AXJO", "^AORD",
               "^NZ50", "^JKSE", "^KLSE"),
    
    region = c(rep("US", 6),
               rep("Americas", 3),
               rep("Europe", 10),
               rep("Asia-Pacific", 13)),
    
    currency = c("USD", "USD", "USD", "USD", "USD", NA,
                 "CAD", "BRL", "MXN",
                 "EUR", "EUR", "GBP", "EUR",
                 "EUR", "EUR", "EUR", "CHF",
                 "EUR", "EUR", "EUR",
                 
                 "JPY", "CNY", "HKD",
                 "KRW", "TWD", "INR",
                 "SGD", "AUD", "AUD",
                 "NZD", "IDR", "MYR"),
    
    stringsAsFactors = FALSE
  )
  
  indices$from <- as.Date(
    ifelse(indices$label == "Bovespa", "1995-01-01", NA)
  )
  
  indices
}
# get_indices <- function() {
#   indices <- data.frame(
#     label = c("S&P 500", "Dow Jones", "Nasdaq Composite", "Russell 2000", "S&P/TSX Composite", "Bovespa",
#               "STOXX Europe 600", "Euro Stoxx 50", "FTSE 100", "DAX", "CAC 40", "IBEX 35", "FTSE MIB", "SMI",
#               "Athens General", "Nikkei 225", "Shanghai Composite", "Hang Seng", "KOSPI", "Sensex", "ASX 200",
#               "VIX"),
#     symbol = c("^GSPC", "^DJI", "^IXIC", "^RUT", "^GSPTSE", "^BVSP", "^STOXX", "^STOXX50E", "^FTSE",
#                "^GDAXI", "^FCHI", "^IBEX", "FTSEMIB.MI", "^SSMI", "GD.AT", "^N225", "000001.SS",
#                "^HSI", "^KS11", "^BSESN", "^AXJO",  "^VIX"),
#     region = c(rep("US", 4), rep("Americas", 2), rep("Europe", 9), rep("Asia-Pacific", 6), "US"),
#     currency = c(rep("USD", 4),
#                  "CAD", "BRL",
#                  "EUR", "EUR", "GBP", "EUR", "EUR", "EUR", "EUR", "CHF", "EUR",
#                  "JPY", "CNY", "HKD", "KRW", "INR", "AUD", NA)
#   )
#   indices$from <- as.Date(ifelse(indices$label == "Bovespa", "1995-01-01", NA))
#   indices
# }
##########################################################################################
#
##########################################################################################
#' @title Read the daily prices of a Yahoo Finance answer
#' @description Days without a close, which Yahoo Finance has for some
#' holidays, are left out, and so is the last day while its market is still
#' open, as its close is not final yet. The dates are those of the exchange.
#' Yahoo Finance keeps the levels with the rounding errors of single
#' precision, such as 4554.97998046875 for 4554.98, so they are rounded to
#' the 2 decimals indices are published with.
#' @param json The JSON text of the answer.
#' @param index One row of [get_indices()].
#' @param now The time to judge whether the market is open, now by default.
#' @return A data frame with a row per day, sorted by date: `label`,
#'   `timestamp` (a Date), `open`, `high`, `low`, `close` and `volume`, or
#'   `NULL` when the answer has no days.
#' @keywords internal
#' @examples
#' json <- paste0(
#'   '{"chart":{"result":[{"meta":{"gmtoffset":-18000,',
#'   '"currentTradingPeriod":{"regular":{"start":1704205800,"end":1704229200}}},',
#'   '"timestamp":[1704205800,1704292200],"indicators":{"quote":[{"open":[4745.2,4725.1],',
#'   '"high":[4754.3,4729.3],"low":[4722.7,4699.7],"close":[4742.8,4704.8],',
#'   '"volume":[3743050000,3950760000]}]}}],"error":null}}'
#' )
#' golemstockindices:::parse_chart(json, golemstockindices::get_indices()[1, ])
parse_chart <- function(json, index, now = Sys.time()) {
  chart <- jsonlite::fromJSON(json)$chart
  if (!is.null(chart$error)) {
    stop(chart$error$description, call. = FALSE)
  }
  result <- chart$result
  timestamp <- unlist(result$timestamp)
  if (length(timestamp) == 0) {
    return(NULL)
  }
  quote <- result$indicators$quote[[1]]
  column <- function(name, digits = 2) {
    values <- unlist(quote[[name]])
    if (length(values) == length(timestamp)) round(as.numeric(values), digits) else rep(NA_real_, length(timestamp))
  }
  meta <- result$meta
  # the time of day of a daily price is the opening of the exchange, in UTC, so its date is
  # the exchange's once its offset from UTC is added
  history <- data.frame(
    label = index$label,
    timestamp = as.Date(as.POSIXct(timestamp + meta$gmtoffset, origin = "1970-01-01", tz = "UTC")),
    open = column("open"),
    high = column("high"),
    low = column("low"),
    close = column("close"),
    volume = column("volume", digits = 0)
  )
  session <- meta$currentTradingPeriod$regular
  if (!is.null(session$end) && as.numeric(now) < session$end && utils::tail(timestamp, 1) >= session$start) {
    history <- utils::head(history, -1)
  }
  history <- history[is.finite(history$close), ]
  history <- history[!duplicated(history$timestamp, fromLast = TRUE), ]
  if (nrow(history) == 0) {
    return(NULL)
  }
  history <- history[order(history$timestamp), ]
  rownames(history) <- NULL
  history
}
##########################################################################################
#
##########################################################################################
#' @title Download the daily prices of an index
#' @description Asks Yahoo Finance for the daily prices from `start_date` to
#' now, in one request. A failed download is reported as a message instead of
#' an error.
#' @param index One row of [get_indices()].
#' @param start_date Date. The first day to download.
#' @return The prices, as described in [parse_chart()], or `NULL` when
#'   nothing could be downloaded.
#' @keywords internal
#' @examples
#' \dontrun{
#' golemstockindices:::download_history(get_indices()[1, ], Sys.Date() - 30)
#' }
download_history <- function(index, start_date) {
  tryCatch(
    {
      url <- sprintf(
        "%s%s?period1=%.0f&period2=%.0f&interval=1d&includePrePost=false",
        yahoo_url, utils::URLencode(index$symbol, reserved = TRUE),
        as.numeric(as.POSIXct(as.character(start_date), tz = "UTC")), as.numeric(Sys.time()) + 24 * 3600
      )
      handle <- curl::new_handle()
      curl::handle_setheaders(handle, "User-Agent" = user_agent)
      response <- curl::curl_fetch_memory(url, handle)
      if (response$status_code != 200) {
        stop("Yahoo Finance answered with status ", response$status_code, call. = FALSE)
      }
      parse_chart(rawToChar(response$content), index)
    },
    error = function(e) {
      message("The download of ", index$label, " failed: ", conditionMessage(e))
      NULL
    }
  )
}
##########################################################################################
#
##########################################################################################
#' @title Get the whole price history of one index, kept on disk and brought up to date
#' @description The first call downloads the whole history, from the `from`
#' day of the index when it has one, and keeps it on disk (see
#' [disk_cache()]). Later calls use the kept history, and once it is more
#' than an hour old download only the last two weeks, which also replace the
#' kept days of those weeks, in case Yahoo Finance corrected them. When
#' bringing it up to date fails, the kept history is used.
#' @param index One row of [get_indices()].
#' @return The whole price history of the index, or `NULL` when it could not
#'   be downloaded.
#' @keywords internal
#' @examples
#' \dontrun{
#' golemstockindices:::index_history(get_indices()[1, ])
#' }
index_history <- function(index) {
  key <- paste0("history_", tolower(gsub("[^A-Za-z0-9]", "", index$symbol)))
  kept <- disk_cache()$get(key)
  if (cachem::is.key_missing(kept)) {
    start <- if (length(index$from) == 1 && !is.na(index$from)) index$from else as.Date("1900-01-01")
    history <- download_history(index, start)
    if (is.null(history)) {
      return(NULL)
    }
    disk_cache()$set(key, list(history = history, time = Sys.time()))
    return(history)
  }
  if (minutes_since(kept$time) >= history_minutes) {
    recent <- download_history(index, max(kept$history$timestamp) - 14)
    if (!is.null(recent)) {
      older <- kept$history[kept$history$timestamp < min(recent$timestamp), ]
      kept <- list(history = rbind(older, recent), time = Sys.time())
      disk_cache()$set(key, kept)
    }
  }
  kept$history
}
##########################################################################################
#
##########################################################################################
#' @title Get the daily price history of indices
#' @description Returns the daily prices of one or more stock market indices
#' from Yahoo Finance, in index points. Each index's history is kept on disk
#' between R sessions, and once it is more than an hour old only its last two
#' weeks are downloaded again, so calls are fast. An index is priced on the
#' days its exchange trades, so weekends and holidays have no prices.
#' @param labels Character vector of index labels, such as "S&P 500", from
#'   the `label` column of [get_indices()].
#' @param start_date Date. The first day to get, a year ago by default.
#' @param indices Data frame of indices from [get_indices()], to look the
#'   labels up.
#' @return A data frame with one row per index and day, sorted by index and
#'   date, with the `open`, `high`, `low`, `close` and `volume` columns,
#'   `timestamp` as a Date and the `label`. Labels that match no index are
#'   left out with a message, and `NULL` is returned when no label matches or
#'   nothing could be downloaded.
#' @export
#' @examples
#' \dontrun{
#' spx <- get_history("S&P 500", as.Date("2020-01-01"))
#' plot_timeseries(spx)
#'
#' history <- get_history(c("S&P 500", "DAX", "Nikkei 225"))
#' plot_compare(normalize_prices(history))
#' }
get_history <- function(labels, start_date = Sys.Date() - 365, indices = get_indices()) {
  unknown <- setdiff(labels, indices$label)
  if (length(unknown) > 0) {
    message("No index is labelled ", paste0("\"", unknown, "\"", collapse = ", "), ", see get_indices()$label")
  }
  matched <- indices[match(unique(labels), indices$label, nomatch = 0), ]
  history <- do.call(rbind, lapply(seq_len(nrow(matched)), function(i) {
    one <- index_history(matched[i, ])
    if (!is.null(one)) one[one$timestamp >= start_date, ]
  }))
  if (is.null(history) || nrow(history) == 0) {
    return(NULL)
  }
  history <- history[order(history$label, history$timestamp), ]
  rownames(history) <- NULL
  history
}
