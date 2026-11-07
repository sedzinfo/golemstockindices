##########################################################################################
# 
##########################################################################################
#' @title Color of a price change
#' @description Losses are red and gains green, more opaque the larger the
#' change, so that changes near zero take the color of the page in light and
#' dark mode. At most 75% opaque, so the text on top stays readable in both
#' modes.
#' @param strength Numbers from 0, no change, to 1, the largest change.
#' @param gain `TRUE` for gains, `FALSE` for losses.
#' @return CSS `rgba()` colors, one per `strength`.
#' @keywords internal
#' @examples
#' golemstockindices:::change_color(c(0, 0.5, 1), gain = TRUE)
change_color <- function(strength, gain) {
  rgb <- if (gain) "25,135,84" else "220,53,69"
  sprintf("rgba(%s,%.3f)", rgb, 0.75 * strength)
}
##########################################################################################
#
##########################################################################################
#' @title Shades of a table column, around a middle
#' @description 5 shades of red below the middle and 5 of green above it, up
#' to the largest distance from it, and no color near it, for
#' [DT::formatStyle()].
#' @param values The numbers of the column, or of the columns that share the
#'   scale.
#' @param middle The value that gets no color, such as 0 for changes or 50
#'   for a share in percent.
#' @return The JavaScript of [DT::styleInterval()].
#' @keywords internal
#' @examples
#' golemstockindices:::shade_interval(c(-3, 1, 2.5), 0)
shade_interval <- function(values, middle) {
  limit <- max(abs(values - middle), 1e-9, na.rm = TRUE)
  steps <- c(1, 0.8, 0.6, 0.4, 0.2)
  DT::styleInterval(
    middle + limit * seq(-0.9, 0.9, by = 0.2),
    c(change_color(steps, gain = FALSE), change_color(0, gain = TRUE), change_color(rev(steps), gain = TRUE))
  )
}
##########################################################################################
#
##########################################################################################
#' @title Send a long chart to the browser in less data
#' @description plotly repeats a hover template or text that is the same for
#' every point once per point, and keeps the attributes the chart was built
#' from, a second copy of its data. For the 25,000 days of the S&P 500 that
#' adds megabytes to the page and seconds to the drawing. The chart is built,
#' each such hover attribute keeps its one value once, and the second copy is
#' dropped.
#' @param p A plotly object.
#' @return The built plotly object.
#' @keywords internal
#' @examples
#' p <- plotly::plot_ly(x = 1:3, y = 1:3, type = "scatter", mode = "lines", hovertemplate = "%{y}")
#' golemstockindices:::compact_traces(p)$x$data[[1]]$hovertemplate
compact_traces <- function(p) {
  built <- plotly::plotly_build(p)
  built$x$data <- lapply(built$x$data, function(trace) {
    for (name in c("hovertemplate", "text", "hovertext")) {
      value <- trace[[name]]
      if (length(value) > 1 && length(unique(value)) == 1) trace[[name]] <- value[[1]]
    }
    trace
  })
  # the attributes the traces were built from, a second copy of all the data
  built$x$attrs <- NULL
  built
}
##########################################################################################
#
##########################################################################################
#' @title Color scale for price changes
#' @description The plotly version of `change_color()`: losses below the
#' middle, gains above it and no color in the middle.
#' @noRd
colorscale_change <- list(
  c(0, change_color(1, gain = FALSE)),
  c(0.5, change_color(0, gain = FALSE)),
  c(0.5, change_color(0, gain = TRUE)),
  c(1, change_color(1, gain = TRUE))
)
##########################################################################################
#
##########################################################################################
#' @title Text color of the light or dark mode
#' @param mode `"light"` or `"dark"`, the mode of the app.
#' @return A CSS color, the body text color of Bootstrap in that mode.
#' @keywords internal
#' @examples
#' golemstockindices:::text_color("dark")
text_color <- function(mode) {
  if (identical(mode, "dark")) "#dee2e6" else "#212529"
}
##########################################################################################
# 
##########################################################################################
#' @title Match a plotly chart to the light or dark mode of the app
#' @description plotly ignores the Bootstrap theme, so the backgrounds are
#' made transparent and the text and grid colors are switched to suit the mode,
#' on every axis of a chart with several panels.
#' @param p A plotly object.
#' @param mode `"light"` or `"dark"`, the value of the dark mode toggle.
#' @return The plotly object `p`, with its layout changed.
#' @keywords internal
#' @examples
#' p <- plotly::plot_ly(x = 1:3, y = c(2, 1, 3), type = "scatter", mode = "lines")
#' golemstockindices:::plot_theme(p, "dark")
plot_theme <- function(p, mode) {
  grid <- list(gridcolor = if (identical(mode, "dark")) "rgba(255,255,255,0.1)" else "rgba(0,0,0,0.1)")
  # a chart made with subplot() has an axis per panel: yaxis2, yaxis3, ...
  axes <- union(c("xaxis", "yaxis"), grep("^[xy]axis[0-9]*$", names(p$x$layout), value = TRUE))
  do.call(plotly::layout, c(
    list(p,
      paper_bgcolor = "rgba(0,0,0,0)",
      plot_bgcolor = "rgba(0,0,0,0)",
      font = list(color = text_color(mode))
    ),
    stats::setNames(rep(list(grid), length(axes)), axes)
  ))
}
##########################################################################################
# 
##########################################################################################
#' @title Background colors of plotly buttons for the light or dark mode
#' @description plotly buttons default to a light background, which hides the
#' light text of the dark mode.
#' @param mode `"light"` or `"dark"`, the mode of the app.
#' @return A list with the `bgcolor` and `activecolor` of the buttons, as
#'   used by a plotly `rangeselector`.
#' @keywords internal
#' @examples
#' golemstockindices:::button_colors("dark")
button_colors <- function(mode) {
  if (identical(mode, "dark")) {
    list(bgcolor = "#343a40", activecolor = "#6c757d")
  } else {
    list(bgcolor = "#eeeeee", activecolor = "#d4d4d4")
  }
}
##########################################################################################
# 
##########################################################################################
#' @title Stop when a price history holds more than one index
#' @description For the functions that work on one index at a time, so that a
#' history of several indices gives a clear error instead of a wrong result.
#' @param history Price history from [get_history()].
#' @return `history`, invisibly, when it holds at most one index.
#' @keywords internal
#' @examples
#' history <- data.frame(label = c("Alpha (A)", "Beta (B)"))
#' try(golemstockindices:::check_one_index(history))
check_one_index <- function(history) {
  indices <- unique(history$label)
  if (length(indices) > 1) {
    stop(
      "history holds ", length(indices), " indices, keep one of them first, for example ",
      "history[history$label == \"", indices[1], "\", ]",
      call. = FALSE
    )
  }
  invisible(history)
}
##########################################################################################
# 
##########################################################################################
#' @title Minutes since a time
#' @param time POSIXct.
#' @return The number of minutes from `time` until now.
#' @keywords internal
#' @examples
#' golemstockindices:::minutes_since(Sys.time() - 90)
minutes_since <- function(time) {
  as.numeric(difftime(Sys.time(), time, units = "mins"))
}
##########################################################################################
#
##########################################################################################
#' @title One card of a summary in words
#' @description A card of the Volatility and Drawdowns tabs: a headline and
#' a list of sentences.
#' @param part A list with a `headline` and `points`, as in the results of
#'   [volatility_text()] and [drawdown_text()].
#' @return A `bslib::card()`.
#' @keywords internal
#' @examples
#' golemstockindices:::summary_card(list(
#'   headline = "Last 2 days: +1.0% together, a normal rise",
#'   points = c("Day by day: 4 Nov +0.4%, 5 Nov +0.6%.", "...")
#' ))
summary_card <- function(part) {
  bslib::card(
    bslib::card_header(tags$strong(part$headline)),
    bslib::card_body(tags$ul(class = "mb-0", lapply(part$points, tags$li)))
  )
}
