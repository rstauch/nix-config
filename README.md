# Setup WSL Distro

Download _nixos-wsl.tar.gz_ from: https://github.com/nix-community/NixOS-WSL/releases (tested with version _23.5.5.2_).

```
# remove existing WSL distro if required
# wsl --unregister NixOS

# import downloaded NixOs-WSL distro
wsl --import NixOS D:\code\wsl\NixOS\ D:\code\wsl\nixos-wsl.tar.gz --version 2

# start distro
wsl -d NixOS

# setup nixos 23.05 channel
sudo nix-channel --add https://nixos.org/channels/nixos-23.05 nixos
sudo nix-channel --update

# provide git
nix-shell -p git

# clone repo
mkdir -p ~/projects/int
cd ~/projects/int
git clone https://github.com/rstauch/nix-config.git

# avoid issues by creating a vscode settings files
mkdir -p /home/nixos/.config/Code/User
touch /home/nixos/.config/Code/User/settings.json

# apply updates
cd ~/projects/int/nix-config
sudo nixos-rebuild switch --flake .#nixos

# reconnect to WSL shell
exit # (nix shell)
exit # (wsl)
wsl -t NixOS
wsl -d NixOS
```

## Mount existing .ssh folder from Windows

Only needs to be performed once:

```
WINDOWS_USER=$(/mnt/c/Windows/System32/WindowsPowerShell/v1.0/powershell.exe '$env:UserName' | tr -d '\r')
echo $WINDOWS_USER
ln -s /mnt/c/Users/$WINDOWS_USER/.ssh ~
# if required:
# chmod 600 ~/.ssh/id_rsa

# test connection
ssh -T git@github.com
```

## Create Windows shortcuts

```
# bash
C:\Windows\System32\wsl.exe --distribution NixOS -u nixos --cd "~"

# zsh
C:\Windows\System32\wsl.exe --distribution NixOS -u nixos --cd "~" -e bash -lc zsh
```

## Setup VcXsrv on Windows

Download and install _VcXsrv_ on Windows https://sourceforge.net/projects/vcxsrv/files/latest/download

Create shortcut: `"C:\Program Files\VcXsrv\xlaunch.exe" -run "C:\code\config.xlaunch"`

**config.xlaunch**:

```xml
<?xml version="1.0" encoding="UTF-8"?>
<XLaunch WindowMode="MultiWindow" ClientMode="NoClient" LocalClient="False" Display="-1" LocalProgram="xcalc" RemoteProgram="xterm" RemotePassword="" PrivateKey="" RemoteHost="" RemoteUser="" XDMCPHost="" XDMCPBroadcast="False" XDMCPIndirect="False" Clipboard="True" ClipboardPrimary="False" ExtraParams="" Wgl="False" DisableAC="True" XDMCPTerminate="False"/>
```

**Note**: Windows Firewall rules might need to be created (**Inbound Rules**) for _VcXsrv_.<BR/>
**Note**: Pot. use https://community.chocolatey.org/packages/vcxsrv#files (includes Firewall Rules).<BR/>
**Note**: Pot. add shortcut to Windows autostart.

# Development

Switch repo _https_ remote to _ssh_:

```
cd ~/projects/int/nix-config
# current remote config
git remote -v

# set remote to ssh
git remote set-url origin git@github.com:rstauch/nix-config.git

# verify results
git remote -v
```

Edit with VSCode:

```
cd ~/projects/int/nix-config
code .
```

# TODO

- zsh config
- direnv
- intelliJ ultimate
- structure to include nix-darwin config (by hostname)
- not working: graalvm, google-chrome, postman (flatpak?)
- readme remote flake
- document shortcuts
- bat mouse wheel scrolling
