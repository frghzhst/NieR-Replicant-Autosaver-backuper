$script:lfile = "config-ndp.txt"
$script:flag1 = (Test-Path $script:lfile) ? $true : $false

function innit {
    param (
        [bool]$s1
    )
    if (-not $s1) { #file does not exists
        New-Item $lfile -ItemType File | Out-Null
        echo "target directory(save to)=$PSScriptRoot`n" >> $lfile
        #
    }
    $script:tpath = ""

    $ttpath = Get-Content $lfile 
    $tpath = $ttpath.Split('=')[1]
    if (-not (Test-Path -Path $tpath)) {
        Write-Host specified path in config does not exist, now creating
        New-Item -Path $tpath -ItemType Directory -Force
    }
}

Write-Host please ensure that this script is in the [drive]:\user\[username]\Doouments\My Games\Nier replicant\Steam\[some number] directory `(if not, press control c to exit from this program now and put it in the directory`)
innit $flag1

$date = (Get-Date).ToString("yyyy-MM-dd_hh-mm-ss")
$filename = "GAMEDATA_$date"
$savefile = Join-Path $tpath -ChildPath $filename
Copy-Item -Path GAMEDATA -Destination $savefile