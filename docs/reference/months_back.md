# The same day some months before

The day `n` months before `date`, on the same day of the month, or on
the last day of the month when that month is shorter: a month before 31
March is 28 February (29 in a leap year), where
[`seq()`](https://rdrr.io/r/base/seq.html) would overflow to 3 March,
and a year before 29 February is 28 February.

## Usage

``` r
months_back(date, n)
```

## Arguments

- date:

  Dates.

- n:

  Number of months back, 12 for a year.

## Value

Dates, as many as `date`.

## Examples

``` r
golemstockindices:::months_back(as.Date(c("2025-03-31", "2025-05-15")), 1)
#> [1] "2025-02-28" "2025-04-15"
golemstockindices:::months_back(as.Date("2024-02-29"), 12)
#> [1] "2023-02-28"
```
