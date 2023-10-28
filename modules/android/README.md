# Capture Android App Network Traffic

Bypass SSL pinning using frida and objection

Taken from: https://www.youtube.com/watch?v=qaJBWcueCIA&ab_channel=CorSecure and https://www.youtube.com/watch?v=xp8ufidc514&ab_channel=IppSec

Simplified if Google Credentials can be provided, in order to access Google Play Store and install the required apps

## Setup Genymotion (Windows)

Create and start new virtual device **Google Pixel 3 XL** (default options)

- a restart of the PC after the first start of the application might be required for everything to work as intended

## Connect with ADB (NixOs)

```
adb devices -l

# find out genymotion ip
# displayed at the top of the virtual device window

adb connect 192.168.17.103:5555
adb devices -l

```

## Run Charles (Windows)

### Export root certificate

open _Help -> SSL Proxying -> Save Charles Root Certificate..._ to download pem file.

Find out hash of \*.pem file:
`x509 -inform PEM -subject_hash_old -in test.pem`

Rename \*.pem file:<BR>
`mv test.pem 8faf5620.0`

Transfer root certicate to emulated device<BR>
`adb push 8faf5620.0 /system/etc/security/cacerts/`

---

if the previous command fails:

```
adb shell; su;
mount -o remount,rw /
exit
```

Run previous command again:<BR>
`adb push 8faf5620.0 /system/etc/security/cacerts/`

---

Stop and restart emulated Android device, then check _Setttings->Security->Encryption&Credentials->Trusted credentials_ for System CA certificate "XK72.ltd"
(identified via `openssl x509 -inform PEM -subject -in 8faf5620.0`)

### Setup Proxy on Android

`ip addr` or "Help->SSL Proxying->Install Charles on a Mobile Device or Remote Browser"

`adb shell settings put global http_proxy 172.26.224.1:8888`

unset proxy with: `adb shell settings put global http_proxy :0`

### Install GApps

To speed things up, its best to unset proxy beforehand.<BR>
Click _Restart_ after installation.

login in to the Playstore
install target app from playstore

## Install Frida (NixOs)

download correct frida-server version from https://github.com/frida/frida/releases

```
wget https://github.com/frida/frida/releases/download/16.0.19/frida-server-16.0.19-android-x86_64.xz
unxz frida-server-16.0.19-android-x86_64.xz
mv frida-server-16.0.19-android-x86_64 frida-server

adb push frida-server /data/local/tmp/
adb shell; su;

# commands in shell
chmod 755 /data/local/tmp/frida-server

# exit shell
exit

# commands in nixos
adb shell "su -c setenforce 0"
adb shell "su -c /data/local/tmp/frida-server &"

# nixos
# verify frida works as intended
frida-ps -U

# installed apps
frida-ps -Uai

# running apps
frida-ps -Ua

# install objection

## does not work
# nix-shell -p python311Packages.pip
# nix-shell -p 'nixos.python39.withPackages (p: with p; [ requests ])'
# pip3 install objection

```

## Install Objection (NixOs)

see https://nixos.wiki/wiki/Python (Package unavailable in Nixpkgs)
examples for shell.nix see: https://github.com/search?q=fetchPypi+lang%3ANix+path%3Ashell.nix&type=code

### Komplexe Installation umgehen

```
# add python3 to home.nix
cd /some/test/dir
python -m venv .venv
source .venv/bin/activate
pip install -r requirements.txt
```

```
adb connect 192.168.17.103:5555
adb devices -l
frida-ps -Ua

adb shell "su -c /data/local/tmp/frida-server &"

objection --gadget com.android.quicksearchbox explore
android sslpinning disable
exit
```
