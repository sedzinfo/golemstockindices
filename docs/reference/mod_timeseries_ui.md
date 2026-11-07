# Timeseries module - UI

An index picker, a button that downloads the index's daily prices as
CSV, and a candlestick chart of those prices, with the trading volume
underneath.

## Usage

``` r
mod_timeseries_ui(id, indices)
```

## Arguments

- id:

  Character. Module namespace id.

- indices:

  Data frame of indices from
  [`get_indices()`](https://sedzinfo.github.io/golemstockindices/reference/get_indices.md),
  whose labels fill the picker.

## Value

A `tagList` of Shiny UI elements.

## Examples

``` r
if (FALSE) { # \dontrun{
shiny::fluidPage(golemstockindices:::mod_timeseries_ui("timeseries", get_indices()))
} # }
```
