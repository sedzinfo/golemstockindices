# Volatility chart of an index

Three panels. The upper one is the volatility of every `month_days`-day
period over the whole history, annualized, with its median and 95th
percentile: where the line is now shows how rough the last month was.
The middle one shows each of the last `days` days as a bar of its move
in the standard deviations the GARCH model expected for it, red for
falls and green for rises, with lines at 2 and 4 standard deviations.
The lower one shows the last `context_days` closes and the forecast of
the next days: the median close, and the ranges of the middle half and
of probability `level` (see
[`volatility_analysis()`](https://sedzinfo.github.io/golemstockindices/reference/volatility_analysis.md)).
Without a GARCH model only the upper panel is drawn.

## Usage

``` r
plot_volatility(analysis, mode = "light", days = 63, context_days = 21)
```

## Arguments

- analysis:

  The result of
  [`volatility_analysis()`](https://sedzinfo.github.io/golemstockindices/reference/volatility_analysis.md).

- mode:

  `"light"` (the default) or `"dark"`, to suit a light or dark page.

- days:

  Days of the middle panel.

- context_days:

  Closes before the forecast in the lower panel.

## Value

A plotly object.

## Examples

``` r
if (FALSE) { # interactive()
spx <- get_history("S&P 500", as.Date("1950-01-01"))
plot_volatility(volatility_analysis(spx))
}
```
