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
#> [1] "S&P 500"          "Dow Jones"        "Nasdaq Composite" "NYSE Composite"   "Russell 2000"     "VIX"             
#> 
#> $Americas
#> [1] "S&P/TSX Composite" "Bovespa"           "IPC Mexico"       
#> 
#> $Europe
#>  [1] "STOXX Europe 600"  "Euro Stoxx 50"     "FTSE 100"          "DAX"               "CAC 40"            "IBEX 35"           "FTSE MIB"          "SMI"               "Euronext 100"     
#> [10] "BEL 20"            "AEX"               "ATX"               "ISEQ All Share"    "PSI"               "OMX Stockholm 30"  "OMX Copenhagen 25" "OMX Helsinki 25"   "OSEBX"            
#> [19] "OMX Tallinn"       "OMX Riga"          "OMX Vilnius"       "Athens General"    "BIST 100"         
#> 
#> $`Asia-Pacific`
#>  [1] "Nikkei 225"               "Shanghai Composite"       "Hang Seng"                "KOSPI"                    "Taiwan Weighted"          "Sensex"                   "Straits Times"           
#>  [8] "ASX 200"                  "All Ordinaries"           "NZX 50"                   "IDX Composite"            "FTSE Bursa Malaysia KLCI"
#> 
```
