# Drawdowns module - UI

For the index selected in the Timeseries tab: two cards that say in
words how far the index is below its all-time high and how that compares
with its earlier falls, a choice of the smallest fall to list, a button
that downloads the falls as CSV, the drawdown chart and the table of the
falls.

## Usage

``` r
mod_drawdowns_ui(id)
```

## Arguments

- id:

  Character. Module namespace id.

## Value

A `tagList` of Shiny UI elements.

## Examples

``` r
if (FALSE) { # \dontrun{
shiny::fluidPage(golemstockindices:::mod_drawdowns_ui("drawdowns"))
} # }
```
