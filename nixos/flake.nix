{
  description = "NixOS - Mark Taguiad";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.11";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    quadlet-nix.url = "github:SEIAROTg/quadlet-nix";

    agenix = {
      url = "github:ryantm/agenix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      nixpkgs-unstable,
      agenix,
      quadlet-nix,
      ...
    }:
    let
      system = "x86_64-linux";

      pkgsFor =
        system:
        import nixpkgs {
          inherit system;

          config = {
            allowUnfree = true;
          };
        };

      unstableFor =
        system:
        import nixpkgs-unstable {
          inherit system;
          config = {
            allowUnfree = true;
          };
        };

      commonModules = [
        # hardware
        ./modules/hardware/kernel_boot.nix
        ./modules/hardware/power.nix
        ./modules/hardware/thinkpad.nix

        # system
        ./modules/system/font.nix
        ./modules/system/locale.nix
        ./modules/system/ssh.nix

        # desktop
        ./modules/desktop/editor.nix
        ./modules/desktop/terminal.nix
      ];

    in
    {
      nixosConfigurations = {

        ########################
        # SINAGTALA
        ########################
        sinagtala = nixpkgs.lib.nixosSystem {
          inherit system;

          specialArgs = {
            pkgs-unstable = unstableFor system;
            inherit agenix;
          };

          modules = commonModules ++ [
            quadlet-nix.nixosModules.quadlet
            agenix.nixosModules.default
            ./hosts/sinagtala/configuration.nix
            ./hosts/sinagtala/hardware-configuration.nix

            {
              environment.systemPackages = [ agenix.packages.${system}.default ];
            }
          ];
        };

        ########################
        # MARILAG
        ########################
        marilag = nixpkgs.lib.nixosSystem {
          inherit system;

          specialArgs = {
            pkgs-unstable = unstableFor system;
          };

          modules = commonModules ++ [
            quadlet-nix.nixosModules.quadlet
            agenix.nixosModules.default
            ./hosts/marilag/configuration.nix
            ./hosts/marilag/hardware-configuration.nix

            {
              environment.systemPackages = [ agenix.packages.${system}.default ];
            }
          ];
        };
      };
    };
}
