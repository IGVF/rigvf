# Package configuration global variable management

Objects documented on this page are for developer use.

`rigvf_config` provides a simple interface to manage 'package global'
variables via `rigvf_config$get()`, `rigvf_config$set()`, etc. The
default `username` and `password` provide guest access.

## Usage

``` r
rigvf_config
```

## Format

`rigvf_config` is a list of functions for listing
([`ls()`](https://rdrr.io/r/base/ls.html))and manipulating
([`get()`](https://rdrr.io/r/base/get.html), `set()`, `unset()`)
package-global variables.
