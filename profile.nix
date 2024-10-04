{ pkgs }:

rec {
  profile = pkgs.buildEnv {
    paths = with pkgs; [ 
      alacritty
      gitFull
      discord
      dunst
      xsecurelock
      feh
    ];
    extraOutputsToInstall = [ "man" "doc" ];
  };
}