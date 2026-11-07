# The volatility analysis in words

Sentences built from the numbers of
[`volatility_analysis()`](https://sedzinfo.github.io/golemstockindices/reference/volatility_analysis.md),
for the Volatility tab.

## Usage

``` r
volatility_text(analysis)
```

## Arguments

- analysis:

  The result of
  [`volatility_analysis()`](https://sedzinfo.github.io/golemstockindices/reference/volatility_analysis.md).

## Value

A list with `month`, `recent` and `forecast`, each with a `headline` and
`points`, a character vector of sentences.

## Examples

``` r
if (FALSE) { # interactive()
spx <- get_history("S&P 500", as.Date("1950-01-01"))
volatility_text(volatility_analysis(spx))
}
```
