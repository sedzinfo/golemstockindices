# The change of each index over a period, the best first

The data of the Performance tab: the chart of
[`plot_performance()`](https://sedzinfo.github.io/golemstockindices/reference/plot_performance.md)
and its CSV file. The indices without a currency, the VIX, are left out,
as it measures the fear in the market rather than the value of shares,
and so are the indices without the change, such as those younger than
the period.

## Usage

``` r
performance_data(
  summary,
  indices,
  period = c("day", "week", "month", "ytd", "year")
)
```

## Arguments

- summary:

  The result of
  [`index_summary()`](https://sedzinfo.github.io/golemstockindices/reference/index_summary.md).

- indices:

  Data frame of indices from
  [`get_indices()`](https://sedzinfo.github.io/golemstockindices/reference/get_indices.md).

- period:

  `"day"`, `"week"`, `"month"`, `"ytd"` (year to date) or `"year"`.

## Value

A data frame with a row per index, the best first: `label`, `region`,
`currency`, `date` and `close` of the last day, and `change_pct`, the
change over the period in percent.

## Examples

``` r
summary <- data.frame(
  label = c("S&P 500", "DAX", "VIX"), date = as.Date("2026-11-06"), close = c(6700, 23500, 19),
  day_pct = c(0.4, -0.8, 5), week_pct = 1, month_pct = 2, ytd_pct = c(14, 18, -10), year_pct = 15
)
golemstockindices:::performance_data(summary, get_indices(), "day")
#> Error: object 'performance_data' not found
```
