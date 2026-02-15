{
  pkgs,
  earthtone-nvim,
  ...
}: let
  schemeToml = builtins.fromTOML (builtins.readFile "${earthtone-nvim}/extras/base16-earthtone-light.toml");
in {
  stylix = {
    enable = true;
    base16Scheme = schemeToml.palette // {inherit (schemeToml.scheme) name author;};
    fonts = {
      monospace = {
        package = pkgs.nerd-fonts.hack;
        name = "Hack Nerd Font Mono";
      };
      sansSerif = {
        package = pkgs.nerd-fonts.hack;
        name = "Hack Nerd Font";
      };
      serif = {
        package = pkgs.nerd-fonts.hack;
        name = "Hack Nerd Font";
      };
      emoji = {
        package = pkgs.emptyDirectory // {meta.mainProgram = "empty-file";};
        name = "";
      };
      sizes = {
        applications = 13;
        desktop = 12;
        popups = 12;
        terminal = 16;
      };
    };
    polarity = "light";
  };
}
