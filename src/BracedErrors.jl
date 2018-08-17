module BracedErrors
using Formatting

export bracederror

get_lg_int(x) = Int(floor(log10(abs(x))))

obracket = Dict(:r => "(", :s => "[", :q => "{", :a => "<", :l => "|", :^ => "^{", :_ => "_{")
cbracket = Dict(:r => ")", :s => "]", :q => "}", :a => ">", :l => "|", :^ => "}", :_ => "}")

"""
		bracederror(μ::Real, σ1::Real, σ2::Real = 0.0; dec::Int = 2, suff::String = "", suff2::String = "", bracket::Symbol = :r, bracket2::Symbol = :r)
Providing a value `μ` and one or two errors `σ1` (`σ2`) it creates a string with the values followed by the errors in brackets.

This notation is commonly used in sciencific papers and this function provide an automated way of getting the appropriate string.

# Keyword Arguments
- `dec::Int = 2`: number of decimals to round the errors to
- `suff::String = ""`: optional suffix after the bracket
- `suff2::String = ""`: optional suffix after the second bracket
- `bracket::Symbol = :r`: type of the bracket
- `bracket2::Symbol = :r`: type of the second bracket

`bracket` and `bracket2` can take the values: $(keys(obracket)) which correspond to $(values(obracket)).
"""
function bracederror(μ::Real, σ1::Real, σ2::Real = 0.0; dec::Int = 2, suff::String = "", suff2::String = "", bracket::Symbol = :r, bracket2::Symbol = :r)
	@assert σ1 > 0.0
	@assert σ2 ≥ 0.0 ## 0.0 means no error => it will be skipped

	### get the log10 power
	μdig = get_lg_int(μ)
	σ1dig = get_lg_int(σ1)
	σ2dig = σ2 ≠ 0.0 ? get_lg_int(σ2) : typemax(Int)

	### get the log10 power of the smaller error
	σdig = min(σ1dig, σ2dig)

	if μdig > σdig ## order of the errors smaller than order of value
		sig = μdig - σdig + dec
		σ1_int = Int(ceil(σ1 / 10.0^(σdig-dec+1)))
		σ2 ≠ 0.0 && (σ2_int = Int(ceil(σ2 / 10.0^(σdig-dec+1))))
		if μdig == sig - 1
			val = sprintf1("%.$(sig)g", μ)
		else
			val = sprintf1("%#.$(sig)g", μ)
		end
	else ## order of the errors larger than order of value
		σ1_int = Int(ceil(σ1))
		σ2 ≠ 0.0 && (σ2_int = Int(ceil(σ2)))
		val = sprintf1("%d", μ)
	end
	### prepare output
	σ2_str = σ2 == 0.0 ? "" : "$(obracket[bracket2])$(σ2_int)$(cbracket[bracket2])$(suff2)"
	σ1_str =  "$(obracket[bracket])$(σ1_int)$(cbracket[bracket])$(suff)"
	return "$val$σ1_str$σ2_str"
end


### unexported due to common used symbol ±
μ ± ε = bracederror(μ, ε...)
±(μ, ε...; kwargs...) = bracederror(μ, ε...; kwargs...)

end # BracedErrors

