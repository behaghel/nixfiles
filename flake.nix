{
  description = "Hubert's ultimate flake";

  inputs.nixpkgs.url = "nixpkgs/nixos-21.05-small";

  outputs = { self, nixpkgs }: {

    nixosConfigurations.dell-laptop = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [ ({pkgs, ...}: {
        # let 'nixos-version --json' know about git revision of this flake
        system.configurationRevision = nixpkgs.lib.mkIf (self ? rev) self.rev;
      })
                  (./hosts/default.nix)
                  (./hosts/dell-laptop/default.nix)
                ];
    };

    packages.x86_64-linux.hello = nixpkgs.legacyPackages.x86_64-linux.hello;

    defaultPackage.x86_64-linux = self.packages.x86_64-linux.hello;

  };
}
