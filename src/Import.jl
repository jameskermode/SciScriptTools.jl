module Import

export use_package

"""
`use_package(package; repo = nothing, update = false, branch = "master" )`

Automatic way to use packages (built with container environments in mind)

### Usage
`SciScriptTools.Import.use_package("JuLIP", update = true)`

`using JuLIP`  # optional

the optional `using JuLIP` brings the module and exported functions into the current scope
ie can use `AbstractAtoms` rather than `JuLIP.AbstractAtoms`
TODO: figure out way to do this from within the function

### Arguments
- `package::string`: package name
- `repo::string`: repository link
- `update::Boolean`: update package
"""
function use_package(package; repo = nothing, update = false, branch = "master" )

    # check if package is already installed or registered, clone if not
    try
        if Pkg.installed(package) == nothing
            info("Package '$package' is registered")
            info("Executing `Pkg.add($package)`")
            Pkg.add(package)
        else
            info("Package '$package' is installed")
        end
    catch
        info("Package '$package' is not installed or registered, trying to clone repository")
        if repo == nothing error("No repository link given") end
        info("Executing `Pkg.clone($repo)`")
        Pkg.clone(repo)
    end

    # checkout a particular branch or version of the package
    if update == true
        info("Executing `Pkg.checkout($package, $branch)`")
        Pkg.checkout(package, branch)
    end

    # excute `using $package`
    use_string = string("using", " $package")
    use = parse(use_string)
    info(string("Executing ", "`", use_string, "`"))

    eval(use)
end

end # module
