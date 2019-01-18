# Not an offical Julia repository so pull from link
try
    # if it already exists
    Pkg.checkout("SciScriptTools")
catch
    Pkg.clone("https://github.com/lifelemons/SciScriptTools.jl.git")
end

using Base.Test
using SciScriptTools

include("IO.jl")