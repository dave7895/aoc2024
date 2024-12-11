module Solver
using Test
using AoC
using AoC.Utils


function parse_input(raw_data)
    ints(raw_data)
end
export parse_input

function splitint(i::Integer)
    str = "$i"
    splitint(str, length(str))
end

function splitint(str::AbstractString, strlen)
    halfidx = strlen÷2
    parse.(Int, (str[1:halfidx], str[halfidx+1:end]))
end

function upperhalfint(str, strlenh)
    parse(Int, str[1:strlenh])
end

let cache = Dict{Tuple{Int, Int},Int}()
global function recursivecount(num, level)
    iszero(level) && return 1
    haskey(cache, (num, level)) && return cache[num, level]
    if iszero(num)
        r = recursivecount(1, level-1)
        cache[num, level] = r
        return r
    end
    strlen = round(Int, log10(num), RoundDown)+1 #length(istr)
    if iseven(strlen)
        istr = "$num"
        #num1, num2 = splitint(istr, strlen)
	strlenh = strlen÷2
        num1 = upperhalfint(istr, strlenh)
        num2 = num - 10^strlenh * num1
        r = recursivecount(num1, level-1) + recursivecount(num2, level-1)
        cache[num, level] = r
        return r
    end
    r = recursivecount(num * 2024, level-1)
    cache[num, level] = r
    return r
end
end

function solve1(parsed)
    stones = copy(parsed)
    len = 0
    for x in stones
        len += recursivecount(x, 25)
    end
    return len
end
export solve1


function solve2(parsed)
    stones = copy(parsed)
    s = 0
    for stone in stones
        s += recursivecount(stone, 75)
    end
    s
end
export solve2


solution = Solution(parse_input, solve1, solve2)

testinput = """125 17"""
testanswer_1 = 55312
testanswer_2 = 55312
export testinput, testanswer_1, testanswer_2

test() = AoC.test_solution(solution, testinput, testanswer_1, testanswer_2)
export test

main(part=missing) = AoC.main(solution, part)
export main


end # module Solver
