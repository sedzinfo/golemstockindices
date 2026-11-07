# The next weekdays after a date

The days of a forecast: markets are closed at weekends. Holidays are not
known, so a forecast day can fall on one.

## Usage

``` r
next_weekdays(date, n)
```

## Arguments

- date:

  A Date.

- n:

  Number of weekdays.

## Value

The `n` weekdays after `date`.

## Examples

``` r
# the Friday 6 November 2026, then the next 3 weekdays
golemstockindices:::next_weekdays(as.Date("2026-11-06"), 3)
#> [1] "2026-11-09" "2026-11-10" "2026-11-11"
```
