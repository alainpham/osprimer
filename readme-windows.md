# Windows standard install

1. Run windows update

2. Check device manager and insall missing drivers 

3. Activate Admin user optional

```PS1
net user administrator /active:yes
net user administrator Password1!
```

autologin

```ps1
Get-ExecutionPolicy
 
Set-ExecutionPolicy RemoteSigned -Force
$Username = "apham"
$Pass = "Password1!"
$RegistryPath = 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon'
Set-ItemProperty $RegistryPath 'AutoAdminLogon' -Value "1" -Type String 
Set-ItemProperty $RegistryPath 'DefaultUsername' -Value "$Username" -type String 
Set-ItemProperty $RegistryPath 'DefaultPassword' -Value "$Pass" -type String
 
Write-Warning "Auto-Login for $username configured. Please restart computer."
 
$restart = Read-Host 'Do you want to restart your computer now for testing auto-logon? (Y/N)'
 
If ($restart -eq 'Y') {
 
    Restart-Computer -Force
 
}

```

3. Activation

```PS1
irm https://get.activated.win | iex
```
4. Rename computer & setup task bar remove all shinnanigans

```PS1

Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" `
    -Name TaskbarGlomLevel -Value 2

Rename-Computer -NewName "wind" -Force -Restart

```

5. Set folders to show extensions

```PS1
Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" `
    -Name HideFileExt -Value 0

Stop-Process -ProcessName explorer -Force
Start-Process explorer
```


1. Install winget for windows 10

```PS1
Invoke-WebRequest https://raw.githubusercontent.com/asheroto/winget-install/master/winget-install.ps1 -UseBasicParsing | iex
```


1. Install apps

```PS1
# win 10 only & ltsc
winget install --id Microsoft.WindowsTerminal -e --accept-source-agreements --accept-package-agreements --silent

# win 10/11

winget install --id=Google.Chrome -e --accept-source-agreements --accept-package-agreements --silent

winget install --id=Git.Git -e --accept-source-agreements --accept-package-agreements --silent
winget install --id=7zip.7zip  -e --accept-source-agreements --accept-package-agreements --silent

winget install --id=Microsoft.OpenJDK.17  -e --accept-source-agreements --accept-package-agreements --silent
winget install --id=Neovim.Neovim  -e --accept-source-agreements --accept-package-agreements --silent
winget install -e --id zyedidia.micro -e --accept-source-agreements --accept-package-agreements --silent

winget install --id AutoHotkey.AutoHotkey -e --accept-source-agreements --accept-package-agreements --silent

winget install --force Microsoft.VisualStudioCode --accept-source-agreements --accept-package-agreements --override '/VERYSILENT /SP- /MERGETASKS="runcode,desktopicon,addcontextmenufiles,addcontextmenufolders,associatewithfiles,addtopath"'

mkdir -p c:\temp
mkdir -p c:\apps

curl.exe -L https://dlcdn.apache.org/maven/maven-3/3.9.11/binaries/apache-maven-3.9.11-bin.zip -o c:\temp\maven.zip

cd c:\temp
& "C:\Program Files\7-Zip\7z.exe" x maven.zip
mv .\apache-maven* C:\apps\maven


$newPath = "C:\apps\maven\bin"
$currentPath = [Environment]::GetEnvironmentVariable("Path", [EnvironmentVariableTarget]::Machine)

# Avoid duplicates
if ($currentPath -notlike "*$newPath*") {
    $updatedPath = $currentPath + ";" + $newPath
    [Environment]::SetEnvironmentVariable("Path", $updatedPath, [EnvironmentVariableTarget]::Machine)
}


winget install --id=MoonlightGameStreamingProject.Moonlight -e --accept-source-agreements --accept-package-agreements --silent
winget install --id=Postman.Postman  -e --accept-source-agreements --accept-package-agreements --silent
winget install --id=VideoLAN.VLC  -e --accept-source-agreements --accept-package-agreements --silent
winget install --id=GIMP.GIMP.3  -e --accept-source-agreements --accept-package-agreements --silent
winget install --id WinSCP.WinSCP -e --accept-source-agreements --accept-package-agreements --silent
winget install --id=yt-dlp.yt-dlp  -e --accept-source-agreements --accept-package-agreements --silent
winget install --id=Inkscape.Inkscape  -e --accept-source-agreements --accept-package-agreements --silent
winget install --id=LibreHardwareMonitor.LibreHardwareMonitor  -e --accept-source-agreements --accept-package-agreements --silent

