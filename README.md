# BracedErrors.jl

This package helps to automate the printing of values with errors in brackets.

[![Build Status](https://travis-ci.org/stakaz/BracedErrors.jl.svg?branch=master)](https://travis-ci.org/stakaz/BracedErrors.jl)

## Getting Started

This is a very simple but yet useful package which helps to generate strings with values and their corresponding error followed in brackets, e. g., `23.56(12)(30)` stands for `23.56 ± 0.12 ± 0.30`.

This is common notation in science and this package provides a function to generate these strings.
The reading is the following: the error denoted with $N$ digits describes the error in the last $N$ shown digits of the value. E. g., `0.345(56) = 0.345 ± 0.56` or `1234567890(123) = 1234567890 ± 123`.

## Rounding

The errors are always rounded with `ceil` while the value is rounded with `round`. This rule is a usual conservative case for rounding errors.

By default the errors will have 2 digits in the brackets. See next section for more explanations.

## Accepted values

This function is mainly written for float-like types as `Float64` and `BigFloat`.
It works with `Int` as well but due to limitations of `sprintf1(::String, ::BigInt)` it does on partially work on `BigInt`.

## Usage

There is only one function exported: `bracederror`.
The usage is explained in its docstring.

### Basic Usage

```julia
julia> bracederror(123.456, 0.123)
"123.46(13)"

julia> bracederror(123.456, 0.00123)
"123.4560(13)"

julia> bracederror(123.456, 123456)
"123(123456)"
```

### Two errors
You can provide two errors.

```julia
julia> bracederror(123.456, 123456, 0.0034)
"123.4560(1234560000)(34)"

julia> bracederror(123.456, 0.123456, 0.0034)
"123.4560(1235)(34)"
```

## Customize Output

With some keywords you can customize the output.

- `dec::Int = 2`: number of decimals to round the errors to
- `suff::String = ""`: optional suffix after the bracket
- `suff2::String = ""`: optional suffix after the second bracket
- `bracket::Symbol = :r`: type of the bracket
- `bracket2::Symbol = :r`: type of the second bracket

`bracket` and `bracket2` can take the values: `[:a, :l, :s, :r, :c, :_, :^]` (angular, line, square, round, curly, subscript, superscript) which correspond to `["<>", "||", "[]", "()", "{}", "_{}", "^{}"]`.
The last two are useful for LaTeX output.

```julia
julia> bracederror(123.456, 0.123456, 0.0034; bracket=:s)
"123.4560[1235](34)"

julia> bracederror(123.456, 0.123456, 0.0034; suff2="_\\inf")
"123.4560(1235)(34)_\\inf"

julia> bracederror(123.456, 0.123456, 0.0034; dec=1)"123.456(124)(4)"
```

## Unexported $±$ Infix Operator

Due to the fact that $\pm$ is often used as an operator `BracedErrors` by default does not export it. It is however defined and can be used by importing it like this:

```julia
julia> import BracedErrors: ±
julia>0.234 ± 0.00056
	"0.23400(56)"
julia>0.234 ± (0.00056, 0.45)
	"0.23400(56)(45000)"
julia>±(0.234, 0.00056, 0.45; bracket2 =:s)
	"0.23400(56)[45000]"
```

By using this infix operator you gain even more convenience in error printing in strings like `"$(val ± err)"` and so on.

## Remarks

I have written this package during the hackathon at juliacon 2018 and this is the first official package.
I have tried to test it on different cases but it is still very early stage. Please use it with care and any help is welcome.

