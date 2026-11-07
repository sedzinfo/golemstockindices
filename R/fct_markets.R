##########################################################################################
#
##########################################################################################
#' @title The exchanges of the indices and their trading hours
#' @description The regular sessions of each exchange in its own time zone,
#' with the lunch breaks of Shanghai, Hong Kong and Tokyo, and the indices
#' that follow its shares, from west to east. The Euro Stoxx 50 and the STOXX
#' Europe 600 are computed while the exchanges of Europe trade, so they go
#' with Frankfurt, and the VIX with New York. São Paulo moves its hours with
#' the summer time of the US: `sessions_us_summer` while New York is on it.
#' Holidays are not known.
#' @noRd
exchanges <- list(
  list(name = "Toronto", tz = "America/Toronto", sessions = "09:30-16:00", indices = "S&P/TSX Composite"),
  list(name = "New York", tz = "America/New_York", sessions = "09:30-16:00",
       indices = c("S&P 500", "Dow Jones", "Nasdaq Composite", "Russell 2000", "VIX")),
  list(name = "S\u00e3o Paulo", tz = "America/Sao_Paulo", sessions = "10:00-18:00", sessions_us_summer = "10:00-17:00",
       indices = "Bovespa"),
  list(name = "London", tz = "Europe/London", sessions = "08:00-16:30", indices = "FTSE 100"),
  list(name = "Frankfurt", tz = "Europe/Berlin", sessions = "09:00-17:30", indices = c("DAX", "Euro Stoxx 50", "STOXX Europe 600")),
  list(name = "Paris", tz = "Europe/Paris", sessions = "09:00-17:30", indices = "CAC 40"),
  list(name = "Madrid", tz = "Europe/Madrid", sessions = "09:00-17:30", indices = "IBEX 35"),
  list(name = "Milan", tz = "Europe/Rome", sessions = "09:00-17:30", indices = "FTSE MIB"),
  list(name = "Zurich", tz = "Europe/Zurich", sessions = "09:00-17:30", indices = "SMI"),
  list(name = "Athens", tz = "Europe/Athens", sessions = "10:00-17:20", indices = "Athens General"),
  list(name = "Mumbai", tz = "Asia/Kolkata", sessions = "09:15-15:30", indices = "Sensex"),
  list(name = "Shanghai", tz = "Asia/Shanghai", sessions = c("09:30-11:30", "13:00-15:00"), indices = "Shanghai Composite"),
  list(name = "Hong Kong", tz = "Asia/Hong_Kong", sessions = c("09:30-12:00", "13:00-16:00"), indices = "Hang Seng"),
  list(name = "Seoul", tz = "Asia/Seoul", sessions = "09:00-15:30", indices = "KOSPI"),
  list(name = "Tokyo", tz = "Asia/Tokyo", sessions = c("09:00-11:30", "12:30-15:30"), indices = "Nikkei 225"),
  list(name = "Sydney", tz = "Australia/Sydney", sessions = "10:00-16:00", indices = "ASX 200")
)
##########################################################################################
#
##########################################################################################
#' @title Which exchanges are open
#' @description For each exchange of the indices: its local time, and whether
#' it is open, at lunch or closed, with when that changes, from its regular
#' sessions on weekdays. Holidays are not known, so on a holiday an exchange
#' shows as open.
#' @param now The time to judge, now by default.
#' @return A data frame with a row per exchange, from west to east:
#'   `exchange`, `local_time` (such as "10:42"), `state` ("open", "lunch" or
#'   "closed"), `text`, when that changes (such as "closes 16:00", "reopens
#'   12:30" or "opens Mon 09:30"), `hours`, the regular sessions of the day
#'   (such as "09:00–11:30, 12:30–15:30"), `time_zone` and `indices`, the
#'   labels of its indices joined by commas.
#' @export
#' @examples
#' market_status()
#' # a Monday at 15:00 UTC: New York, London and the euro area are open
#' market_status(as.POSIXct("2026-11-09 15:00", tz = "UTC"))
market_status <- function(now = Sys.time()) {
  minutes <- function(hhmm) {
    parts <- as.integer(strsplit(hhmm, ":")[[1]])
    parts[1] * 60 + parts[2]
  }
  clock <- function(m) sprintf("%02d:%02d", m %/% 60, m %% 60)
  rows <- lapply(exchanges, function(exchange) {
    local <- as.POSIXlt(now, tz = exchange$tz)
    minute <- local$hour * 60 + local$min
    weekday <- local$wday %in% 1:5
    hours <- exchange$sessions
    if (!is.null(exchange$sessions_us_summer) && isTRUE(as.POSIXlt(now, tz = "America/New_York")$isdst > 0)) {
      hours <- exchange$sessions_us_summer
    }
    sessions <- t(vapply(strsplit(hours, "-"), function(s) c(minutes(s[1]), minutes(s[2])), numeric(2)))
    open <- weekday & minute >= sessions[, 1] & minute < sessions[, 2]
    if (any(open)) {
      state <- "open"
      text <- paste("closes", clock(sessions[which(open), 2]))
    } else if (weekday && minute >= sessions[1, 1] && minute < sessions[nrow(sessions), 2]) {
      state <- "lunch"
      text <- paste("reopens", clock(sessions[which(sessions[, 1] > minute)[1], 1]))
    } else {
      state <- "closed"
      # the next weekday that opens: today before the first session, or a later day
      days <- if (weekday && minute < sessions[1, 1]) 0 else 1
      while (!((local$wday + days) %% 7 %in% 1:5)) days <- days + 1
      text <- if (days == 0) {
        paste("opens", clock(sessions[1, 1]))
      } else {
        paste("opens", c("Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat")[(local$wday + days) %% 7 + 1], clock(sessions[1, 1]))
      }
    }
    data.frame(
      exchange = exchange$name, local_time = clock(minute), state = state, text = text,
      hours = paste(sub("-", "\u2013", hours, fixed = TRUE), collapse = ", "), time_zone = exchange$tz,
      indices = paste(exchange$indices, collapse = ", ")
    )
  })
  do.call(rbind, rows)
}
##########################################################################################
#
##########################################################################################
#' @title The strip of the exchanges that are open
#' @description A row of small labels, one per exchange, with a green dot
#' when it is open, an amber one at lunch and a grey one when it is closed.
#' Hovering over a label gives its local time, when that changes and its
#' indices; the table of [market_table()] has them all.
#' @param status The result of [market_status()].
#' @param table_id The id of that table on the page, for a link to it, or
#'   `NULL` for none.
#' @return A `div` of Shiny UI elements.
#' @keywords internal
#' @examples
#' golemstockindices:::market_strip(market_status())
market_strip <- function(status, table_id = NULL) {
  div(
    class = "market-strip",
    lapply(seq_len(nrow(status)), function(i) {
      row <- status[i, ]
      span(
        class = paste("market", row$state),
        title = paste0(row$local_time, " local time, ", row$text, " \u00b7 ", row$indices),
        span(class = "market-dot", `aria-hidden` = "true"),
        row$exchange
      )
    }),
    if (!is.null(table_id)) tags$a(class = "market-note", href = paste0("#", table_id), "Trading hours \u2193")
  )
}
##########################################################################################
#
##########################################################################################
#' @title The table of the exchanges and their trading hours
#' @description A row per exchange, from west to east: its indices, its local
#' time, whether it is open, at lunch or closed, with the dot of the strip of
#' [market_strip()], when that changes, its regular sessions and its time
#' zone.
#' @param status The result of [market_status()].
#' @return A `table` of Shiny UI elements.
#' @keywords internal
#' @examples
#' golemstockindices:::market_table(market_status())
market_table <- function(status) {
  states <- c(open = "Open", lunch = "Lunch break", closed = "Closed")
  tags$table(
    class = "table table-sm align-middle market-table",
    # every column but the indices on one line: on a phone the table scrolls sideways instead
    tags$thead(tags$tr(lapply(
      c("Exchange", "Indices", "Local time", "Now", "Next", "Regular hours", "Time zone"),
      function(name) tags$th(class = if (name != "Indices") "text-nowrap", name)
    ))),
    tags$tbody(lapply(seq_len(nrow(status)), function(i) {
      row <- status[i, ]
      tags$tr(
        tags$td(class = "text-nowrap", tags$strong(row$exchange)),
        tags$td(class = "market-indices", row$indices),
        tags$td(class = "market-time", row$local_time),
        tags$td(span(class = paste("market-state", row$state), span(class = "market-dot", `aria-hidden` = "true"), states[[row$state]])),
        tags$td(class = "text-nowrap", row$text),
        tags$td(class = "market-time", row$hours),
        tags$td(class = "text-body-secondary text-nowrap", row$time_zone)
      )
    }))
  )
}
##########################################################################################
#
##########################################################################################
#' @title A small line of the last year of closes
#' @description An inline SVG for a table cell: the closes of the last 365
#' days, thinned to at most 100 points, green when the year ended higher
#' than it started and red when lower.
#' @param date Dates of the closes, sorted.
#' @param close The closes.
#' @param label Name of the index, for screen readers.
#' @param width,height Size in pixels.
#' @return The SVG as a character string.
#' @keywords internal
#' @examples
#' golemstockindices:::sparkline_svg(Sys.Date() - 300:0, cumsum(rnorm(301)) + 100, "Alpha")
sparkline_svg <- function(date, close, label, width = 110, height = 26) {
  keep <- date >= max(date) - 365
  y <- close[keep]
  if (length(y) < 2) {
    return("")
  }
  if (length(y) > 100) y <- y[unique(c(round(seq(1, length(y), length.out = 100))))]
  range <- max(y) - min(y)
  x_px <- (seq_along(y) - 1) / (length(y) - 1) * (width - 2) + 1
  y_px <- if (range > 0) (height - 2) - (y - min(y)) / range * (height - 4) else rep(height / 2, length(y))
  change <- (utils::tail(y, 1) / y[1] - 1) * 100
  sprintf(
    paste0(
      '<svg width="%d" height="%d" viewBox="0 0 %d %d" role="img" aria-label="%s over the last year: %s%%">',
      '<polyline fill="none" stroke="%s" stroke-width="1.5" stroke-linejoin="round" points="%s"/></svg>'
    ),
    width, height, width, height, gsub("&", "&amp;", label, fixed = TRUE), signed(change), if (change >= 0) "#198754" else "#dc3545",
    paste(sprintf("%.1f,%.1f", x_px, y_px), collapse = " ")
  )
}
