{
  description = "NixOS - Mark Taguiad";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.11";

    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";

    flake-utils.url = "github:numtide/flake-utils";

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

        # network
        ./modules/network/base.nix

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
