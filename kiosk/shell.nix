let
  pkgs = import ../pkgs {
    version = "1.0.0-dev";
    updateUrl = "http://localhost:9999";
    kioskUrl = "https://dev-play.dividat.com/";
  };
in
  pkgs.playos-kiosk-browser
