{ config, pkgs, ...}: {
  fonts = {
    fonts = with pkgs; [
      # fonts that many things (apps, websites) expect
      dejavu_fonts
      liberation_ttf
      roboto
      raleway
      ubuntu_font_family
      # unfree
      # corefonts
      # helvetica-neue-lt-std
      # fonts I use
      etBook
      emacs-all-the-icons-fonts
      # coding fonts
      source-sans-pro
      source-serif-pro
      (nerdfonts.override {
        enableWindowsFonts = true;
        fonts = [ "Iosevka" "FiraCode" "Inconsolata" "JetBrainsMono" "Hasklig" "Meslo" "Noto" ];
      })
    ];
    fontconfig = {
      defaultFonts = {
        monospace = [ "Iosevka" ];
        sansSerif = [ "FiraGO" "Source Sans Pro" ];
        serif = [ "ETBembo" "Source Serif Pro" ];
      };
    };
    fontDir.enable = true;
  };

  # Enable the X11 windowing system.
  services.xserver.enable = true;

  services.xserver.windowManager.i3.enable = true;
  services.xserver.displayManager.defaultSession = "none+i3";

  # Configure keymap in X11
  services.xserver.layout = "fr";
  services.xserver.xkbVariant = "bepo";
  services.xserver.xkbOptions = "caps:swapescape";

}
