module Solver
using Test
using AoC
using AoC.Utils


function parse_input(raw_data)
    lines = Vector{Char}[]
    for line in eachline(IOBuffer(raw_data))
        push!(lines, collect(line))
    end
    permutedims([lines...;;])
end
export parse_input

rotr90(v::AbstractVector) = [0 1; -1 0] * v
rotn(n) = ∘(repeat([rotr90], n)...)
const rotdict = Dict(CartesianIndex(rotn(i)([-1, 0])...)=>CartesianIndex(rotn(i+1)([-1, 0])...) for i in 1:4)
rotr90(idx::CartesianIndex)=rotdict[idx]
const neighbs4 = CartesianIndex{2}[CartesianIndex(rotn(i)([1, 0])...) for i in 1:4]
areneighs(c1, c2) = (c1-c2) ∈ neighbs4

function getareaandperim(map, pos, char, visited)
    arperim = [1, 0]
    for neigh in neighbs4
        newpos = pos+neigh
        if !checkbounds(Bool, map, newpos) || map[newpos] != char
            arperim += [0, 1]
        else
            newpos ∈ visited && continue
            push!(visited, newpos)
            arperim += getareaandperim(map, newpos, char, visited)
        end
    end
    return arperim
end

function solve1(parsed)
    map = copy(parsed)
    nsum = 0
    visited = Set{CartesianIndex{2}}()
    for startpos in eachindex(IndexCartesian(), map)
        startpos ∈ visited && continue
        push!(visited, startpos)
        arper = getareaandperim(map, startpos, map[startpos], visited)
        #@info "arperim is $arper for $startpos with char $(map[startpos])"
        nsum += prod(arper)
        #@show visited
    end
    nsum
end
export solve1

function getareaandsides(map, pos, char, visited, localvisit)
    arperim = [1, 0]
    nneighs = 0
    for neigh in neighbs4
        newpos = pos+neigh
        if !checkbounds(Bool, map, newpos) || map[newpos] != char
            arperim += [0, 1]
        else
            nneighs += 1
            newpos ∈ visited && continue
            push!(visited, newpos)
            arperim += getareaandsides(map, newpos, char, visited, localvisit)
        end
    end
    push!(localvisit, (pos, nneighs))
    return arperim
end

function solve2(parsed)
    map = copy(parsed)
    nsum = 0
    visited = Set{CartesianIndex{2}}()
    for startpos in eachindex(IndexCartesian(), map)
        startpos ∈ visited && continue
        localvisit = Set()
        push!(visited, startpos)
        ch = map[startpos]
        arper = getareaandsides(map, startpos, ch, visited, localvisit)
        nsides = 0
        # boolean not of same area
        suitable(p) = !checkbounds(Bool, map, p) || map[p] != ch
        for (node, nneighs) in localvisit
            if iszero(nneighs)
                nsides += 4
                continue
            elseif isone(nneighs)
                @info "$node is end"
                nsides += 2
                continue
            elseif nneighs == 2
                for neigh in neighbs4
                    u = node + neigh
                    r = node + rotr90(neigh)
                    if (suitable(u) && suitable(r))
                        # node is outer corner
                        nsides += 1
                        if (suitable(3node-u-r))
                            # node is inner corner as well
                            nsides += 1
                        end
                        break
                    end
                end
                continue
            end
            for neigh in neighbs4
                u = node + neigh
                r = node + rotr90(neigh)
                diagback = u+r-node
                if (!suitable(u) && !suitable(r) && suitable(diagback))
                    # node is inner corner
                    # because 2 neighbours are but diagonal across is not same
                    nsides += 1
                end
            end
        end
        nsum += arper[1] * nsides
    end
    nsum
end
export solve2


solution = Solution(parse_input, solve1, solve2)

testinput = """
AAAAAA
AAABBA
AAABBA
ABBAAA
ABBAAA
AAAAAA"""
testanswer_1 = 140 
testanswer_2 = 368
export testinput, testanswer_1, testanswer_2

test() = AoC.test_solution(solution, testinput, testanswer_1, testanswer_2)
export test

main(part=missing) = AoC.main(solution, part)
export main


end # module Solver
