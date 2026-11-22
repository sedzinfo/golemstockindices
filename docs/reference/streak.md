# The current run of rises or falls

How many closes in a row, up to the last one, rose or fell from the
close before. A close equal to the one before ends a run.

## Usage

``` r
streak(close)
```

## Arguments

- close:

  Numeric vector of close prices, sorted by date.

## Value

An integer: positive for rises, such as 3 for three rises in a row,
negative for falls, and 0 when the last close did not move or there is
only one.

## Examples

``` r
golemstockindices:::streak(c(100, 99, 101, 102, 103))
#> [1] 3
golemstockindices:::streak(c(100, 101, 99, 98))
#> [1] -2
```
