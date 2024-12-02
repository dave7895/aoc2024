module Solver
using Test
using AoC
using AoC.Utils


function parse_input(raw_data)
    m = Matrix{Int}(undef, 0, 2)
    for line in eachline(IOBuffer(raw_data))
        m = vcat(m, parse.(Int, split(line))')
    end
    m
end
export parse_input


function solve1(parsed)
    sortedmat = hcat(sort.(eachcol(parsed))...)
    diffs = abs.((-).(eachcol(sortedmat)...))
    sum(diffs)
end
export solve1


function solve2(parsed)
    l1, l2 = Vector.(eachcol(parsed))
    n = 0
    for i1 in l1
        n += i1 * count(==(i1), l2)
    end
    n
end
export solve2


solution = Solution(parse_input, solve1, solve2)

testinput = """
3   4
4   3
2   5
1   3
3   9
3   3
"""
testanswer_1 = 11
testanswer_2 = 31
export testinput, testanswer_1, testanswer_2

test() = AoC.test_solution(solution, testinput, testanswer_1, testanswer_2)
export test

main(part=missing) = AoC.main(solution, part)
export main


end # module Solver
