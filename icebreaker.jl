using Random

struct Args
    n::Int 
    filepaths::Vector{<:AbstractString}
end


function show_help()
    println("Usage: julia icebreaker.jl [-n N] [-h] <file> [[file] ...]")
    println("Where:")
    println("  -n N        Set number of questions to choose to N (default is 5)")
    println("  -h, --help  Show this help and exit")
    println("  file        Path to file containing questions")
end

function parse_args(args::Vector{<:AbstractString})
    # Default settings.
    n = 5
    filepaths = Vector{String}()

    function set_n(value::AbstractString)
        n = parse(Int, value)
        f = set_file
    end

    function set_file(value::AbstractString)
        push!(filepaths, value)
    end

    f = set_file
    for a in args
        if a == "-n"
            f = set_n
        elseif a in ("-h", "--help")
            show_help()
            exit(0)
        else
            f(a)
        end
    end

    return Args(n, filepaths)
end

function load_questions(paths::Vector{<:AbstractString})
    questions = Vector{String}()
    for p in paths
        append!(questions, [q for q in eachline(p) if length(q) > 0])
    end

    return questions
end

function main()
    args = parse_args(ARGS)
    questions = load_questions(args.filepaths)
    shuffle!(questions)
    
    for q in 1:min(args.n, length(questions))
        println("$q) $(questions[q])")
    end
end

main()
