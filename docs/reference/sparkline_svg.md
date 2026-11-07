# A small line of the last year of closes

An inline SVG for a table cell: the closes of the last 365 days, thinned
to at most 100 points, green when the year ended higher than it started
and red when lower.

## Usage

``` r
sparkline_svg(date, close, label, width = 110, height = 26)
```

## Arguments

- date:

  Dates of the closes, sorted.

- close:

  The closes.

- label:

  Name of the index, for screen readers.

- width, height:

  Size in pixels.

## Value

The SVG as a character string.

## Examples

``` r
golemstockindices:::sparkline_svg(Sys.Date() - 300:0, cumsum(rnorm(301)) + 100, "Alpha")
#> [1] "<svg width=\"110\" height=\"26\" viewBox=\"0 0 110 26\" role=\"img\" aria-label=\"Alpha over the last year: +7.2%\"><polyline fill=\"none\" stroke=\"#198754\" stroke-width=\"1.5\" stroke-linejoin=\"round\" points=\"1.0,7.4 2.1,7.1 3.2,7.7 4.3,9.3 5.4,11.0 6.5,12.0 7.5,14.3 8.6,12.4 9.7,11.0 10.8,12.2 11.9,13.1 13.0,14.2 14.1,13.4 15.2,11.5 16.3,11.7 17.4,10.3 18.5,9.2 19.5,9.7 20.6,7.5 21.7,5.8 22.8,6.8 23.9,7.6 25.0,10.5 26.1,10.3 27.2,10.9 28.3,11.5 29.4,12.5 30.5,11.7 31.5,12.0 32.6,10.9 33.7,8.9 34.8,9.2 35.9,8.7 37.0,8.8 38.1,8.8 39.2,9.1 40.3,9.5 41.4,8.7 42.5,8.8 43.5,9.8 44.6,11.4 45.7,11.5 46.8,14.4 47.9,14.1 49.0,16.5 50.1,16.4 51.2,16.3 52.3,16.4 53.4,15.3 54.5,15.6 55.5,17.0 56.6,19.0 57.7,19.0 58.8,19.3 59.9,21.8 61.0,22.5 62.1,24.0 63.2,22.9 64.3,21.4 65.4,21.7 66.5,20.3 67.5,18.5 68.6,16.9 69.7,16.9 70.8,18.1 71.9,18.7 73.0,21.5 74.1,23.1 75.2,22.0 76.3,20.6 77.4,20.7 78.5,19.3 79.5,17.9 80.6,16.8 81.7,16.3 82.8,16.6 83.9,14.9 85.0,14.5 86.1,14.6 87.2,15.7 88.3,14.9 89.4,16.9 90.5,16.2 91.5,14.6 92.6,14.7 93.7,14.0 94.8,16.0 95.9,17.6 97.0,17.5 98.1,16.2 99.2,15.1 100.3,12.4 101.4,12.0 102.5,11.0 103.5,9.4 104.6,7.3 105.7,6.2 106.8,2.2 107.9,2.4 109.0,2.0\"/></svg>"
```
