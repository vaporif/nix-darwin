{pkgs, ...}: {
  stylix = {
    enable = true;
    base16Scheme = {
      scheme = "Everforest Light Custom";
      author = "Based on Sainnhe Park";
      base00 = "e8dcc6"; # background
      base01 = "f8f1de"; # lighter bg
      base02 = "d5c9b8"; # selection bg
      base03 = "b5c1b8"; # comments
      base04 = "9da9a0"; # dark fg
      base05 = "5c6a72"; # default fg
      base06 = "4d5b56"; # light fg
      base07 = "3a5b4d"; # light bg
      base08 = "b85450"; # red
      base09 = "c08563"; # orange
      base0A = "c9a05a"; # yellow
      base0B = "89a05d"; # green
      base0C = "6b9b91"; # cyan
      base0D = "6b8b8f"; # blue
      base0E = "9b7d8a"; # purple
      base0F = "859289"; # brown
    };
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
        applications = 12;
        desktop = 10;
        popups = 10;
        terminal = 16;
      };
    };
    polarity = "light";
  };
}
