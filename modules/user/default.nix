{ config, lib, pkgs, ... }:
let
  cfg = config.ragon.user;
  uid = cfg.uid;
  username = cfg.username;
  extraGroups = cfg.extraGroups;
  extraAuthorizedKeys = cfg.extraAuthorizedKeys;

in
{
  options.ragon.user = {
    enable = lib.mkEnableOption "Enables my user.";
    uid = lib.mkOption {
      type = lib.types.nullOr lib.types.int;
      default = 1000;
    };
    username = lib.mkOption {
      type = lib.types.str;
      default = "ragon";
      description = "My username for this system.";
    };
    extraGroups = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [ ];
    };
    extraAuthorizedKeys = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [ ];
      description = "Additional authorized keys";
    };
    persistent = {
      homeDir = lib.mkOption {
        type = lib.types.str;
        default = "/persistent/home/${username}";
        description = "Location of persistent home files";
      };
      extraFiles = lib.mkOption {
        type = lib.types.listOf lib.types.str;
        default = [ ];
      };
      extraDirectories = lib.mkOption {
        type = lib.types.listOf lib.types.str;
        default = [ ];
      };
    };
  };

  config = lib.mkIf cfg.enable {
    # Let ~/bin/ be in $PATH
    environment.homeBinInPath = true;

    # Define my user account
    users.extraUsers.${username} = {
      isNormalUser = true;
      uid = uid;
      extraGroups = [ "wheel" ] ++ extraGroups;
      shell = pkgs.zsh;
      openssh.authorizedKeys.keys = pkgs.pubkeys.ragon.computers ++ extraAuthorizedKeys;
      passwordFile = "/run/secrets/ragonPasswd";
    };
    ragon.agenix.secrets.ragonPasswd = { };

    # List packages installed in system profile. To search by name, run:
    # $ nix-env -qaP | grep wget
    environment.systemPackages = with pkgs; [
      dnsutils
      nfs-utils
      sshfs-fuse
    ];
  };
}
