module Solver
using Test
using AoC
using AoC.Utils
using LinearAlgebra

function parse_input(raw_data)
    machines = []
    butA = (0, 0)
    butB = (0, 0)
    prizepos = (0, 0)
    reg = r"X[+=]([0-9]+), Y[+=]([0-9]+)"
    for line in eachline(IOBuffer(raw_data|>strip))
        if startswith(line, "Button A")
            butA = parse.(BigInt, match(reg, line).captures)
        elseif startswith(line, "Button B")
            butB = parse.(BigInt, match(reg, line).captures)
        elseif startswith(line, "Prize")
            prizepos = parse.(BigInt, match(reg, line).captures)
        end
        isempty(line) && push!(machines, (butA, butB, prizepos))
    end
    push!(machines, (butA, butB, prizepos))
    machines
end
export parse_input

price(sol)=sum((3, 1) .* sol)

function solve1(parsed)
    nsum = 0

    for machine in parsed
        butA, butB, target = machine
        #println(machine)
        A = [vec(butA);; vec(butB)]
        v = vec(target)
        minprice = solvelinearsystem(A, v)
        nsum += minprice
    end
    nsum
end
export solve1

function solvelinearsystem(A::AbstractMatrix, v::AbstractVector)
    if iszero(det(A))
        @info "$A $v det 0"
        return v[1]÷A[2, 1]
    end
    xa, ya, xb, yb = A
    xt, yt = v
    a = (yb*xt-xb*yt)//(yb*xa-xb*ya)
    isone(a.den) || return 0
    b = (yt-a*ya)//yb
    isone(b.den) || return 0
    3*a.num + b.num
    #invA = [d -b; -c a].// (a*d - b*c)
    #@show invA * v
    #@show (a*d - b*c)
    #sol = (invA*v) 
    #@show sol
    #all(x->isone(x.den), sol) || return 0
    #return [3, 1]'*sol
end

function solve2(parsed)
    nsum = 0
    i = 1
    for machine in parsed
        butA, butB, target = machine
        target = target .+ 10000000000000
        minprice = typemax(Int)
        A = [vec(butA);; vec(butB)]
        v = vec(target)
        minprice = solvelinearsystem(A, v)
        if minprice != typemax(Int)
            nsum += minprice
        end
    end
    nsum
end
export solve2


solution = Solution(parse_input, solve1, solve2)

testinput = """
Button A: X+94, Y+34
Button B: X+22, Y+67
Prize: X=8400, Y=5400

Button A: X+26, Y+66
Button B: X+67, Y+21
Prize: X=12748, Y=12176

Button A: X+17, Y+86
Button B: X+84, Y+37
Prize: X=7870, Y=6450

Button A: X+69, Y+23
Button B: X+27, Y+71
Prize: X=18641, Y=10279"""
testanswer_1 = 480
testanswer_2 = nothing
export testinput, testanswer_1, testanswer_2

test() = AoC.test_solution(solution, testinput, testanswer_1, testanswer_2)
export test

main(part=missing) = AoC.main(solution, part)
export main


end # module Solver
