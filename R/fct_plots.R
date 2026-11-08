##########################################################################################
# 
##########################################################################################
#' @title Date range buttons of the timeseries chart
#' @noRd
range_buttons <- list(
  list(count = 1, label = "1 year", step = "year", stepmode = "backward"),
  list(count = 1, label = "year to date", step = "year", stepmode = "todate"),
  list(count = 6, label = "6 months", step = "month", stepmode = "backward"),
  list(count = 3, label = "3 months", step = "month", stepmode = "backward"),
  list(count = 1, label = "1 month", step = "month", stepmode = "backward"),
  list(count = 7, label = "7 days", step = "day", stepmode = "backward"),
  list(step = "all")
)
##########################################################################################
# 
##########################################################################################
#' @title Colors of the moving average lines, in the order of the averages
#' @description Blue and purple first, which stand out from the orange close
#' line, the green and red candles and the green volume, in light and dark mode.
#' @noRd
average_colors <- c("#3b82f6", "#a855f7", "#14b8a6", "#eab308")
##########################################################################################
#
##########################################################################################
#' @title Candlestick chart of an index's prices
#' @description Plots the daily open, high, low and close, in index points,
#' with a line through the close, its moving averages, date range buttons and
#' a range slider. Underneath, smaller charts show the trading volume, when
#' the history has any, and the drawdown: how far the index is below its
#' all-time high so far. A click on a legend entry hides or shows that line.
#'
#' The vertical axes follow the days in view: zoomed in, each runs from the
#' lowest to the highest value of those days, so a week's candles fill the
#' chart instead of lying flat on an axis that reaches back to the start of
#' the history. The Linear and Log buttons switch the axis of the prices; on
#' the log axis equal distances are equal percentages, which suits the whole
#' history.
#' @param history Price history of one index from [get_history()]. The
#'   averages and the drawdown use the whole history, so pass all of it and
#'   zoom with the range buttons.
#' @param mode `"light"` (the default) or `"dark"`, to suit a light or dark
#'   page.
#' @param averages Days of the moving averages to draw (see
#'   [moving_average()]), or `NULL` for none.
#' @param show_drawdown `TRUE` to add the drawdown chart (see [drawdown()]).
#' @return A plotly object.
#' @export
#' @examplesIf interactive()
#' spx <- get_history("S&P 500", as.Date("1950-01-01"))
#' plot_timeseries(spx)
#' # shorter averages, and no drawdown chart
#' plot_timeseries(spx, averages = c(20, 100), show_drawdown = FALSE)
plot_timeseries <- function(history, mode = "light", averages = c(50, 200), show_drawdown = TRUE) {
  check_one_index(history)
  # the candles show their open, high, low and close on hover by themselves
  price <- plotly::plot_ly(history,
    x = history$timestamp,
    open = history$open,
    high = history$high,
    low = history$low,
    close = history$close,
    yaxis = "y",
    name = "Range",
    type = "candlestick"
  ) %>%
    plotly::add_lines(
      x = history$timestamp,
      y = history$close,
      line = list(width = 1, color = "#ff7f0e"),
      inherit = FALSE,
      name = "close",
      hovertemplate = "%{x}<br>Close: %{y:,.2f}<extra></extra>"
    )
  for (i in seq_along(averages)) {
    price <- plotly::add_lines(price,
      x = history$timestamp,
      y = round(moving_average(history$close, averages[i]), 2),
      line = list(width = 1.5, color = average_colors[(i - 1) %% length(average_colors) + 1]),
      inherit = FALSE,
      name = paste0(averages[i], "-day average"),
      hovertemplate = paste0("%{x}<br>", averages[i], "-day average: %{y:,.2f}<extra></extra>")
    )
  }
  price <- price %>%
    plotly::layout(
      # on the left, as the legend is centred above the chart
      title = list(text = unique(history$label), x = 0.01, xanchor = "left"),
      legend = list(orientation = "h", x = 0.5, xanchor = "center"),
      yaxis = list(title = "Points"),
      xaxis = list(
        title = "Date",
        rangeslider = list(type = "date", visible = TRUE),
        rangeselector = c(button_colors(mode), list(buttons = range_buttons))
      )
    )
  volume <- plotly::plot_ly(
    x = history$timestamp,
    y = history$volume,
    type = "scatter",
    mode = "lines",
    line = list(color = "#2ca02c"),
    name = "Volume"
  ) %>%
    # no axis title: the legend names the panel, and on a short panel the titles run into each other
    plotly::layout(yaxis = list(title = ""))
  # the VIX has no volume, and the other indices none for their first years
  has_volume <- any(history$volume > 0, na.rm = TRUE)
  panels <- if (has_volume) list(price, volume) else list(price)
  heights <- if (has_volume) c(0.8, 0.2) else 1
  if (show_drawdown) {
    from_high <- plotly::plot_ly(
      x = history$timestamp,
      y = round(drawdown(history$close), 2),
      type = "scatter",
      mode = "lines",
      fill = "tozeroy",
      line = list(width = 1, color = change_color(1, gain = FALSE)),
      fillcolor = change_color(0.2, gain = FALSE),
      name = "From high",
      hovertemplate = "%{x}<br>From high: %{y:.1f}%<extra></extra>"
    ) %>%
      plotly::layout(yaxis = list(title = "", ticksuffix = "%"))
    panels <- c(panels, list(from_high))
    heights <- if (has_volume) c(0.65, 0.15, 0.2) else c(0.75, 0.25)
  }
  plotly::subplot(panels, heights = heights, nrows = length(panels), shareX = TRUE, titleY = TRUE) %>%
    plotly::layout(updatemenus = list(list(
      type = "buttons",
      direction = "right",
      # at the right of the row of the range buttons
      x = 1,
      xanchor = "right",
      y = 1,
      yanchor = "bottom",
      # light in both modes, as plotly draws the active button light, as on the Compare chart
      bgcolor = "#eeeeee",
      font = list(color = "#212529"),
      buttons = list(
        list(label = "Linear", method = "relayout", args = list("yaxis.type", "linear")),
        list(label = "Log", method = "relayout", args = list("yaxis.type", "log"))
      )
    ))) %>%
    plot_theme(mode) %>%
    compact_traces() %>%
    htmlwidgets::onRender(paste(readLines(app_sys("js/fit_y_axes.js"), warn = FALSE), collapse = "\n"))
}
##########################################################################################
# 
##########################################################################################
#' @title Line chart of normalized close prices
#' @description One line per index, with buttons that switch the y axis between
#' a linear and a log scale.
#' @param prices Prices from [normalize_prices()].
#' @inheritParams plot_timeseries
#' @return A plotly object.
#' @export
#' @examplesIf interactive()
#' history <- get_history(c("S&P 500", "Euro Stoxx 50", "Nikkei 225"))
#' plot_compare(normalize_prices(history))
plot_compare <- function(prices, mode = "light") {
  plotly::plot_ly(prices,
    x = ~timestamp,
    y = ~index,
    color = ~label,
    type = "scatter",
    mode = "lines",
    hovertemplate = "%{x}<br>%{y:.2f}"
  ) %>%
    plotly::layout(
      title = paste0("Normalized close (", min(prices$timestamp), " = 100)"),
      legend = list(orientation = "h", x = 0.5, xanchor = "center"),
      xaxis = list(title = "Date"),
      yaxis = list(title = "Index"),
      updatemenus = list(list(
        type = "buttons",
        direction = "right",
        x = 0,
        y = 1.08,
        # plotly draws the active button light in both modes, so the other buttons get a
        # light background too, instead of the page's, and all of them dark text
        bgcolor = "#eeeeee",
        font = list(color = "#212529"),
        buttons = list(
          list(label = "Linear", method = "relayout", args = list("yaxis.type", "linear")),
          list(label = "Log", method = "relayout", args = list("yaxis.type", "log"))
        )
      ))
    ) %>%
    plot_theme(mode) %>%
    compact_traces()
}
##########################################################################################
#
##########################################################################################
#' @title Linear and log axes side by side
#' @description An example for the About tab: two made-up indices that grow at
#' steady rates, one doubling every year and one by 25% a year, on a linear axis
#' and on a log axis. On the log axis both are straight lines, and the steeper
#' line is the faster growth.
#' @inheritParams plot_timeseries
#' @return A plotly object.
#' @keywords internal
#' @examples
#' golemstockindices:::plot_scales()
plot_scales <- function(mode = "light") {
  years <- seq(0, 5, by = 1 / 12)
  indices <- list("Doubles every year" = 100 * 2^years, "+25% a year" = 100 * 1.25^years)
  panel <- function(type) {
    p <- plotly::plot_ly()
    for (i in seq_along(indices)) {
      p <- plotly::add_lines(p,
        x = years,
        y = indices[[i]],
        name = names(indices)[i],
        legendgroup = names(indices)[i],
        # one legend entry per index for both panels
        showlegend = type == "linear",
        line = list(color = average_colors[i]),
        hovertemplate = "Year %{x:.1f}<br>Index %{y:,.0f}<extra></extra>"
      )
    }
    yaxis <- list(type = type, title = if (type == "linear") "Index" else "")
    # a gridline at every doubling, equally far apart on the log axis
    if (type == "log") yaxis$tickvals <- 100 * 2^(0:5)
    plotly::layout(p, xaxis = list(title = "Years"), yaxis = yaxis)
  }
  title <- function(text, x) {
    list(text = text, x = x, y = 1, xref = "paper", yref = "paper", xanchor = "center", yanchor = "bottom", showarrow = FALSE)
  }
  plotly::subplot(panel("linear"), panel("log"), titleX = TRUE, titleY = TRUE, margin = 0.07) %>%
    plotly::layout(
      # above the panel titles, clear of the axis titles under the panels
      legend = list(orientation = "h", x = 0.5, xanchor = "center", y = 1.12, yanchor = "bottom"),
      annotations = list(title("Linear axis", 0.215), title("Log axis", 0.785)),
      margin = list(t = 80)
    ) %>%
    # an illustration: no zoom or download buttons, which would cover the panel titles
    plotly::config(displayModeBar = FALSE) %>%
    plot_theme(mode)
}
##########################################################################################
# 
##########################################################################################
#' @title Heatmap of monthly returns by year
#' @description Months are colored from red to green by their return. The color
#' limit is the 95th percentile of the absolute returns, so a few extreme
#' months do not wash out the rest.
#' @param calendar Matrix from [monthly_returns()].
#' @param label Label of the index for the title, or `NULL` for none.
#' @inheritParams plot_timeseries
#' @return A plotly object.
#' @export
#' @examplesIf interactive()
#' spx <- get_history("S&P 500", as.Date("1950-01-01"))
#' plot_returns_calendar(monthly_returns(spx), "S&P 500")
plot_returns_calendar <- function(calendar, label = NULL, mode = "light") {
  limit <- unname(stats::quantile(abs(calendar), .95, na.rm = TRUE))
  plotly::plot_ly(
    x = colnames(calendar),
    y = rownames(calendar),
    z = calendar,
    type = "heatmap",
    zmin = -limit,
    zmax = limit,
    colorscale = colorscale_change,
    hovertemplate = "%{x} %{y}<br>%{z:.2f}%<extra></extra>"
  ) %>%
    plotly::layout(
      title = paste(c("Monthly returns", label), collapse = ": "),
      # the grid would show through the faint and the empty months
      xaxis = list(title = "", showgrid = FALSE),
      yaxis = list(title = "", type = "category", showgrid = FALSE)
    ) %>%
    plot_theme(mode)
}
##########################################################################################
#
##########################################################################################
#' @title Volatility chart of an index
#' @description Three panels. The upper one is the volatility of every
#' `month_days`-day period over the whole history, annualized, with its
#' median and 95th percentile: where the line is now shows how rough the
#' last month was. The middle one shows each of the last `days` days as a bar
#' of its move in the standard deviations the GARCH model expected for it,
#' red for falls and green for rises, with lines at 2 and 4 standard
#' deviations. The lower one shows the last `context_days` closes and the
#' forecast of the next days: the median close, and the ranges of the middle
#' half and of probability `level` (see [volatility_analysis()]). Without a
#' GARCH model only the upper panel is drawn.
#' @param analysis The result of [volatility_analysis()].
#' @param days Days of the middle panel.
#' @param context_days Closes before the forecast in the lower panel.
#' @inheritParams plot_timeseries
#' @return A plotly object.
#' @export
#' @examplesIf interactive()
#' spx <- get_history("S&P 500", as.Date("1950-01-01"))
#' plot_volatility(volatility_analysis(spx))
plot_volatility <- function(analysis, mode = "light", days = 63, context_days = 21) {
  series <- analysis$series
  month <- analysis$settings$month_days
  volatility <- series[!is.na(series$volatility_month), ]
  level <- function(p, name, dash) {
    value <- stats::quantile(volatility$volatility_month, p)
    list(
      x = range(volatility$date), y = rep(value, 2), name = name,
      line = list(width = 1, dash = dash, color = average_colors[2]),
      hovertemplate = paste0(name, ": %{y:.1f}%<extra></extra>")
    )
  }
  upper <- plotly::plot_ly(
    x = volatility$date,
    y = round(volatility$volatility_month, 2),
    type = "scatter",
    mode = "lines",
    line = list(width = 1, color = "#ff7f0e"),
    name = paste0(month, "-day volatility"),
    hovertemplate = paste0("%{x}<br>", month, "-day volatility: %{y:.1f}% a year<extra></extra>")
  )
  for (line in list(level(0.5, "Median", "dash"), level(0.95, "95th percentile", "dot"))) {
    upper <- do.call(plotly::add_lines, c(list(upper, inherit = FALSE), line))
  }
  upper <- plotly::layout(upper, yaxis = list(title = "% a year", ticksuffix = "%"), xaxis = list(title = ""))
  title <- paste0(analysis$index, ": volatility")
  if (is.null(analysis$garch)) {
    return(plotly::layout(upper, title = list(text = title, x = 0.01, xanchor = "left"), legend = list(orientation = "h", x = 0.5, xanchor = "center")) %>%
      plot_theme(mode) %>%
      compact_traces())
  }
  recent <- utils::tail(series[!is.na(series$garch_z), ], days)
  lower <- plotly::plot_ly(
    x = recent$date,
    y = recent$garch_z,
    type = "bar",
    marker = list(color = ifelse(recent$garch_z < 0, change_color(1, gain = FALSE), change_color(1, gain = TRUE))),
    customdata = recent$return_pct,
    name = "Daily move in GARCH standard deviations",
    hovertemplate = "%{x}<br>%{customdata:+.2f}%, %{y:+.1f} standard deviations<extra></extra>"
  )
  for (z in c(-4, -2, 2, 4)) {
    lower <- plotly::add_lines(lower,
      x = range(recent$date), y = c(z, z), inherit = FALSE, showlegend = FALSE, hoverinfo = "skip",
      line = list(width = 1, dash = if (abs(z) == 2) "dash" else "dot", color = text_color(mode))
    )
  }
  lower <- plotly::layout(lower, yaxis = list(title = paste("Last", days, "days, sd")), xaxis = list(title = ""))
  ahead <- plot_forecast(analysis, context_days)
  plotly::subplot(upper, lower, ahead, nrows = 3, heights = c(0.38, 0.31, 0.31), titleY = TRUE, margin = 0.05) %>%
    plotly::layout(
      title = list(text = title, x = 0.01, xanchor = "left"),
      # below the dates of the lower panel, which plotly would otherwise draw it over
      legend = list(orientation = "h", x = 0.5, xanchor = "center", y = 0, yanchor = "bottom", yref = "container"),
      margin = list(b = 90),
      bargap = 0.2
    ) %>%
    plot_theme(mode) %>%
    compact_traces()
}
##########################################################################################
#
##########################################################################################
#' @title Forecast panel of the volatility chart
#' @description The last closes and the forecast ranges of the next days,
#' which start from the last close, for [plot_volatility()]. Hover over the
#' median line for the ranges of a day.
#' @param analysis The result of [volatility_analysis()], with a forecast.
#' @param context_days Closes before the forecast.
#' @return A plotly object.
#' @keywords internal
#' @examples
#' \dontrun{
#' spx <- get_history("S&P 500", as.Date("1950-01-01"))
#' golemstockindices:::plot_forecast(volatility_analysis(spx), 30)
#' }
plot_forecast <- function(analysis, context_days) {
  level <- round(100 * analysis$settings$level)
  closes <- utils::tail(analysis$series, context_days)
  last <- utils::tail(closes, 1)
  # the ranges start from the last close
  columns <- c("low", "low_50", "median", "high_50", "high")
  start <- data.frame(date = last$date, matrix(last$close, 1, 5, dimnames = list(NULL, columns)))
  cone <- rbind(start, analysis$forecast$days[c("date", columns)])
  color <- average_colors[1]
  band <- function(alpha) sprintf("rgba(59,130,246,%s)", alpha)
  plotly::plot_ly(
    x = closes$date,
    y = closes$close,
    type = "scatter",
    mode = "lines",
    line = list(width = 1.5, color = color),
    name = "Close",
    hovertemplate = "%{x}<br>Close: %{y:,.2f}<extra></extra>"
  ) %>%
    plotly::add_ribbons(
      x = cone$date, ymin = cone$low, ymax = cone$high, inherit = FALSE,
      name = paste0(level, "% range"), fillcolor = band(0.15), line = list(width = 0), hoverinfo = "skip"
    ) %>%
    plotly::add_ribbons(
      x = cone$date, ymin = cone$low_50, ymax = cone$high_50, inherit = FALSE,
      name = "50% range", fillcolor = band(0.3), line = list(width = 0), hoverinfo = "skip"
    ) %>%
    plotly::add_lines(
      x = cone$date, y = cone$median, inherit = FALSE, name = "Forecast median",
      line = list(width = 1.5, dash = "dash", color = color),
      customdata = lapply(seq_len(nrow(cone)), function(i) unname(unlist(cone[i, c("low", "low_50", "high_50", "high")]))),
      hovertemplate = paste0(
        "%{x}<br>Median: %{y:,.2f}<br>50%: %{customdata[1]:,.2f} to %{customdata[2]:,.2f}<br>",
        level, "%: %{customdata[0]:,.2f} to %{customdata[3]:,.2f}<extra></extra>"
      )
    ) %>%
    plotly::layout(yaxis = list(title = "Next days, points"), xaxis = list(title = ""))
}
##########################################################################################
#
##########################################################################################
#' @title Drawdown chart of an index
#' @description Two panels over the whole history. The upper one is the
#' close on a log scale with the all-time high so far; the lower one is the
#' drawdown, how far each close is below that high (see [drawdown()]), with
#' a dashed line at `min_depth` percent. The falls of the analysis are shaded
#' from their peak to their recovery, the current one in amber, and their
#' troughs carry their rank, as in [drawdown_table()]; hover over a trough
#' for its dates.
#' @param analysis The result of [drawdown_analysis()].
#' @inheritParams plot_timeseries
#' @return A plotly object.
#' @export
#' @examplesIf interactive()
#' spx <- get_history("S&P 500", as.Date("1950-01-01"))
#' plot_drawdowns(drawdown_analysis(spx))
plot_drawdowns <- function(analysis, mode = "light") {
  series <- analysis$series
  episodes <- analysis$episodes
  current <- "rgba(245,158,11,%s)"
  price <- plotly::plot_ly(
    x = series$date,
    y = series$close,
    type = "scatter",
    mode = "lines",
    line = list(width = 1, color = "#ff7f0e"),
    name = "close",
    hovertemplate = "%{x}<br>Close: %{y:,.2f}<extra></extra>"
  ) %>%
    plotly::add_lines(
      x = series$date,
      y = series$high,
      inherit = FALSE,
      line = list(width = 1, dash = "dot", color = text_color(mode)),
      name = "All-time high so far",
      hovertemplate = "%{x}<br>All-time high so far: %{y:,.2f}<extra></extra>"
    ) %>%
    plotly::layout(yaxis = list(title = "Points, log scale", type = "log"))
  under <- plotly::plot_ly(
    x = series$date,
    y = round(series$drawdown_pct, 2),
    type = "scatter",
    mode = "lines",
    fill = "tozeroy",
    line = list(width = 1, color = change_color(1, gain = FALSE)),
    fillcolor = change_color(0.2, gain = FALSE),
    name = "From high",
    hovertemplate = "%{x}<br>From high: %{y:.1f}%<extra></extra>"
  ) %>%
    plotly::add_lines(
      x = range(series$date), y = rep(-analysis$min_depth, 2), inherit = FALSE, showlegend = FALSE, hoverinfo = "skip",
      line = list(width = 1, dash = "dash", color = text_color(mode))
    )
  shapes <- list()
  if (nrow(episodes) > 0) {
    end <- ifelse(episodes$ongoing, as.character(analysis$last_date), as.character(episodes$recovery_date))
    back <- ifelse(
      episodes$ongoing,
      paste0("not back at the high yet, ", fmt(episodes$days_total, 0), " days so far"),
      paste0("back at the high ", episodes$recovery_date, ", ", fmt(episodes$days_total, 0), " days after the peak")
    )
    under <- plotly::add_trace(under,
      x = episodes$trough_date,
      y = episodes$depth_pct,
      type = "scatter",
      mode = "markers+text",
      inherit = FALSE,
      text = episodes$rank,
      textposition = "bottom center",
      textfont = list(color = text_color(mode), size = 11),
      marker = list(size = 7, color = ifelse(episodes$ongoing, sprintf(current, 1), change_color(1, gain = FALSE))),
      name = paste0("Falls of ", analysis$min_depth, "% or more"),
      customdata = paste0(
        "#", episodes$rank, ": ", sprintf("%.1f", episodes$depth_pct), "%<br>",
        "peak ", episodes$peak_date, ", trough ", episodes$trough_date, "<br>", back
      ),
      hovertemplate = "%{customdata}<extra></extra>"
    )
    shapes <- lapply(seq_len(nrow(episodes)), function(i) {
      list(
        type = "rect", xref = "x", yref = "paper", x0 = as.character(episodes$peak_date[i]), x1 = end[i], y0 = 0, y1 = 1,
        fillcolor = if (episodes$ongoing[i]) sprintf(current, 0.15) else change_color(0.12, gain = FALSE),
        line = list(width = 0), layer = "below"
      )
    })
  }
  under <- plotly::layout(under, yaxis = list(title = "From high", ticksuffix = "%"))
  chart <- plotly::subplot(price, under, nrows = 2, heights = c(0.55, 0.45), shareX = TRUE, titleY = TRUE, margin = 0.03)
  # set directly: layout() merges with modifyList(), which drops a list of shapes without names
  chart$x$layout$shapes <- shapes
  chart %>%
    plotly::layout(
      title = list(text = paste0(analysis$index, ": falls from the all-time high"), x = 0.01, xanchor = "left"),
      legend = list(orientation = "h", x = 0.5, xanchor = "center", y = 0, yanchor = "bottom", yref = "container"),
      margin = list(b = 60),
      xaxis = list(title = "")
    ) %>%
    plot_theme(mode) %>%
    compact_traces()
}
##########################################################################################
#
##########################################################################################
#' @title Table of the falls of an index
#' @description A sortable table of the falls of [drawdown_analysis()], the
#' deepest first, with the numbers of the chart of [plot_drawdowns()]. The
#' fall is shaded red, more strongly the deeper it is, and the current fall,
#' which has not got back to its high, is in bold.
#' @param analysis The result of [drawdown_analysis()].
#' @return A DT datatable.
#' @export
#' @examplesIf interactive()
#' spx <- get_history("S&P 500", as.Date("1950-01-01"))
#' drawdown_table(drawdown_analysis(spx))
drawdown_table <- function(analysis) {
  episodes <- analysis$episodes
  table <- data.frame(
    episodes$rank, episodes$peak_date, episodes$peak_price, episodes$trough_date, episodes$trough_price,
    episodes$depth_pct, episodes$days_to_trough, episodes$recovery_date, episodes$days_to_recover, episodes$days_total,
    episodes$ongoing
  )
  names(table) <- c(
    "#", "Peak", "High", "Trough", "Low", "Fall", "Days to trough", "Back at high", "Days to recover", "Days in all", "ongoing"
  )
  # index points with 2 decimals, as in the text of the cards
  price <- DT::JS(
    "function(data, type) {",
    "  if (type !== 'display' || data === null) return data;",
    "  return Number(data).toLocaleString('en-US', {minimumFractionDigits: 2, maximumFractionDigits: 2});",
    "}"
  )
  # the dates and days a fall that goes on does not have yet
  missing <- function(text) DT::JS(sprintf("function(data, type) { return type === 'display' && data === null ? '%s' : data; }", text))
  days <- DT::JS(
    "function(data, type) {",
    "  if (type !== 'display') return data;",
    "  return data === null ? '\\u2013' : Number(data).toLocaleString('en-US');",
    "}"
  )
  DT::datatable(table,
    rownames = FALSE,
    selection = "none",
    options = list(
      dom = if (nrow(table) > 20) "tp" else "t",
      pageLength = 20,
      columnDefs = list(
        list(targets = c(2, 4), render = price),
        list(targets = 7, render = missing("not yet")),
        list(targets = c(6, 8, 9), render = days),
        list(targets = 10, visible = FALSE),
        list(targets = c(0, 2, 4:6, 8:9), className = "dt-right")
      )
    )
  ) %>%
    DT::formatCurrency("Fall", currency = "%", before = FALSE, digits = 1) %>%
    DT::formatStyle("Fall", backgroundColor = DT::styleInterval(
      seq(-90, -10, by = 10), change_color(seq(1, 0.1, length.out = 10), gain = FALSE)
    )) %>%
    DT::formatStyle(names(table), valueColumns = "ongoing", fontWeight = DT::styleEqual(TRUE, "bold"))
}
##########################################################################################
#
##########################################################################################
#' @title Seasonality chart of an index
#' @description Two panels with a bar per group of [seasonality_analysis()].
#' The upper one shows the mean return, green above 0 and red below, with the
#' median as a diamond; the lower one shows the share of the returns above 0,
#' with a dashed line at 50%. Hover over a bar for all the numbers of its
#' group.
#' @param analysis The result of [seasonality_analysis()].
#' @inheritParams plot_timeseries
#' @return A plotly object.
#' @export
#' @examplesIf interactive()
#' spx <- get_history("S&P 500", as.Date("1950-01-01"))
#' plot_seasonality(seasonality_analysis(spx, "month"))
#' plot_seasonality(seasonality_analysis(spx, "day"), mode = "dark")
plot_seasonality <- function(analysis, mode = "light") {
  groups <- analysis$groups
  words <- seasonality_periods[[analysis$period]]
  digits <- return_digits(analysis$period)
  # plotly reads week numbers as numbers, so the groups are text on a category axis
  x <- as.character(groups$group)
  number <- function(value) sprintf(paste0("%+.", digits, "f%%"), value)
  hover <- paste0(
    words$group, ": ", x, "<br>",
    "Mean: ", number(groups$mean_pct), "<br>",
    "Median: ", number(groups$median_pct), "<br>",
    "Up: ", round(groups$up_pct * groups$returns / 100), " of ", groups$returns, " (", sprintf("%.0f", groups$up_pct), "%)<br>",
    "Best: ", number(groups$best_pct), ", worst: ", number(groups$worst_pct)
  )
  returns <- plotly::plot_ly(
    x = x,
    y = groups$mean_pct,
    type = "bar",
    marker = list(color = ifelse(groups$mean_pct >= 0, change_color(1, gain = TRUE), change_color(1, gain = FALSE))),
    name = "Mean",
    customdata = hover,
    hovertemplate = "%{customdata}<extra></extra>"
  ) %>%
    plotly::add_trace(
      x = x,
      y = groups$median_pct,
      type = "scatter",
      mode = "markers",
      inherit = FALSE,
      marker = list(symbol = "diamond", size = 8, color = text_color(mode)),
      name = "Median",
      customdata = hover,
      hovertemplate = "%{customdata}<extra></extra>"
    ) %>%
    plotly::layout(yaxis = list(title = "Return", ticksuffix = "%"))
  up <- plotly::plot_ly(
    x = x,
    y = groups$up_pct,
    type = "bar",
    marker = list(color = ifelse(groups$up_pct >= 50, change_color(0.5, gain = TRUE), change_color(0.5, gain = FALSE))),
    name = "Share up",
    customdata = hover,
    hovertemplate = "%{customdata}<extra></extra>"
  ) %>%
    plotly::layout(yaxis = list(title = "Up", ticksuffix = "%", range = c(0, 100)))
  chart <- plotly::subplot(returns, up, nrows = 2, heights = c(0.6, 0.4), shareX = TRUE, titleY = TRUE, margin = 0.03)
  # set directly: layout() merges with modifyList(), which drops a list of shapes without names
  chart$x$layout$shapes <- list(list(
    type = "line", xref = "paper", x0 = 0, x1 = 1, yref = "y2", y0 = 50, y1 = 50,
    line = list(width = 1, dash = "dash", color = text_color(mode))
  ))
  chart %>%
    plotly::layout(
      title = list(text = paste0(analysis$index, ": ", words$title), x = 0.01, xanchor = "left"),
      legend = list(orientation = "h", x = 0.5, xanchor = "center", y = 0, yanchor = "bottom", yref = "container"),
      margin = list(b = 60),
      xaxis = list(title = "", type = "category", categoryorder = "array", categoryarray = x)
    ) %>%
    plot_theme(mode)
}
##########################################################################################
#
##########################################################################################
#' @title Table of the seasonality of an index
#' @description A table with a row per group of [seasonality_analysis()], in
#' their natural order, with the numbers of the chart of
#' [plot_seasonality()]. The mean and the median are shaded red below 0 and
#' green above it, and the share up red below 50% and green above it, more
#' strongly the further they are from the middle.
#' @param analysis The result of [seasonality_analysis()].
#' @return A DT datatable.
#' @export
#' @examplesIf interactive()
#' spx <- get_history("S&P 500", as.Date("1950-01-01"))
#' seasonality_table(seasonality_analysis(spx, "month"))
seasonality_table <- function(analysis) {
  groups <- analysis$groups
  digits <- return_digits(analysis$period)
  # week numbers sort as numbers when a header is clicked
  group <- if (analysis$period == "week") as.integer(as.character(groups$group)) else as.character(groups$group)
  table <- data.frame(group, groups$returns, groups$mean_pct, groups$median_pct, groups$up_pct, groups$best_pct, groups$worst_pct)
  names(table) <- c(seasonality_periods[[analysis$period]]$group, "Returns", "Mean", "Median", "Up", "Best", "Worst")
  DT::datatable(table,
    rownames = FALSE,
    selection = "none",
    options = list(
      dom = "t",
      pageLength = nrow(table),
      # the natural order of the groups, not the alphabetical one
      order = list(),
      columnDefs = list(list(targets = 1:6, className = "dt-right"))
    )
  ) %>%
    DT::formatCurrency(c("Mean", "Median", "Best", "Worst"), currency = "%", before = FALSE, digits = digits) %>%
    DT::formatCurrency("Up", currency = "%", before = FALSE, digits = 0) %>%
    DT::formatStyle(c("Mean", "Median"), backgroundColor = shade_interval(c(groups$mean_pct, groups$median_pct), 0)) %>%
    DT::formatStyle("Up", backgroundColor = shade_interval(groups$up_pct, 50))
}
##########################################################################################
#
##########################################################################################
#' @title Table of where the indices stand
#' @description A table with a row per index of [index_summary()], in the
#' order of [get_indices()]: its region, last close and its date, the change
#' on the day, this year and over a year, how far it is below its all-time
#' high, that high and its date, the currency of its shares and the first day
#' of its history. The changes are shaded red for falls and green for rises,
#' each column on its own scale, as a day's moves are much smaller than a
#' year's, and the distance from the high red, more strongly the further it
#' is. Given the history, a column after the close draws the last year of
#' each index as a small line (see [sparkline_svg()]).
#' @param summary The result of [index_summary()].
#' @param indices Data frame of indices from [get_indices()], for the regions
#'   and currencies.
#' @param history The price history the summary was made from, for the
#'   lines of the last year, or `NULL` for none.
#' @return A DT datatable.
#' @export
#' @examplesIf interactive()
#' indices <- get_indices()
#' history <- get_history(indices$label[1:3], as.Date("1900-01-01"))
#' overview_table(index_summary(history), indices, history)
overview_table <- function(summary, indices = get_indices(), history = NULL) {
  info <- indices[match(summary$label, indices$label), ]
  table <- data.frame(
    summary$label, info$region, summary$close, summary$date, summary$day_pct, summary$ytd_pct, summary$year_pct,
    summary$from_high_pct, summary$high, summary$high_date, info$currency, summary$first_date
  )
  names(table) <- c(
    "Index", "Region", "Close", "Date", "Day", "Year to date", "1 year", "From high", "High", "High on", "Currency", "Since"
  )
  if (!is.null(history)) {
    lines <- vapply(summary$label, function(label) {
      one <- history[history$label == label, ]
      sparkline_svg(one$timestamp, one$close, label)
    }, character(1))
    table <- data.frame(table[1:3], "Last year" = lines, table[-(1:3)], check.names = FALSE)
  }
  table <- table[order(match(table$Index, indices$label)), ]
  # DT counts the columns from 0
  column <- function(names) match(names, names(table)) - 1
  # the VIX is in percent a year, not in the money of any shares
  dash <- DT::JS("function(data, type) { return type === 'display' && data === null ? '\u2013' : data; }")
  columns <- list(
    list(targets = column("Currency"), render = dash),
    list(targets = column(c("Close", "Day", "Year to date", "1 year", "From high", "High")), className = "dt-right")
  )
  if (!is.null(history)) columns <- c(columns, list(list(targets = column("Last year"), orderable = FALSE)))
  out <- DT::datatable(table,
    rownames = FALSE,
    selection = "none",
    # the lines are SVG, the other columns text
    escape = setdiff(names(table), "Last year"),
    options = list(dom = "t", pageLength = nrow(table), order = list(), columnDefs = columns)
  ) %>%
    DT::formatRound(c("Close", "High"), digits = 2) %>%
    DT::formatCurrency(c("Day", "Year to date", "1 year"), currency = "%", before = FALSE, digits = 2) %>%
    DT::formatCurrency("From high", currency = "%", before = FALSE, digits = 1)
  for (column in c("Day", "Year to date", "1 year", "From high")) {
    out <- DT::formatStyle(out, column, backgroundColor = shade_interval(table[[column]], 0))
  }
  out
}
##########################################################################################
#
##########################################################################################
#' @title Performance of the indices over a period
#' @description One horizontal bar per index, its change over the period in
#' percent, green for rises and red for falls, the best at the top, from
#' [performance_data()]. The VIX is left out: it measures the fear in the
#' market rather than the value of shares, and its swings of tens of percent
#' would squeeze the others.
#' @param summary The result of [index_summary()].
#' @param indices Data frame of indices from [get_indices()]; the indices
#'   without a currency, the VIX, are left out.
#' @param period `"day"`, `"week"`, `"month"`, `"month3"`, `"month6"`,
#'   `"month9"` (3, 6 and 9 months), `"ytd"` (year to date) or `"year"`.
#' @inheritParams plot_timeseries
#' @return A plotly object.
#' @export
#' @examplesIf interactive()
#' indices <- get_indices()
#' summary <- index_summary(get_history(indices$label, as.Date("2020-01-01")))
#' plot_performance(summary, indices, "ytd")
plot_performance <- function(summary, indices = get_indices(), period = performance_periods, mode = "light") {
  period <- match.arg(period)
  titles <- c(day = "Change on the day", week = "Change over the last week", month = "Change over the last month",
              month3 = "Change over the last 3 months", month6 = "Change over the last 6 months",
              month9 = "Change over the last 9 months", ytd = "Change this year", year = "Change over the last year")
  # plotly draws the first category at the bottom, so the best comes last
  data <- performance_data(summary, indices, period)
  data <- data[rev(seq_len(nrow(data))), ]
  labels <- data$label
  change <- data$change_pct
  # room beyond the longest bars on both sides, for their labels, which would otherwise run into the
  # names of the indices on a narrow screen
  span <- max(c(change, 0)) - min(c(change, 0))
  spare <- 0.35 * (if (span > 0) span else 1)
  # more on the left, where a label of a fall sits next to the names
  spare_left <- 0.45 * (if (span > 0) span else 1)
  plotly::plot_ly(
    x = change,
    y = labels,
    type = "bar",
    orientation = "h",
    marker = list(color = ifelse(change >= 0, change_color(1, gain = TRUE), change_color(1, gain = FALSE))),
    text = sprintf("%+.2f%%", change),
    textposition = "outside",
    cliponaxis = FALSE,
    textfont = list(color = text_color(mode)),
    hovertemplate = "%{y}: %{x:+.2f}%<extra></extra>"
  ) %>%
    plotly::layout(
      title = list(text = titles[[period]], x = 0.01, xanchor = "left"),
      xaxis = list(
        title = "", ticksuffix = "%", zeroline = TRUE,
        range = c(min(c(change, 0)) - if (any(change < 0)) spare_left else 0, max(c(change, 0)) + if (any(change > 0)) spare else 0)
      ),
      yaxis = list(title = "", type = "category", categoryorder = "array", categoryarray = labels, automargin = TRUE),
      margin = list(t = 50)
    ) %>%
    plot_theme(mode)
}
