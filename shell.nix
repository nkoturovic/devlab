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
}: pkgs.mkShell {
    name = "Dev Lab";
    version = "0.0.5";

    # Programs and libraries used by the new derivation at run-time
    packages = [
      pkgs.ncurses
      # pkgs.gcc
      # pkgs.cmake
      pkgs.gnumake
      pkgs.go
      # pkgs.rustc
      # pkgs.cargo
      # pkgs.cargo-expand
      # pkgs.helix
      # pkgs.zls
      zig."0.12.0"
      kotur-nixpkgs.dinosay # packet loads from the custom nixpkgs (kotur-nixpkgs)
    ];

    # Hook used for modifying the prompt look and printing the welcome message
    shellHook = ''
      PS1="\[\e[32m\][\[\e[m\]\[\e[33m\]nix-shell\\[\e[m\]:\[\e[36m\]\w\[\e[m\]\[\e[32m\]]\[\e[m\]\\$\[\e[m\] "
      alias ll="ls -l"
      dinosay -r -b happy -w 60 "Welcome to the $name dev environment!"
    '';
  }
