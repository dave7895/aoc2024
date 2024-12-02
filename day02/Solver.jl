module Solver
using Test
using AoC
using AoC.Utils


function parse_input(raw_data)
    raw_data
    data = []
    for line in eachline(IOBuffer(raw_data))
        arr = Int[]
        
	for c in line
            isnumeric(c) || continue
            push!(arr, parse(Int, c))
        end
        arr = parse.(Int, split(line))
        push!(data, arr)
    end
    data
end
export parse_input

"""
function check_record(record)
returns a boolean if a record is safe
"""
function check_record(record)
        # needs to be sorted either ascending or descending
        (issorted(record) || issorted(record; rev=true)) || return false
        # get difference between neighbouring numbers
        diffs = map(x->abs(x[1]-x[2]), zip(record, record[2:end]))
        # check if the differences fulfill the requirements
	all(>=(1), diffs) && all(<=(3), diffs) && return true
	false
end

function solve1(parsed)
    count(check_record.(parsed))
end
export solve1


function solve2(parsed)
    n = 0
    checked = check_record.(parsed)
    n += count(checked)
    # boolean indexing to select those that were not safe on their own
    bad = parsed[(!).(checked)]
    for record in bad
        anygood = false
        # combinatorial nightmare, recheck without any preselection
        for i in eachindex(record)
            anygood && break
            boolidxs = trues(length(record))
            boolidxs[i] = false
            newrec = record[boolidxs]
            anygood = check_record(newrec)
        end
	if anygood
            n += 1
            continue
        end
    end
    n
end
export solve2


solution = Solution(parse_input, solve1, solve2)

testinput = """
7 6 4 2 1
1 2 7 8 9
9 7 6 2 1
1 3 2 4 5
8 6 4 4 1
1 3 6 7 9
"""
testanswer_1 = 2
testanswer_2 = 4
export testinput, testanswer_1, testanswer_2

test() = AoC.test_solution(solution, testinput, testanswer_1, testanswer_2)
export test

main(part=missing) = AoC.main(solution, part)
export main


end # module Solver
