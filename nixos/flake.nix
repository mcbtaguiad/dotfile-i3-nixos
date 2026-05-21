{
  description = "NixOS - Mark Taguiad";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.11";

    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";

    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs =
    {
      nixpkgs,
      nixpkgs-unstable,
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
        ./modules/core.nix
        ./modules/hardware.nix
        ./modules/network.nix
        ./modules/power.nix
        ./modules/system.nix
        ./modules/thinkpad.nix
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
          };

          modules = commonModules ++ [
            ./hosts/sinagtala/configuration.nix
            ./hosts/sinagtala/hardware-configuration.nix

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
            ./hosts/marilag/configuration.nix
            ./hosts/marilag/hardware-configuration.nix

            # server feature flags
            # {
            #   myProfile = {
            #     nvidia.enable = true;
            #     virtualization.enable = false;
            #   };
            # }

            # optional server-only tuning
            {
              boot.kernelParams = [ "nvidia-drm.modeset=1" ];
            }
          ];
        };
      };
    };
}
