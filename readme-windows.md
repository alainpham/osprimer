# Windows standard install

1. Run windows update

2. Check device manager and insall missing drivers 

3. Activation

```PS1
irm https://get.activated.win | iex
```
4. Rename computer & setup task bar remove all shinnanigans

```PS1

Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" `
    -Name TaskbarGlomLevel -Value 2

Rename-Computer -NewName "winx" -Force -Restart

```

5. Set folders to show extensions

```PS1
Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" `
    -Name HideFileExt -Value 0

Stop-Process -ProcessName explorer -Force
Start-Process explorer
```

6. Install winget

```PS1
Set-ExecutionPolicy Unrestricted

Write-Host "Attempting to download and install dependencies"

# check xaml dependency first in winget repo: src/PowerShell/Microsoft.WinGet.Client.Engine/Helpers/AppxModuleHelper.cs
# Download and install VCLibs package

try 
{
  Add-AppxPackage "https://aka.ms/Microsoft.VCLibs.x64.14.00.Desktop.appx" -Verbose
}
catch
{
  Write-Host "Failed to install VCLibs package. Error: $_" -ForegroundColor Red
  exit 1
}

# Download XAML package
try 
{
  $ProgressPreference = 'SilentlyContinue'
  Invoke-WebRequest -Uri "https://www.nuget.org/api/v2/package/Microsoft.UI.Xaml/2.8.6" -OutFile "microsoft.ui.xaml.2.8.6.zip" -ErrorAction Stop
}
catch
{
  Write-Host "Failed to download XAML package. Error: $_" -ForegroundColor Red
  exit 1
}

# Extract XAML package
try 
{
  Expand-Archive .\microsoft.ui.xaml.2.8.6.zip -Force -ErrorAction Stop
} 
catch
{
  Write-Host "Failed to extract XAML package. Error: $_" -ForegroundColor Red
  exit 1
}

# Install XAML package
try
{
  Add-AppPackage .\microsoft.ui.xaml.2.8.6\tools\AppX\x64\Release\Microsoft.UI.Xaml.2.8.appx -Verbose
}
catch 
{
  Write-Host "Failed to install XAML package. Error: $_" -ForegroundColor Red
  exit 1
}

Write-Host "Dependencies installed successfully."

Write-Host "Attempting to download and install Winget"

# Download Winget package
# https://github.com/microsoft/winget-cli/releases/latest
try 
{  
  $ProgressPreference = 'SilentlyContinue'
  Invoke-WebRequest -Uri "https://github.com/microsoft/winget-cli/releases/download/v1.11.430/Microsoft.DesktopAppInstaller_8wekyb3d8bbwe.msixbundle" -OutFile ".\winget.msixbundle" -ErrorAction Stop
  Invoke-WebRequest -Uri "https://github.com/microsoft/winget-cli/releases/download/v1.11.430/e53e159d00e04f729cc2180cffd1c02e_License1.xml" -OutFile ".\winget_license.xml" -ErrorAction Stop
} 
catch 
{
  Write-Host "Failed to download Winget package. Error: $_" -ForegroundColor Red
  exit 1
}

# Install Winget package
try 
{
  Add-AppxProvisionedPackage -Online -PackagePath "winget.msixbundle" -LicensePath "winget_license.xml" -Verbose
} 
catch 
{
  Write-Host "Failed to install Winget package. Error: $_" -ForegroundColor Red
  exit 1
}

Write-Host "Winget installed successfully."
```

7. Install apps

```PS1
# win 10 only
winget install -e --id Microsoft.WindowsTerminal

# win 10/11
winget install --id=Google.Chrome  -e
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
winget install --id=Postman.Postman  -e

wsl --install --no-distribution

winget install --force Microsoft.VisualStudioCode --override '/VERYSILENT /SP- /MERGETASKS="runcode,desktopicon,addcontextmenufiles,addcontextmenufolders,associatewithfiles,addtopath"'
```

8. win 11 old context menu

```PS1
reg.exe add "HKCU\Software\Classes\CLSID\{86ca1aa0-34aa-4e8b-a509-50c905bae2a2}\InprocServer32" /f /ve
```

9. PS3 controller

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

Show seconds in clock windows 10

```PS1
Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "ShowSecondsInSystemClock" -Type DWord -Value 1
```

Emulation
v
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
 
mkdir -p c:\apps\RetroArch-Win64
mv RetroArch-Win64 c:\apps

```