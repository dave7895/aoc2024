module Solver
using Test
using AoC
using AoC.Utils


function parse_input(raw_data)
    reg = r"mul\(([0-9]+),([0-9]+)\)"
    matches = findall(reg, raw_data)
    tuples = []
    for r in matches
        substr = raw_data[r]
        m = match(reg, substr)
        push!(tuples, parse.(Int, tuple(m.captures...)))
    end
    tuples
end
export parse_input


function solve1(parsed)
    sum(x->*(x...), parsed)
end
export solve1


function solve2(parsed)
end
export solve2


solution = Solution(parse_input, solve1, solve2)

testinput = """xmul(2,4)%&mul[3,7]!@^do_not_mul(5,5)+mul(32,64]then(mul(11,8)mul(8,5))"""
testanswer_1 = 161
testanswer_2 = nothing
export testinput, testanswer_1, testanswer_2

test() = AoC.test_solution(solution, testinput, testanswer_1, testanswer_2)
export test

main(part=missing) = AoC.main(solution, part)
export main


end # module Solver
