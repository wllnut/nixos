{ config, lib, ... }:
let
  cfg = config.dendritic.helix;
in {
  # Declared on flake-parts options (top-level)
  options.dendritic.helix.enable = lib.mkEnableOption "helix";

  # Evaluated when building nixos.modules.helix
  config.nixos.modules.helix = lib.mkIf cfg.enable ({ pkgs, ... }:
    let
      helixConfig = (pkgs.formats.toml { }).generate "helix-config.toml" {
        theme = "monochrome";
        editor = {
          auto-format = true;
          bufferline = "multiple";
          cursorline = true;
          line-number = "relative";

          cursor-shape = {
            insert = "bar";
            normal = "block";
            select = "underline";
          };

          whitespace.render = {
            space = "none";
            nbsp = "none";
            tab = "none";
            newline = "none";
          };

          whitespace.characters = {
        		space = "·";
            nbsp = "⍽";
            tab = "→";
            newline = "⏎";
            tabpad = "·";
          };

          lsp.display-messages = true;

                   
          
        };
      };
    in {
      environment.systemPackages = [ pkgs.helix ];
      systemd.tmpfiles.rules = [
        "d /home/william/.config/helix 0755 william users -"
        "L+ /home/william/.config/helix/config.toml - - - - ${helixConfig}"
        
      ];
    });
}
