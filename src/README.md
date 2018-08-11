# BracedErrors

This package helps to automate the printing of values with errors in brackets.

## Getting Started

This is a very simple but yet useful package which helps to generate strings with values and their corresponding error followed in brackets, e. g., `23.56(12)(30)` stands for `23.56 ± 0.12 ± 0.30`.

This is common notation in science and this package provides a function to generate these strings.

## Usage

There is only one function exported: `bracederror`.
The usage is explained in its docstring.

### Basic Usage

```juliashell
> bracederror(123.456, 0.123)
"123.46(13)"

> bracederror(123.456, 0.00123)
"123.4560(13)"

> bracederror(123.456, 123456)
"123(123456)"
```

### Two errors
You can provide two errors.

```juliashell
> bracederror(123.456, 123456, 0.0034)
"123.4560(1234560000)(34)"

> bracederror(123.456, 0.123456, 0.0034)
"123.4560(1235)(34)"
```

## Customize Output

With some keywords you can customize the output.

- `dec::Int = 2`: number of decimals to round the errors to
- `suff::String = ""`: optional suffix after the bracket
- `suff2::String = ""`: optional suffix after the second bracket
- `bracket::Symbol = :r`: type of the bracket
- `bracket2::Symbol = :r`: type of the second bracket

`bracket` and `bracket2` can take the values: `[:a, :l, :s, :r, :q]` which correspond to `["<", "|", "[", "(", "{"]`.

```juliashell
> bracederror(123.456, 0.123456, 0.0034; bracket=:s)
"123.4560[1235](34)"

> bracederror(123.456, 0.123456, 0.0034; suff2="_\\inf")
"123.4560(1235)(34)_\\inf"

> bracederror(123.456, 0.123456, 0.0034; dec=1)"123.456(124)(4)"
```

## Remarks

I have written this package during the hackathon at juliacon 2018 and this is the first official package.
I have tried to test it on different cases but it is still very early stage. Please use it with care and any help is welcome.

