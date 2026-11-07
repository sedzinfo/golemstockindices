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
#> [1] "S&P 500"          "Dow Jones"        "Nasdaq Composite" "Russell 2000"     "VIX"             
#> 
#> $Europe
#> [1] "Euro Stoxx 50"  "FTSE 100"       "DAX"            "CAC 40"         "Athens General"
#> 
#> $Asia
#> [1] "Nikkei 225" "Hang Seng" 
#> 
```
