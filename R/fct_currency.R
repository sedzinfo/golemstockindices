##########################################################################################
#
##########################################################################################
#' @title The currencies the Performance and Compare tabs can show the indices in
#' @description The choices of their currency pickers, and the names of the
#' currencies in the titles of the charts.
#' @noRd
currency_choices <- c("Local currencies" = "local", "US dollars" = "USD", "Euros" = "EUR")
#' @noRd
currency_names <- c(USD = "US dollars", EUR = "euros")
##########################################################################################
#
##########################################################################################
#' @title Days an exchange rate stands in for the days after it
#' @description A day without a rate of its own, such as a holiday of the
#' currency markets or a day Yahoo Finance lacks, takes the last rate before
#' it, but only from the week before: the rates of Yahoo Finance have gaps of
#' months, such as that of the Brazilian real from September 2004 to February
#' 2006, across which the last rate would be far off.
#' @noRd
rate_days <- 7
##########################################################################################
#
##########################################################################################
#' @title Exchange rates that are far from the rates around them
#' @description The daily rates of Yahoo Finance have errors on a few days,
#' some of them wild, such as a Taiwan dollar worth 16 times as much on 24
#' October 2011, or a run of days of late 2013 that put the rupiah 18% off. A
#' rate more than 15% away from the median of the 21 trading days around it is
#' left out, and of the rest, a rate more than 8% away from the median of the
#' 7 trading days around it. A real jump, such as that of the Swiss franc when
#' its cap on the euro ended in January 2015, takes the median with it, so it
#' stays. The first and last days of the history, which have no days on both
#' sides, are kept.
#' @param rate Numeric vector of the daily rates of a currency, sorted by date,
#'   without `NA`.
#' @return A logical vector as long as `rate`, `TRUE` for the rates to leave
#'   out.
#' @keywords internal
#' @examples
#' rate <- c(rep(1.02, 15), rep(0.86, 15))
#' rate[22] <- 0.086
#' which(golemstockindices:::bad_rates(rate))
bad_rates <- function(rate) {
  away <- function(rate, days, limit) {
    if (length(rate) < days) {
      return(rep(FALSE, length(rate)))
    }
    abs(log(rate / stats::runmed(rate, days, endrule = "keep"))) > log(1 + limit)
  }
  bad <- away(rate, 21, 0.15)
  bad[!bad] <- away(rate[!bad], 7, 0.08)
  bad
}
##########################################################################################
#
##########################################################################################
#' @title Daily exchange rates against the US dollar
#' @description The rates of Yahoo Finance, such as `EUR=X`, the euros a US
#' dollar buys, from as far back as it has them: 1996 for the yen, 2001 to
#' 2006 for the other currencies. They are downloaded, kept on disk and
#' brought up to date like the prices of the indices (see
#' [index_histories()]). The rates of weekends, when the currency markets are
#' closed and Yahoo Finance has a few stray ones, are left out, and so are
#' those far from the rates around them (see [bad_rates()]).
#' @param currencies Character vector of currency codes, such as "EUR". The US
#'   dollar, which needs no rate, and `NA` are left out.
#' @return A data frame with a row per currency and day: `currency`,
#'   `timestamp` (a Date) and `per_usd`, the units of the currency a US dollar
#'   buys. A currency whose rates cannot be downloaded has no rows.
#' @keywords internal
#' @examples
#' \dontrun{
#' golemstockindices:::currency_rates(c("EUR", "JPY"))
#' }
currency_rates <- function(currencies) {
  none <- data.frame(currency = character(), timestamp = as.Date(character()), per_usd = numeric())
  currencies <- setdiff(unique(currencies[!is.na(currencies)]), "USD")
  if (length(currencies) == 0) {
    return(none)
  }
  symbols <- data.frame(
    label = currencies,
    symbol = paste0(currencies, "=X"),
    from = rep(as.Date(NA), length(currencies))
  )
  histories <- index_histories(symbols)
  rates <- lapply(seq_along(currencies), function(i) {
    one <- histories[[i]]
    if (is.null(one)) {
      return(NULL)
    }
    one <- one[as.POSIXlt(one$timestamp)$wday %in% 1:5 & one$close > 0, ]
    one <- one[!bad_rates(one$close), ]
    data.frame(currency = rep(currencies[i], nrow(one)), timestamp = one$timestamp, per_usd = one$close)
  })
  rates <- do.call(rbind, rates)
  if (is.null(rates)) {
    return(none)
  }
  rownames(rates) <- NULL
  rates
}
##########################################################################################
#
##########################################################################################
#' @title Convert the prices of indices to one currency
#' @description Each price, in the money of the shares of its index, is
#' multiplied by the rate of its day, the units of the new currency that a
#' unit of that money buys, worked out through the US dollar from the rates
#' of Yahoo Finance (see [currency_rates()]): a price in yen, for example,
#' becomes `price × (euros per dollar) / (yen per dollar)` euros. A day without
#' a rate of its own takes the last rate of the week before it; the days
#' without one, as before the rates start, between 1996 and 2006 depending on
#' the currency, are left out. The volume, the VIX, which is not in the money
#' of any shares, and the indices already in the currency are left as they
#' are. The daily rates are not taken at the close of each exchange, so the
#' change of a single day mixes in a few hours of the moves of the currency;
#' over weeks and months this matters little.
#' @param history Price history from [get_history()].
#' @param to `"local"` to leave every index in the money of its shares, `"USD"`
#'   for US dollars or `"EUR"` for euros.
#' @param indices Data frame of indices from [get_indices()], for the currency
#'   of each.
#' @param rates Exchange rates from [currency_rates()], downloaded when `NULL`.
#' @return `history`, with `open`, `high`, `low` and `close` in the currency,
#'   without the days that have no rate.
#' @export
#' @examples
#' history <- data.frame(
#'   label = "Nikkei 225", timestamp = as.Date(c("2024-01-04", "2024-01-05")),
#'   open = 33000, high = 33500, low = 32800, close = c(33288, 33377), volume = 0
#' )
#' rates <- data.frame(
#'   currency = c("JPY", "JPY", "EUR", "EUR"),
#'   timestamp = as.Date(c("2024-01-04", "2024-01-05", "2024-01-04", "2024-01-05")),
#'   per_usd = c(144.6, 144.6, 0.913, 0.915)
#' )
#' convert_prices(history, "USD", rates = rates)
#' convert_prices(history, "EUR", rates = rates)
#' @examplesIf interactive()
#' # the S&P 500 and the DAX in euros, each starting at 100
#' euros <- convert_prices(get_history(c("S&P 500", "DAX")), "EUR")
#' plot_compare(normalize_prices(euros), currency = "EUR")
convert_prices <- function(history, to = c("local", "USD", "EUR"), indices = get_indices(), rates = NULL) {
  to <- match.arg(to)
  if (to == "local" || is.null(history) || nrow(history) == 0) {
    return(history)
  }
  from <- indices$currency[match(history$label, indices$label)]
  convert <- !is.na(from) & from != to
  if (!any(convert)) {
    return(history)
  }
  if (is.null(rates)) rates <- currency_rates(c(from[convert], to))
  # the units of a currency a dollar buys on each day, from the last rate of the week before at most
  per_usd <- function(currency, dates) {
    if (currency == "USD") {
      return(rep(1, length(dates)))
    }
    one <- rates[rates$currency == currency, ]
    one <- one[order(one$timestamp), ]
    last <- findInterval(as.numeric(dates), as.numeric(one$timestamp))
    found <- last > 0
    found[found] <- as.numeric(dates[found] - one$timestamp[last[found]]) <= rate_days
    rate <- rep(NA_real_, length(dates))
    rate[found] <- one$per_usd[last[found]]
    rate
  }
  factor <- rep(1, nrow(history))
  for (currency in unique(from[convert])) {
    rows <- which(convert & from == currency)
    dates <- as.Date(history$timestamp[rows])
    factor[rows] <- per_usd(to, dates) / per_usd(currency, dates)
  }
  for (column in intersect(c("open", "high", "low", "close"), names(history))) {
    history[[column]] <- history[[column]] * factor
  }
  history <- history[!is.na(factor), ]
  rownames(history) <- NULL
  history
}
##########################################################################################
#
##########################################################################################
#' @title The indices a conversion left out, in words
#' @description For the line above the charts of the Performance and Compare
#' tabs: [convert_prices()] leaves out an index whose exchange rates cannot be
#' downloaded.
#' @param labels The labels of the indices before the conversion.
#' @param converted The labels of the indices after it.
#' @return A sentence, or `NULL` when no index was left out.
#' @noRd
missing_rates_text <- function(labels, converted) {
  missing <- setdiff(unique(labels), unique(converted))
  if (length(missing) == 0) {
    return(NULL)
  }
  sprintf(
    "No exchange rates for %s right now, so %s left out.",
    and_list(missing), if (length(missing) == 1) "it is" else "they are"
  )
}
