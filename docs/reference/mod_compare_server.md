# Compare module - server

Gets the price history of the selected indices from the start date,
converts it to the currency picked with
[`convert_prices()`](https://sedzinfo.github.io/golemstockindices/reference/convert_prices.md),
renders the closes normalized to 100, and serves them as a CSV file
named like `compare-2026-11-07.csv`, or `compare-usd-2026-11-07.csv` in
US dollars, with the columns `date`, `label`, `currency`, `close` and
`index`. The download waits until the selection has not changed for 1.5
seconds, instead of starting on every click in the picker. In another
currency, a line above the chart says which indices have no exchange
rates, and when the rates, which start between 1996 and 2006, make the
comparison start later than the prices would.

## Usage

``` r
mod_compare_server(id, indices, dark_mode)
```

## Arguments

- id:

  Character. Module namespace id, must match the id used in
  [`mod_compare_ui()`](https://sedzinfo.github.io/golemstockindices/reference/mod_compare_ui.md).

- indices:

  Data frame of indices from
  [`get_indices()`](https://sedzinfo.github.io/golemstockindices/reference/get_indices.md).

- dark_mode:

  Reactive returning `"light"` or `"dark"`, the mode of the app.

## Value

None. Called for its side effect of registering the module server.

## Examples

``` r
if (FALSE) { # \dontrun{
# inside app_server():
function(input, output, session) {
  mod_compare_server("compare", indices, reactive(input$dark_mode))
}
} # }
```
