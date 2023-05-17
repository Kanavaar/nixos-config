{config, pkgs, lib, ...}:
{
  networking.hostName = "binary";

  users.users.tilman = {
    password = "1234";
    isNormalUser = true;
    shell = pkgs.zsh;
    description = "Tilman Andre Mix";
    home = "/home/tilman";
    extraGroups = [ "libvirtd" "wheel" "audio" "video" "networkmanager" "usb" "users" ]; # Enable ‘sudo’ for the user.
  };
}
