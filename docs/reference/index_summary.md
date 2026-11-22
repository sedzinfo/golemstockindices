# Where each index stands

For each index of a price history: its last close, and the change in
percent since the close before, since the last close at least a week and
1, 3, 6 and 9 months before, since the last close of the year before
(year to date) and since the last close at least a year before, and how
far it is below its highest close. Pass the whole history, as the
highest close is that of the history given. The months are counted with
[`months_back()`](https://sedzinfo.github.io/golemstockindices/reference/months_back.md):
a month before 31 March is the last day of February, and a year before
29 February is 28 February.

## Usage

``` r
index_summary(history)
```

## Arguments

- history:

  Price history from
  [`get_history()`](https://sedzinfo.github.io/golemstockindices/reference/get_history.md),
  with `label`, `timestamp` and `close` columns.

  It also gives the trend of the last year: the current run of rises or
  falls (see
  [`streak()`](https://sedzinfo.github.io/golemstockindices/reference/streak.md)),
  how far the last close is from its 200-day average (see
  [`moving_average()`](https://sedzinfo.github.io/golemstockindices/reference/moving_average.md)),
  and from the lowest and the highest close of the last 52 weeks, the
  closes after the day a year before.

## Value

A data frame with a row per index, in the order of their first rows in
`history`: `label`, `date` and `close` of the last day, `day_pct`,
`week_pct`, `month_pct`, `month3_pct`, `month6_pct`, `month9_pct`,
`ytd_pct`, `year_pct`, `high` and `high_date` of the highest close,
`from_high_pct` (from -100 to 0), `first_date`, the first day of the
history, `streak`, `average200` and `from_average200_pct`, `low52` and
`from_low52_pct` (0 or more), and `high52` and `from_high52_pct` (from
-100 to 0). A change is `NA` when the history does not go back far
enough, and the average when it has fewer than 200 closes.

## Examples

``` r
history <- data.frame(
  label = "Alpha",
  timestamp = as.Date(c("2024-12-31", "2025-06-30", "2025-12-31", "2026-01-02", "2026-01-05")),
  close = c(100, 150, 120, 126, 132)
)
index_summary(history)
#>   label       date close  day_pct week_pct month_pct month3_pct month6_pct month9_pct ytd_pct year_pct high  high_date from_high_pct first_date streak average200 from_average200_pct low52
#> 1 Alpha 2026-01-05   132 4.761905      -12       -12        -12        -12         32      10       32  150 2025-06-30           -12 2024-12-31      2         NA                  NA   120
#>   from_low52_pct high52 from_high52_pct
#> 1             10    150             -12
```
