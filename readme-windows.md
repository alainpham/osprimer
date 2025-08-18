
setup task bar remove all shinnanigans

install chrome set as default. 

login to bitwarden in chrome

run windows update

set folders to show extensions

check device manager and insall missing drivers after 

update has completed

rename computer

install https://openhardwaremonitor.org/
uninstall useless stuff



install winget from store on windows 10
https://github.com/microsoft/winget-cli/releases

browse apps here
https://winstall.app/

win 10 only 
winget install -e --id Microsoft.WindowsTerminal

win 11

winget install --id=Git.Git  -e
winget install --id=Neovim.Neovim  -e
winget install --id=OBSProject.OBSStudio  -e
winget install --id=KDE.Kdenlive  -e
winget install --id=Microsoft.OpenJDK.17  -e
winget install --id=Zoom.Zoom  -e
winget install --id=7zip.7zip  -e
winget install --id=GIMP.GIMP.3  -e
winget install --id=VideoLAN.VLC  -e
winget install --id=Avidemux.Avidemux  -e
winget install --id=Iterate.Cyberduck  -e
winget install --id=yt-dlp.yt-dlp  -e
winget install --id=LibreHardwareMonitor.LibreHardwareMonitor  -e
winget install --id=Microsoft.WSL  -e
winget install --id=Canonical.Ubuntu.2404  -e
winget install --id=ONLYOFFICE.DesktopEditors  -e
winget install --id=Inkscape.Inkscape  -e
winget install --id=MoonlightGameStreamingProject.Moonlight  -e

install vscode from website & sync with account 

win 11 old context menu
reg.exe add "HKCU\Software\Classes\CLSID\{86ca1aa0-34aa-4e8b-a509-50c905bae2a2}\InprocServer32" /f /ve


PS3 controller
https://github.com/nefarius/DsHidMini/releases/latest
https://github.com/nefarius/BthPS3/releases/latest

reg add HKCR\ms-gamebar /f /ve /d URL:ms-gamebar 2>&1 >''
reg add HKCR\ms-gamebar /f /v "URL Protocol" /d "" 2>&1 >''
reg add HKCR\ms-gamebar /f /v "NoOpenWith" /d "" 2>&1 >''
reg add HKCR\ms-gamebar\shell\open\command /f /ve /d "\`"$env:SystemRoot\System32\systray.exe\`"" 2>&1 >''
reg add HKCR\ms-gamebarservices /f /ve /d URL:ms-gamebarservices 2>&1 >''
reg add HKCR\ms-gamebarservices /f /v "URL Protocol" /d "" 2>&1 >''
reg add HKCR\ms-gamebarservices /f /v "NoOpenWith" /d "" 2>&1 >''
reg add HKCR\ms-gamebarservices\shell\open\command /f /ve /d "\`"$env:SystemRoot\System32\systray.exe\`"" 2>&1 >''

Retroarch
https://buildbot.libretro.com/stable/1.21.0/windows/x86_64/

https://buildbot.libretro.com/stable/1.21.0/windows/x86_64/RetroArch.7z
https://buildbot.libretro.com/stable/1.21.0/windows/x86_64/RetroArch_cores.7z

pcsx2 bios:
https://emulation.gametechwiki.com/index.php/Emulator_files#PlayStation_2

optional 
https://www.nirsoft.net/utils/multimonitortool-x64.zip
multi mon tool


installing scripts to rip record


wget -O /mnt/c/recordings/wconv-ripcapt.bat https://raw.githubusercontent.com/alainpham/de
bian-os-image/refs/heads/master/scripts/ffmpeg/wconv-ripcapt.bat

