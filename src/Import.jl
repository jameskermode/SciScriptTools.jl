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
            print("Package '$package' is registered\n")
            print("Pkg.add($package)\n")
            Pkg.add(package)
        else
            print("Package '$package' is installed\n")
        end
    catch
        print("Package '$package' does not exist nor is registered, trying to clone repository\n")
        if repo == nothing
            # put error into proper framework
            print("Error: no repository link given!\n")
        end
        print("Pkg.clone($repo)\n")
        Pkg.clone(repo)
    end

    use_string = string("using", " $package")
    use = parse(use_string)

    if update == true
        print("Pkg.checkout($package, $branch)\n")
        Pkg.checkout(package, branch)
    end

    print(string(use_string, "\n"))
    eval(use)
end

end # module
