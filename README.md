# elelem.sh - easily extract project files for LLM integration

`elelem.sh` is a Bash script that simplifies extracting relevant files from your project directory for use with Large Language Models (LLMs). It filters files by extension and search patterns, excluding common directories by default.

## Features

- **Selective Filtering:** Filter files by extension and search patterns.
- **Exclusion of Common Directories:** Skip build, dependency, and output folders.
- **Organized Output:** Generates a clipboard-ready summary of the copied files, including file names, paths, and estimated token count.
- **Token Estimation:** Provides an approximate token count for LLM resource management.

## Usage

1. **Run the Script:**
   ```bash
   elelem [--include pattern1] [--include pattern2] ... <extension1> [extension2] ...
   ```

   *   `--include pattern`: (Optional) Filter by patterns in filenames or paths (can be used multiple times).
   *   `extension`: Specify file extensions to include in the search.

**Example:**

```bash
elelem --include "README" --include "config" txt md py
```

This finds `txt`, `md`, and `py` files containing "README" or "config", excluding common build directories.

## Installation on macOS

1.  **Copy Files:**
    ```bash
    sudo cp elelem.sh estimate_tokens.py /usr/local/bin
    ```

2.  **Make Executable:**
    ```bash
    sudo chmod +x /usr/local/bin/elelem.sh /usr/local/bin/estimate_tokens.py
    ```

Now you can run `elelem` from any directory.

