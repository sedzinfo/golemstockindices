# The falls of a drawdown analysis, as one table

The table behind the CSV button of the Drawdowns tab.

## Usage

``` r
drawdown_csv(analysis)
```

## Arguments

- analysis:

  The result of
  [`drawdown_analysis()`](https://sedzinfo.github.io/golemstockindices/reference/drawdown_analysis.md).

## Value

The `episodes` of the analysis, with the depth renamed `fall_pct`.

## Examples

``` r
if (FALSE) { # interactive()
spx <- get_history("S&P 500", as.Date("1950-01-01"))
head(golemstockindices:::drawdown_csv(drawdown_analysis(spx)))
}
```
