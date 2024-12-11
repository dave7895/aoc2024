module Solver
using Test
using AoC
using AoC.Utils


function parse_input(raw_data)
    raw_data
    linearr = Vector{Char}[]
    for line in eachline(IOBuffer(raw_data))
        isempty(line) && continue
        pline = collect(line)
        push!(linearr, pline)
    end
    permutedims([linearr...;;])
end
export parse_input

rotr90(v::AbstractVector) = [0 1; -1 0] * v
rotn(n) = ∘(repeat([rotr90], n)...)
const neighbs4 = CartesianIndex{2}[CartesianIndex(rotn(i)([1, 0])...) for i in 1:4]

function npeaks(map, startpos, h)
    reachable = CartesianIndex{2}[] #Set()
    map[startpos] == '9' && return [startpos] #Set((startpos,))
    for neighb in neighbs4
        newpos = startpos + neighb
        !checkbounds(Bool, map, newpos) && continue
        h + 1 == map[newpos] && (append!(reachable, npeaks(map, newpos, h+1)))
    end
    return reachable
end

function solve1(parsed)
    #println(join(join.(eachrow(parsed), ""), '\n'))
    nsum = 0
    allstarts = findall(==('0'), parsed)
    isnothing(allstarts) && return 0
    for starts in allstarts
        np = npeaks(parsed, starts, '0')
        nsum += length(unique(np))
    end
    nsum
end
export solve1

function solve2(parsed)
    nsum = 0
    allstarts = findall(==('0'), parsed)
    isnothing(allstarts) && return 0
    for starts in allstarts
        np = npeaks(parsed, starts, '0')
        nsum += length(np) 
    end
    nsum
end
export solve2


solution = Solution(parse_input, solve1, solve2)

testinput = """
89010123
78121874
87430965
96549874
45678903
32019012
01329801
10456732"""
testanswer_1 = 36
testanswer_2 = 81
export testinput, testanswer_1, testanswer_2

test() = AoC.test_solution(solution, testinput, testanswer_1, testanswer_2)
export test

main(part=missing) = AoC.main(solution, part)
export main


end # module Solver
