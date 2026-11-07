# The daily data of a volatility analysis, as one table

The `series` of
[`volatility_analysis()`](https://sedzinfo.github.io/golemstockindices/reference/volatility_analysis.md),
followed by the days of its forecast, for the CSV button of the
Volatility tab.

## Usage

``` r
volatility_csv(analysis)
```

## Arguments

- analysis:

  The result of
  [`volatility_analysis()`](https://sedzinfo.github.io/golemstockindices/reference/volatility_analysis.md).

## Value

A data frame with a row per day, sorted by date: the columns of
`series`, and the forecast columns `forecast_sigma`, `forecast_low`,
`forecast_low_50`, `forecast_median`, `forecast_high_50` and
`forecast_high`, which are filled on the days ahead only. Without a
forecast, `series` alone.

## Examples

``` r
if (FALSE) { # \dontrun{
spx <- get_history("S&P 500", as.Date("1950-01-01"))
utils::tail(golemstockindices:::volatility_csv(volatility_analysis(spx)), 10)
} # }
```
