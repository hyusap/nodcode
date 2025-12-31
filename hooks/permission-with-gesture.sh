#!/bin/bash

# PermissionRequest hook for nodcode plugin
# Uses bobble (installed via Homebrew) to get yes/no responses via AirPods head gestures
# 
# Requirements:
#   - bobble installed: brew install hyusap/tap/bobble
#   - AirPods Pro/Max or Beats Fit Pro
#   - macOS 14.0+

set -e

# Path to bobble executable (installed via Homebrew)
BOBBLE="bobble"

# Check if bobble is installed
if ! command -v bobble &> /dev/null; then
    say "please install bobble. run slash nod code colon setup to do so."
    echo "Error: bobble not found. Install it with: brew install hyusap/tap/bobble" >&2
    exit 1
fi

# Read JSON input from stdin
INPUT=$(cat)

# Parse tool name and input
TOOL_NAME=$(echo "$INPUT" | python3 -c "import sys, json; print(json.load(sys.stdin).get('tool_name', ''))" 2>&1)
TOOL_INPUT=$(echo "$INPUT" | python3 -c "import sys, json; print(json.dumps(json.load(sys.stdin).get('tool_input', {})))" 2>&1)

# Check if headphone motion is available before proceeding
# If not available, immediately fall back to normal permission flow
if ! "$BOBBLE" --check 2>/dev/null; then
    exit 1
fi

# Create a descriptive permission message based on the tool
PERMISSION_MESSAGE="Claude wants to use $TOOL_NAME."

# Add context based on tool type
case "$TOOL_NAME" in
    "Bash")
        COMMAND=$(echo "$TOOL_INPUT" | python3 -c "import sys, json; print(json.load(sys.stdin).get('command', ''))" 2>/dev/null || echo "")
        if [ -n "$COMMAND" ]; then
            # Truncate long commands for voice readability
            COMMAND_SHORT=$(echo "$COMMAND" | head -c 80)
            if [ ${#COMMAND} -gt 80 ]; then
                COMMAND_SHORT="${COMMAND_SHORT}..."
            fi
            PERMISSION_MESSAGE="Claude wants to run: $COMMAND_SHORT"
        fi
        ;;
    "Write"|"Edit")
        FILE_PATH=$(echo "$TOOL_INPUT" | python3 -c "import sys, json; print(json.load(sys.stdin).get('filePath', json.load(sys.stdin).get('file_path', '')))" 2>/dev/null || echo "")
        if [ -n "$FILE_PATH" ]; then
            FILENAME=$(basename "$FILE_PATH")
            PERMISSION_MESSAGE="Claude wants to $TOOL_NAME $FILENAME."
        fi
        ;;
    "Task")
        PERMISSION_MESSAGE="Claude wants to start a subtask."
        ;;
esac

# Speak the permission request using system default voice
say "$PERMISSION_MESSAGE Nod for yes, shake for no."


# Use bobble to get response
"$BOBBLE" --timeout 15 --sensitivity 0.5
GESTURE_EXIT=$?

# Process the gesture response
case $GESTURE_EXIT in
    0)
        # Nod detected - approve
        OUTPUT=$(cat <<EOF
{
  "hookSpecificOutput": {
    "hookEventName": "PermissionRequest",
    "decision": {
      "behavior": "allow"
    }
  },
  "suppressOutput": true,
  "systemMessage": "✓ Approved via head nod"
}
EOF
)
        echo "$OUTPUT"
        exit 0
        ;;
    1)
        # Shake detected - deny
        OUTPUT=$(cat <<EOF
{
  "hookSpecificOutput": {
    "hookEventName": "PermissionRequest",
    "decision": {
      "behavior": "deny",
      "message": "User denied via head shake gesture",
      "interrupt": false
    }
  },
  "systemMessage": "✗ Denied via head shake"
}
EOF
)
        echo "$OUTPUT"
        exit 0
        ;;
    2)
        # Timeout - fall back to normal UI prompt
        echo "No gesture detected within 15 seconds" >&2
        exit 1
        ;;
    3)
        # Error - fall back to normal permission flow
        echo "Headphones not available - falling back to normal permission flow" >&2
        exit 1
        ;;
esac
