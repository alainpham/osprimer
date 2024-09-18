apt install build-essential fakeroot devscripts

apt install debhelper-compat m4 libgl-dev libgtk2.0-dev libjansson-dev libvdpau-dev libxext-dev libxv-dev libxxf86vm-dev pkg-config xserver-xorg-dev debhelper dh-dkms patchelf po-debconf quilt linux-headers-amd64

apt install nvidia-legacy-340xx-driver nvidia-settings-legacy-340xx

inspired from this gist : https://gist.github.com/Anakiev2/b828ed2972c04359d52a44e9e5cf2c63

## How to install nvidia-legacy-340xx-driver on Debian 12 Bookworm
This guide will show you how to download, compile and install the nvidia-legacy-340xx-driver on Debian 12. Some people install the driver directly from sid but this will mix packages from both stable and unstable which may create issues. It's recommended to update and upgrade your system before you start.

### Step 1. Download the source code. 
Install these packages.
```sh
sudo apt install build-essential fakeroot devscripts
```
<i>You can manually download the source code from debian.org and go to Step 2 or continue with Step 1. Don't worry you won't be able to install packages from sid.</i><br />
Add `'deb-src http://httpredir.debian.org/debian unstable main non-free contrib'` to `'/etc/apt/sources.list'`.<br />
Update your system.
```sh
sudo apt update
```
Create these folders.
```sh
mkdir -p Build/nvidia340 Build/nvidia-settings
```
Download the driver in `'Build/nvidia340'`.
```sh
apt source nvidia-legacy-340xx-driver
```
Download the nvidia-settings in `'Build/nvidia-settings'`.
```sh
apt source nvidia-settings-legacy-340xx
```
Delete `'deb-src http://httpredir.debian.org/debian unstable main non-free contrib'` from `'/etc/apt/sources.list'`.<br />
Update your system.
```sh
sudo apt update
```

### Step 2. Compile the driver.
Run
```sh
debuild -b -uc -us
```
in both folders `'Build/nvidia340/nvidia-graphics-drivers-legacy-340xx-340.108'` and `'Build/nvidia-settings/nvidia-settings-legacy-340xx-340.108'`.<br />
It will complain about missing build dependencies. Install them.
```sh
# Example
# sudo apt install debhelper-compat m4 libgl-dev libgtk2.0-dev libjansson-dev libvdpau-dev libxext-dev libxv-dev libxxf86vm-dev pkg-config xserver-xorg-dev debhelper dh-dkms patchelf po-debconf quilt linux-headers-amd64
```
Run again
```sh
debuild -b -uc -us
```
in both folders `'Build/nvidia340/nvidia-graphics-drivers-legacy-340xx-340.108'` and `'Build/nvidia-settings/nvidia-settings-legacy-340xx-340.108'` to compile the driver.


### Step 3. Make a local repository.
Make a new folder `'/nvidia'`.
```sh
sudo mkdir /nvidia
```
Copy all *.deb files from `'Build/nvidia340'` and `'Build/nvidia-settings'` inside `'/nvidia'`.
```sh
sudo cp *.deb /nvidia
```
Create `'Packages'`.
```sh
cd /nvidia
sudo sh -c 'dpkg-scanpackages . > Packages'
```
Add `'deb [trusted=yes] file:/nvidia ./'` to `'/etc/apt/sources.list'`.<br />
Enable `'contrib'` in your `'/etc/apt/sources.list'`.
```sh
# Example
# deb http://deb.debian.org/debian bookworm main non-free-firmware contrib
```

### Step 4. Install the driver.
<i>For each additional kernel you have to manually install the respective linux-headers.</i><br />
Update your system and install the driver.
```sh
sudo apt update
sudo apt install nvidia-legacy-340xx-driver nvidia-settings-legacy-340xx
# If the above line doesn't work try with
# sudo apt install --no-install-recommends --no-install-suggests nvidia-legacy-340xx-driver nvidia-settings-legacy-340xx libgles1-nvidia-legacy-340xx libgles2-nvidia-legacy-340xx
```
It's recommended to uninstall all other video drivers or at least nouveau.
```sh
sudo apt autoremove xserver-xorg-video-nouveau
```

### Step 5. Clean up. OPTIONAL.
I would definitely keep the source code because I might have to rebuild the driver in the future otherwise you can run.
```sh
rm -r Build/nvidia340 Build/nvidia-settings
rmdir Build
```
You can remove `'deb [trusted=yes] file:/nvidia ./'` from `'/etc/apt/sources.list'` and update your system.<br />
You can also delete `'/nvidia'` and all *.deb files.
```sh
sudo rm -r /nvidia
```

### Sources:
https://wiki.debian.org/SourcesList<br />
https://wiki.debian.org/BuildingTutorial<br />
https://wiki.debian.org/DebianRepository/Setup