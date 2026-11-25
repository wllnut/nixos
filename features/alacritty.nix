{ config, lib, ... }:
let
  cfg = config.dendritic.alacritty;
  c = config.dendritic.colors;
in {
  options.dendritic.alacritty.enable = lib.mkEnableOption "alacritty";

  config.nixos.modules.alacritty = lib.mkIf cfg.enable ({ pkgs, ... }:
    let
      alacrittyConfig = (pkgs.formats.toml { }).generate "alacritty.toml" {
        window = {
          padding = {
            x = 8;
            y = 8;
          };
        };
        font = {
          size = 11.0;
        };
        cursor = {
          style = {
            shape = "Block";
            blinking = "On";
          };
        };
	
	colors = {
      primary = {
        background = c.bg;
        foreground = c.fg;
      };

      cursor = {
        text = c.cursorText;
        cursor = c.cursor;
      };

      selection = {
        text = c.bright;
        background = c.surface;
      };

      normal = {
        black = c.bg;
        red = c.dim;
        green = c.fg;
        yellow = c.accent;
        blue = c.muted;
        magenta = c.dim;
        cyan = c.fg;
        white = c.fg;
      };

      bright = {
        black = c.subtle;
        red = c.dim;
        green = c.bright;
        yellow = c.bright;
        blue = c.accent;
        magenta = c.bright;
        cyan = c.bright;
        white = c.bright;
      };
    };
          

        
              };
    in {
      environment.systemPackages = [ pkgs.alacritty ];

      systemd.tmpfiles.rules = [
        "d /home/william/.config/alacritty 0755 william users -"
        "L+ /home/william/.config/alacritty/alacritty.toml - - - - ${alacrittyConfig}"
      ];
    });
}
