# Set the path to ffmpeg.exe
$ffmpeg = "P:\scoop\apps\ffmpeg\current\bin\ffmpeg.exe"
$mkvextract = "P:\scoop\apps\mkvtoolnix\current\mkvextract.exe"
$mkvmerge = "P:\scoop\apps\mkvtoolnix\current\mkvmerge.exe"

$sourceFolder = Read-Host "Enter location of input directory"

$destinationFolder = Read-Host "Enter location of OUTPUT directory"

# choose framerate
do {
    $prefps = Read-Host "Choose a framerate (enter 1, 2, 3, or type in your own):
1. 23.976
2. 29.97
3. Custom"
} while (($prefps -notmatch '^[123]$') -and (-not $prefps.Trim()))

# If the user chose option 3, prompt them to enter a custom file naming format
if ($prefps -eq "3") {
    $custom = Read-Host "Enter a custom framerate"
}

#set fps

if ($prefps -eq "1") {
    $ffps = "0:23.976fps"
} elseif ($prefps -eq "2") {
    $fps = "0:29.97fps"
} else {
    $fps = ("0:" + $custom + "fps")
}

# go through folder and find video files

$files = Get-ChildItem -Path $sourceFolder -File

foreach ($file in $files) {
    $extension = $file.Extension

    if (($extension -eq ".mp4") -or ($extension -eq ".mkv") -or ($extension -eq ".webm")) {
        $videoPath = Join-Path $sourceFolder $file.Name
        $audioPath = Join-Path $sourceFolder ($file.BaseName + ".mka")
        $vidOutput = Join-Path $sourceFolder ($file.BaseName + "-v.mkv")
        $pureVidOutput = Join-Path $sourceFolder ($file.BaseName)
        $outputPath = Join-Path $destinationFolder ($file.BaseName + ".mkv")

        # Extract video
        & $ffmpeg -fflags +genpts -i $videoPath -c:v copy -an -sn -dn -y $vidOutput
        & $mkvextract $vidOutput tracks 0:$pureVidOutput

        # Extract audio
        & $ffmpeg -i $videoPath -vn -c:a copy -y $audioPath

        # Remux video and audio
        & $mkvmerge --ui-language en --priority lower --output $outputPath --language 0:und --default-duration $fps $pureVidOutput --language 0:en $audioPath --track-order 0:0,1:0

        # Delete temporary files
        Remove-Item $vidOutput
        Remove-Item $audioPath
        Remove-Item $pureVidOutput
    }
}

pause
