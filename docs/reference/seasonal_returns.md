# The return of each complete period of an index

A period's return is its last close relative to the last close of the
period before, in percent, as in
[`monthly_returns()`](https://sedzinfo.github.io/golemstockindices/reference/monthly_returns.md).
Markets close at weekends and on holidays, so a day's return runs from
the close of the trading day before, as long as it is at most 4 calendar
days earlier: a weekend or a long weekend, but not a gap in the data.
Only complete periods count: the period must have ended, either because
the history goes on after it or because its last close is on its last
weekday, and the period before must be the one just before it. So the
first period, which has none before it, and the current one, which has
not ended, are left out.

Each return is put in a group: the day of the week for days, the ISO
8601 week of the year for weeks (Monday to Sunday), the month for
months, and the year of the 4-year US presidential cycle for years. The
elections come in years divisible by 4, such as 2024, so 2025 was a
post-election year, 2026 a midterm year and 2027 a pre-election year.

## Usage

``` r
seasonal_returns(history, period = c("day", "week", "month", "year"))
```

## Arguments

- history:

  Price history of one index from
  [`get_history()`](https://sedzinfo.github.io/golemstockindices/reference/get_history.md),
  with `timestamp` and `close` columns.

- period:

  `"day"`, `"week"`, `"month"` or `"year"`.

## Value

A data frame with a row per complete period, the oldest first: `start`
and `end`, the first and last day of the period, `group`, a factor with
the groups in their natural order, and `return_pct`.

## Examples

``` r
# the weekdays of 2024 to the end of April
days <- as.Date("2024-01-01") + 0:120
days <- days[as.POSIXlt(days)$wday %in% 1:5]
history <- data.frame(timestamp = days, close = 100 * 1.001^seq_along(days))
seasonal_returns(history, "month")
#>        start        end group return_pct
#> 1 2024-02-01 2024-02-29   Feb   2.121134
#> 2 2024-03-01 2024-03-31   Mar   2.121134
#> 3 2024-04-01 2024-04-30   Apr   2.223255
head(seasonal_returns(history, "day"))
#>        start        end     group return_pct
#> 1 2024-01-02 2024-01-02   Tuesday        0.1
#> 2 2024-01-03 2024-01-03 Wednesday        0.1
#> 3 2024-01-04 2024-01-04  Thursday        0.1
#> 4 2024-01-05 2024-01-05    Friday        0.1
#> 5 2024-01-08 2024-01-08    Monday        0.1
#> 6 2024-01-09 2024-01-09   Tuesday        0.1
```
