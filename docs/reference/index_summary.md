# Where each index stands

For each index of a price history: its last close, and the change in
percent since the close before, since the last close at least a week and
1, 3, 6 and 9 months before, since the last close of the year before
(year to date) and since the last close at least a year before, and how
far it is below its highest close. Pass the whole history, as the
highest close is that of the history given.

## Usage

``` r
index_summary(history)
```

## Arguments

- history:

  Price history from
  [`get_history()`](https://sedzinfo.github.io/golemstockindices/reference/get_history.md),
  with `label`, `timestamp` and `close` columns.

## Value

A data frame with a row per index, in the order of their first rows in
`history`: `label`, `date` and `close` of the last day, `day_pct`,
`week_pct`, `month_pct`, `month3_pct`, `month6_pct`, `month9_pct`,
`ytd_pct`, `year_pct`, `high` and `high_date` of the highest close,
`from_high_pct` (from -100 to 0) and `first_date`, the first day of the
history. A change is `NA` when the history does not go back far enough.

## Examples

``` r
history <- data.frame(
  label = "Alpha",
  timestamp = as.Date(c("2024-12-31", "2025-06-30", "2025-12-31", "2026-01-02", "2026-01-05")),
  close = c(100, 150, 120, 126, 132)
)
index_summary(history)
#>   label       date close  day_pct week_pct month_pct month3_pct month6_pct month9_pct ytd_pct year_pct high  high_date from_high_pct first_date
#> 1 Alpha 2026-01-05   132 4.761905      -12       -12        -12        -12         32      10       32  150 2025-06-30           -12 2024-12-31
```
