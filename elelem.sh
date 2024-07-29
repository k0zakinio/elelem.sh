#!/bin/bash

# Excluded directories
excluded_dirs=(build node_modules out)

# Function to print usage
print_usage() {
    echo "Usage: $0 [--include pattern1] [--include pattern2] ... <extension1> [extension2] ..."
    echo "  --include pattern: Pattern to match in filenames or paths (can be used multiple times)"
    echo "  extension: File extension to search for"
}

# Check if at least one argument is provided
if [ $# -eq 0 ]; then
    print_usage
    exit 1
fi

# Parse arguments
include_patterns=()
extensions=()
while [[ $# -gt 0 ]]; do
    case $1 in
        --include)
            if [[ -z "$2" || "$2" == --* ]]; then
                echo "Error: --include requires a pattern"
                exit 1
            fi
            include_patterns+=("$2")
            shift 2
            ;;
        *)
            extensions+=("$1")
            shift
            ;;
    esac
done

# Function to format file content
format_file_content() {
    local file="$1"
    echo "File: $file"
    echo "----------------------------------------"
    cat "$file"
    echo -e "\n----------------------------------------\n"
}

# Prepare patterns
include_pattern=$(IFS='|'; echo "${include_patterns[*]}")
extension_conditions=()
for ext in "${extensions[@]}"; do
    extension_conditions+=(-o -iname "\"*.$ext\"")
done

# Remove the first "-o" from the array
extension_conditions=("${extension_conditions[@]:1}")

# Build exclude conditions dynamically
exclude_conditions=()
for dir in "${excluded_dirs[@]}"; do
    exclude_conditions+=(-o -name "$dir")
done
exclude_conditions=("${exclude_conditions[@]:1}")  # Remove initial "-o"

# Debug information
echo "Debug: Current working directory: $(pwd)" >&2
echo "Debug: Include patterns: ${include_patterns[@]}" >&2
echo "Debug: File extensions: ${extensions[@]}" >&2
echo "Debug: Include pattern: $include_pattern" >&2
echo "Debug: Extension conditions: ${extension_conditions[@]}" >&2

# Main logic
matched_files=()
clipboard_content=""

find_command="find . -type d \( ${exclude_conditions[@]} \) -prune -o -type f \( ${extension_conditions[@]} \)"
if [[ ${#include_patterns[@]} -gt 0 ]]; then
    find_command+=" | grep -iE \"$include_pattern\""
fi

echo "Debug: Executing find command: $find_command" >&2
while IFS= read -r file; do
    matched_files+=("$file")
    clipboard_content+=$(format_file_content "$file")
done < <(eval "$find_command" | sort -u)

# Copy to clipboard
echo "$clipboard_content" | pbcopy

# Estimate token count 
script_dir=$(dirname "$0")
token_count=$(echo "$clipboard_content" | "$script_dir/estimate_tokens.py")

# Output results
echo "Files copied to clipboard:"
printf '%s\n' "${matched_files[@]}"
echo "---"
echo "Total files copied: ${#matched_files[@]}"
echo "Estimated token count: $token_count"
echo "File contents have been copied to clipboard."
