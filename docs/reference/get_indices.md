# The stock market indices of the app

The major indices of the US, the rest of the Americas, Europe and
Asia-Pacific, and the VIX, with their symbols on Yahoo Finance. The
`label` column holds the names, such as "S&P 500", that pick indices in
[`get_history()`](https://sedzinfo.github.io/golemstockindices/reference/get_history.md).

## Usage

``` r
get_indices()
```

## Value

A data frame with a row per index: `label`, `symbol` on Yahoo Finance,
`region` ("US", "Americas", "Europe" or "Asia-Pacific"), the `currency`
of the shares in it, and `from`, the first day to keep, or `NA` to keep
all of the history. The VIX is a measure of the expected volatility of
the S&P 500, in percent a year, so its currency is `NA`. The Bovespa
starts in 1995: in the hyperinflation of Brazil before the real, its
returns of thousands of percent a year in the money of the time would
swamp every analysis.

## Examples

``` r
get_indices()
#>                       label     symbol       region currency       from
#> 1                   S&P 500      ^GSPC           US      USD       <NA>
#> 2                 Dow Jones       ^DJI           US      USD       <NA>
#> 3          Nasdaq Composite      ^IXIC           US      USD       <NA>
#> 4            NYSE Composite       ^NYA           US      USD       <NA>
#> 5              Russell 2000       ^RUT           US      USD       <NA>
#> 6                       VIX       ^VIX           US     <NA>       <NA>
#> 7         S&P/TSX Composite    ^GSPTSE     Americas      CAD       <NA>
#> 8                   Bovespa      ^BVSP     Americas      BRL 1995-01-01
#> 9                IPC Mexico       ^MXX     Americas      MXN       <NA>
#> 10         STOXX Europe 600     ^STOXX       Europe      EUR       <NA>
#> 11            Euro Stoxx 50  ^STOXX50E       Europe      EUR       <NA>
#> 12                 FTSE 100      ^FTSE       Europe      GBP       <NA>
#> 13                      DAX     ^GDAXI       Europe      EUR       <NA>
#> 14                   CAC 40      ^FCHI       Europe      EUR       <NA>
#> 15                  IBEX 35      ^IBEX       Europe      EUR       <NA>
#> 16                 FTSE MIB FTSEMIB.MI       Europe      EUR       <NA>
#> 17                      SMI      ^SSMI       Europe      CHF       <NA>
#> 18             Euronext 100      ^N100       Europe      EUR       <NA>
#> 19                   BEL 20       ^BFX       Europe      EUR       <NA>
#> 20           Athens General      GD.AT       Europe      EUR       <NA>
#> 21               Nikkei 225      ^N225 Asia-Pacific      JPY       <NA>
#> 22       Shanghai Composite  000001.SS Asia-Pacific      CNY       <NA>
#> 23                Hang Seng       ^HSI Asia-Pacific      HKD       <NA>
#> 24                    KOSPI      ^KS11 Asia-Pacific      KRW       <NA>
#> 25          Taiwan Weighted      ^TWII Asia-Pacific      TWD       <NA>
#> 26                   Sensex     ^BSESN Asia-Pacific      INR       <NA>
#> 27            Straits Times       ^STI Asia-Pacific      SGD       <NA>
#> 28                  ASX 200      ^AXJO Asia-Pacific      AUD       <NA>
#> 29           All Ordinaries      ^AORD Asia-Pacific      AUD       <NA>
#> 30                   NZX 50      ^NZ50 Asia-Pacific      NZD       <NA>
#> 31            IDX Composite      ^JKSE Asia-Pacific      IDR       <NA>
#> 32 FTSE Bursa Malaysia KLCI      ^KLSE Asia-Pacific      MYR       <NA>
```
