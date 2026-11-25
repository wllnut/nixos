{ pkgs, ... }: {
  nixos.configurations.genesis = {
    system = "x86_64-linux";

    module = { config, lib, pkgs, ... }: {
      imports = [ ./_hardware-configuration.nix ];

      xdg.portal = {
        enable = true;
        extraPortals = [
          pkgs.xdg-desktop-portal-gtk
        ];

        config.common.default = ["gtk"];
      };
      
      services.flatpak.enable = true; # Remember that flatpaks are NOT declarative

      environment.systemPackages = [pkgs.git];

      boot.loader.systemd-boot.enable = true;
      boot.loader.efi.canTouchEfiVariables = true;
      boot.kernelParams = [
        "quiet"
        "loglevel=3"
        "systemd.show_status=auto"
        "rd.udev.log_level=3"
      ];
      boot.consoleLogLevel = 3;

      services.journald.settings.Journal = {
        ForwardToConsole = false;
        ForwardToWall = false;        
      };

      networking.hostName = "genesis";
      networking.networkmanager.enable = true;

      time.timeZone = "America/Chicago";
      i18n.defaultLocale = "en_US.UTF-8";

      services.displayManager.ly.enable = true;
      services.xserver.displayManager.lightdm.enable = false;
      
      nixpkgs.config.allowUnfree = true;

      users.users.william = {
        isNormalUser = true;
        extraGroups = [ "wheel" "networkmanager" ];
        packages = with pkgs; [];
        initialPassword = "password";
      };

      nix.settings.experimental-features = [ "nix-command" "flakes" ];
      system.stateVersion = "26.05";
    };
  };
}
