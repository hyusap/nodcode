# nodcode

> Hands-free yes/no interactions for Claude Code using AirPods head gestures

**nodcode** is a Claude Code plugin that enables gesture-based permission requests. When Claude asks for permission to run commands, edit files, or perform tasks, you can simply nod (yes) or shake (no) your head instead of clicking buttons.

Perfect for:
- Hands-free coding sessions
- When your hands are on the keyboard and you don't want to reach for the mouse
- Accessibility scenarios
- Looking cool while pair programming 😎

## Demo

When Claude Code asks for permission, nodcode:
1. ✅ Checks if your AirPods are connected
2. 🔊 Speaks the permission request using your Mac's voice
3. 👂 Listens for your head gesture (15 seconds)
4. ✓ Approves on nod, denies on shake
5. 🔄 Falls back to normal UI if no gesture detected

## Requirements

- **macOS**: 14.0 or later
- **Claude Code**: 1.0.33 or later
- **bobble**: The head gesture detection CLI ([install instructions](#installation))
- **AirPods**: AirPods Pro, AirPods Max, or Beats Fit Pro

## Installation

### Step 1: Install bobble

nodcode requires [bobble](https://github.com/hyusap/bobble), a CLI tool for detecting head gestures:

```bash
brew install hyusap/tap/bobble
```

Verify the installation:

```bash
bobble --version
```

### Step 2: Install nodcode plugin

**Option A: From a marketplace** (recommended when available)

If nodcode is published to a Claude Code plugin marketplace:

```bash
# In Claude Code
/plugin install nodcode
```

**Option B: Local installation** (for development/testing)

Clone this repository and load it with `--plugin-dir`:

```bash
git clone https://github.com/hyusap/nodcode.git
claude --plugin-dir ./nodcode
```

### Step 3: Verify setup

Once installed, run the check command in Claude Code:

```bash
/nodcode:check
```

This will verify that:
- bobble is installed
- Your AirPods are connected and available
- Gesture detection is working

## Usage

Once installed, nodcode automatically handles permission requests:

1. **Put on your AirPods** (Pro, Max, or Beats Fit Pro)
2. **Start Claude Code** with the plugin enabled
3. **When Claude asks for permission**:
   - You'll hear the request spoken aloud
   - **Nod your head** to approve (✓)
   - **Shake your head** to deny (✗)
   - **Do nothing** for 15 seconds to see the normal permission UI

### Slash Commands

- `/nodcode:check` - Check if bobble is installed and AirPods are available

## How It Works

nodcode is a Claude Code [PermissionRequest hook](https://code.claude.com/docs/hooks) that integrates with bobble:

1. **Hook triggers** when Claude needs permission for a tool (Bash, Write, Edit, Task, etc.)
2. **Availability check** - Uses `bobble --check` to verify AirPods are connected (8ms)
3. **Voice prompt** - Speaks the request using macOS `say` command
4. **Gesture detection** - Runs `bobble --timeout 15 --sensitivity 0.5`
5. **Response** - Returns JSON decision to Claude Code based on gesture

### Exit codes from bobble

- `0` - Nod detected → Permission granted
- `1` - Shake detected → Permission denied
- `2` - Timeout → Fall back to UI
- `3` - Error/No AirPods → Fall back to UI

### Gesture Thresholds

The default sensitivity (0.5) uses these thresholds:
- **Nod**: ~6° to ~19° pitch movement
- **Shake**: ~13° to ~33° yaw movement

## Configuration

### Customizing sensitivity

To adjust gesture sensitivity, modify the `--sensitivity` flag in `hooks/permission-with-gesture.sh`:

```bash
"$BOBBLE" --timeout 15 --sensitivity 0.5  # Default
# Lower = more sensitive (0.1-0.4)
# Higher = less sensitive (0.6-1.0)
```

### Customizing timeout

Change the `--timeout` value (in seconds):

```bash
"$BOBBLE" --timeout 15  # Default: 15 seconds
```

## Troubleshooting

### "bobble not found"

Install bobble:
```bash
brew install hyusap/tap/bobble
```

### "Headphone motion not available"

- Ensure your AirPods Pro/Max or Beats Fit Pro are connected
- Make sure you're wearing them (motion detection only works when worn)
- Try disconnecting and reconnecting your AirPods

### "No gesture detected within 15 seconds"

- Make more pronounced head movements
- Try lowering the sensitivity in the hook configuration
- Ensure your AirPods fit snugly

### Permission UI still shows up

This is expected behavior! If:
- AirPods aren't available
- No gesture is detected within 15 seconds
- bobble encounters an error

nodcode gracefully falls back to the normal Claude Code permission UI.

## Development

### Project Structure

```
nodcode/
├── .claude-plugin/
│   └── plugin.json           # Plugin manifest
├── hooks/
│   ├── hooks.json           # Hook configuration
│   └── permission-with-gesture.sh  # Permission hook script
├── commands/
│   └── check.md             # /nodcode:check command
├── README.md
└── LICENSE
```

### Testing Locally

```bash
# Load the plugin in Claude Code
claude --plugin-dir /path/to/nodcode

# Run the check command
/nodcode:check

# Trigger a permission request to test the hook
/bash ls
```

### Building a Marketplace

To distribute nodcode via a Claude Code marketplace, see [Create and distribute a plugin marketplace](https://code.claude.com/docs/plugin-marketplaces).

## Related Projects

- [bobble](https://github.com/hyusap/bobble) - The underlying head gesture detection CLI
- [Claude Code](https://code.claude.com/) - AI coding assistant

## License

MIT License - see [LICENSE](LICENSE) for details

## Author

Created by [@hyusap](https://github.com/hyusap)

## Contributing

Issues and pull requests welcome! Please check the [issue tracker](https://github.com/hyusap/nodcode/issues).
