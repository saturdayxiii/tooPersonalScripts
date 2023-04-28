# Set the path to ffmpeg.exe
$ffmpeg = "P:\scoop\apps\ffmpeg\current\bin\ffmpeg.exe"

# Set the input
$inAudio = Read-Host "Enter location\filename.ext of input audio"

# Set the output
$output = Read-Host "Enter location\filename.mp4 for outputvideo"

# doit
& $ffmpeg -f lavfi -i color=c=black:s=1920x1080:r=5 -i $inAudio -crf 0 -c:a copy -shortest $output -pix_fmt yuv420p

 #pause
