# Forecast panel of the volatility chart

The last closes and the forecast ranges of the next days, which start
from the last close, for
[`plot_volatility()`](https://sedzinfo.github.io/golemstockindices/reference/plot_volatility.md).
Hover over the median line for the ranges of a day.

## Usage

``` r
plot_forecast(analysis, context_days)
```

## Arguments

- analysis:

  The result of
  [`volatility_analysis()`](https://sedzinfo.github.io/golemstockindices/reference/volatility_analysis.md),
  with a forecast.

- context_days:

  Closes before the forecast.

## Value

A plotly object.

## Examples

``` r
if (FALSE) { # \dontrun{
spx <- get_history("S&P 500", as.Date("1950-01-01"))
golemstockindices:::plot_forecast(volatility_analysis(spx), 30)
} # }
```
