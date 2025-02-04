{ inputs, config, lib, pkgs, ... }:
let
  cfg = config.ragon.home-manager;
  isGui = config.ragon.gui.enable;
in
{
  options.ragon.home-manager.enable = lib.mkEnableOption "Enables my home-manager config";

  # Import the home-manager module
  imports = [ inputs.home-manager.nixosModules.home-manager ];

  config = lib.mkIf cfg.enable {
    # Make sure to start the home-manager activation before I log it.
    systemd.services."home-manager-${config.ragon.user.username}" = {
      before = [ "display-manager.service" ];
      wantedBy = [ "multi-user.target" ];
    };
    environment.systemPackages = with pkgs;[
      dunst # dunstify
    ];
    programs.fuse.userAllowOther = true; # for persistence user dirs to work

    home-manager.users.${config.ragon.user.username} = { pkgs, lib, ... }:
      {
        # Import a persistance module for home-manager.
        ## TODO this can be done less ugly
        imports = [ "${inputs.impermanence}/home-manager.nix" ];

        programs.home-manager.enable = true;

        home.persistence.${config.ragon.user.persistent.homeDir} = {
          files = [ ] ++ config.ragon.user.persistent.extraFiles;
          directories = [
            ".ssh"
            ".gnupg"
            "Downloads"
            "Backgrounds"
            "proj"
            "git"
          ] ++ config.ragon.user.persistent.extraDirectories;
          allowOther = true;
        };

        home.stateVersion = "21.05";
      };
  };
}
