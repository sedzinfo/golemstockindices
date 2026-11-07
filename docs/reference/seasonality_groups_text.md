# The best and the worst group in words

By the mean return, among the groups with at least half the returns of
the largest group: week 53, which only some years have, would otherwise
often come first or last by luck.

## Usage

``` r
seasonality_groups_text(analysis)
```

## Arguments

- analysis:

  The result of
  [`seasonality_analysis()`](https://sedzinfo.github.io/golemstockindices/reference/seasonality_analysis.md).

## Value

A list with a `headline` and `points`.

## Examples

``` r
if (FALSE) { # interactive()
spx <- get_history("S&P 500", as.Date("1950-01-01"))
golemstockindices:::seasonality_groups_text(seasonality_analysis(spx, "month"))
}
```
