{ alacritty, symlinkJoin, writeText, makeWrapper, theme }:

let config = writeText "alacritty.yaml" (builtins.toJSON {
  colors = {
    inherit (theme.bright);
    inherit (theme.normal);
    primary = {
      background = theme.background;
      foreground = theme.foreground;
    };
  };
  env.TERM = "xterm-256color";
  font = {
    normal.family = "JetBrains Mono";
    size = 9;
  };
}); in
symlinkJoin
{
  name = "alacritty-custom";
  paths = [
    alacritty
  ];
  buildInputs = [ makeWrapper ];
  postBuild = ''
    mkdir $out/etc
    cp ${config} $out/etc/alacritty.yml
    wrapProgram $out/bin/alacritty --add-flags "--config-file=$out/etc/alacritty.yml"
  '';
}