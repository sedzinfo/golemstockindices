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
#> 20                      AEX       ^AEX       Europe      EUR       <NA>
#> 21                      ATX       ^ATX       Europe      EUR       <NA>
#> 22           ISEQ All Share      ^ISEQ       Europe      EUR       <NA>
#> 23                      PSI   PSI20.LS       Europe      EUR       <NA>
#> 24         OMX Stockholm 30       ^OMX       Europe      SEK       <NA>
#> 25        OMX Copenhagen 25    ^OMXC25       Europe      DKK       <NA>
#> 26          OMX Helsinki 25    ^OMXH25       Europe      EUR       <NA>
#> 27                    OSEBX   OSEBX.OL       Europe      NOK       <NA>
#> 28              OMX Tallinn    ^OMXTGI       Europe      EUR       <NA>
#> 29                 OMX Riga    ^OMXRGI       Europe      EUR       <NA>
#> 30              OMX Vilnius    ^OMXVGI       Europe      EUR       <NA>
#> 31           Athens General      GD.AT       Europe      EUR       <NA>
#> 32                 BIST 100   XU100.IS       Europe      TRY       <NA>
#> 33               Nikkei 225      ^N225 Asia-Pacific      JPY       <NA>
#> 34       Shanghai Composite  000001.SS Asia-Pacific      CNY       <NA>
#> 35                Hang Seng       ^HSI Asia-Pacific      HKD       <NA>
#> 36                    KOSPI      ^KS11 Asia-Pacific      KRW       <NA>
#> 37          Taiwan Weighted      ^TWII Asia-Pacific      TWD       <NA>
#> 38                   Sensex     ^BSESN Asia-Pacific      INR       <NA>
#> 39            Straits Times       ^STI Asia-Pacific      SGD       <NA>
#> 40                  ASX 200      ^AXJO Asia-Pacific      AUD       <NA>
#> 41           All Ordinaries      ^AORD Asia-Pacific      AUD       <NA>
#> 42                   NZX 50      ^NZ50 Asia-Pacific      NZD       <NA>
#> 43            IDX Composite      ^JKSE Asia-Pacific      IDR       <NA>
#> 44 FTSE Bursa Malaysia KLCI      ^KLSE Asia-Pacific      MYR       <NA>
```
