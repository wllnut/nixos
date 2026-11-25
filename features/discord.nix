{config, lib, ...}:
let
  cfg = config.dendritic.discord;
in {
  options.dendritic.discord.enable = lib.mkEnableOption "discord";

  config.nixos.modules.steam = lib.mkIf cfg.enable ({ pkgs, ... }:
    let
    in {
      environment.systemPackages = [pkgs.discord];

    });
}
