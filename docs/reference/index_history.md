# Get the whole price history of one index, kept on disk and brought up to date

[`index_histories()`](https://sedzinfo.github.io/golemstockindices/reference/index_histories.md)
for one index.

## Usage

``` r
index_history(index)
```

## Arguments

- index:

  One row of
  [`get_indices()`](https://sedzinfo.github.io/golemstockindices/reference/get_indices.md).

## Value

The whole price history of the index, or `NULL` when it could not be
downloaded.

## Examples

``` r
if (FALSE) { # \dontrun{
golemstockindices:::index_history(get_indices()[1, ])
} # }
```
