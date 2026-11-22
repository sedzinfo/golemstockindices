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
#' @title Normalized prices relative to one of the indices
#' @description The relative strength of each index against a base index:
#' the ratio of their normalized prices, so 100 on the first common date, as
#' in [normalize_prices()]. A line that rises did better than the base, one
#' that falls did worse, and 120 means 20% better since the start. The
#' exchanges have holidays of their own, so on a day the base has no close,
#' its last close before stands in.
#' @param prices Prices from [normalize_prices()].
#' @param base The label of the index to divide by, one of those of
#'   `prices`.
#' @return The rows of `prices` of the other indices, with `index` the
#'   ratio to the base times 100, the base's own `index` in `base_index`,
#'   and `base`.
#' @export
#' @examples
#' history <- data.frame(
#'   label = rep(c("Alpha (A)", "Beta (B)"), each = 3),
#'   timestamp = rep(as.Date("2024-01-01") + 0:2, 2),
#'   close = c(10, 11, 12, 200, 180, 220)
#' )
#' relative_prices(normalize_prices(history), "Beta (B)")
relative_prices <- function(prices, base) {
  if (!base %in% prices$label) stop("base must be one of the indices of prices", call. = FALSE)
  base_prices <- prices[prices$label == base, ]
  base_prices <- base_prices[order(base_prices$timestamp), ]
  others <- prices[prices$label != base, ]
  # the base's last close on or before each day
  at <- findInterval(as.numeric(others$timestamp), as.numeric(base_prices$timestamp))
  others <- others[at > 0, ]
  base_index <- base_prices$index[at[at > 0]]
  others$base_index <- base_index
  others$index <- others$index / base_index * 100
  others$base <- rep(base, nrow(others))
  rownames(others) <- NULL
  others
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
#' @title Bollinger bands of prices
#' @description John Bollinger's bands: the moving average of the last `days`
#' closes (see [moving_average()]), and `width` standard deviations of those
#' closes above and below it. The bands widen when the index swings and
#' narrow when it is calm; a close outside them is far from its recent level.
#' The standard deviation is that of the closes in the window, divided by
#' `days` and not `days - 1`, as Bollinger defined it.
#' @param close Numeric vector of close prices, sorted by date.
#' @param days Number of days of the average, 20 by default.
#' @param width Number of standard deviations from the average to the bands,
#'   2 by default.
#' @return A data frame as long as `close` with `middle`, `upper` and
#'   `lower`, `NA` for the first `days - 1` days.
#' @export
#' @examples
#' bollinger_bands(c(10, 11, 12, 11, 10, 12, 14), days = 3)
bollinger_bands <- function(close, days = 20, width = 2) {
  middle <- moving_average(close, days)
  n <- length(close)
  variance <- rep(NA_real_, n)
  if (n >= days) {
    # the closes of each window, a row per day: the squared distances from the window's own
    # average, which the mean of the squares less the square of the mean would lose in rounding
    windows <- stats::embed(close, days)
    variance[days:n] <- rowMeans((windows - middle[days:n])^2)
  }
  spread <- width * sqrt(variance)
  data.frame(middle = middle, upper = middle + spread, lower = middle - spread)
}
##########################################################################################
#
##########################################################################################
#' @title Relative strength index of prices
#' @description J. Welles Wilder's RSI, from 0 to 100: the share of the
#' average daily rise in the average daily move,
#' `100 - 100 / (1 + average rise / average fall)`. The first averages are
#' the means of the rises and the falls of the first `days` days; after that
#' each day counts for `1 / days` of the average and the day before for the
#' rest, as Wilder smoothed them. Traders read above 70 as overbought, a run
#' up that may pause, and below 30 as oversold.
#' @param close Numeric vector of close prices, sorted by date.
#' @param days Number of days of the averages, 14 by default.
#' @return A numeric vector as long as `close`, `NA` for the first `days`
#'   days, 100 when the index only rose and 50 when it did not move.
#' @export
#' @examples
#' rsi(c(100, 101, 102, 101, 103, 104, 103, 105), days = 3)
rsi <- function(close, days = 14) {
  n <- length(close)
  out <- rep(NA_real_, n)
  if (n <= days) {
    return(out)
  }
  change <- diff(close)
  rise <- pmax(change, 0)
  fall <- pmax(-change, 0)
  smooth <- function(x) {
    first <- mean(x[seq_len(days)])
    rest <- x[-seq_len(days)]
    if (length(rest) == 0) {
      return(first)
    }
    c(first, as.numeric(stats::filter(rest / days, (days - 1) / days, method = "recursive", init = first)))
  }
  up <- smooth(rise)
  down <- smooth(fall)
  value <- ifelse(down == 0, ifelse(up == 0, 50, 100), 100 - 100 / (1 + up / down))
  out[(days + 1):n] <- value
  out
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
#' @title The same day some months before
#' @description The day `n` months before `date`, on the same day of the
#' month, or on the last day of the month when that month is shorter: a month
#' before 31 March is 28 February (29 in a leap year), where [seq()] would
#' overflow to 3 March, and a year before 29 February is 28 February.
#' @param date Dates.
#' @param n Number of months back, 12 for a year.
#' @return Dates, as many as `date`.
#' @keywords internal
#' @examples
#' golemstockindices:::months_back(as.Date(c("2025-03-31", "2025-05-15")), 1)
#' golemstockindices:::months_back(as.Date("2024-02-29"), 12)
months_back <- function(date, n) {
  day <- as.POSIXlt(date)
  # months since January 1900, the origin of the years of POSIXlt
  month <- day$year * 12 + day$mon - n
  first_day <- function(month) as.Date(ISOdate(month %/% 12 + 1900, month %% 12 + 1, 1))
  start <- first_day(month)
  start + pmin(day$mday, as.numeric(first_day(month + 1) - start)) - 1
}
##########################################################################################
#
##########################################################################################
#' @title The current run of rises or falls
#' @description How many closes in a row, up to the last one, rose or fell
#' from the close before. A close equal to the one before ends a run.
#' @param close Numeric vector of close prices, sorted by date.
#' @return An integer: positive for rises, such as 3 for three rises in a
#'   row, negative for falls, and 0 when the last close did not move or
#'   there is only one.
#' @keywords internal
#' @examples
#' golemstockindices:::streak(c(100, 99, 101, 102, 103))
#' golemstockindices:::streak(c(100, 101, 99, 98))
streak <- function(close) {
  moves <- sign(diff(close))
  n <- length(moves)
  if (n == 0 || is.na(moves[n]) || moves[n] == 0) {
    return(0L)
  }
  # the first move back from the last one that is not the same, a missing close included
  broken <- which(is.na(rev(moves)) | rev(moves) != moves[n])
  run <- if (length(broken) == 0) n else broken[1] - 1
  as.integer(run * moves[n])
}
##########################################################################################
#
##########################################################################################
#' @title Where each index stands
#' @description For each index of a price history: its last close, and the
#' change in percent since the close before, since the last close at least a
#' week and 1, 3, 6 and 9 months before, since the last close of the year
#' before (year to date) and since the last close at least a year before, and how far it is
#' below its highest close. Pass the whole history, as the highest close is
#' that of the history given. The months are counted with [months_back()]: a
#' month before 31 March is the last day of February, and a year before 29
#' February is 28 February.
#' @param history Price history from [get_history()], with `label`,
#'   `timestamp` and `close` columns.
#'
#' It also gives the trend of the last year: the current run of rises or
#' falls (see [streak()]), how far the last close is from its 200-day
#' average (see [moving_average()]), and from the lowest and the highest
#' close of the last 52 weeks, the closes after the day a year before.
#' @return A data frame with a row per index, in the order of their first
#'   rows in `history`: `label`, `date` and `close` of the last day,
#'   `day_pct`, `week_pct`, `month_pct`, `month3_pct`, `month6_pct`,
#'   `month9_pct`, `ytd_pct`, `year_pct`, `high` and
#'   `high_date` of the highest close, `from_high_pct` (from -100 to 0),
#'   `first_date`, the first day of the history, `streak`, `average200`
#'   and `from_average200_pct`, `low52` and `from_low52_pct` (0 or more),
#'   and `high52` and `from_high52_pct` (from -100 to 0). A change is `NA`
#'   when the history does not go back far enough, and the average when it
#'   has fewer than 200 closes.
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
    months_change <- function(n) change(one$close[one$timestamp <= months_back(date, n)])
    high <- which.max(one$close)
    last_year <- one$close[one$timestamp > months_back(date, 12)]
    average200 <- utils::tail(moving_average(one$close, 200), 1)
    data.frame(
      label = label,
      date = date,
      close = last,
      day_pct = change(one$close[-n]),
      week_pct = change(one$close[one$timestamp <= date - 7]),
      month_pct = months_change(1),
      month3_pct = months_change(3),
      month6_pct = months_change(6),
      month9_pct = months_change(9),
      ytd_pct = change(one$close[one$timestamp < as.Date(format(date, "%Y-01-01"))]),
      year_pct = months_change(12),
      high = one$close[high],
      high_date = one$timestamp[high],
      from_high_pct = (last / one$close[high] - 1) * 100,
      first_date = one$timestamp[1],
      streak = streak(one$close),
      average200 = average200,
      from_average200_pct = (last / average200 - 1) * 100,
      low52 = min(last_year),
      from_low52_pct = (last / min(last_year) - 1) * 100,
      high52 = max(last_year),
      from_high52_pct = (last / max(last_year) - 1) * 100
    )
  })
  do.call(rbind, rows)
}
##########################################################################################
#
##########################################################################################
#' @title The periods of the Performance tab
#' @description The periods of [index_summary()] that [performance_data()]
#' and [plot_performance()] take, shortest first, with "ytd", this year,
#' before the year.
#' @noRd
performance_periods <- c("day", "week", "month", "month3", "month6", "month9", "ytd", "year")
##########################################################################################
#
##########################################################################################
#' @title The change of each index over a period, the best first
#' @description The data of the Performance tab: the chart of
#' [plot_performance()] and its CSV file. The indices without a currency, the
#' VIX, are left out, as it measures the fear in the market rather than the
#' value of shares, and so are the indices without the change, such as those
#' younger than the period.
#' @param summary The result of [index_summary()].
#' @param indices Data frame of indices from [get_indices()].
#' @param period `"day"`, `"week"`, `"month"`, `"month3"`, `"month6"`,
#'   `"month9"` (3, 6 and 9 months), `"ytd"` (year to date) or `"year"`.
#' @param currency `"local"` for a summary of the prices in the money of
#'   each index, or the currency they were converted to with
#'   [convert_prices()], `"USD"` or `"EUR"`, which then fills the `currency`
#'   column.
#' @return A data frame with a row per index, the best first: `label`,
#'   `region`, `currency`, `type` ("total return" or "price", see
#'   [get_indices()]), `date` and `close` of the last day, and `change_pct`,
#'   the change over the period in percent.
#' @keywords internal
#' @examples
#' summary <- data.frame(
#'   label = c("S&P 500", "DAX", "VIX"), date = as.Date("2026-11-06"), close = c(6700, 23500, 19),
#'   day_pct = c(0.4, -0.8, 5), week_pct = 1, month_pct = 2, month3_pct = 4, month6_pct = 8,
#'   month9_pct = 12, ytd_pct = c(14, 18, -10), year_pct = 15
#' )
#' golemstockindices:::performance_data(summary, get_indices(), "day")
performance_data <- function(summary, indices, period = performance_periods, currency = "local") {
  period <- match.arg(period)
  shares <- indices[!is.na(indices$currency), c("label", "region", "currency", "type")]
  data <- merge(summary[c("label", "date", "close", paste0(period, "_pct"))], shares, by = "label")
  names(data)[names(data) == paste0(period, "_pct")] <- "change_pct"
  if (currency != "local") data$currency <- rep(currency, nrow(data))
  data <- data[!is.na(data$change_pct), c("label", "region", "currency", "type", "date", "close", "change_pct")]
  data <- data[order(-data$change_pct), ]
  rownames(data) <- NULL
  data
}
##########################################################################################
#
##########################################################################################
#' @title The line above the overview table: the days of the last closes
#' @description The day most indices last closed on, and then the indices
#' whose last close is of another day, by day, newest first. The exchanges of
#' Asia-Pacific close hours before those of Europe and the Americas, a holiday
#' leaves an index a day behind, and a special session, such as the hour of
#' trading of Mumbai on the evening of Diwali, can put one ahead, even on a
#' weekend. A region whose indices all share a day is named as a region, a
#' few indices by their labels, and more by their number, as the Date column
#' of the table has the day of each.
#' @param summary The result of [index_summary()].
#' @param indices Data frame of indices from [get_indices()], for the
#'   regions.
#' @return A string, such as "Daily closes from Yahoo Finance, up to 6 Nov
#'   2026; 8 Nov 2026 for Sensex".
#' @noRd
closes_text <- function(summary, indices) {
  dates <- summary$date
  counts <- table(format(dates))
  # the day most indices share, the newest of a tie
  main <- max(as.Date(names(counts)[counts == max(counts)]))
  text <- paste0("Daily closes from Yahoo Finance, up to ", long_date(main))
  others <- sort(unique(dates[dates != main]), decreasing = TRUE)
  if (length(others) == 0) {
    return(text)
  }
  regions <- c(
    US = "the US indices", Americas = "the other indices of the Americas",
    Europe = "the European indices", "Asia-Pacific" = "the Asia-Pacific indices"
  )
  known <- indices[indices$label %in% summary$label, ]
  parts <- character(length(others))
  for (i in seq_along(others)) {
    labels <- summary$label[dates == others[i]]
    whole <- Filter(function(region) {
      members <- known$label[known$region == region]
      length(members) > 0 && all(members %in% labels)
    }, names(regions))
    rest <- setdiff(labels, known$label[known$region %in% whole])
    who <- if (length(rest) > 4) {
      c(regions[whole], paste(length(rest), if (length(whole) > 0) "other indices" else "indices"))
    } else {
      c(regions[whole], rest)
    }
    parts[i] <- paste(long_date(others[i]), "for", and_list(unname(who)))
  }
  paste0(text, "; ", paste(parts, collapse = "; "))
}
