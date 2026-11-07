# Get the whole price history of one index, kept on disk and brought up to date

The first call downloads the whole history, from the `from` day of the
index when it has one, and keeps it on disk (see
[`disk_cache()`](https://sedzinfo.github.io/golemstockindices/reference/disk_cache.md)).
Later calls use the kept history, and once it is more than an hour old
download only the last two weeks, which also replace the kept days of
those weeks, in case Yahoo Finance corrected them. When bringing it up
to date fails, the kept history is used.

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
