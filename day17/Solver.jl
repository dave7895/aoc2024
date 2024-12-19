module Solver
using Test
using AoC
using AoC.Utils

function parse_input(raw_data)
    A = B = C = 0
    prog = Int[]
    i = 1
    for line in eachline(IOBuffer(raw_data))
        if i == 1
            A = ints(line)[1]
        elseif i == 2
            B = ints(line)[1]
        elseif i == 3
            C = ints(line)[1]
        end
        i += 1
        isempty(line) && continue
        if startswith(line, "Program") 
            prog = ints(line)
        end
    end
    (prog, [A, B, C])
end
export parse_input

function combo(x, regs)
    x < 4 && return x
    return regs[x-3]
end

adv(A::Integer, c) = A÷(2^c)
bxl(B::Integer, l) = B ⊻ l
bst(c::Integer) = c & 0b111
jnz(A::Integer, l, ptr) = iszero(A) ? ptr+2 : l+1
bxc(B::Integer, C::Integer) =  B ⊻ C
out(c) = c & 0b111
bdv(A::Integer, c) = adv(A, c)
cdv(A::Integer, c) = adv(A, c)

function instruction(opcode, operand, ptr, regs, outputs)
    if opcode == 0
        regs[1] = adv(regs[1], combo(operand, regs))
    elseif opcode == 1
        regs[2] = bxl(regs[2], operand)
    elseif opcode == 2
        regs[2] = bst(combo(operand, regs))
    elseif opcode == 3
        return jnz(regs[1], operand, ptr)
    elseif opcode == 4
        regs[2] = bxc(regs[2], regs[3])
    elseif opcode == 5
        push!(outputs, out(combo(operand, regs)))
    elseif opcode == 6
        regs[2] = bdv(regs[1], combo(operand, regs))
    elseif opcode == 7
        regs[3] = cdv(regs[1], combo(operand, regs))
    end
    return ptr+2
end

function simulate(prog, A, B, C)
    regs = [A, B, C]
    outputs = Int[]
    ptr = 1
    while ptr < length(prog)
        #ptr == 1 && @show regs
        #@show regs
        ptr = instruction(prog[ptr], prog[ptr+1], ptr, regs, outputs)

    end
    outputs
end

function solve1(parsed)
    prog, regs = deepcopy(parsed)
    out = simulate(prog, regs...)
    return join(out, ',')
    #return out
end
export solve1


function solve2(parsed)
    prog, regs = deepcopy(parsed)
    A, B, C = regs
    out = Int[-1]
    A = 0
    pos = 0
    while out != prog
        if out[end-pos:end] == prog[end-pos:end]
            A *= 8
            pos += 1
        else
            A += 1
        end
        out = simulate(prog, A, B, C)
    end
    A
end
export solve2


solution = Solution(parse_input, solve1, solve2)

testinput = """
Register A: 2024
Register B: 0
Register C: 0

Program: 0,3,5,4,3,0"""
testanswer_1 = "5,7,3,0"
testanswer_2 = 117440
export testinput, testanswer_1, testanswer_2

test() = AoC.test_solution(solution, testinput, testanswer_1, testanswer_2)
export test

main(part=missing) = AoC.main(solution, part)
export main


end # module Solver
