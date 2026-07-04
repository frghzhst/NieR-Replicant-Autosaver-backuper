$script:lfile = "config-d.txt"
$script:flag1 = (Test-Path $script:lfile) ? $true : $false

function innit {
    param (
        [bool]$s1
    )
    if (-not $s1) { #file does not exists
        New-Item $lfile -ItemType File | Out-Null
        echo "target directory(save to)=$PSScriptRoot`n" >> $lfile
        echo "detection delay time(in seconds)=1200`n" >> $lfile
        #
    }
    $script:tpath = ""
    $script:dtime = 1200
    
    $config = @{}

    Get-Content $lfile | ForEach-Object {
        $key, $value = $_.Split('=', 2)
        $config[$key.Trim()] = $value.Trim()
    }

    $tpath = $config["target directory(save to)"]
    if (-not (Test-Path -Path $tpath)) {
        Write-Host specified path in config does not exist, now creating
        New-Item -Path $tpath -ItemType Directory -Force
    }
    $dtime = [int]$config["detection delay time"]
}

function save {
    $date = (Get-Date).ToString("yyyy-MM-dd_HH-mm-ss")
    $filename = "GAMEDATA_$date"
    $savefile = Join-Path $tpath -ChildPath $filename
    Copy-Item -Path GAMEDATA -Destination $savefile
}

function main {
    $pa_run = $null -ne (Get-Process -Name "NieR Replicant ver.1.22474487139" -ErrorAction SilentlyContinue)
	while (1) {
        $pr_run = Get-Process -Name "NieR Replicant ver.1.22474487139" -ErrorAction SilentlyContinue
        if ($pr_run -and -not $pa_run) { #is running now but not 20 minutes ago
            save
        }

        if (-not $pr_run -and $pa_run) { # was running 20 minutes ago but not now
            save
        }
		Start-Sleep -Seconds $dtime # checks every 20 minutes(default), feel free to change it in config file
        $pa_run = $pr_run
	}
    
}

Write-Host please ensure that this script is in the [drive]:\user\[username]\Doouments\My Games\Nier replicant\Steam\[some number] directory `(if not, press control c to exit from this program now and put it in the directory`)
innit $flag1
main