# with MSYS
winget install --id MSYS2.MSYS2 -e --accept-source-agreements --accept-package-agreements --silent

pacman -S mingw-w64-ucrt-x86_64-gcc mingw-w64-ucrt-x86_64-pkg-config mingw-w64-ucrt-x86_64-SDL2 git vim


# advanced workstation
winget install --id=OBSProject.OBSStudio  -e --accept-source-agreements --accept-package-agreements --silent
winget install --id=KDE.Kdenlive  -e --accept-source-agreements --accept-package-agreements --silent
winget install --id=Zoom.Zoom  -e --accept-source-agreements --accept-package-agreements --silent
winget install --id=Avidemux.Avidemux  -e --accept-source-agreements --accept-package-agreements --silent
winget install --id=Microsoft.WSL  -e --accept-source-agreements --accept-package-agreements --silent
winget install --id=Canonical.Ubuntu.2404  -e --accept-source-agreements --accept-package-agreements --silent
winget install --id=ONLYOFFICE.DesktopEditors  -e --accept-source-agreements --accept-package-agreements --silent
wsl --install --no-distribution


```



8. some setup

```PS1
reg.exe add "HKCU\Software\Classes\CLSID\{86ca1aa0-34aa-4e8b-a509-50c905bae2a2}\InprocServer32" /f /ve
```

Show seconds in clock windows 10

```PS1
Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "ShowSecondsInSystemClock" -Type DWord -Value 1

Set-ItemProperty -Path "HKCU:\Control Panel\International" `
    -Name "sShortDate" -Value "yyyy-MM-dd"

Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Search" `
    -Name "SearchboxTaskbarMode" -Value 0

Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" `
    -Name "ShowTaskViewButton" -Value 0 -Type DWord

Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" `
    -Name "TaskbarAl" -Value 0 -Type DWord

Stop-Process -Name explorer -Force

```


Also set manually time
- Keyboard and date formats a currency formats, number format digit grouping, metric
- Dark Theme
- Align task bar to the left, never combine icons
- Deactivate azure launcher & server manager

Taskbar pins
- file explorer
- chrome
- terminal
- moonlight
- vscode

configure moonlight
- Optimize Mouse FOr remote desktop
- Display mode windowed
- REsolution 1080@60fps
- turn off vsync
- Switch off mute host PC speakers



Msys in terminal
```json 
"defaultProfile": "{17da3cac-b318-431e-8a3e-7fcdefe6d114}",
"profiles": {
  "list":
  [
    // ...
    {
        "guid": "{17da3cac-b318-431e-8a3e-7fcdefe6d114}",
        "name": "UCRT64 / MSYS2",
        "commandline": "C:/msys64/msys2_shell.cmd -defterm -here -no-start -ucrt64",
        "startingDirectory": "C:/msys64/home/%USERNAME%",
        "icon": "C:/msys64/ucrt64.ico"
    }
    // ...
  ]
}
```

1. PS3 controller

https://github.com/nefarius/DsHidMini/releases/latest

-> insall bowth ini files

https://github.com/nefarius/BthPS3/releases/latest

10. Deactivate gamebar

```PS1
reg add HKCR\ms-gamebar /f /ve /d URL:ms-gamebar 2>&1 >''
reg add HKCR\ms-gamebar /f /v "URL Protocol" /d "" 2>&1 >''
reg add HKCR\ms-gamebar /f /v "NoOpenWith" /d "" 2>&1 >''
reg add HKCR\ms-gamebar\shell\open\command /f /ve /d "\`"$env:SystemRoot\System32\systray.exe\`"" 2>&1 >''
reg add HKCR\ms-gamebarservices /f /ve /d URL:ms-gamebarservices 2>&1 >''
reg add HKCR\ms-gamebarservices /f /v "URL Protocol" /d "" 2>&1 >''
reg add HKCR\ms-gamebarservices /f /v "NoOpenWith" /d "" 2>&1 >''
reg add HKCR\ms-gamebarservices\shell\open\command /f /ve /d "\`"$env:SystemRoot\System32\systray.exe\`"" 2>&1 >''
```



