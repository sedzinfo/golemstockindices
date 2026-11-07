# Overview module - UI

A line with the date of the last closes, a button that downloads the
table as CSV, and the table of all the indices from
[`overview_table()`](https://sedzinfo.github.io/golemstockindices/reference/overview_table.md).

## Usage

``` r
mod_overview_ui(id)
```

## Arguments

- id:

  Character. Module namespace id.

## Value

A `tagList` of Shiny UI elements.

## Examples

``` r
if (FALSE) { # \dontrun{
shiny::fluidPage(golemstockindices:::mod_overview_ui("overview"))
} # }
```
