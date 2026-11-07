# Compare module - UI

A picker for up to 10 indices, a start date, a button that downloads the
normalized closes as CSV, and a chart of the indices' closes normalized
to 100.

## Usage

``` r
mod_compare_ui(
  id,
  indices,
  selected = c("S&P 500", "Euro Stoxx 50", "Nikkei 225")
)
```

## Arguments

- id:

  Character. Module namespace id.

- indices:

  Data frame of indices from
  [`get_indices()`](https://sedzinfo.github.io/golemstockindices/reference/get_indices.md),
  whose labels fill the picker.

- selected:

  The indices selected at start: the S&P 500, the Euro Stoxx 50 and the
  Nikkei 225, one for each region.

## Value

A `tagList` of Shiny UI elements.

## Examples

``` r
if (FALSE) { # \dontrun{
shiny::fluidPage(golemstockindices:::mod_compare_ui("compare", get_indices()))
} # }
```
