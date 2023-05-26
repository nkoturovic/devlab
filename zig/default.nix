{
  system ? builtins.currentSystem,
  lock ? builtins.fromJSON (builtins.readFile ./flake.lock),
  # The official nixpkgs input, pinned with the hash defined in the flake.lock file
  pkgs ? let
    nixpkgs = fetchTarball {
      url = "https://github.com/NixOS/nixpkgs/archive/${lock.nodes.nixpkgs.locked.rev}.tar.gz";
      sha256 = lock.nodes.nixpkgs.locked.narHash;
    };
  in
    import nixpkgs {
      overlays = [];
      config = {};
      inherit system;
    },
  # Helper tool for generating compile-commands.json
  zig ? let
    zig = fetchTarball {
      url = "https://github.com/mitchellh/zig-overlay/archive/${lock.nodes.zig.locked.rev}.tar.gz";
      sha256 = lock.nodes.zig.locked.narHash;
    };
  in
    import zig {
      inherit system;
      },
  # Custom nixpkgs channel, owner's nickname is kotur, hence kotur-nixpkgs
  kotur-nixpkgs ? let
    koturPkgs = fetchTarball {
      url = "https://github.com/nkoturovic/kotur-nixpkgs/archive/${lock.nodes.koturNixPkgs.locked.rev}.tar.gz";
      sha256 = lock.nodes.koturNixPkgs.locked.narHash;
    };
  in
    import koturPkgs {
      inherit system;
    },
}: let
  # Stdenv is base for packaging software in Nix It is used to pull in dependencies such as the GCC toolchain,
  # GNU make, core utilities, patch and diff utilities, and so on. Basic tools needed to compile a huge pile
  # of software currently present in nixpkgs.
  #
  # Some platforms have different toolchains in their StdEnv definition by default
  # To ensure gcc being default, we use gccStdenv as a base instead of just stdenv
  # mkDerivation is the main function used to build packages with the Stdenv
  package = pkgs.stdenv.mkDerivation (self: {
    name = "zig-nix-app";
    version = "0.0.3";

    # Programs and libraries used/available at build-time
    nativeBuildInputs = [
      pkgs.stdenv # Also used bellow with mini_compile_commands in shell
      pkgs.ncurses
      pkgs.cmake
      pkgs.gnumake
      zig.master
    ];

    # Programs and libraries used by the new derivation at run-time
    buildInputs = [
    ];

    # builtins.path is used since source of our package is the current directory: ./
    # Alternatively, you can use: fetchFromGitHub, fetchTarball or similar
    src = builtins.path {
      path = ./.;

      # Filter all files that begin with '.', for example '.git', that way
      # .git directory will not become part of the source of our package
      filter = path: type:
        !(pkgs.lib.hasPrefix "." (baseNameOf path));
    };

    # Specify cmake flags
    cmakeFlags = [
      "--no-warn-unused-cli" # Supresses unused varibles warning
      # "-DMyVar=foo" # Example CMake argument
    ];

    # Nix is smart enough to detect we're using cmake to build our project
    # It will read our CMakeLists.txt file and create needed definitions
    # Alternatively, we could have been pre-defining the default phases that nix does
    # for a CMake based projects (see definitions bellow that are commented-out ###)

    ### buildDir = "build-nix-${self.name}-${self.version}";

    ### configurePhase = ''
    ###   mkdir ./${self.buildDir} && cd ./${self.buildDir}
    ###   cmake .. -DCMAKE_BUILD_TYPE=Release
    ### '';

    ### buildPhase = ''
    ###   make -j$(nproc)
    ### '';

    ### installPhase = ''
    ###   mkdir -p $out/bin
    ###   cp src/${self.name} $out/bin/
    ### '';

    # passthru - it is meant for values that would be useful outside of the derivation
    # in other parts of a Nix expression (e.g. in other derivations)
    passthru = {
      # inherit has nothing to do with OOP, it's a nix-specific syntax for
      # inheriting (copying) variables from the surrounding lexical scope
      inherit pkgs shell;
      # equivalent to:
      # pkgs = pkgs
      # shell = shell
    };
  });

  # Development shell
  shell = pkgs.mkShell {
    # Copy build inputs (dependencies) from the derivation the nix-shell environment
    # That way, there is no need for speciying dependenvies separately for derivation and shell
    inputsFrom = [
      package
    ];

    # Shell (dev environment) specific packages
    packages = [
      kotur-nixpkgs.dinosay # packet loads from the custom nixpkgs (kotur-nixpkgs)
      pkgs.helix
      pkgs.zls
    ];

    # Hook used for modifying the prompt look and printing the welcome message
    shellHook = ''
      PS1="\[\e[32m\][\[\e[m\]\[\e[33m\]nix-shell\\[\e[m\]:\[\e[36m\]\w\[\e[m\]\[\e[32m\]]\[\e[m\]\\$\[\e[m\] "
      alias ll="ls -l"
      dinosay -r -b happy -w 60 "Welcome to the '${package.name}' dev environment!"
      cd examples
    '';
  };
in
  package
