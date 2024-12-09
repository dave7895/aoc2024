module Solver
using Test
using AoC
using AoC.Utils


function parse_input(raw_data)
    rules = []
    prints = []
    printing = false
    for line in eachline(IOBuffer(raw_data))
        if contains(line, '|')
            push!(rules, parse.(Int, split(line, '|')))
            continue
        end
        isempty(line) && (printing=true) && continue
        push!(prints, parse.(Int, split(line, ',')))
    end
    rules, prints
end
export parse_input


function solve1(parsed)
    rules, prints = parsed
    n = 0
    for p in prints
        #println("testing $p")
        iseven(length(p)) && continue
        failed = false
        inp = in(p) # function to check if x in p
        for (nidx, n) in enumerate(p)
            my_in = x->in(n, x)
            fitrules = findall(my_in, rules)
            for rule in rules[fitrules]
                #@show rule
                all(inp, rule) || continue
                #@show nidx, findfirst(==(rule[2]), p)
                if rule[1] == n
                    nidx < findfirst(==(rule[2]), p) || (failed = true)
                else
                    findfirst(==(rule[1]), p) < nidx || (failed = true)
                end
                #println("rule $rule failed: $failed")
                failed && break
            end
            failed && break
        end
        failed && continue
        n += p[div(length(p), 2) + 1]
    end
    n
end
export solve1

function getmyisless(dic)
    function myisless(a, b)
        rules = intersect(findall(x->in(x, a), dic), findall(x->in(x, b), dic))
        isempty(rules) && return false
        rule = rules[1]
        a == x[1] && b == x[2]
    end
end
        

function solve2(parsed)
    rules, prints = parsed
    n = 0
    for p in prints
        solve1((rules, [p])) == 0 || continue
        while solve1((rules, [p])) == 0
        inp = in(p) # function to check if x in p
        for (nidx, n) in enumerate(p)
            my_in = x->in(n, x)
            fitrules = findall(my_in, rules)
            for rule in rules[fitrules]
                all(inp, rule) || continue
                if rule[1] == n
                    ridx = findfirst(==(rule[2]), p)
                    nidx < ridx || (p[[nidx, ridx]] = p[[ridx, nidx]])
                else
                    ridx = findfirst(==(rule[1]), p)
                    ridx < nidx || (p[[nidx, ridx]] = p[[ridx, nidx]])
                end
            end
        end
    end
        n += p[div(length(p), 2) + 1]
    end
    n

end
export solve2


solution = Solution(parse_input, solve1, solve2)

testinput = """
47|53
97|13
97|61
97|47
75|29
61|13
75|53
29|13
97|29
53|29
61|53
97|53
61|29
47|13
75|47
97|75
47|61
75|61
47|29
75|13
53|13

75,47,61,53,29
97,61,53,29,13
75,29,13
75,97,47,61,53
61,13,29
97,13,75,29,47"""
testanswer_1 = 143
testanswer_2 = 123
export testinput, testanswer_1, testanswer_2

test() = AoC.test_solution(solution, testinput, testanswer_1, testanswer_2)
export test

main(part=missing) = AoC.main(solution, part)
export main


end # module Solver
