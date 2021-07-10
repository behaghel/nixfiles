{ config, pkgs, ...}:
{

  # activating support for flakes
  nix = {
    package = pkgs.nixUnstable;
    extraOptions = ''
      experimental-features = nix-command flakes
    '';
   };

  # Set your time zone.
  time.timeZone = "Europe/London";

  # Select internationalisation properties.
  # i18n.defaultLocale = "en_US.UTF-8";
  console = {
    font = "Lat2-Terminus16";
    keyMap = "fr-bepo";
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.hub = {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" ]; # Enable ‘sudo’ for the user.
    shell = pkgs.zsh;
  };

  programs.zsh.enable = true;
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };

  services = {
    openssh.enable = true;
    emacs = {
      enable = true;
      defaultEditor = true; # EDITOR env-var to emacsclient wrapper
    };
  };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    networkmanager
    vim
    git
  ];
  # to have completion in zsh for systemd units
  environment.pathsToLink = [ "/share/zsh" ];
}