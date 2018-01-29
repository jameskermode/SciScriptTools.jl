module Import

export use_package

"""
    `use_package(package; repo = nothing, update = false, branch = "master" )`

Automatic way to use packages (built with container environments in mind)

### Usage
    `SciScriptTools.Import.use_package("JuLIP", update = true)`
    using JuLIP

the `using JuLIP` part brings the module and exported functions into the current scope
ie can use `AbstractAtoms` rather than `JuLIP.AbstractAtoms`
TODO: figure out way to do this from within the function

### Arguments
- `package::string`: package name
- `repo::string`: repository link
- `update::Boolean`: update package
"""
function use_package(package; repo = nothing, update = false, branch = "master" )

    # check if package already exists or is registered, clone if not
    try
        if Pkg.installed(package) == nothing
            info("Package '$package' is registered\n")
            info("Pkg.add($package)\n")
            Pkg.add(package)
        else
            info("Package '$package' is installed\n")
        end
    catch
        info("Package '$package' is not installed or registered, trying to clone repository\n")
        if repo == nothing error("No repository link given\n") end
        info("Pkg.clone($repo)\n")
        Pkg.clone(repo)
    end

    if update == true
        info("Pkg.checkout($package, $branch)\n")
        Pkg.checkout(package, branch)
    end

    use_string = string("using", " $package")
    use = parse(use_string)

    info(string(use_string, "\n"))
    eval(use)
end

end # module
