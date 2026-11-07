# Returns calendar module - UI

A button that downloads the monthly returns as CSV, and a heatmap of the
monthly returns of the index selected in the Timeseries tab.

## Usage

``` r
mod_returns_calendar_ui(id)
```

## Arguments

- id:

  Character. Module namespace id.

## Value

A `tagList` of Shiny UI elements.

## Examples

``` r
if (FALSE) { # \dontrun{
shiny::fluidPage(golemstockindices:::mod_returns_calendar_ui("returns_calendar"))
} # }
```
