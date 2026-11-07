# The current fall in words

The current fall in words

## Usage

``` r
drawdown_now_text(analysis)
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
golemstockindices:::drawdown_now_text(drawdown_analysis(spx))
}
```
