# Table of the falls of an index

A sortable table of the falls of
[`drawdown_analysis()`](https://sedzinfo.github.io/golemstockindices/reference/drawdown_analysis.md),
the deepest first, with the numbers of the chart of
[`plot_drawdowns()`](https://sedzinfo.github.io/golemstockindices/reference/plot_drawdowns.md).
The fall is shaded red, more strongly the deeper it is, and the current
fall, which has not got back to its high, is in bold.

## Usage

``` r
drawdown_table(analysis)
```

## Arguments

- analysis:

  The result of
  [`drawdown_analysis()`](https://sedzinfo.github.io/golemstockindices/reference/drawdown_analysis.md).

## Value

A DT datatable.

## Examples

``` r
if (FALSE) { # interactive()
spx <- get_history("S&P 500", as.Date("1950-01-01"))
drawdown_table(drawdown_analysis(spx))
}
```
