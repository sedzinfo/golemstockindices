# The stock market indices of the app

The major indices of the US, the rest of the Americas, Europe, Africa
and Asia-Pacific, and the VIX, with their symbols on Yahoo Finance. The
`label` column holds the names, such as "S&P 500", that pick indices in
[`get_history()`](https://sedzinfo.github.io/golemstockindices/reference/get_history.md).

## Usage

``` r
get_indices()
```

## Value

A data frame with a row per index: `label`, `symbol` on Yahoo Finance,
`region` ("US", "Americas", "Europe", "Africa" or "Asia-Pacific"), the
`currency` of the shares in it, its `type`, "total return" for the
performance indices, in which the dividends of the companies are
reinvested, such as the DAX, or "price" for those that leave them out,
such as the S&P 500, and `from`, the first day to keep, or `NA` to keep
all of the history. The VIX is a measure of the expected volatility of
the S&P 500, in percent a year, so its currency and type are `NA`. The
Bovespa starts in 1995: in the hyperinflation of Brazil before the real,
its returns of thousands of percent a year in the money of the time
would swamp every analysis.

## Examples

``` r
get_indices()
#>                          label     symbol       region currency         type       from
#> 1                      S&P 500      ^GSPC           US      USD        price       <NA>
#> 2                    Dow Jones       ^DJI           US      USD        price       <NA>
#> 3             Nasdaq Composite      ^IXIC           US      USD        price       <NA>
#> 4                   Nasdaq-100       ^NDX           US      USD        price       <NA>
#> 5               NYSE Composite       ^NYA           US      USD        price       <NA>
#> 6                 Russell 2000       ^RUT           US      USD        price       <NA>
#> 7                          VIX       ^VIX           US     <NA>         <NA>       <NA>
#> 8            S&P/TSX Composite    ^GSPTSE     Americas      CAD        price       <NA>
#> 9                      Bovespa      ^BVSP     Americas      BRL total return 1995-01-01
#> 10                  IPC Mexico       ^MXX     Americas      MXN        price       <NA>
#> 11            STOXX Europe 600     ^STOXX       Europe      EUR        price       <NA>
#> 12               Euro Stoxx 50  ^STOXX50E       Europe      EUR        price       <NA>
#> 13                    FTSE 100      ^FTSE       Europe      GBP        price       <NA>
#> 14                    FTSE 250      ^FTMC       Europe      GBP        price       <NA>
#> 15              FTSE All-Share      ^FTAS       Europe      GBP        price       <NA>
#> 16                         DAX     ^GDAXI       Europe      EUR total return       <NA>
#> 17                        MDAX     ^MDAXI       Europe      EUR total return       <NA>
#> 18                        SDAX     ^SDAXI       Europe      EUR total return       <NA>
#> 19                      TecDAX    ^TECDAX       Europe      EUR total return       <NA>
#> 20                      CAC 40      ^FCHI       Europe      EUR        price       <NA>
#> 21                     IBEX 35      ^IBEX       Europe      EUR        price       <NA>
#> 22                    FTSE MIB FTSEMIB.MI       Europe      EUR        price       <NA>
#> 23                         SMI      ^SSMI       Europe      CHF        price       <NA>
#> 24                Euronext 100      ^N100       Europe      EUR        price       <NA>
#> 25                    Next 150      ^N150       Europe      EUR        price       <NA>
#> 26                      BEL 20       ^BFX       Europe      EUR        price       <NA>
#> 27                         AEX       ^AEX       Europe      EUR        price       <NA>
#> 28                         ATX       ^ATX       Europe      EUR        price       <NA>
#> 29              ISEQ All Share      ^ISEQ       Europe      EUR        price       <NA>
#> 30                         PSI   PSI20.LS       Europe      EUR        price       <NA>
#> 31            OMX Stockholm 30       ^OMX       Europe      SEK        price       <NA>
#> 32           OMX Copenhagen 25    ^OMXC25       Europe      DKK        price       <NA>
#> 33             OMX Helsinki 25    ^OMXH25       Europe      EUR        price       <NA>
#> 34                       OSEBX   OSEBX.OL       Europe      NOK total return       <NA>
#> 35                 OMX Tallinn    ^OMXTGI       Europe      EUR total return       <NA>
#> 36                    OMX Riga    ^OMXRGI       Europe      EUR total return       <NA>
#> 37                 OMX Vilnius    ^OMXVGI       Europe      EUR total return       <NA>
#> 38              Athens General      GD.AT       Europe      EUR        price       <NA>
#> 39                    BIST 100   XU100.IS       Europe      TRY        price       <NA>
#> 40             FTSE/JSE Top 40   ^J200.JO       Africa      ZAR        price       <NA>
#> 41                  Nikkei 225      ^N225 Asia-Pacific      JPY        price       <NA>
#> 42          Shanghai Composite  000001.SS Asia-Pacific      CNY        price       <NA>
#> 43          Shenzhen Component  399001.SZ Asia-Pacific      CNY        price       <NA>
#> 44                   Hang Seng       ^HSI Asia-Pacific      HKD        price       <NA>
#> 45 Hang Seng China Enterprises      ^HSCE Asia-Pacific      HKD        price       <NA>
#> 46                       KOSPI      ^KS11 Asia-Pacific      KRW        price       <NA>
#> 47                      KOSDAQ      ^KQ11 Asia-Pacific      KRW        price       <NA>
#> 48             Taiwan Weighted      ^TWII Asia-Pacific      TWD        price       <NA>
#> 49                      Sensex     ^BSESN Asia-Pacific      INR        price       <NA>
#> 50               Straits Times       ^STI Asia-Pacific      SGD        price       <NA>
#> 51                     ASX 200      ^AXJO Asia-Pacific      AUD        price       <NA>
#> 52              All Ordinaries      ^AORD Asia-Pacific      AUD        price       <NA>
#> 53                      NZX 50      ^NZ50 Asia-Pacific      NZD total return       <NA>
#> 54               IDX Composite      ^JKSE Asia-Pacific      IDR        price       <NA>
#> 55    FTSE Bursa Malaysia KLCI      ^KLSE Asia-Pacific      MYR        price       <NA>
```
