# Normalized prices relative to one of the indices

The relative strength of each index against a base index: the ratio of
their normalized prices, so 100 on the first common date, as in
[`normalize_prices()`](https://sedzinfo.github.io/golemstockindices/reference/normalize_prices.md).
A line that rises did better than the base, one that falls did worse,
and 120 means 20% better since the start. The exchanges have holidays of
their own, so on a day the base has no close, its last close before
stands in.

## Usage

``` r
relative_prices(prices, base)
```

## Arguments

- prices:

  Prices from
  [`normalize_prices()`](https://sedzinfo.github.io/golemstockindices/reference/normalize_prices.md).

- base:

  The label of the index to divide by, one of those of `prices`.

## Value

The rows of `prices` of the other indices, with `index` the ratio to the
base times 100, the base's own `index` in `base_index`, and `base`.

## Examples

``` r
history <- data.frame(
  label = rep(c("Alpha (A)", "Beta (B)"), each = 3),
  timestamp = rep(as.Date("2024-01-01") + 0:2, 2),
  close = c(10, 11, 12, 200, 180, 220)
)
relative_prices(normalize_prices(history), "Beta (B)")
#>       label  timestamp close    index base_index     base
#> 1 Alpha (A) 2024-01-01    10 100.0000        100 Beta (B)
#> 2 Alpha (A) 2024-01-02    11 122.2222         90 Beta (B)
#> 3 Alpha (A) 2024-01-03    12 109.0909        110 Beta (B)
```
