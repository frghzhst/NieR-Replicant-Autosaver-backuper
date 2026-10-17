$script:lfile = "config-nd.txt"
#$script:flag1 = (Test-Path $script:lfile) ? $true : $false
$script:flag1 = Test-Path $script:lfile

function innit {
    param (
        [bool]$s1
    )
    if (-not $s1) { #file does not exists
        New-Item $lfile -ItemType File | Out-Null
        echo "target directory(save to)=$PSScriptRoot" >> $lfile
        #
    }
    $script:tpath = ""

    $ttpath = Get-Content $lfile 
    $script:tpath = $ttpath.Split('=')[1]
    if (-not (Test-Path -Path $script:tpath)) {
        Write-Host specified path in config does not exist, now creating
        New-Item -Path $script:tpath -ItemType Directory -Force
    }
}

Write-Host please ensure that this script is in the [drive]:\user\[username]\Documents\My Games\Nier replicant\Steam\[some number] directory `(if not, press control c to exit from this program now and put it in the directory`)
pause
innit $flag1

$date = (Get-Date).ToString("yyyy-MM-dd_HH;mm;ss")
$filename = "GAMEDATA_$date"
$savefile = Join-Path $script:tpath -ChildPath $filename
$source = Join-Path $PSScriptRoot "GAMEDATA"
try {
    Copy-Item -Path $source -Destination $savefile -ErrorAction Stop
    Write-Host backed up at $date, at $savefile
} catch {
    Write-Host Failed to back up
    Write-Host "Error: $($_.Exception.Message)"
}