Emulation

pcsx2 bios:
https://emulation.gametechwiki.com/index.php/Emulator_files#PlayStation_2

optional 
https://www.nirsoft.net/utils/multimonitortool-x64.zip
multi mon tool

```PS1

$RETROARCH_VERSION="1.21.0"

cd c:\temp

curl.exe -LO "https://buildbot.libretro.com/stable/${RETROARCH_VERSION}/windows/x86_64/RetroArch.7z"

curl.exe -LO "https://buildbot.libretro.com/stable/${RETROARCH_VERSION}/windows/x86_64/RetroArch_cores.7z"

& "C:\Program Files\7-Zip\7z.exe" x RetroArch.7z
& "C:\Program Files\7-Zip\7z.exe" x RetroArch_cores.7z

curl.exe -L https://github.com/Abdess/retroarch_system/releases/download/v20220308/RetroArch_v1.10.1.zip -o bios.zip

& "C:\Program Files\7-Zip\7z.exe" x "bios.zip" "system\*" -o".\RetroArch-Win64\"
 
mkdir -p c:\apps
mv RetroArch-Win64 c:\apps\

curl.exe -L https://raw.githubusercontent.com/alainpham/debian-os-image/master/scripts/emulation/retroarch/retroarch.win.cfg -o C:\apps\RetroArch-Win64\retroarch.cfg

curl.exe -L "https://raw.githubusercontent.com/alainpham/debian-os-image/master/scripts/emulation/retroarch/autoconfig/xinput/Xbox%20360%20Wired%20Controller.cfg" -o "C:\apps\RetroArch-Win64\autoconfig\xinput\Xbox 360 Wired Controller.cfg"

$WshShell = New-Object -ComObject WScript.Shell
$Shortcut = $WshShell.CreateShortcut("C:\ProgramData\Microsoft\Windows\Start Menu\Programs\retroarch.lnk")
$Shortcut.TargetPath = "C:\apps\RetroArch-Win64\retroarch.exe"
$Shortcut.WorkingDirectory = "C:\apps\RetroArch-Win64\"
$Shortcut.Save()

#emu station
cd c:\temp
curl.exe -L https://gitlab.com/es-de/emulationstation-de/-/package_files/210673039/download -o estation.zip
& "C:\Program Files\7-Zip\7z.exe" x estation.zip
mv ES-DE c:\apps

$WshShell = New-Object -ComObject WScript.Shell
$Shortcut = $WshShell.CreateShortcut("C:\ProgramData\Microsoft\Windows\Start Menu\Programs\estation.lnk")
$Shortcut.TargetPath = "C:\apps\ES-DE\ES-DE.exe"
$Shortcut.WorkingDirectory = "C:\"
$Shortcut.Save()


# PCSX2
cd c:\temp
curl.exe -L https://github.com/PCSX2/pcsx2/releases/download/v2.4.0/pcsx2-v2.4.0-windows-x64-Qt.7z -o pcsx2.7z

& "C:\Program Files\7-Zip\7z.exe" x pcsx2.7z -opcsx2
mv pcsx2 c:\apps

$WshShell = New-Object -ComObject WScript.Shell
$Shortcut = $WshShell.CreateShortcut("C:\ProgramData\Microsoft\Windows\Start Menu\Programs\pcsx2.lnk")
$Shortcut.TargetPath = "C:\apps\pcsx2\pcsx2-qt.exe"
$Shortcut.WorkingDirectory = "C:\apps\pcsx2\"
$Shortcut.Save()

mkdir -p C:/Users/apham/Documents/PCSX2/bios
mkdir -p C:/Users/apham/Documents/PCSX2/inis

curl.exe -L https://github.com/archtaurus/RetroPieBIOS/raw/master/BIOS/pcsx2/bios/ps2-0230a-20080220.bin -o C:/Users/apham/Documents/PCSX2/bios/ps2-0230a-20080220.bin


curl.exe -L https://raw.githubusercontent.com/alainpham/debian-os-image/master/scripts/emulation/pcsx2/PCSX2-win.ini -o C:/Users/apham/Documents/PCSX2/inis/PCSX2.ini

# DOLPHIN
cd c:\temp
curl.exe -L https://dl.dolphin-emu.org/releases/2509/dolphin-2509-x64.7z -o dolphin.7z

& "C:\Program Files\7-Zip\7z.exe" x dolphin.7z
mv Dolphin-x64 c:\apps

$WshShell = New-Object -ComObject WScript.Shell
$Shortcut = $WshShell.CreateShortcut("C:\ProgramData\Microsoft\Windows\Start Menu\Programs\dolphin.lnk")
$Shortcut.TargetPath = "C:\apps\Dolphin-x64\Dolphin.exe"
$Shortcut.WorkingDirectory = "C:\apps\Dolphin-x64\"
$Shortcut.Save()


mkdir -p "C:\Users\apham\AppData\Roaming\Dolphin Emulator\Config"
curl.exe -L https://raw.githubusercontent.com/alainpham/debian-os-image/master/scripts/emulation/dolphin-emu/win/Dolphin.ini -o "C:/Users/apham/AppData/Roaming/Dolphin Emulator/Config/Dolphin.ini"
curl.exe -L https://raw.githubusercontent.com/alainpham/debian-os-image/master/scripts/emulation/dolphin-emu/GCPadNew.ini -o "C:/Users/apham/AppData/Roaming/Dolphin Emulator/Config/GCPadNew.ini"
curl.exe -L https://raw.githubusercontent.com/alainpham/debian-os-image/master/scripts/emulation/dolphin-emu/WiimoteNew.ini -o "C:/Users/apham/AppData/Roaming/Dolphin Emulator/Config/WiimoteNew.ini"
curl.exe -L https://raw.githubusercontent.com/alainpham/debian-os-image/master/scripts/emulation/dolphin-emu/GFX.ini -o "C:/Users/apham/AppData/Roaming/Dolphin Emulator/Config/GFX.ini"
curl.exe -L https://raw.githubusercontent.com/alainpham/debian-os-image/master/scripts/emulation/dolphin-emu/Hotkeys.ini -o "C:/Users/apham/AppData/Roaming/Dolphin Emulator/Config/Hotkeys.ini"


#cemu
cd c:\temp
curl.exe -L https://github.com/cemu-project/Cemu/releases/download/v2.6/cemu-2.6-windows-x64.zip -o cmu.zip
& "C:\Program Files\7-Zip\7z.exe" x cmu.zip
mv Cemu* c:/apps/cemu

$WshShell = New-Object -ComObject WScript.Shell
$Shortcut = $WshShell.CreateShortcut("C:\ProgramData\Microsoft\Windows\Start Menu\Programs\cemu.lnk")
$Shortcut.TargetPath = "C:\apps\cemu\Cemu.exe"
$Shortcut.WorkingDirectory = "C:\apps\cemu"
$Shortcut.Save()

mkdir -p "C:\Users\apham\AppData\Roaming\Cemu\controllerProfiles"
curl.exe -L https://raw.githubusercontent.com/alainpham/debian-os-image/master/scripts/emulation/cemu/settings-win.xml -o "C:/Users/apham/AppData/Roaming/Cemu/settings.xml"
curl.exe -L https://raw.githubusercontent.com/alainpham/debian-os-image/master/scripts/emulation/cemu/controllerProfiles/controller0.xml -o "C:/Users/apham/AppData/Roaming/Cemu/controllerProfiles/controller0.xml"

# PUT GSHORTS into startup

mkdir -p "C:\apps\gshorts"
curl.exe -L https://raw.githubusercontent.com/alainpham/debian-os-image/master/scripts/emulation/gshorts/gshorts.c -o "C:/apps/gshorts/gshorts.c"

curl.exe -L https://raw.githubusercontent.com/alainpham/debian-os-image/master/scripts/emulation/gshorts/gshorts.ahk -o "C:/apps/gshorts/gshorts.ahk"

#in msys
cd "C:\apps\gshorts"
rm gshorts.exe ; gcc gshorts.c -o gshorts.exe $(pkg-config --cflags --libs sdl2) -mconsole
cp "C:\msys64\ucrt64\bin\SDL2.dll" "C:\apps\gshorts\SDL2.dll"

$Action = New-ScheduledTaskAction -Execute "C:\apps\gshorts\gshorts.ahk"
$Trigger = New-ScheduledTaskTrigger -AtLogOn
Register-ScheduledTask -TaskName "gshorts" -Action $Action -Trigger $Trigger -Force
```