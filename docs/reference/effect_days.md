# The group of each trading day in a calendar effect

Puts each trading day of an index in or out of a calendar effect,
counting the trading days of the index itself, so its own holidays:

- turn:

  The turn of the month: the last trading day of a month and the first 3
  of the next.

- holiday:

  The day before a holiday: a trading day after which the exchange stays
  shut on at least one weekday, for at most 5 calendar days; a longer
  closure is a gap in the data or a crisis.

- santa:

  The Santa rally: the last 5 trading days of December and the first 2
  of January.

The first and the last month of the history, which may be cut short,
have no group for the turn of the month and the Santa rally, as the
place of a day in its month is not known, and the last day has none
before a holiday, as the next trading day is not known.

## Usage

``` r
effect_days(date, period = c("turn", "holiday", "santa"))
```

## Arguments

- date:

  The trading days, sorted.

- period:

  `"turn"`, `"holiday"` or `"santa"`.

## Value

A factor as long as `date`, the days in the effect first, `NA` for a day
whose group is not known.

## Examples

``` r
days <- as.Date("2024-03-25") + 0:14
days <- days[as.POSIXlt(days)$wday %in% 1:5 & days != as.Date("2024-03-29")]
data.frame(days, group = golemstockindices:::effect_days(days, "holiday"))
#>          days            group
#> 1  2024-03-25       Other days
#> 2  2024-03-26       Other days
#> 3  2024-03-27       Other days
#> 4  2024-03-28 Before a holiday
#> 5  2024-04-01       Other days
#> 6  2024-04-02       Other days
#> 7  2024-04-03       Other days
#> 8  2024-04-04       Other days
#> 9  2024-04-05       Other days
#> 10 2024-04-08             <NA>
```
