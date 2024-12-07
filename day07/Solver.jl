module Solver
using Test
using AoC
using AoC.Utils


function parse_input(raw_data)
    raw_data
    parsed = []
    for line in eachline(IOBuffer(raw_data))
        testres, nums = split(line, ": ")
        push!(parsed, (parse(Int, testres), parse.(Int, split(nums, ' '))))
    end
    parsed
end
export parse_input

function calculate(nums, ops)
    res = ops[1](nums[1], nums[2])
    for i in 2:length(ops)
        res = ops[i](res, nums[i+1])
    end
    res
end

function solve1(parsed)
    nsum = 0
    @show length(parsed)
    i = 0
    Threads.@threads :dynamic for (res, nums) in copy(parsed)
        print("\r$(i+=1), $(Threads.threadid())")
        for ops in Iterators.product(repeat([(+, *)], length(nums)-1)...)
            calcres = calculate(nums, ops)
            if calcres == res
                nsum += res
                break
            end
        end
    end
    nsum
end
export solve1


function solve2(parsed)
    nsum = 0
    lck = ReentrantLock()
    @show length(parsed)
    i = 0
    myop(i1, i2) = parse(Int, string(i1)*string(i2))
    works = Int[]
    for (res, nums) in copy(parsed)
        print("\r$(i+=1), $(Threads.threadid())")
        found = false
        for availops in [(+,), (*,), (+, *)]
            for ops in Iterators.product(repeat([availops], length(nums)-1)...)
                #availops == (+, *) && all(==(*), ops) && continue
                calcres = calculate(nums, ops)
                if calcres == res
                    nsum += res
                    push!(works, res)
                    found = true
                    break
                end
            end
            found && break
        end
    end
    println("part 1 is $nsum")
    myop2(i, j)=Int(i*exp10(round(Int, log10(j), RoundUp))+j)
    Threads.@threads :dynamic for (res, nums) in copy(parsed)
        res in works && continue
        print("\r$(i+=1), $(Threads.threadid())")
        opsarr = vec(collect(Iterators.product(repeat([(+, *, myop2)], length(nums)-1)...)))
        if rem(res, last(nums)) == 0
            #display(opsarr)
            sort!(opsarr, by=x->(last(x)==(*)))
        end
        if endswith(string(res), string(last(nums)))
            sort!(opsarr, by=x->(last(x)==myop2))
        end
        #@show length(opsarr)
        for ops in opsarr
            calcres = calculate(nums, ops)
            if calcres == res
                lock(lck)
                nsum += res
                unlock(lck)
                break
            end
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
"""
testanswer_1 = 3749
testanswer_2 = 11387
export testinput, testanswer_1, testanswer_2

test() = AoC.test_solution(solution, testinput, testanswer_1, testanswer_2)
export test

main(part=missing) = AoC.main(solution, part)
export main


end # module Solver
