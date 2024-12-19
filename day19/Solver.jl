module Solver
using Test
using AoC
using AoC.Utils
using ProgressMeter

function parse_input(raw_data)
    lines = split(raw_data, '\n')
    towels = split(lines[1], ", ")
    patterns = lines[3:end]
    towels, patterns
end
export parse_input

let cache = Dict()
global function findpatterns(pattern, towels, earlyexit::Bool)
    found = 0
    #@show pattern
    #any(==(pattern), towels) && return 1
    get!(cache, (pattern, earlyexit)) do
        for towel in towels
            if pattern == towel
                earlyexit && return 1
                #@info "$pattern == $towel"
                found += 1
                isone(length(pattern)) && return found
                continue
            end
            earlyexit && found > 0 && break
            if endswith(pattern, towel)
                #@info "$pattern endswith $towel"
                found += findpatterns(pattern[1:end-length(towel)], towels, earlyexit)
            #elseif earlyexit && startswith(pattern, towel)
            #    found += findpatterns(pattern[length(towel)+1:end], towels)
            end
            earlyexit && found > 0 && break
        end
        found
    end
end
end

function solve1(parsed)
    towels, patterns = deepcopy(parsed)
    nposs = 0
    for pattern in patterns
        println(pattern)
        if findpatterns(pattern, towels, true) > 0
            nposs += 1
        end
    end 
    nposs
end
export solve1


function solve2(parsed)
    towels, patterns = deepcopy(parsed)
    nposs = 0
    for pattern in patterns
        println(pattern)
        #if findpatterns(pattern, towels, true) > 0
            npat = findpatterns(pattern, towels, false)
            @show npat
            nposs += npat
        #end
    end 
    nposs
end
export solve2


solution = Solution(parse_input, solve1, solve2)

testinput = """
r, wr, b, g, bwu, rb, gb, br

brwrr
bggr
gbbr
rrbgbr
ubwu
bwurrg
brgr
bbrgwb"""
testanswer_1 = 6
testanswer_2 = 16
export testinput, testanswer_1, testanswer_2

test() = AoC.test_solution(solution, testinput, testanswer_1, testanswer_2)
export test

main(part=missing) = AoC.main(solution, part)
export main


end # module Solver
