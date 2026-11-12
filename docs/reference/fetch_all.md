# Fetch several addresses at the same time

Sends every request at once, at most `parallel_downloads` at a time, and
waits for all of them, so 49 indices take about as long as the slowest
few instead of the sum of all of them.

## Usage

``` r
fetch_all(urls)
```

## Arguments

- urls:

  Character vector of addresses.

## Value

A list with an element per address, in the same order: a list with the
`status_code` and the raw `content` of the answer, or with the `error`
message when the request could not be made.

## Examples

``` r
if (FALSE) { # \dontrun{
golemstockindices:::fetch_all(c("https://example.com", "https://example.org"))
} # }
```
