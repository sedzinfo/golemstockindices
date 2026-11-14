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
#'   `currency` of the shares in it, its `type`, "total return" for the
#'   performance indices, in which the dividends of the companies are
#'   reinvested, such as the DAX, or "price" for those that leave them out,
#'   such as the S&P 500, and `from`, the first day to keep, or
#'   `NA` to keep all of the history. The VIX is a measure of the expected
#'   volatility of the S&P 500, in percent a year, so its currency and type
#'   are `NA`.
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
              
              "STOXX Europe 600", "Euro Stoxx 50", "FTSE 100", "FTSE 250",
              "DAX", "MDAX", "SDAX", "TecDAX",
              "CAC 40", "IBEX 35", "FTSE MIB", "SMI",
              "Euronext 100", "Next 150", "BEL 20", "AEX", "ATX",
              "ISEQ All Share", "PSI",
              "OMX Stockholm 30", "OMX Copenhagen 25", "OMX Helsinki 25", "OSEBX",
              "OMX Tallinn", "OMX Riga", "OMX Vilnius",
              "Athens General", "BIST 100",
              
              "Nikkei 225", "Shanghai Composite", "Hang Seng",
              "KOSPI", "Taiwan Weighted", "Sensex",
              "Straits Times", "ASX 200", "All Ordinaries",
              "NZX 50", "IDX Composite", "FTSE Bursa Malaysia KLCI"),
    
    symbol = c("^GSPC", "^DJI", "^IXIC", "^NYA",
               "^RUT", "^VIX",
               
               "^GSPTSE", "^BVSP", "^MXX",
               
               "^STOXX", "^STOXX50E", "^FTSE", "^FTMC",
               "^GDAXI", "^MDAXI", "^SDAXI", "^TECDAX",
               "^FCHI", "^IBEX", "FTSEMIB.MI", "^SSMI",
               "^N100", "^N150", "^BFX", "^AEX", "^ATX",
               "^ISEQ", "PSI20.LS",
               "^OMX", "^OMXC25", "^OMXH25", "OSEBX.OL",
               "^OMXTGI", "^OMXRGI", "^OMXVGI",
               "GD.AT", "XU100.IS",
               
               "^N225", "000001.SS", "^HSI",
               "^KS11", "^TWII", "^BSESN",
               "^STI", "^AXJO", "^AORD",
               "^NZ50", "^JKSE", "^KLSE"),
    
    region = c(rep("US", 6),
               rep("Americas", 3),
               rep("Europe", 28),
               rep("Asia-Pacific", 12)),
    
    currency = c("USD", "USD", "USD", "USD", "USD", NA,
                 "CAD", "BRL", "MXN",
                 "EUR", "EUR", "GBP", "GBP",
                 "EUR", "EUR", "EUR", "EUR",
                 "EUR", "EUR", "EUR", "CHF",
                 "EUR", "EUR", "EUR", "EUR", "EUR",
                 "EUR", "EUR",
                 "SEK", "DKK", "EUR", "NOK",
                 "EUR", "EUR", "EUR",
                 "EUR", "TRY",
                 
                 "JPY", "CNY", "HKD",
                 "KRW", "TWD", "INR",
                 "SGD", "AUD", "AUD",
                 "NZD", "IDR", "MYR"),
    
    stringsAsFactors = FALSE
  )

  # the performance indices, in which the dividends of the companies are reinvested: Yahoo
  # Finance names them P (DAX P, MDAX P), GI (gross index) or Gross
  total_return <- c("Bovespa", "DAX", "MDAX", "SDAX", "TecDAX", "OSEBX", "OMX Tallinn", "OMX Riga", "OMX Vilnius", "NZX 50")
  indices$type <- ifelse(is.na(indices$currency), NA, ifelse(indices$label %in% total_return, "total return", "price"))

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
#' the 7 significant digits single precision holds, and to at least the 2
#' decimals indices are published with: 4554.98 for an index, and 0.90496
#' for the euros a dollar buys (see [currency_rates()]), which 2 decimals
#' would turn into 0.9.
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
  column <- function(name, digits = NULL) {
    values <- unlist(quote[[name]])
    if (length(values) != length(timestamp)) {
      return(rep(NA_real_, length(timestamp)))
    }
    values <- as.numeric(values)
    # 7 significant digits and at least 2 decimals (at most 15, which a 0 would otherwise exceed)
    if (is.null(digits)) digits <- pmin(pmax(2, 6 - floor(log10(abs(values)))), 15)
    round(values, digits)
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
#' @title Downloads that run at the same time
#' @description How many requests go to Yahoo Finance at once. More finish
#' sooner, but too many in a row can make it answer 429 (too many requests).
#' @noRd
parallel_downloads <- 8
##########################################################################################
#
##########################################################################################
#' @title Fetch several addresses at the same time
#' @description Sends every request at once, at most `parallel_downloads` at a
#' time, and waits for all of them, so 49 indices take about as long as the
#' slowest few instead of the sum of all of them.
#' @param urls Character vector of addresses.
#' @return A list with an element per address, in the same order: a list with
#'   the `status_code` and the raw `content` of the answer, or with the
#'   `error` message when the request could not be made.
#' @keywords internal
#' @examples
#' \dontrun{
#' golemstockindices:::fetch_all(c("https://example.com", "https://example.org"))
#' }
fetch_all <- function(urls) {
  answers <- vector("list", length(urls))
  pool <- curl::new_pool(host_con = parallel_downloads)
  for (i in seq_along(urls)) {
    local({
      j <- i
      handle <- curl::new_handle()
      curl::handle_setheaders(handle, "User-Agent" = user_agent)
      curl::curl_fetch_multi(
        urls[j], handle = handle, pool = pool,
        done = function(response) answers[[j]] <<- list(status_code = response$status_code, content = response$content),
        fail = function(message) answers[[j]] <<- list(error = message)
      )
    })
  }
  curl::multi_run(pool = pool)
  answers
}
##########################################################################################
#
##########################################################################################
#' @title Download the daily prices of several indices at the same time
#' @description Asks Yahoo Finance for the daily prices of each index from its
#' start date to now, one request per index, all sent at once (see
#' [fetch_all()]). A failed download is reported as a message instead of an
#' error, and the other indices are still read.
#' @param indices Rows of [get_indices()].
#' @param starts Dates, one per row: the first day to download.
#' @return A list with an element per row: the prices, as described in
#'   [parse_chart()], or `NULL` when nothing could be downloaded.
#' @keywords internal
#' @examples
#' \dontrun{
#' golemstockindices:::download_histories(get_indices()[1:3, ], rep(Sys.Date() - 30, 3))
#' }
download_histories <- function(indices, starts) {
  if (nrow(indices) == 0) {
    return(list())
  }
  urls <- sprintf(
    "%s%s?period1=%.0f&period2=%.0f&interval=1d&includePrePost=false",
    yahoo_url, vapply(indices$symbol, utils::URLencode, "", reserved = TRUE),
    as.numeric(as.POSIXct(as.character(starts), tz = "UTC")), as.numeric(Sys.time()) + 24 * 3600
  )
  answers <- fetch_all(urls)
  lapply(seq_len(nrow(indices)), function(i) {
    answer <- answers[[i]]
    tryCatch(
      {
        if (!is.null(answer$error)) {
          stop(answer$error, call. = FALSE)
        }
        if (answer$status_code != 200) {
          stop("Yahoo Finance answered with status ", answer$status_code, call. = FALSE)
        }
        parse_chart(rawToChar(answer$content), indices[i, ])
      },
      error = function(e) {
        message("The download of ", indices$label[i], " failed: ", conditionMessage(e))
        NULL
      }
    )
  })
}
##########################################################################################
#
##########################################################################################
#' @title Download the daily prices of an index
#' @description [download_histories()] for one index.
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
  download_histories(index, start_date)[[1]]
}
##########################################################################################
#
##########################################################################################
#' @title Get the whole price histories of indices, kept on disk and brought up to date
#' @description For an index not kept yet, the whole history is downloaded,
#' from its `from` day when it has one, and kept on disk (see
#' [disk_cache()]). A kept history more than an hour old is brought up to date
#' with its last two weeks, which also replace the kept days of those weeks, in
#' case Yahoo Finance corrected them; when that fails, the kept history is
#' used. The downloads of all the indices run at the same time (see
#' [download_histories()]).
#' @param indices Rows of [get_indices()].
#' @return A list with an element per row: the whole price history of the
#'   index, or `NULL` when it could not be downloaded.
#' @keywords internal
#' @examples
#' \dontrun{
#' golemstockindices:::index_histories(get_indices()[1:3, ])
#' }
index_histories <- function(indices) {
  if (nrow(indices) == 0) {
    return(list())
  }
  keys <- paste0("history_", tolower(gsub("[^A-Za-z0-9]", "", indices$symbol)))
  kept <- lapply(keys, function(key) disk_cache()$get(key))
  missing <- vapply(kept, cachem::is.key_missing, logical(1))
  stale <- !missing & vapply(kept, function(k) !cachem::is.key_missing(k) && minutes_since(k$time) >= history_minutes, logical(1))
  # what to download: the whole history of the missing ones, the last two weeks of the stale ones
  starts <- rep(as.Date(NA), length(keys))
  for (i in which(missing)) {
    starts[i] <- if (length(indices$from[i]) == 1 && !is.na(indices$from[i])) indices$from[i] else as.Date("1900-01-01")
  }
  for (i in which(stale)) {
    starts[i] <- max(kept[[i]]$history$timestamp) - 14
  }
  wanted <- which(missing | stale)
  downloaded <- vector("list", length(keys))
  if (length(wanted) > 0) {
    downloaded[wanted] <- download_histories(indices[wanted, , drop = FALSE], starts[wanted])
  }

  lapply(seq_along(keys), function(i) {
    new <- downloaded[[i]]
    if (missing[i]) {
      if (!is.null(new)) disk_cache()$set(keys[i], list(history = new, time = Sys.time()))
      return(new)
    }
    if (stale[i] && !is.null(new)) {
      older <- kept[[i]]$history[kept[[i]]$history$timestamp < min(new$timestamp), ]
      kept[[i]] <- list(history = rbind(older, new), time = Sys.time())
      disk_cache()$set(keys[i], kept[[i]])
    }
    kept[[i]]$history
  })
}
##########################################################################################
#
##########################################################################################
#' @title Get the whole price history of one index, kept on disk and brought up to date
#' @description [index_histories()] for one index.
#' @param index One row of [get_indices()].
#' @return The whole price history of the index, or `NULL` when it could not
#'   be downloaded.
#' @keywords internal
#' @examples
#' \dontrun{
#' golemstockindices:::index_history(get_indices()[1, ])
#' }
index_history <- function(index) {
  index_histories(index)[[1]]
}
##########################################################################################
#
##########################################################################################
#' @title Get the daily price history of indices
#' @description Returns the daily prices of one or more stock market indices
#' from Yahoo Finance, in index points. Each index's history is kept on disk
#' between R sessions, and once it is more than an hour old only its last two
#' weeks are downloaded again, so calls are fast. The downloads of several
#' indices run at the same time. An index is priced on the days its exchange
#' trades, so weekends and holidays have no prices.
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
  matched <- indices[match(unique(labels), indices$label, nomatch = 0), , drop = FALSE]
  history <- do.call(rbind, lapply(index_histories(matched), function(one) {
    if (!is.null(one)) one[one$timestamp >= start_date, ]
  }))
  if (is.null(history) || nrow(history) == 0) {
    return(NULL)
  }
  history <- history[order(history$label, history$timestamp), ]
  rownames(history) <- NULL
  history
}
