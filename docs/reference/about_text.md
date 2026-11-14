# The text of the About tab

Reads `inst/app/about.md` and fills in how often the data are downloaded
again, so that the text follows `history_minutes`.

## Usage

``` r
about_text()
```

## Value

The Markdown text, as one string.

## Examples

``` r
cat(substr(golemstockindices:::about_text(), 1, 300))
#> Stock Market Indices shows the daily prices of the major stock market indices of the Americas, Europe, Africa and Asia-Pacific, from <a href="https://finance.yahoo.com" target="_blank" rel="noopener">Yahoo Finance</a>. This page explains what each index measures, what each tab shows and how its numb
```
