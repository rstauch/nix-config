# WSL2 NixOS Dotfiles

## Setup WSL Distro

Download _nixos-wsl.tar.gz_ from: https://github.com/nix-community/NixOS-WSL/releases (tested with version _23.5.5.2_).

```
# remove existing WSL distro if required
# wsl --unregister NixOS

# import NixOs-WSL distro
wsl --import NixOS D:\code\wsl\NixOS\ D:\code\wsl\nixos-wsl.tar.gz --version 2

# start distro
wsl -d NixOS

# setup nixos 23.05 channel
sudo nix-channel --add https://nixos.org/channels/nixos-23.05 nixos
sudo nix-channel --update

# clone repo to tmp
git clone https://github.com/rstauch/nix-config.git /tmp/configuration

sudo nixos-rebuild switch --flake /tmp/configuration

# Reconnect to WSL shell
exit # (wsl)
wsl -t NixOS
wsl -d NixOS

# move the configuration to the new home directory
mkdir -p ~/projects/int
mv /tmp/configuration ~/projects/int
```

<BR/>
<BR/>

## Mount .ssh folder from Windows

Only needs to be performed once:

```
WINDOWS_USER=$(/mnt/c/Windows/System32/WindowsPowerShell/v1.0/powershell.exe '$env:UserName')
ln -s /mnt/c/Users/$WINDOWS_USER/.ssh ~
chmod 600 ~/.ssh/id_rsa

# test connection
ssh -T git@github.com
```

<BR/>
<BR/>

## Setup VcXsrv on Windows

Download and install VcXsrv on Windows https://sourceforge.net/projects/vcxsrv/files/latest/download

Create shortcut: `"C:\Program Files\VcXsrv\xlaunch.exe" -run "C:\code\config.xlaunch"`

**config.xlaunch**:

```xml
<?xml version="1.0" encoding="UTF-8"?>
<XLaunch WindowMode="MultiWindow" ClientMode="NoClient" LocalClient="False" Display="-1" LocalProgram="xcalc" RemoteProgram="xterm" RemotePassword="" PrivateKey="" RemoteHost="" RemoteUser="" XDMCPHost="" XDMCPBroadcast="False" XDMCPIndirect="False" Clipboard="True" ClipboardPrimary="False" ExtraParams="" Wgl="False" DisableAC="True" XDMCPTerminate="False"/>
```

**Note**: Windows Firewall rules might need to be created (**Inbound Rules**) for _VcXsrv_.
**Note:** Pot. use https://community.chocolatey.org/packages/vcxsrv#files (includes Firewall Rules)

<BR/>
<BR/>

## Development

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
