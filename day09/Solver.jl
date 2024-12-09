module Solver
using Test
using AoC
using AoC.Utils


function parse_input(raw_data)
    raw_data
    layout = Int[]
    sizedict = Dict()
    for (idx, char) in enumerate(collect(strip(raw_data)))
        idx -= 1
        n = parse(Int, char)
        id = iseven(idx) ? idx÷2 : -1
        id != -1 && (sizedict[id]=n)
        append!(layout, repeat([id], n))
    end
    layout, sizedict
end
export parse_input


function solve1(parsed)
    layout = copy(parsed[1])
    while (lastf = findlast(>=(0), layout)) > (firstspace = findfirst(==(-1), layout))
        layout[lastf], layout[firstspace] = layout[firstspace], layout[lastf]
    end
    n = 0
    for i in eachindex(layout)
        x = layout[i]
        x == -1 && break
        n += x*(i-1)
    end
    n
end
export solve1


function solve2(parsed)
    layout = copy(parsed[1])
    dic = parsed[2]
    id2move = layout[findlast(>=(0), layout)]
    while id2move > 0
        sz = dic[id2move]
        len = sz-1
        locblock = findfirst(==(id2move), layout)
        empties = findall(==(-1), layout[1:locblock])
        loc = -1
        for empt in empties
            if all(==(-1), layout[empt:empt+len])
                loc = empt
                break
            end
        end
        if loc != -1 && loc < locblock
            layout[locblock:locblock+len], layout[loc:loc+len] = layout[loc:loc+len], layout[locblock:locblock+len]
        end
        id2move -= 1
    end
    n = 0
    for i in eachindex(layout)
        x = layout[i]
        x == -1 && continue
        n += x*(i-1)
    end
    n
end
export solve2


solution = Solution(parse_input, solve1, solve2)

testinput = """
2333133121414131402"""
testanswer_1 = 1928
testanswer_2 = 2858
export testinput, testanswer_1, testanswer_2

test() = AoC.test_solution(solution, testinput, testanswer_1, testanswer_2)
export test

main(part=missing) = AoC.main(solution, part)
export main


end # module Solver
