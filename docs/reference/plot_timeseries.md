# Candlestick chart of an index's prices

Plots the daily open, high, low and close, in index points, with a line
through the close, its moving averages, date range buttons and a range
slider. Underneath, smaller charts show the trading volume, when the
history has any, and the drawdown: how far the index is below its
all-time high so far. A click on a legend entry hides or shows that
line.

The vertical axes follow the days in view: zoomed in, each runs from the
lowest to the highest value of those days, so a week's candles fill the
chart instead of lying flat on an axis that reaches back to the start of
the history. The Linear and Log buttons switch the axis of the prices;
on the log axis equal distances are equal percentages, which suits the
whole history.

## Usage

``` r
plot_timeseries(
  history,
  mode = "light",
  averages = c(50, 200),
  show_drawdown = TRUE
)
```

## Arguments

- history:

  Price history of one index from
  [`get_history()`](https://sedzinfo.github.io/golemstockindices/reference/get_history.md).
  The averages and the drawdown use the whole history, so pass all of it
  and zoom with the range buttons.

- mode:

  `"light"` (the default) or `"dark"`, to suit a light or dark page.

- averages:

  Days of the moving averages to draw (see
  [`moving_average()`](https://sedzinfo.github.io/golemstockindices/reference/moving_average.md)),
  or `NULL` for none.

- show_drawdown:

  `TRUE` to add the drawdown chart (see
  [`drawdown()`](https://sedzinfo.github.io/golemstockindices/reference/drawdown.md)).

## Value

A plotly object.

## Examples

``` r
if (FALSE) { # interactive()
spx <- get_history("S&P 500", as.Date("1950-01-01"))
plot_timeseries(spx)
# shorter averages, and no drawdown chart
plot_timeseries(spx, averages = c(20, 100), show_drawdown = FALSE)
}
```
