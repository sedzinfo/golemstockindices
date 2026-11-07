# The drawdown analysis in words

Sentences built from the numbers of
[`drawdown_analysis()`](https://sedzinfo.github.io/golemstockindices/reference/drawdown_analysis.md),
for the Drawdowns tab.

## Usage

``` r
drawdown_text(analysis)
```

## Arguments

- analysis:

  The result of
  [`drawdown_analysis()`](https://sedzinfo.github.io/golemstockindices/reference/drawdown_analysis.md).

## Value

A list with `now` and `history`, each with a `headline` and `points`, a
character vector of sentences.

## Examples

``` r
if (FALSE) { # interactive()
spx <- get_history("S&P 500", as.Date("1950-01-01"))
drawdown_text(drawdown_analysis(spx))
}
```
