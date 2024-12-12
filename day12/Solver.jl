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

function getareaandsides(map, pos, char, visited, outvecs)
    arperim = [1, 0]
    for neigh in neighbs4
        newpos = pos+neigh
        if !checkbounds(Bool, map, newpos) || map[newpos] != char
            arperim += [0, 1]
            push!(outvecs, (pos, neigh))
        else
            newpos ∈ visited && continue
            push!(visited, newpos)
            arperim += getareaandsides(map, newpos, char, visited, outvecs)
        end
    end
    return arperim
end

function solve2(parsed)
    map = copy(parsed)
    nsum = 0
    visited = Set{CartesianIndex{2}}()
    for startpos in eachindex(IndexCartesian(), map)
        startpos ∈ visited && continue
        push!(visited, startpos)
        outvecs = Set()
        arper = getareaandsides(map, startpos, map[startpos], visited, outvecs)
        isone(arper[1]) && (nsum += 4)
        arper[1] == 2 && (nsum += 8)
        display(outvecs)
        nsides = 0
        sides = Set()
        lookedat = Set()
        for (c1, v1) in outvecs
            for (c2, v2) in lookedat
                c1 == c2 && continue
                areneighs(c1, c2) || continue
                !areneighs(c1+v1, c2+v2) && (push!(sides, (c2, v2)); nsides+=1)
            end
            push!(lookedat, (c1, v1))
        end
        @show nsides
        display(sides)
        @info "arperim is $arper for $startpos with char $(map[startpos])"
        nsum += arper[1] * nsides
        #@show visited
    end
    nsum
end
export solve2


solution = Solution(parse_input, solve1, solve2)

testinput = """
AAAA
BBCD
BBCC
EEEC"""
testanswer_1 = 140 
testanswer_2 = 80
export testinput, testanswer_1, testanswer_2

test() = AoC.test_solution(solution, testinput, testanswer_1, testanswer_2)
export test

main(part=missing) = AoC.main(solution, part)
export main


end # module Solver
