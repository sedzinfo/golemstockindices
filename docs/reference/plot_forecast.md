# Forecast chart of an index

The last closes of an index and the forecast of its next days from the
GARCH model of
[`volatility_analysis()`](https://sedzinfo.github.io/golemstockindices/reference/volatility_analysis.md):
the median close, and the ranges of the middle half and of probability
`level`, which start from the last close. Hover over the median line for
the ranges of a day. It is the lower panel of
[`plot_volatility()`](https://sedzinfo.github.io/golemstockindices/reference/plot_volatility.md),
on its own.

## Usage

``` r
plot_forecast(analysis, mode = "light", context_days = 30)
```

## Arguments

- analysis:

  The result of
  [`volatility_analysis()`](https://sedzinfo.github.io/golemstockindices/reference/volatility_analysis.md),
  with a forecast: there is none when the GARCH model could not be
  fitted.

- mode:

  `"light"` (the default) or `"dark"`, to suit a light or dark page.

- context_days:

  Closes before the forecast.

## Value

A plotly object.

## Examples

``` r
if (FALSE) { # interactive()
spx <- get_history("S&P 500", as.Date("1950-01-01"))
plot_forecast(volatility_analysis(spx))
# the next 14 days after the last 60 closes
plot_forecast(volatility_analysis(spx, forecast_days = 14), context_days = 60)
}
```
