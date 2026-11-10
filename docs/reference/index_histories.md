# Get the whole price histories of indices, kept on disk and brought up to date

For an index not kept yet, the whole history is downloaded, from its
`from` day when it has one, and kept on disk (see
[`disk_cache()`](https://sedzinfo.github.io/golemstockindices/reference/disk_cache.md)).
A kept history more than an hour old is brought up to date with its last
two weeks, which also replace the kept days of those weeks, in case
Yahoo Finance corrected them; when that fails, the kept history is used.
The downloads of all the indices run at the same time (see
[`download_histories()`](https://sedzinfo.github.io/golemstockindices/reference/download_histories.md)).

## Usage

``` r
index_histories(indices)
```

## Arguments

- indices:

  Rows of
  [`get_indices()`](https://sedzinfo.github.io/golemstockindices/reference/get_indices.md).

## Value

A list with an element per row: the whole price history of the index, or
`NULL` when it could not be downloaded.

## Examples

``` r
if (FALSE) { # \dontrun{
golemstockindices:::index_histories(get_indices()[1:3, ])
} # }
```
