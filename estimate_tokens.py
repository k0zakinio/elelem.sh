#!/usr/bin/env python3

import sys
import re

def estimate_tokens(text):
    # This is a very rough estimation based on GPT tokenization guidelines
    # It's not exact, but should give a ballpark figure
    words = re.findall(r'\w+|[^\w\s]', text)
    return len(words)

if __name__ == "__main__":
    text = sys.stdin.read()
    token_count = estimate_tokens(text)
    print(token_count)
