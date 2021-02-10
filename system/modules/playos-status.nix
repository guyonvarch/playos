{ config, lib, pkgs, ... }:
let
  ttyNumber = 8;
  tty = "tty${toString ttyNumber}";
  ttyPath = "/dev/${tty}";
  driverUrl = "http://127.0.0.1:8382";

  script =
    pkgs.writeShellScriptBin "print-status" ''
      while :; do
        screen=$(xrandr --current | grep '*' | awk '{print $1}')
        networkCount=$(connmanctl services | grep wifi | wc -l)
        networkConnected=$(connmanctl services | grep wifi | grep "*" | awk '{ print $2 }')
        rfid=$(opensc-tool --list-readers)
        controller=$(systemctl is-active playos-controller)
        time=$(date +'%T %Z')
        printf "\033c"
        printf "%s\n" \
          "Screen dimensions: $screen" \
          "Wifi networks found: $networkCount" \
          "Connected to network: $networkConnected" \
          "RFID: " \
          " $rfid" \
          "Controller: $controller" \
          "Updated at: $time" \
          > ${ttyPath}
        sleep 5
      done
    '';
in
{
  config = {
    console.extraTTYs = [ tty ];
    systemd.services.playos-status = {
      environment = {
        XAUTHORITY = "${config.users.users.play.home}/.Xauthority";
        DISPLAY = ":0";
      };
      path = with pkgs; [
        connman
        gnugrep
        gawk
        xorg.xrandr
        opensc
      ];
      description = "PlayOS status";
      wantedBy = [ "multi-user.target" ];
      after = [ "playos-controller.service" ];
      serviceConfig = {
        ExecStart = "${script}/bin/print-status";
        User = "root";
        StandardOutput = "tty";
        TTYPath = ttyPath;
      };
    };
  };
}
