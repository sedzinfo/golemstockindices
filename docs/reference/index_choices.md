# The index pickers' choices, grouped by region

The index pickers' choices, grouped by region

## Usage

``` r
index_choices(indices)
```

## Arguments

- indices:

  Data frame of indices from
  [`get_indices()`](https://sedzinfo.github.io/golemstockindices/reference/get_indices.md).

## Value

A named list of index labels, one element per region, for the `choices`
of
[`shiny::selectInput()`](https://rdrr.io/pkg/shiny/man/selectInput.html).

## Examples

``` r
golemstockindices:::index_choices(get_indices())
#> $US
#> [1] "S&P 500"          "Dow Jones"        "Nasdaq Composite" "Nasdaq-100"       "NYSE Composite"   "Russell 2000"     "VIX"             
#> 
#> $Americas
#> [1] "S&P/TSX Composite" "Bovespa"           "IPC Mexico"       
#> 
#> $Europe
#>  [1] "STOXX Europe 600"  "Euro Stoxx 50"     "FTSE 100"          "FTSE 250"          "FTSE All-Share"    "DAX"               "MDAX"              "SDAX"              "TecDAX"           
#> [10] "CAC 40"            "IBEX 35"           "FTSE MIB"          "SMI"               "Euronext 100"      "Next 150"          "BEL 20"            "AEX"               "ATX"              
#> [19] "ISEQ All Share"    "PSI"               "OMX Stockholm 30"  "OMX Copenhagen 25" "OMX Helsinki 25"   "OSEBX"             "OMX Tallinn"       "OMX Riga"          "OMX Vilnius"      
#> [28] "Athens General"    "BIST 100"         
#> 
#> $Africa
#> [1] "FTSE/JSE Top 40"
#> 
#> $`Asia-Pacific`
#>  [1] "Nikkei 225"                  "Shanghai Composite"          "Shenzhen Component"          "Hang Seng"                   "Hang Seng China Enterprises" "KOSPI"                      
#>  [7] "KOSDAQ"                      "Taiwan Weighted"             "Sensex"                      "Straits Times"               "ASX 200"                     "All Ordinaries"             
#> [13] "NZX 50"                      "IDX Composite"               "FTSE Bursa Malaysia KLCI"   
#> 
```
