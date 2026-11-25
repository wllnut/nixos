{ lib, ... }: {
  options.dendritic.colors = lib.mkOption {
    type = lib.types.attrsOf lib.types.str;
    default = {};
    description = "Monochrome color palette";
  };

  config.dendritic.colors = {
    bg = "#000000";
    fg = "#b4b4b4";
    dim = "#8a8a8a";
    surface = "#262626";
    muted = "#555555";
    subtle = "#3a3a3a";
    bright = "#f7f7f7";
    accent = "#aaaaaa";
    cursor = "#b4b4b4";
    cursorText = "#000000";
    border = "#aaaaaa";
  };
}
