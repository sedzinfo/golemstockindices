# The falls of the history in words

The falls of the history in words

## Usage

``` r
drawdown_history_text(analysis)
```

## Arguments

- analysis:

  The result of
  [`drawdown_analysis()`](https://sedzinfo.github.io/golemstockindices/reference/drawdown_analysis.md).

## Value

A list with a `headline` and `points`.

## Examples

``` r
if (FALSE) { # interactive()
spx <- get_history("S&P 500", as.Date("1950-01-01"))
golemstockindices:::drawdown_history_text(drawdown_analysis(spx))
}
```
