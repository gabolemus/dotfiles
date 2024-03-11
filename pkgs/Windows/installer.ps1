winget export -s winget -o $HOME\winget-pkgs.json

winget import $HOME\winget-pkgs.json
