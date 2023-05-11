atreplinit() do repl # [Automatically start with Julia](https://kristofferc.github.io/OhMyREPL.jl/latest/installation/#Automatically-start-with-Julia.)
    try
        @eval using OhMyREPL
    catch e
        @warn "error while importing OhMyREPL" e
    end
end # mkdir -p $HOME/.julia/config && cp startup.jl "$_"
