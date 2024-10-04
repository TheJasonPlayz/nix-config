{ user, feh, symlinkJoin, writeText makeWrapper }:

symlinkJoin { 
  name = "feh-custom";
  paths = [ feh ];
  buildInputs = [ makeWrapper ];
  postBuild = writeText "${user.home}/.fehbg" ''feh --bg-scale --no-fehbg --no-xinerama ${user.home}/Pictures/BGs/''
}