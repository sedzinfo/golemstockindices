# How rare a move is, in words

The thresholds are in trading days: a move seen about every month (21
trading days) or more often is normal, less often than monthly but more
than once a year unusual, once in 1 to 10 years rare, and rarer than
that very rare.

## Usage

``` r
move_verdict(one_in_days, up)
```

## Arguments

- one_in_days:

  A move this large happens about once in so many trading days.

- up:

  `TRUE` for a rise, `FALSE` for a fall.

## Value

A character string such as "rare fall", or `NA`.

## Examples

``` r
golemstockindices:::move_verdict(c(12, 400, 5000), up = c(TRUE, FALSE, FALSE))
#> [1] "normal rise"    "rare fall"      "very rare fall"
```
