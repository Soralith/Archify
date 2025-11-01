#!/bin/bash

DOWNLOAD_DIR="~/Music"
mkdir -p "$DOWNLOAD_DIR"

echo "Archify - Download music from Youtube with yt-dlp effortlessly."
echo "Press 'q' and Enter to exit."
music_downloader() {
    while true; do
        read -r -p "Enter music keyword: " SEARCH_TERM
        if [[ "$SEARCH_TERM" == "q" ]]; then
            echo "Exiting script. Goodbye! 👋"
            exit 0
        fi
        if [[ -z "$SEARCH_TERM" ]]; then
            continue
        fi

        echo "Searching 25 results for: '$SEARCH_TERM'..."

        RESULTS=$(yt-dlp --ignore-errors --flat-playlist --default-search "ytsearch25" "$SEARCH_TERM" \
            --print "%(duration_string)s | %(id)s | %(title)s" 2>/dev/null)

        if [[ -z "$RESULTS" ]]; then
            echo "❌ No results found for '$SEARCH_TERM'."
            continue
        fi

        SELECTED_LINES=$(echo "$RESULTS" | fzf \
            --multi \
            --reverse \
            --exit-0 \
            --prompt="Select Music: " \
            --header="Press TAB to select multiple, ESCAPE (or Ctrl-C) to return to search." \
            --delimiter=" | ")

        if [[ -z "$SELECTED_LINES" ]]; then
            echo "Returning to search mode. ↩️"
            continue
        fi

        echo "Processing download..."

        echo "$SELECTED_LINES" | while IFS=" | " read -r DURATION VIDEO_ID VIDEO_TITLE; do
            YOUTUBE_URL="https://www.youtube.com/watch?v=$VIDEO_ID"
            echo "--------------------------------------------------------"
            echo "🎧 Downloading: [$DURATION] $VIDEO_TITLE (with Cover Image)"
            yt-dlp -x --audio-format mp3 \
                --embed-thumbnail \
                --convert-thumbnails jpg \
                --output "%(title)s.%(ext)s" \
                -P "$DOWNLOAD_DIR" \
                "$YOUTUBE_URL"
            if [[ $? -eq 0 ]]; then
                echo "✅ Done: $VIDEO_TITLE (Cover Image OK)"
            else
                echo "❌ Failed to download: $VIDEO_TITLE"
            fi
        done

        echo "========================================================"
        echo "All downloads complete. Files are in $DOWNLOAD_DIR"
        echo "========================================================"
    done
}

# EXECUTEEEEEE
music_downloader
