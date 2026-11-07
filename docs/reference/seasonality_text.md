# The seasonality analysis in words

Sentences built from the numbers of
[`seasonality_analysis()`](https://sedzinfo.github.io/golemstockindices/reference/seasonality_analysis.md),
for the Seasonality tab: the best and the worst group, and whether the
differences between the groups could be chance.

## Usage

``` r
seasonality_text(analysis)
```

## Arguments

- analysis:

  The result of
  [`seasonality_analysis()`](https://sedzinfo.github.io/golemstockindices/reference/seasonality_analysis.md).

## Value

A list with `groups` and `chance`, each with a `headline` and `points`,
a character vector of sentences.

## Examples

``` r
if (FALSE) { # interactive()
spx <- get_history("S&P 500", as.Date("1950-01-01"))
seasonality_text(seasonality_analysis(spx, "day"))
}
```
