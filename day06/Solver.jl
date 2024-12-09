module Solver
using Test
using AoC
using AoC.Utils
using LinearAlgebra
import Base.rotr90

function parse_input(raw_data)
    raw_data
    linearr = []
    for line in eachline(IOBuffer(raw_data))
        push!(linearr, collect(line))
    end
    newarr = permutedims([linearr...;;])
    guardpos = findfirst(==('^'), newarr)
    obstacles = zeros(Int8, size(newarr))
    for i in eachindex(newarr)
        obstacles[i] = newarr[i] == '#' ? 1 : 0
    end
    obstacles, guardpos
end
export parse_input


function solve1(parsed)
    obstacles, guardpos = parsed
    obstacles = copy(obstacles)
    direction = [-1, 0]
    leftmap = false
    while leftmap == false
        obstacles[guardpos] = 2
        infront = 0
        cartdir = CartesianIndex(direction...)
        try
            infront = obstacles[guardpos + cartdir]
        catch e
            if e isa BoundsError
                leftmap = true
                break
            end
        end
        if isone(infront)
            direction = rotr90(direction)
        else
            guardpos = guardpos + cartdir
        end
    end
    count(==(2), obstacles)
end
export solve1


rotr90(v::AbstractVector) = [0 1; -1 0] * v
rotn(n) = ∘(repeat([rotr90], n)...)
rotdict = Dict(CartesianIndex(rotn(i)([-1, 0])...)=>CartesianIndex(rotn(i+1)([-1, 0])...) for i in 1:4)
println("rotdict defined")
for k in keys(rotdict)
    @show k
    @show rotdict[k]
    @show rotr90([k.I...])
end

function leaves(obstacles, guardpos, direction)
    guardpos = CartesianIndex(guardpos.I...)
    obstacles = copy(obstacles)
    direction = copy(direction)
    leftmap = false
    cartdir = CartesianIndex(direction...)
    for i in 1:length(obstacles)
        infront = 0
        #cartdir = CartesianIndex(Tuple(direction))
        try
            infront = obstacles[guardpos + cartdir]
        catch e
            if e isa BoundsError
                leftmap = true
                break
            end
        end
        if isone(infront)
            #direction = rotr90(direction)
            cartdir = rotdict[cartdir]
        else
            guardpos = guardpos + cartdir
        end
    end
    leftmap
end

function solve2(parsed)
    obstacles, guardpos = parsed
    iniguardpos = CartesianIndex(guardpos.I...)
    direction = [-1, 0]
    rotr90(v::AbstractVector) = [0 1; -1 0] * v
    dirdict = Dict([∘(repeat([rotr90], i)...)([-1, 0])=>(1<<i) for i in 1:4])
    leftmap = false
    obspos = Set()
    lck = ReentrantLock()
    for i in eachindex(obstacles)
        obstacles[i] == 1 && continue
        obs = copy(obstacles)
        obs[i] = 1
        if !leaves(obs, iniguardpos, direction)
            lock(lck)
            push!(obspos, i)
            unlock(lck)
        end
    end
    #=while leftmap == false
        #@show guardpos
        #display(obstacles)
        obstacles[guardpos] |= dirdict[direction]
        infront = 0
        cartdir = CartesianIndex(direction...)
        try
            infront = obstacles[guardpos + cartdir]
        catch e
            if e isa BoundsError
                leftmap = true
                break
            end
        end
        if isone(infront)
            direction = rotr90(direction)
        else
            guardpos = guardpos + cartdir
        end
    end
    display(obstacles)
    leftmap = false
    guardpos = iniguardpos
    direction = [-1, 0]
    while leftmap == false
        print("\r$(length(obspos))")
        #@show guardpos
        #display(obstacles)
        infront = 0
        cartdir = CartesianIndex(direction...)
        try
            infront = obstacles[guardpos + cartdir]
        catch e
            if e isa BoundsError
                leftmap = true
                break
            end
        end
        if isone(infront)
            direction = rotr90(direction)
        else
            newdir = rotr90(direction)
            Threads.@threads :greedy for mult in 1:150
                try
                    val = obstacles[guardpos + mult*CartesianIndex(newdir...)]
                    isone(val) && break
                    #if (val & dirdict[newdir]) != 0
                        obscop = copy(obstacles)
                        obscop[guardpos+cartdir] = 1
                        if !leaves(obscop, guardpos, direction)
                           # @info "putting obstacle at $(guardpos+cartdir) with direction $(direction)"
                            push!(obspos, guardpos+cartdir)
                        end
                    #end
                catch e
                    e isa BoundsError && break
                end
            end
            guardpos = guardpos + cartdir
        end
    end
    display(obspos)
    for pos in obspos
        obstacles[pos] = -1
    end
    obstacles[iniguardpos] = -2=#
    length(obspos)
end
export solve2


solution = Solution(parse_input, solve1, solve2)

testinput = """
....#.....
.........#
..........
..#.......
.......#..
..........
.#..^.....
........#.
#.........
......#...
"""
testanswer_1 = 41
testanswer_2 = 6
export testinput, testanswer_1, testanswer_2

test() = AoC.test_solution(solution, testinput, testanswer_1, testanswer_2)
export test

main(part=missing) = AoC.main(solution, part)
export main


end # module Solver
