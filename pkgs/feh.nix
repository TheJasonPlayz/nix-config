{ feh, symlinkJoin, writeText makeWrapper }:

symlinkJoin { 
  name = "feh-custom";
  paths = [ feh ];
  buildInputs = [ makeWrapper ];
  postBuild = writeText "/home/jasonw/.fehbg" ''feh --bg-scale --no-fehbg --no-xinerama /home/jasonw/Pictures/BGs/''
}
