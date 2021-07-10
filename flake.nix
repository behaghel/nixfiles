{
  description = "Hubert's ultimate flake";

  inputs.nixpkgs.url = "nixpkgs/nixos-21.05-small";

  inputs.home-manager.url = "github:nix-community/home-manager/release-21.05";
  inputs.home-manager.inputs.nixpkgs.follows = "nixpkgs";

  inputs.hub-home.url = "github:behaghel/dotfiles/stow-refactoring";
  inputs.hub-home.inputs.nixpkgs.follows = "nixpkgs";

  outputs = { self, nixpkgs, home-manager, hub-home }:
    let
      # Function to create default (common) system config options
      defFlakeSystem = baseCfg:
        nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          modules = [
            (./hosts/default.nix)
            # Add home-manager option to all configs
            ({ ... }: {
              imports = [
                {
                  # Set the $NIX_PATH entry for nixpkgs. This is necessary in
                  # this setup with flakes, otherwise commands like `nix-shell
                  # -p pkgs.htop` will keep using an old version of nixpkgs.
                  # With this entry in $NIX_PATH it is possible (and
                  # recommended) to remove the `nixos` channel for both users
                  # and root e.g. `nix-channel --remove nixos`. `nix-channel
                  # --list` should be empty for all users afterwards
                  nix.nixPath = [ "nixpkgs=${nixpkgs}" ];
                }
                baseCfg
                home-manager.nixosModules.home-manager
                # DONT set useGlobalPackages! It's not necessary in newer
                # home-manager versions and does not work with configs using
                # `nixpkgs.config`
                { home-manager.useUserPackages = true; }
              ];
              # Let 'nixos-version --json' know the Git revision of this flake.
              system.configurationRevision =
                nixpkgs.lib.mkIf (self ? rev) self.rev;
              nix.registry.nixpkgs.flake = nixpkgs;
            })
          ];
        };
    in {
      nixosConfigurations = {
        inherit nixpkgs;
        dell-laptop = defFlakeSystem {
          imports = [
            (./hosts/dell-laptop/default.nix)
            # Add home-manager config
            { home-manager.users.hub = hub-home.nixosModules.desktop; }
          ];
        };
      };
      packages.x86_64-linux.hello = nixpkgs.legacyPackages.x86_64-linux.hello;
      defaultPackage.x86_64-linux = self.packages.x86_64-linux.hello;
    };
}
