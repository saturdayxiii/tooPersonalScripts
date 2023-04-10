# Set the path to ffmpeg.exe
$ffmpeg = "P:\scoop\apps\ffmpeg\current\bin\ffmpeg.exe"

# Set the input directory containing the mkv, mp4, or webm files
$inputDirectory = Read-Host "Enter location of input directory"

# Set the output directory for the mka files
$outputDirectory = Read-Host "Enter location of OUTPUT directory"

# Loop through each file in the input directory
Get-ChildItem -Path $inputDirectory -Include *.mkv, *.mp4, *.webm -Recurse | ForEach-Object {
    
    # Set the input file path
    $inputFile = $_.FullName
    
    # Set the output file path with the same name as the input file but with .mka extension
    $outputFile = Join-Path $outputDirectory "$($_.BaseName).mka"
    
    # Use ffmpeg to extract the first audio track and save as mka while preserving metadata
    & $ffmpeg -i $inputFile -map 0:a:0 -c:a copy -metadata:s:a:0 handler_name="Extracted by PowerShell" $outputFile
    
    # Print the output file path
    Write-Output "Extracted $($inputFile) to $($outputFile)"
}
# pause
