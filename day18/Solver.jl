module Solver
using Test
using AoC
using AoC.Utils
using DataStructures
using LinearAlgebra

function parse_input(raw_data)
    indices = CartesianIndex[]
    for line in split(raw_data, '\n')
        y, x = parse.(Int, split(line, ',')) .+ 1
        push!(indices, CartesianIndex(x, y))
    end
    indices
end
export parse_input

rotr90(v::AbstractVector) = [0 1; -1 0] * v
rotn(n) = ∘(repeat([rotr90], n)...)
const rotdict = Dict(CartesianIndex(rotn(i)([-1, 0])...)=>CartesianIndex(rotn(i+1)([-1, 0])...) for i in 1:4)
rotr90(idx::CartesianIndex)=rotdict[idx]
const neighbs4 = CartesianIndex{2}[CartesianIndex(rotn(i)([1, 0])...) for i in 1:4]
areneighs(c1, c2) = (c1-c2) ∈ neighbs4

function getH(target)
    x -> norm((target-x).I, 1)
end


function findshortestpath(mat, startpos=CartesianIndex(1, 1), target=CartesianIndex(size(mat, 1), size(mat, 2)))
    pq = PriorityQueue{CartesianIndex, Int}()
    predecessors = Dict{CartesianIndex, CartesianIndex}()
    gScore = Dict()
    gScore[startpos] = 0
    h = getH(target)
    fScore = Dict()
    fScore[startpos] = h(startpos)
    enqueue!(pq, startpos, 1)
    while !isempty(pq)
        node = dequeue!(pq)
        if node == target
            return predecessors
        end
        for neigh in node .+ neighbs4
            checkbounds(Bool, mat, neigh) || continue
            mat[neigh] && continue
            tentative_g = gScore[node] + 1
            if tentative_g < get(gScore, neigh, Inf)
                predecessors[neigh] = node
                gScore[neigh] = tentative_g
                pq[neigh] = tentative_g + h(neigh)
            end
        end
    end
    return nothing
end

function assemblePath(dic, endpos)
    path = [endpos]
    sizehint!(path, endpos.I[1]; first=true)
    while haskey(dic, first(path))
        pushfirst!(path, dic[first(path)])
    end
    path
end  # function assemblePath

function solve1(parsed)
    example = length(parsed) < 1024
    siz = example ? (7, 7) : (71, 71)
    mat = falses(siz)
    for idx in parsed[1:(example ? 12 : 1024)]
        mat[idx] = true
    end
    pathdict = findshortestpath(mat)
    path = assemblePath(pathdict, CartesianIndex(siz))
    #display(path)
    length(path)-1
end
export solve1

function getMatrix(indices, upto, matsize)
    matrix = falses(matsize)
    for idx in indices[1:upto]
        matrix[idx] = true
    end
    matrix
end

function solve2(parsed)
    example = length(parsed) < 1024
    siz = example ? (7, 7) : (71, 71)
    mat = falses(siz)
    lastidx = (example ? 12 : 1024)
    for idx in parsed[1:lastidx]
        mat[idx] = true
    end
    lower = lastidx
    upper = lastindex(parsed)
    #mat = getMatrix(parsed, idx, siz)
    idx = lastidx
    pathdict = Dict()
    while lower+1 != upper
        idx = (lower + upper) ÷ 2
        mat = getMatrix(parsed, idx, siz)
        pathdict = findshortestpath(mat)
        if isnothing(pathdict)
            upper = idx
        else
            lower = idx
        end 
    end
    return reverse(parsed[upper].I) .- 1
end
export solve2


solution = Solution(parse_input, solve1, solve2)

testinput = """
5,4
4,2
4,5
3,0
2,1
6,3
2,4
1,5
0,6
3,3
2,6
5,1
1,2
5,5
2,5
6,5
1,4
0,4
6,4
1,1
6,1
1,0
0,5
1,6
2,0"""
testanswer_1 = 22
testanswer_2 = (6, 1)
export testinput, testanswer_1, testanswer_2

test() = AoC.test_solution(solution, testinput, testanswer_1, testanswer_2)
export test

main(part=missing) = AoC.main(solution, part)
export main


end # module Solver
