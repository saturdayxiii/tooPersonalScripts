#This script uses yt-dlp.exe to download a youtube video or playlist in best quality.
#It will ask for the URL, the destination directory, then give options for the filename.

#just start by changing the next line to point to the location of your copy of yt-dlp.exe
$ytdlp = "P:\scoop\apps\yt-dlp\current\yt-dlp.exe"

# Prompt the user to enter the URL of the YouTube playlist they want to download
$playlistUrl = Read-Host "Enter the URL of the YouTube playlist you want to download"

# Prompt the user to choose the output directory for the downloaded files
$outputDirectory = Read-Host "Enter the path of the output directory for the downloaded files"

# Prompt the user to choose the file naming format for the downloaded files
do {
    $fileNamingFormat = Read-Host "Choose a file naming format (enter 1, 2, 3, or type in your own):
1. %(playlist_index)02d - %(title)s.%(ext)s
2. %(upload_date)s-%(title)s[%(id)s].%(ext)s
3. Custom format"
} while (($fileNamingFormat -notmatch '^[123]$') -and (-not $fileNamingFormat.Trim()))

# If the user chose option 3, prompt them to enter a custom file naming format
if ($fileNamingFormat -eq "3") {
    $customFormat = Read-Host "Enter a custom file naming format (use youtube-dl format specifiers)"
}

# Use youtube-dl to download the videos in the playlist in best video and audio quality,
# and name the downloaded files according to the chosen file naming format
# Add the video URL as a metadata tag labeled "url"
if ($fileNamingFormat -eq "1") {
    $format = "%(playlist_index)02d - %(title)s.%(ext)s"
} elseif ($fileNamingFormat -eq "2") {
    $format = "%(upload_date)s-%(title)s[%(id)s].%(ext)s"
} else {
    $format = $customFormat
}
& $ytdlp $playlistUrl -f bestvideo+bestaudio --output "$outputDirectory\$format" --write-subs --add-metadata --metadata-from-title "%(url)s"
