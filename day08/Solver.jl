module Solver
using Test
using AoC
using AoC.Utils
using LinearAlgebra

function parse_input(raw_data)
    raw_data = strip(raw_data)
    lines = collect.(split(raw_data, '\n'))
    println(length(lines))
    println(length.(lines))
    return permutedims([lines...;;])
end
export parse_input


function solve1(parsed)
    map = copy(parsed)
    nodesposs = Set()
    freqs = filter(!=('.'), unique(map))
    allantennas = Dict(freq=>findall(==(freq), map) for freq in freqs)
    for freq in freqs
        antennas = allantennas[freq]
        for a1 in antennas
            for a2 in antennas
                a1 == a2 && continue
                diffvec = a2-a1
                for v in [a1-diffvec, a2+diffvec]
                    try
                        map[v] = '#'
                        push!(nodesposs, v)
                    catch e
                        e isa BoundsError && continue
                        rethrow(e)
                    end
                end
            end
        end
    end
    println(join(String.(eachrow(map)), '\n'))
    length(nodesposs)
end
export solve1


function solve2(parsed)
    map = copy(parsed)
    nodesposs = Set()
    freqs = filter(!=('.'), unique(map))
    allantennas = Dict(freq=>findall(==(freq), map) for freq in freqs)
    for freq in freqs
        antennas = allantennas[freq]
        for a1 in antennas
            for a2 in antennas
                a1 == a2 && continue
                diffvec = a2-a1
                difftup = diffvec.I
                lengthrange = -(maximum(a1.I)÷maximum(difftup)):(size(map, 1)-maximum(a1.I))
                println(lengthrange)
                for vm in lengthrange
                    v = a1 + vm*diffvec
                    try
                        map[v] = '#'
                        push!(nodesposs, v)
                    catch e
                        e isa BoundsError && continue
                        rethrow(e)
                    end
                end
            end
        end
    end
    println(join(String.(eachrow(map)), '\n'))
    length(nodesposs)
end
export solve2


solution = Solution(parse_input, solve1, solve2)

testinput = """
............
........0...
.....0......
.......0....
....0.......
......A.....
............
............
........A...
.........A..
............
............"""
testanswer_1 = 14
testanswer_2 = 34
export testinput, testanswer_1, testanswer_2

test() = AoC.test_solution(solution, testinput, testanswer_1, testanswer_2)
export test

main(part=missing) = AoC.main(solution, part)
export main


end # module Solver
