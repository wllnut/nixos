{config, lib, ...}:
let
  cfg = config.dendritic.steam;
in {
  options.dendritic.steam.enable = lib.mkEnableOption "steam";

  config.nixos.modules.steam = lib.mkIf cfg.enable ({ pkgs, ... }:
    let
    in {
      environment.systemPackages = [pkgs.steam];

    });
}
