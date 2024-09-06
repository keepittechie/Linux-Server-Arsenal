#!/usr/bin/env bash

# gen_article.sh
# A script to generate an article using the Ollama API.

# Usage: ./gen_article.sh <transcription_output_file>

# Check if a file was provided as an argument
if [ -z "$1" ]; then
    echo "Usage: ./gen_article.sh <transcription_output_file>"
    exit 1
fi

TRANSCRIPTION_FILE=$1

# Ensure the transcription file exists
if [ ! -f "$TRANSCRIPTION_FILE" ]; then
    echo "File not found: $TRANSCRIPTION_FILE"
    exit 1
fi

# Set the Ollama API URL (replace with your cloud server's IP if running remotely)
OLLAMA_API_URL="http://127.0.0.1:11434/api/generate"

# Read the transcription file content
TRANSCRIPTION_CONTENT=$(<"$TRANSCRIPTION_FILE")

# Make a POST request to the Ollama API to generate the article
echo "Processing $TRANSCRIPTION_FILE..."
OLLAMA_RESPONSE=$(curl -s -X POST $OLLAMA_API_URL \
    -H "Content-Type: application/json" \
    -d '{
          "model": "openchat",
          "prompt": "'"$TRANSCRIPTION_CONTENT"'",
          "stream": false
        }')

# Check if the API call was successful
if echo "$OLLAMA_RESPONSE" | jq -e .response > /dev/null 2>&1; then
    ARTICLE=$(echo "$OLLAMA_RESPONSE" | jq -r .response)

    # Save the generated article to a new file
    OUTPUT_FILE="${TRANSCRIPTION_FILE%.txt}_article.txt"
    echo "$ARTICLE" > "$OUTPUT_FILE"
    echo "Article successfully generated and saved to $OUTPUT_FILE"
else
    echo "Failed to generate article for $TRANSCRIPTION_FILE"
    echo "Ollama API response: $OLLAMA_RESPONSE"
fi

echo "Article generation process completed."
