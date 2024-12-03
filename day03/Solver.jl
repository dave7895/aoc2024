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
    tuples = []
    str = raw_data[:]
    for i in 1:length(raw_data)
        str = str[2:end]
        m = match(reg, str)
        if !isnothing(m) && m.offset == 1
            push!(tuples, parse.(Int, tuple(m.captures...)))
            continue
        end
        if startswith(str, "don't()")
            push!(tuples, (0,0))
        elseif startswith(str, "do()")
            push!(tuples, (0, 1))
        end
    end
    tuples
end
export parse_input


function solve1(parsed)
    sum(x->*(x...), parsed)
end
export solve1


function solve2(parsed)
    n = 0
    enabled = true
    for tup in parsed
        if tup == (0, 1)
            enabled=true
            continue
        end
        enabled || continue
        if tup == (0, 0)
            enabled = false
            continue
        end
        n += *(tup...)
    end
    n
end
export solve2


solution = Solution(parse_input, solve1, solve2)

testinput = """xmul(2,4)&mul[3,7]!^don't()_mul(5,5)+mul(32,64](mul(11,8)undo()?mul(8,5))"""
testanswer_1 = 161
testanswer_2 = 48
export testinput, testanswer_1, testanswer_2

test() = AoC.test_solution(solution, testinput, testanswer_1, testanswer_2)
export test

main(part=missing) = AoC.main(solution, part)
export main


end # module Solver
