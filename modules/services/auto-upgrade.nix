{ config, lib, pkgs, ... }:
let
  cfg = config.ragon.services.auto-upgrade;
in
{
  options.ragon.services.auto-upgrade = {
    enable = lib.mkEnableOption "Enable auto updating of the nix config";
    user = lib.mkOption {
      type = lib.types.str;
      default = "root";
      defaultText = "root";
      description = "User to run as";
    };
    path = lib.mkOption {
      type = lib.types.str;
      default = "/etc/nixos/";
      defaultText = "/etc/nixos/";
      description = "Working directory for the job to update the config";
    };
    interval = lib.mkOption {
      type = lib.types.str;
      default = "04:30";
      example = "hourly";
      description = ''
        Update configs at this interval. Runs by default at 04:30 every day.

        The format is described in
        <citerefentry><refentrytitle>systemd.time</refentrytitle>
        <manvolnum>7</manvolnum></citerefentry>.
      '';
    };
  };

  config = lib.mkIf false {
    # Enable auto upgrader
    system.autoUpgrade.enable = true;

    # Auto garbage collect
    nix.gc.automatic = !config.ragon.gui.enable;
    nix.gc.options = "--delete-older-than 30d";

    # Set up service
    systemd.services.update-nixos-config = {
      description = "update-nixos-config";
      after = [ "network.target" ];
      wantedBy = [ "default.target" ];
      path = with pkgs; [ git niv nix gnutar gzip ];
      serviceConfig = {
        Type = "oneshot";
        User = cfg.user;
        ExecStart = pkgs.writeScript "update-config-and-external-deps.sh" ''
          #!/bin/sh
          git reset --hard HEAD
          git pull
          niv update dwm
        '';
        WorkingDirectory = cfg.path;
      };
    };

    # Run service
    systemd.timers.update-nixos-config = {
      description = "Update timer for update-nixos-config";
      partOf = [ "update-nixos-config.service" ];
      wantedBy = [ "timers.target" ];
      timerConfig.OnCalendar = cfg.interval;
    };
  };
}
