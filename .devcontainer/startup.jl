# [Automatically start with Julia](https://kristofferc.github.io/OhMyREPL.jl/latest/installation/#Automatically-start-with-Julia.)
# TerminalPager:
# - https://ronisbr.github.io/TerminalPager.jl/dev/
# - https://discourse.julialang.org/t/ann-terminalpager-jl-v0-5-0/104122
atreplinit() do repl
    try
        @eval using OhMyREPL, TerminalPager
    catch e
        @warn "error in startup.jl (okatsn/my-julia-space)" e
    end
end # mkdir -p $HOME/.julia/config && cp startup.jl "$_"
