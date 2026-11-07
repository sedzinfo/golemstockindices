# The groups of a seasonality analysis, as one table

The table behind the CSV button of the Seasonality tab.

## Usage

``` r
seasonality_csv(analysis)
```

## Arguments

- analysis:

  The result of
  [`seasonality_analysis()`](https://sedzinfo.github.io/golemstockindices/reference/seasonality_analysis.md).

## Value

The `groups` of the analysis, with the period in front and the group
column named after the period, such as `month`.

## Examples

``` r
if (FALSE) { # interactive()
spx <- get_history("S&P 500", as.Date("1950-01-01"))
golemstockindices:::seasonality_csv(seasonality_analysis(spx, "month"))
}
```
