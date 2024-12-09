module Solver
using Test
using AoC
using AoC.Utils
using ProgressMeter

function parse_input(raw_data)
    raw_data
    parsed = []
    for line in eachline(IOBuffer(raw_data))
        testres, nums = split(line, ": ")
        push!(parsed, (parse(BigInt, testres), parse.(BigInt, split(nums, ' '))))
    end
    parsed
end
export parse_input

function calculate(nums, ops)
    return ∘(ops...)(nums...)
    # short for ->
    #=res = ops[1](nums[1], nums[2])
    for i in 2:length(ops)
        res = ops[i](res, nums[i+1])
    end
    res=#
end

function solve1(parsed)
    #=nsum = 0
    i = 0
    works = Int[]
    for (res, nums) in deepcopy(parsed)
        #print("\r$(res), $(Threads.threadid())")
        found = false
        origres = res
        for i in 1:length(nums)
            res < 0 && break
            res == 0 && !isempty(nums) && break
            lastnum = popat!(nums, lastindex(nums))
            newres, rem = divrem(res, lastnum)
            if rem == 0
                res = newres
            else
                res -= lastnum
            end
            if isempty(nums) && ((isone(res) && iszero(rem)) || iszero(res))
                nsum += origres
                push!(works, origres)
                found = true
                break
            end
        end
    end
    nsum =#
    nsum = 0
    for (res, nums) in deepcopy(parsed)
        origres = res
        #@show origres
        possible = checkpossible(res, nums, false)
        if possible
            #@info "adding $origres to nsum"
            nsum += origres
        end
    end
    nsum
end
export solve1

function checkpossible(res, nums, usecat=true, rem=-1)
    #=@show usecat=#
    doprint = false
    doprint && @show res
    doprint && @show nums
    res < 0 && return false
    if isempty(nums)
        doprint && @info "shortcutting with $res, $nums, $rem"
        iszero(rem) && isone(res) && return true
        iszero(res) && return true
    end
    nums = copy(nums)
    for i in 1:length(nums)
            lastnum = popat!(nums, lastindex(nums))
            newres, rem = divrem(res, lastnum)
            resstr = string(res)
            endstr = string(lastnum)
            if rem == 0
                possible = checkpossible(newres, nums, usecat, rem)
                possible && return true
            end
            if usecat && endswith(resstr, endstr)
                newresstr = resstr[begin:end-length(endstr)]
                if isempty(newresstr)
                    isempty(nums) && return true
                else
                    doprint && println("$newresstr $(isempty(newresstr))")
                    possible = checkpossible(parse(Int, newresstr), nums, usecat)
                    possible && return true
                end
            end
            begin
                doprint && @info "checking for plus $res-$lastnum, $nums"
                possible = checkpossible(res-lastnum, nums, usecat)
                possible && return true
            end
            return false
        end
        false
end

function solve2(parsed)
    #@warn "starting part 2"
    nsum = 0
    i = 0
    works = Int[]
    for (res, nums) in deepcopy(parsed)
        #print("\r$(res), $(Threads.threadid())")
        found = false
        origres = res
        possible = checkpossible(res, nums, true)
        if possible
            #println("$origres works")
            (nsum += origres)
        else
            #println("$origres does not work")
        end
    end
    nsum
end
export solve2


solution = Solution(parse_input, solve1, solve2)

testinput = """
190: 10 19
3267: 81 40 27
83: 17 5
156: 15 6
7290: 6 8 6 15
161011: 16 10 13
192: 17 8 14
21037: 9 7 18 13
292: 11 6 16 20
123: 1 2 3
6: 1 1 1 1 1 1
232: 1 23 2
244: 3 4 2 2
32: 15 16
1303: 58 5 643 75 297
"""
testanswer_1 = 3749 + 6
testanswer_2 = 11387 + 123 + 6 + 232 + 244
export testinput, testanswer_1, testanswer_2

test() = AoC.test_solution(solution, testinput, testanswer_1, testanswer_2)
export test

main(part=missing) = AoC.main(solution, part)
export main


end # module Solver

if abspath(PROGRAM_FILE) == @__FILE__
    using .Solver
    main()
end
