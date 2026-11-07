##########################################################################################
# 
##########################################################################################
#' @title Normalize close prices to 100
#' @description Every index starts at 100 on the first date on which all of them
#' have data, so their lines can be compared directly: 150 means the price rose
#' by half since that date.
#' @param history Price history from [get_history()], with `label`,
#'   `timestamp` and `close` columns, sorted by index and date.
#' @return `history` from the first common date on, with an `index` column.
#' @export
#' @examples
#' history <- data.frame(
#'   label = rep(c("Alpha (A)", "Beta (B)"), each = 3),
#'   timestamp = rep(as.Date("2024-01-01") + 0:2, 2),
#'   close = c(10, 11, 12, 200, 180, 220)
#' )
#' normalize_prices(history)
normalize_prices <- function(history) {
  first_date <- as.Date(
    max(tapply(as.numeric(history$timestamp), history$label, min)),
    origin = "1970-01-01"
  )
  prices <- history[history$timestamp >= first_date, ]
  prices$index <- stats::ave(prices$close, prices$label, FUN = function(x) x / x[1] * 100)
  prices
}
##########################################################################################
# 
##########################################################################################
#' @title Monthly returns of an index
#' @description Each month's return is its last close relative to the last close
#' of the month before, in percent. The first month, and the months still to
#' come, are `NA`.
#' @param history Price history of one index from [get_history()], with
#'   `timestamp` and `close` columns, sorted by date.
#' @return A year by month matrix of returns in percent, rounded to 2
#'   decimals, with the years as row names and `month.abb` as column names.
#' @export
#' @examples
#' history <- data.frame(
#'   timestamp = as.Date(c("2024-01-31", "2024-02-29", "2024-03-31")),
#'   close = c(100, 110, 121)
#' )
#' monthly_returns(history)
monthly_returns <- function(history) {
  check_one_index(history)
  month_close <- tapply(history$close, format(history$timestamp, "%Y-%m"), function(x) x[length(x)])
  month_return <- round((month_close / c(NA, utils::head(month_close, -1)) - 1) * 100, 2)
  months <- names(month_close)
  calendar <- tapply(
    month_return,
    list(substr(months, 1, 4), factor(as.integer(substr(months, 6, 7)), levels = 1:12)),
    sum
  )
  colnames(calendar) <- month.abb
  calendar
}
##########################################################################################
#
##########################################################################################
#' @title Moving average of prices
#' @description The simple moving average: each day's value is the mean of the
#' last `days` closes, that day included, so the first `days - 1` days have
#' none.
#' @param close Numeric vector of close prices, sorted by date.
#' @param days Number of days to average, such as 50 or 200.
#' @return A numeric vector as long as `close`, `NA` for the first
#'   `days - 1` days, and all `NA` when there are fewer than `days` closes,
#'   as for an index younger than the average.
#' @export
#' @examples
#' moving_average(c(1, 2, 3, 4, 5), days = 3)
moving_average <- function(close, days) {
  if (days > length(close)) {
    return(rep(NA_real_, length(close)))
  }
  as.numeric(stats::filter(close, rep(1 / days, days), sides = 1))
}
##########################################################################################
#
##########################################################################################
#' @title Drawdown of prices
#' @description How far each close is below the highest close up to that day,
#' the all-time high so far, in percent: 0 on a new high and -50 at half of it.
#' @param close Numeric vector of close prices, sorted by date.
#' @return A numeric vector as long as `close`, from -100 to 0.
#' @export
#' @examples
#' drawdown(c(100, 120, 90, 130, 65))
drawdown <- function(close) {
  (close / cummax(close) - 1) * 100
}
##########################################################################################
#
##########################################################################################
#' @title Where each index stands
#' @description For each index of a price history: its last close, and the
#' change in percent since the close before, since the last close at least a
#' week and a month before, since the last close of the year before (year to
#' date) and since the last close at least a year before, and how far it is
#' below its highest close. Pass the whole history, as the highest close is
#' that of the history given.
#' @param history Price history from [get_history()], with `label`,
#'   `timestamp` and `close` columns.
#' @return A data frame with a row per index, in the order of their first
#'   rows in `history`: `label`, `date` and `close` of the last day,
#'   `day_pct`, `week_pct`, `month_pct`, `ytd_pct`, `year_pct`, `high` and
#'   `high_date` of the highest close, `from_high_pct` (from -100 to 0) and
#'   `first_date`, the first day of the history. A change is `NA` when the
#'   history does not go back far enough.
#' @export
#' @examples
#' history <- data.frame(
#'   label = "Alpha",
#'   timestamp = as.Date(c("2024-12-31", "2025-06-30", "2025-12-31", "2026-01-02", "2026-01-05")),
#'   close = c(100, 150, 120, 126, 132)
#' )
#' index_summary(history)
index_summary <- function(history) {
  rows <- lapply(unique(history$label), function(label) {
    one <- history[history$label == label, ]
    one <- one[order(one$timestamp), ]
    n <- nrow(one)
    last <- one$close[n]
    date <- one$timestamp[n]
    change <- function(before) if (length(before) == 0) NA_real_ else (last / utils::tail(before, 1) - 1) * 100
    year_ago <- seq(date, by = "-1 year", length.out = 2)[2]
    month_ago <- seq(date, by = "-1 month", length.out = 2)[2]
    high <- which.max(one$close)
    data.frame(
      label = label,
      date = date,
      close = last,
      day_pct = change(one$close[-n]),
      week_pct = change(one$close[one$timestamp <= date - 7]),
      month_pct = change(one$close[one$timestamp <= month_ago]),
      ytd_pct = change(one$close[one$timestamp < as.Date(format(date, "%Y-01-01"))]),
      year_pct = change(one$close[one$timestamp <= year_ago]),
      high = one$close[high],
      high_date = one$timestamp[high],
      from_high_pct = (last / one$close[high] - 1) * 100,
      first_date = one$timestamp[1]
    )
  })
  do.call(rbind, rows)
}
