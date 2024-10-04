{user, nixpkgs}:

let 
in
nixpkgs.writeText ${user.home}/qtile/config.py ''
  
''