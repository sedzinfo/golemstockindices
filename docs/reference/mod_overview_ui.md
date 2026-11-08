# Overview module - UI

The strip of the exchanges that are open, a line with the date of the
last closes, a button that downloads the table as CSV, the table of all
the indices from
[`overview_table()`](https://sedzinfo.github.io/golemstockindices/reference/overview_table.md),
and at the bottom the table of the exchanges and their trading hours
from
[`market_table()`](https://sedzinfo.github.io/golemstockindices/reference/market_table.md).
The chart of their performance is in the Performance tab.

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
