#!/bin/bash

# Function to clean up input and handle spaces/newlines
cleanup_input() {
    echo "$1" | tr -s ' ' | tr '\n' ' ' | sed 's/ \{2,\}/ /g'
}

# Function to handle API response cleanup
cleanup_response() {
    echo "$1" | sed 's/\\n/\n/g' | sed 's/\s\+/ /g'
}

# Function to generate markdown content
generate_markdown() {
    local cleaned_content
    cleaned_content=$(cleanup_input "$1")

    echo "Generating markdown..."

    # Send cleaned content to API for title, description, keywords, article content, etc.
    title=$(curl -s -X POST http://localhost:11434/api/generate -d "{\"model\":\"openchat\",\"prompt\":\"Generate a catchy title for: $cleaned_content\",\"stream\":false}" | jq -r '.response')
    description=$(curl -s -X POST http://localhost:11434/api/generate -d "{\"model\":\"openchat\",\"prompt\":\"Generate a short description for: $cleaned_content\",\"stream\":false}" | jq -r '.response')
    keywords=$(curl -s -X POST http://localhost:11434/api/generate -d "{\"model\":\"openchat\",\"prompt\":\"Generate SEO keywords for: $cleaned_content\",\"stream\":false}" | jq -r '.response')
    toc=$(curl -s -X POST http://localhost:11434/api/generate -d "{\"model\":\"openchat\",\"prompt\":\"Generate a table of contents for: $cleaned_content\",\"stream\":false}" | jq -r '.response')

    # Expanded content generation using Ollama (generate article based on the topic)
    article=$(curl -s -X POST http://localhost:11434/api/generate -d "{\"model\":\"openchat\",\"prompt\":\"Write a detailed article on: $cleaned_content. Include relevant links throughout the article for key concepts and related topics.\",\"stream\":false}" | jq -r '.response')

    # Error handling for API responses
    if [ -z "$title" ] || [ -z "$description" ] || [ -z "$keywords" ] || [ -z "$toc" ] || [ -z "$article" ]; then
        echo "Error: Failed to generate some parts of the markdown content. Please check your API or content."
        exit 1
    fi

    # Clean up API responses
    title=$(cleanup_response "$title")
    description=$(cleanup_response "$description")
    keywords=$(cleanup_response "$keywords")
    toc=$(cleanup_response "$toc")
    article=$(cleanup_response "$article")

    # Create markdown file with expanded article content
    echo "Creating markdown file: ${output_file}"
    cat <<EOL > ${output_file}
# ${title}

## Description
${description}

## Keywords
${keywords}

## Table of Contents
${toc}

## Article Content
${article}

## Related Articles
* [Related Article 1](https://yourwebsite.com/related-article-1)
* [Related Article 2](https://yourwebsite.com/related-article-2)
EOL

    echo "Article generation completed. The output file is located at ${output_file}."
}

# Check if input file is provided
if [ -z "$1" ]; then
    echo "Usage: $0 <transcription_output_file>"
    exit 1
fi

input_file="$1"
output_file="${input_file%.*}.md"

# Check if the input file exists
if [ ! -f "$input_file" ]; then
    echo "Error: Input file $input_file does not exist."
    exit 1
fi

# Read content from the input file
content=$(cat "$input_file")

# Generate markdown with cleaned content and expanded article
generate_markdown "$content"
