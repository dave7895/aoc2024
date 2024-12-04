module Solver
using Test
using AoC
using AoC.Utils


function parse_input(raw_data)
    raw_data
    linearr = []
    for line in eachline(IOBuffer(raw_data))
        push!(linearr, collect(line))
    end
    return permutedims([linearr...;;])
end
export parse_input


function solve1(parsed)
    diagi = [CartesianIndex(i, i) for i in 0:3]
    diagi2 = [CartesianIndex(i, -i) for i in 0:3]
    hori = [CartesianIndex(0, i) for i in 0:3]
    verti = [CartesianIndex(i, 0) for i in 0:3]
    indices = [diagi, (-).(diagi), diagi2, (-).(diagi2), hori, (-).(hori), verti, (-).(verti)]
    
    nfound = 0
    bitarr = falses(size(parsed))
    for idx in CartesianIndices(parsed)
        parsed[idx] == 'X' || continue
        for idxset in indices
            try
                str = String(parsed[idx .+ idxset])
                if str == "XMAS"
                    nfound += 1
                    bitarr[idx .+ idxset] .= true
                end
            catch e
                e isa BoundsError && continue
                rethrow(e)
            end
        end
    end
    println(bitarr)
    nfound
end
export solve1


function solve2(parsed)
    indices = vec([vec([CartesianIndex(i, j) for i in si:-si*2:-si, j in sj:-sj*2:-sj]) for si=-1:2:1, sj=-1:2:1])
    println(indices)
    truewords = ["MMSS", "MMSS", "MSMS", "MSMS"]
    nfound = 0
    bitarr = falses(size(parsed))
    for idx in CartesianIndices(parsed)
        parsed[idx] == 'A' || continue
        cont = false
        for (idxn, idxset) in enumerate(indices)
            try
                str1 = String(parsed[idx .+ idxset])
                str2 = String(parsed[idx .+ idxset[2:2:4]])
                println(str1, str2)
                if str1 == "MSMS" || str1 == "MMSS"
                    nfound += 1
                    bitarr[idx .+ idxset] .= true
                    bitarr[idx] = true
                    break
                end
            catch e
                e isa BoundsError && continue
                rethrow(e)
            end
        end
    end
    println(bitarr)
    nfound
end
export solve2


solution = Solution(parse_input, solve1, solve2)

testinput = """
MMMSXXMASM
MSAMXMSMSA
AMXSXMAAMM
MSAMASMSMX
XMASAMXAMM
XXAMMXXAMA
SMSMSASXSS
SAXAMASAAA
MAMMMXMMMM
MXMXAXMASX
"""
testanswer_1 = 18
testanswer_2 = 9
export testinput, testanswer_1, testanswer_2

test() = AoC.test_solution(solution, testinput, testanswer_1, testanswer_2)
export test

main(part=missing) = AoC.main(solution, part)
export main


end # module Solver
