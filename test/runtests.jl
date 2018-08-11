using Test
using BracedErrors

# @testset "get_lg_int" begin
# @test get_lg_int(12345.45) == 4
# @test get_lg_int(1.023) == 0
# @test get_lg_int(1.3e-17) == -17
# @test get_lg_int(0.004) == -3
# @test get_lg_int(1.0) == 0
# @test_throws DomainError get_lg_int(-0.1)
# @test_throws InexactError get_lg_int(0.0)
# end

@testset "str_err" begin
	@testset "dec = 2" begin
		@test str_err(123.456, 0.12345) == "123.46(13)"
		@test str_err(123.456, 0.0012345) == "123.4560(13)"
		@test str_err(123.456, 0.00012345) == "123.45600(13)"
	end

	@testset "dec = 3" begin
		@test str_err(123.456, 0.12345; dec=3) == "123.456(124)"
		@test str_err(123.456, 0.0012345; dec=3) == "123.45600(124)"
		@test str_err(123.456, 0.00012345; dec=3) == "123.456000(124)"
	end

	@testset "error bigger than value" begin
		@test str_err(123.456, 123.45) == "123(124)"
		@test str_err(123.456, 123456) == "123(123456)"
		@test str_err(123e8, 123456e8) == "12300000000(12345600000000)"
		@test str_err(123e-8, 123456e8) == "0(12345600000000)"
		@test str_err(1, 123456e8) == "1(12345600000000)"

		@test str_err(123.456, 123.45; dec = 4) == "123(124)"
		@test str_err(123.456, 123456; dec = 4) == "123(123456)"
		@test str_err(123e8, 123456e8; dec = 4) == "12300000000(12345600000000)"
	end

	@testset "two errors" begin
		@testset "small errors" begin
			@test str_err(123.456, 0.12345, 0.567) == "123.46(13)(57)"
			@test str_err(123.456, 0.0012345, 78.9) == "123.4560(13)(789000)"
			@test str_err(123.456, 12, 0.00356) == "123.4560(120000)(36)"
		end

		@testset "big errors" begin
			@test str_err(123.456, 1234, 0.567) == "123.46(123400)(57)"
			@test str_err(123.456, 7778, 345) == "123(7778)(345)"
			@test str_err(1e-3, 12, 0.356) == "0(12)(1)"
		end
	end

	@testset "at edge" begin
		@test str_err(10.0, 1.0) == "10.0(10)"
		@test str_err(10.0, 0.999) == "10.00(100)"
		@test str_err(10.0, 0.999, 1.0) == "10.00(100)(100)"
		@test str_err(10.0, 0.999, 0.344) == "10.00(100)(35)"
	end

	@testset "with e notation" begin
		@test str_err(234.567e68, 34.6e68) == "2.35e+70(35)"
		@test str_err(234.567e-68, 34.6e-68) == "2.35e-66(35)"
		@test str_err(234.567e-68, 34.6e-68, 99.4e-67) == "2.35e-66(35)(994)"
	end

	@testset "styles" begin
		@test str_err(123.456, 0.345; bracket = :s) == "123.46[35]"
		@test str_err(123.456, 0.345; bracket = :q) == "123.46{35}"
		@test str_err(123.456, 0.345; bracket = :a) == "123.46<35>"
		@test str_err(123.456, 0.345; suff = "_\\inf") == "123.46(35)_\\inf"
	end
end
