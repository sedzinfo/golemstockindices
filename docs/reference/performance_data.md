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
  period = performance_periods,
  currency = "local"
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

  `"day"`, `"week"`, `"month"`, `"month3"`, `"month6"`, `"month9"` (3, 6
  and 9 months), `"ytd"` (year to date) or `"year"`.

- currency:

  `"local"` for a summary of the prices in the money of each index, or
  the currency they were converted to with
  [`convert_prices()`](https://sedzinfo.github.io/golemstockindices/reference/convert_prices.md),
  `"USD"` or `"EUR"`, which then fills the `currency` column.

## Value

A data frame with a row per index, the best first: `label`, `region`,
`currency`, `type` ("total return" or "price", see
[`get_indices()`](https://sedzinfo.github.io/golemstockindices/reference/get_indices.md)),
`date` and `close` of the last day, and `change_pct`, the change over
the period in percent.

## Examples

``` r
summary <- data.frame(
  label = c("S&P 500", "DAX", "VIX"), date = as.Date("2026-11-06"), close = c(6700, 23500, 19),
  day_pct = c(0.4, -0.8, 5), week_pct = 1, month_pct = 2, month3_pct = 4, month6_pct = 8,
  month9_pct = 12, ytd_pct = c(14, 18, -10), year_pct = 15
)
golemstockindices:::performance_data(summary, get_indices(), "day")
#>     label region currency         type       date close change_pct
#> 1 S&P 500     US      USD        price 2026-11-06  6700        0.4
#> 2     DAX Europe      EUR total return 2026-11-06 23500       -0.8
```
