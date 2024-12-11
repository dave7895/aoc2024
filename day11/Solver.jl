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

function stonetransform(i)
    if iszero(i)
        return 1
    end
    strlen = round(Int, log10(i), RoundDown)+1 #length(istr)
    if iseven(strlen)
        istr = "$i"
        return splitint(istr, strlen)
    end
    return i * 2024
end

function solve1(parsed)
    stones = copy(parsed)
    for i = 1:25
        stones = map(stonetransform, Iterators.flatten(stones))
    end
    #display(stones)
    len = 0
    for x in stones
        len += x isa Number ? 1 : 2
    end
    return len
end
export solve1


function solve2(parsed)
    stones = copy(parsed)
    totallen = 0
    for i = 1:75
        newstones = Int[]
        sizehint!(newstones, 2*length(stones))
        for stone in Iterators.flatten(stones)
            append!(newstones, stonetransform(stone))
        end
        stones = newstones
    end
    #display(stones)
    return length(stones)
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
