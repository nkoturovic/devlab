## Modules

* A package is a directory of .go files. Using packages, you organize your code into reusable units.
* A module is a collection of go packages.
* In go, a convention is that a package's name should be equal to the name of its source directory.
* The first statement in a Go source file must be package name. Executable commands must always use package main. 
* See go mod for example of accessing local modules with a replace directive

### Packages vs Modules

| Feature               | Go Packages                                  | Go Submodules                                |
|-----------------------|----------------------------------------------|----------------------------------------------|
| **Scope**             | Used within a single project repository      | Can span across multiple project repositories |
| **Purpose**           | Organize and structure code in one project   | Manage dependencies and versions of external modules |
| **Versioning**        | Tied to the repository’s overall version     | Independent versioning for each submodule    |
| **Dependency Management** | Internal to the same repository           | Managed with `go mod` across different repositories |
| **Use-Case**          | Code organization and reuse within a single project | Reusable libraries, modular development, and deployment across multiple projects |
