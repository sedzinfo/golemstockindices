# Overview module - server

Gets the whole history of every index, sums it up with
[`index_summary()`](https://sedzinfo.github.io/golemstockindices/reference/index_summary.md)
and shows it as a table, with a small line of each index's last year,
and as a chart of the performance over the period picked. The histories
are brought up to date when they are more than an hour old, and the
table follows while the page stays open; the strip and the table of the
exchanges follow the clock every minute. The CSV file, named like
`overview-2026-11-07.csv`, holds the summary unrounded.

## Usage

``` r
mod_overview_server(id, indices, dark_mode)
```

## Arguments

- id:

  Character. Module namespace id, must match the id used in
  [`mod_overview_ui()`](https://sedzinfo.github.io/golemstockindices/reference/mod_overview_ui.md).

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
  mod_overview_server("overview", get_indices(), reactive(input$dark_mode))
}
} # }
```
