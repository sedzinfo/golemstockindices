# Performance module - UI

A choice of the period, a button that downloads the changes as CSV, and
the chart of the performance of the indices from
[`plot_performance()`](https://sedzinfo.github.io/golemstockindices/reference/plot_performance.md),
the best at the top.

## Usage

``` r
mod_performance_ui(id)
```

## Arguments

- id:

  Character. Module namespace id.

## Value

A `tagList` of Shiny UI elements.

## Examples

``` r
if (FALSE) { # \dontrun{
shiny::fluidPage(golemstockindices:::mod_performance_ui("performance"))
} # }
```
