$ErrorActionPreference = "Continue"

. "$PSScriptRoot\common-winpython.ps1"

$Root = Get-MemilRoot
Set-Location $Root

function Show-Guide {
    Clear-Host
    Write-MemilTitle "WinPython Setup Guide"

    $PythonExe = Find-MemilWinPython

    if ($PythonExe) {
        Write-MemilOk "WinPython python.exe was found."
        Write-Host ""
        Write-Host $PythonExe
        Write-Host ""
        Write-Host "Python version:"
        & $PythonExe --version
        Write-Host ""
    } else {
        Show-MemilWinPythonHelp

        $WinPythonDir = Join-Path $Root "winpython"

        Write-MemilTitle "Files currently in winpython folder"

        if (Test-Path $WinPythonDir) {
            $items = Get-ChildItem -Path $WinPythonDir -ErrorAction SilentlyContinue

            if ($items.Count -eq 0) {
                Write-MemilWarn "winpython folder is empty."
            } else {
                foreach ($item in $items) {
                    Write-Host $item.Name
                }

                Write-Host ""
                $installerFiles = Get-ChildItem -Path $WinPythonDir -Filter "*.exe" -ErrorAction SilentlyContinue
                $zipFiles = Get-ChildItem -Path $WinPythonDir -Filter "*.zip" -ErrorAction SilentlyContinue

                if ($installerFiles.Count -gt 0 -or $zipFiles.Count -gt 0) {
                    Write-MemilWarn "Installer or zip file was found, but python.exe was not found."
                    Write-Host ""
                    Write-Host "This usually means WinPython has not been extracted yet."
                    Write-Host "Please run the .exe installer or extract the .zip file."
                    Write-Host ""
                }
            }
        } else {
            Write-MemilWarn "winpython folder does not exist."
        }
    }

    Write-MemilTitle "Menu"

    Write-Host "1. Open WinPython download page"
    Write-Host "2. Open winpython folder"
    Write-Host "3. Check again"
    Write-Host "0. Back"
    Write-Host ""
}

while ($true) {
    Show-Guide

    $choice = Read-Host "Select number"

    if ($choice -eq "0") {
        break
    } elseif ($choice -eq "1") {
        Start-Process "https://sourceforge.net/projects/winpython/files/WinPython_3.12/3.12.10.1/"
    } elseif ($choice -eq "2") {
        $WinPythonDir = Join-Path $Root "winpython"

        if (-not (Test-Path $WinPythonDir)) {
            New-Item -ItemType Directory -Path $WinPythonDir | Out-Null
        }

        Start-Process $WinPythonDir
    } elseif ($choice -eq "3") {
        continue
    } else {
        Write-Host "Invalid number."
        Read-Host "Press Enter to continue"
    }
}
