#!/bin/bash

lineinfile() {
    local file_path="$1"   # First argument: file path
    local regex="$2"       # Second argument: regex to search for
    local new_line="$3"    # Third argument: new line to replace or add

    # Check if the file exists
    if [[ ! -f "$file_path" ]]; then
        echo "File not found!"
        return 1
    fi

    # Check if the line matching the regex exists in the file
    if grep -qE "$regex" "$file_path"; then
        # If found, replace the matching line
        sed -i "s/$regex/$new_line/" "$file_path"
        echo "Line matching '$regex' was replaced."
    else
        # If not found, append the new line at the end of the file
        echo "$new_line" >> "$file_path"
        echo "New line added : $new_line"
    fi
}
TARGET_USERNAME=apham
export DOCKER_BUILDX_VERSION=v0.16.2
export MAJOR_KUBE_VERSION=v1.29
# https://github.com/derailed/k9s/releases
export K9S_VERSION=v0.32.5
export MVN_VERSION=3.9.9
export DWM_VERSION=6.5
export ST_VERSION=0.9.2
export DMENU_VERSION=5.3
export KEYBOARD_LAYOUT=fr
export NERDFONTS="ComicShannsMono FiraMono JetBrainsMono"


lineinfile toto.txt ".*alias.*ll.*=.*" 'alias ll="ls -larth"'
lineinfile toto.txt ".*export.*ROOTFS*=.*" 'export ROOTFS=\/'
lineinfile toto.txt ".*export.*TARGET_USERNAME*=.*" "export TARGET_USERNAME=${TARGET_USERNAME}"
lineinfile toto.txt ".*export.*DOCKER_BUILDX_VERSION*=.*" "export DOCKER_BUILDX_VERSION=${DOCKER_BUILDX_VERSION}"
lineinfile toto.txt ".*export.*MAJOR_KUBE_VERSION*=.*" "export MAJOR_KUBE_VERSION=${MAJOR_KUBE_VERSION}"
lineinfile toto.txt ".*export.*K9S_VERSION*=.*" "export K9S_VERSION=${K9S_VERSION}"
lineinfile toto.txt ".*export.*MVN_VERSION*=.*" "export MVN_VERSION=${MVN_VERSION}"




sed -i '/GRUB_CMDLINE_LINUX_DEFAULT/ {/modprobe.blacklist=nouveau/! s/"$/ modprobe.blacklist=nouveau"/}' grub


testecho() {
    echo "Hello World ${MVN_VERSION}"
    export toto=tutu
}

testecho

echo $toto