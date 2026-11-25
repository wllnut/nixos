{ inputs, config, lib, ...}: {
  options.nixos = {
    modules = lib.mkOption {
      type = lib.types.lazyAttrsOf lib.types.deferredModule;
      default = {};
      description = "Named NixOS module sets.";
    };

    configurations = lib.mkOption {
      type = lib.types.lazyAttrsOf (lib.types.submodule ({ config, ... }: {
        options = {
          module = lib.mkOption {
            type = lib.types.deferredModule;
            default = {};
          };

          system = lib.mkOption {
            type = lib.types.enum [ "x86_64-linux" "aarch64-linux" "x86_64-darwin" "aarch64-darwin" ];
            default = "x86_64-linux";
          };

          specialArgs = lib.mkOption {
            type = lib.types.attrsOf lib.types.unspecified;
            default = {};
          };
        };
      }));
      default = {};
    };
  };

  config.flake.nixosConfigurations = lib.mapAttrs (
    _name: cfg:
    inputs.nixpkgs.lib.nixosSystem {
      inherit (cfg) system specialArgs;
      modules = [ cfg.module ] ++  builtins.attrValues config.nixos.modules;
    }
  ) config.nixos.configurations;
}
