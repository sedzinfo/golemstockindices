# Table of the seasonality of an index

A table with a row per group of
[`seasonality_analysis()`](https://sedzinfo.github.io/golemstockindices/reference/seasonality_analysis.md),
in their natural order, with the numbers of the chart of
[`plot_seasonality()`](https://sedzinfo.github.io/golemstockindices/reference/plot_seasonality.md).
The mean and the median are shaded red below 0 and green above it, and
the share up red below 50% and green above it, more strongly the further
they are from the middle.

## Usage

``` r
seasonality_table(analysis)
```

## Arguments

- analysis:

  The result of
  [`seasonality_analysis()`](https://sedzinfo.github.io/golemstockindices/reference/seasonality_analysis.md).

## Value

A DT datatable.

## Examples

``` r
if (FALSE) { # interactive()
spx <- get_history("S&P 500", as.Date("1950-01-01"))
seasonality_table(seasonality_analysis(spx, "month"))
}
```
