# Overview module - server

Gets the whole history of every index, sums it up with
[`index_summary()`](https://sedzinfo.github.io/golemstockindices/reference/index_summary.md)
and shows it as a table. The histories are brought up to date when they
are more than an hour old, and the table follows while the page stays
open. The CSV file, named like `overview-2026-11-07.csv`, holds the
summary unrounded.

## Usage

``` r
mod_overview_server(id, indices)
```

## Arguments

- id:

  Character. Module namespace id, must match the id used in
  [`mod_overview_ui()`](https://sedzinfo.github.io/golemstockindices/reference/mod_overview_ui.md).

- indices:

  Data frame of indices from
  [`get_indices()`](https://sedzinfo.github.io/golemstockindices/reference/get_indices.md).

## Value

None. Called for its side effect of registering the module server.

## Examples

``` r
if (FALSE) { # \dontrun{
# inside app_server():
function(input, output, session) {
  mod_overview_server("overview", get_indices())
}
} # }
```
