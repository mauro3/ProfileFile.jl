# ProfileFile

[![Build Status](https://travis-ci.org/mauro3/ProfileFile.jl.svg?branch=master)](https://travis-ci.org/mauro3/ProfileFile.jl)

This add the profiling results to `*.pro` files just like
`--code-coverage` and `--track-allocation` do with code coverage and
memory allocations.

Usage:

```julia
@profile f(...)
using ProfileFile
ProfileFile.write_to_file()
```
