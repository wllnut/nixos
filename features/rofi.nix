{config, lib, ...}:
let
  cfg = config.dendritic.rofi;
in {
  options.dendritic.rofi.enable = lib.mkEnableOption "rofi";

  config.nixos.modules.rofi = lib.mkIf cfg.enable ({ pkgs, ... }:
    let
      rofiConfig = pkgs.writeText "rofi-config.rasi" ''
      configuration {
        modi: "drun,run,window";
        show-icons: true;
        drun-display-format: "{name}";
      }
      '';
    in {
      environment.systemPackages = [pkgs.rofi];

      systemd.tmpfiles.rules = [
        "d /home/william/.config/rofi 0755 william users -"
        "L+ /home/william/.config/rofi/config.rasi - - - - ${rofiConfig}"
      ];
    });
}
