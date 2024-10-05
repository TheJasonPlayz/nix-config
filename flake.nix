{
    inputs = {
        nixpkgs.url = "github:nixos/nixpkgs/nixos-24.05";
        lanzaboote = {
            url = "github:nix-community/lanzaboote/v0.4.1";

            inputs.nixpkgs.follows = "nixpkgs";
        };
    };
    outputs = { self, nixpkgs, ... } @ args: {
        packages = let
            system = "x86_64-linux";
            theme = import ./theme.nix; 
            pkgs = import nixpkgs { inherit system; config.allowUnfree = true; };
        in 
        {
            qtile = pkgs.callPackage ./pkgs/qtile.nix {};

            profile = import ./profile.nix {
                inherit (self.packages.${system}) pkgs;
            };

            alacritty = pkgs.callPackage ./pkgs/alacritty.nix {};
            feh = pkgs.callPackage ./pkgs/feh.nix {};
            git = pkgs.callPackage ./pkgs/git.nix {};
            discord = pkgs.callPackage ./pkgs/discord.nix {};
            direnv = pkgs.callPackage ./pkgs/direnv.nix {};
            nix-zsh-completions = pkgs.callPackage ./pkgs/nix-zsh-completions.nix { };
            rofi = pkgs.callPackage ./pkgs/rofi.nix { inherit theme; };
            vscode = pkgs.callPackage ./pkgs/vscode.nix { };
            zsh = pkgs.callPackage ./pkgs/zsh.nix {
                inherit theme;
                inherit (self.packages.${system}) nix-zsh-completions direnv;
            };
            xsecurelock = pkgs.callPackage ./pkgs/xsecurelock.nix {};
        };

	nixosConfigurations.jasonw = let 
          system = "x86_64-linux";
	  pkgs = import nixpkgs { inherit system; config.allowUnfree = true; };
        in
        nixpkgs.lib.nixosSystem {
            inherit pkgs;
            inherit system;
            modules = [
                args.lanzaboote.nixosModules.lanzaboote
                ./configuration.nix
            ];
        };
    };
}
