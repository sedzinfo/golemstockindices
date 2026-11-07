# Whether the differences could be chance, in words

Whether the differences could be chance, in words

## Usage

``` r
seasonality_chance_text(analysis)
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
golemstockindices:::seasonality_chance_text(seasonality_analysis(spx, "month"))
}
```
