{
  description = "Portable and easy to deploy NixOS Flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.05";
    preservation.url = "github:nix-community/preservation";
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    nuenv.url = "github:DeterminateSystems/nuenv";
  };

  outputs = inputs @ {
    nixpkgs,
    nixos-hardware,
    nuenv,
    ...
  }: {
    nixosConfigurations = {
      # Baseline server deployment
      foxcatcher = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs =
          inputs
          // {
            myvars.username = "ajg";
            myvars.userfullname = "Anthony J. G.";
          };
        modules = [
          {networking.hostName = "foxcatcher";}

          ./configuration.nix

          ../modules/base
          ../modules/nixos/base/i18n.nix
          ../modules/nixos/base/user-group.nix
          ../modules/nixos/base/networking.nix

          ../hosts/idols-ai/hardware-configuration.nix
          ../hosts/idols-ai/preservation.nix
        ];
      };

      # shoukei = nixpkgs.lib.nixosSystem {
      #   system = "x86_64-linux";
      #   specialArgs =
      #     inputs
      #     // {
      #       myvars.username = "ajg";
      #       myvars.userfullname = "Anthony J. G.";
      #     };
      #   modules = [
      #     # Building on a USB installer is buggy, lack of disk space, memory, trublesome to setup substituteers, etc.
      #     # so we disable apple-t2 module here to avoid build kernel during the initial installation, and enable it after the first boot.
      #     # nixos-hardware.nixosModules.apple-t2
      #     ({pkgs, ...}: {
      #       networking.hostName = "shoukei";
      #       boot.kernelPackages = pkgs.linuxPackages_latest; # Use latest kernel for the initial installation.
      #       # hardware.apple-t2.enableAppleSetOsLoader = true;
      #     })
      #
      #     ./configuration.nix
      #
      #     ../modules/base
      #     ../modules/nixos/base/i18n.nix
      #     ../modules/nixos/base/user-group.nix
      #     ../modules/nixos/base/networking.nix
      #
      #     ../hosts/12kingdoms-shoukei/hardware-configuration.nix
      #     ../hosts/idols-ai/preservation.nix
      #   ];
      # };
    };
  };
}