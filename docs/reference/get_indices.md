# The stock market indices of the app

The major indices of the US, Europe and Asia, and the VIX, with their
symbols on Yahoo Finance. The `label` column holds the names, such as
"S&P 500", that pick indices in
[`get_history()`](https://sedzinfo.github.io/golemstockindices/reference/get_history.md).

## Usage

``` r
get_indices()
```

## Value

A data frame with a row per index: `label`, `symbol` on Yahoo Finance,
`region` ("US", "Europe" or "Asia") and the `currency` of the shares in
it. The VIX is a measure of the expected volatility of the S&P 500, in
percent a year, so its currency is `NA`.

## Examples

``` r
get_indices()
#>               label    symbol region currency
#> 1           S&P 500     ^GSPC     US      USD
#> 2         Dow Jones      ^DJI     US      USD
#> 3  Nasdaq Composite     ^IXIC     US      USD
#> 4      Russell 2000      ^RUT     US      USD
#> 5     Euro Stoxx 50 ^STOXX50E Europe      EUR
#> 6          FTSE 100     ^FTSE Europe      GBP
#> 7               DAX    ^GDAXI Europe      EUR
#> 8            CAC 40     ^FCHI Europe      EUR
#> 9    Athens General     GD.AT Europe      EUR
#> 10       Nikkei 225     ^N225   Asia      JPY
#> 11        Hang Seng      ^HSI   Asia      HKD
#> 12              VIX      ^VIX     US     <NA>
```
