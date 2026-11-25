{ config, inputs, lib, ... }:
let
  cfg = config.dendritic.oxwm;
in {
  options.dendritic.oxwm.enable = lib.mkEnableOption "oxwm";

  config.nixos.modules.oxwm = lib.mkIf cfg.enable ({ pkgs, config, ... }:
    let
      oxwmPkg = inputs.oxwm.packages.${pkgs.stdenv.hostPlatform.system}.default;

        # Uses pkgs.alacritty's store path so it always resolves even if PATH varies
      alacrittyBin = "${pkgs.alacritty}/bin/alacritty";
      rofiLauncher = "${pkgs.rofi}/bin/rofi -show drun";
      oxwmConfig = pkgs.writeText "oxwm-config.lua" ''
        local modkey = "Mod4"

        -- Set Alacritty as the default terminal for oxwm.spawn_terminal()
        oxwm.set_terminal("${alacrittyBin}")
        oxwm.set_modkey(modkey)
        oxwm.set_tags({ "1", "2", "3", "4", "5", "6", "7", "8", "9" })

        -- Borders & gaps
        oxwm.border.set_width(2)
        oxwm.border.set_focused_color("#aaaaaa")
        oxwm.border.set_unfocused_color("#8a8a8a")
        oxwm.gaps.set_inner(5, 5)
        oxwm.gaps.set_outer(5, 5)

        -- Bar
        oxwm.bar.set_scheme_normal("#8a8a8a", "#000000", "#3a3a3a")
        oxwm.bar.set_scheme_occupied("#b4b4b4", "#000000", "#aaaaaa")
        oxwm.bar.set_scheme_selected("#f7f7f7", "#262626", "#aaaaaa")
        oxwm.bar.set_scheme_urgent("#000000", "#b4b4b4", "#f7f7f7")

        oxwm.bar.set_blocks({
          oxwm.bar.block.ram({
            format = "Ram: {used}/{total} GB",
            interval = 5,
            color = "#b4b4b4"
          }),

          oxwm.bar.block.datetime({
            format = "{}",
            date_format = "%a, %b %d - %-I:%M %P",
            interval = 1,
            color = "#aaaaaa",
            underline = false;
          }),
        })

        -- Terminal & core keybinds
        oxwm.key.bind({ modkey, "Shift" }, "Return", oxwm.spawn_terminal())
        oxwm.key.bind({ modkey }, "Return", oxwm.spawn("${rofiLauncher}"))
        oxwm.key.bind({ modkey }, "Q", oxwm.client.kill())
        oxwm.key.bind({ modkey, "Shift" }, "R", oxwm.restart())
        oxwm.key.bind({ modkey, "Shift" }, "Q", oxwm.quit())

        oxwm.key.bind({ modkey }, "H", oxwm.monitor.focus(-1))
        oxwm.key.bind({ modkey }, "J", oxwm.client.focus_stack(1))
        oxwm.key.bind({ modkey }, "K", oxwm.client.focus_stack(-1))
        oxwm.key.bind({ modkey }, "L", oxwm.monitor.focus(1))

        oxwm.key.bind({ modkey }, "Space", oxwm.client.toggle_floating())

        oxwm.key.bind({ modkey, "Shift" }, "H", oxwm.monitor.tag(-1))
        oxwm.key.bind({ modkey, "Shift"}, "J", oxwm.client.move_stack(1))
        oxwm.key.bind({ modkey, "Shift"}, "K", oxwm.client.move_stack(-1))
        oxwm.key.bind({ modkey, "Shift" }, "L", oxwm.monitor.tag(1))
        
        
        -- Workspace / tag switching (1-9)
        for i = 1, 9 do
          oxwm.key.bind({ modkey }, tostring(i), oxwm.tag.view(i - 1))
          oxwm.key.bind({ modkey, "Shift" }, tostring(i), oxwm.tag.move_to(i - 1))
        end
      '';
    in {
      environment.systemPackages = [ oxwmPkg pkgs.firefox ];

      services.xserver = {
        enable = true;
        windowManager.session = [{
          name = "oxwm";
          start = ''
            ${oxwmPkg}/bin/oxwm &
            waitPID=$!
          '';
        }];
      };

system.activationScripts.oxwmConfig = lib.stringAfter [ "users" ] ''
  ${pkgs.util-linux}/bin/runuser -u william -- mkdir -p /home/william/.config/oxwm
  ${pkgs.util-linux}/bin/runuser -u william -- ln -sfn ${oxwmConfig} /home/william/.config/oxwm/config.lua
'';




    });
}
