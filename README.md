# dotfiles

This repo contains the configuration to set up my machines. It uses [Chezmoi](https://chezmoi.io) to manage them.

## Exporting packages

### Arch Linux

#### Native packages

```shell
# Export installed files.
pacman -Qqen > arch-native-pkgs.txt
```

```shell
# Install packages from file
sudo pacman -S - < arch-native-pkgs.txt
```

#### AUR

```shell
# Export installed files.
pacman -Qm | awk '!/-debug/ && $1 != "yay" {print $1}' > arch-aur-pkgs.txt
```

```shell
# Install packages from file
yay -S --noconfirm - < arch-aur-pkags.txt
```

## Windows

### PowerShell 7

```pwsh
# Export installed Winget packages.
winget export -s winget -o $HOME\winget-pkgs.json
```

```pwsh
# Install Winget packages from file.
winget import $HOME\winget-pkgs.json
```

### CMD

```cmd
# Export installed Winget packages.
winget export -s winget -o %USERPROFILE%\winget-pkgs.json
```

```cmd
# Install Winget packages from file.
winget import %USERPROFILE%\winget-pkgs.json
```
