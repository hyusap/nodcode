# Testing nodcode Plugin

Quick guide for testing the nodcode plugin locally.

## Prerequisites

1. **Install bobble** (if not already installed):
   ```bash
   brew install hyusap/tap/bobble
   ```

2. **Verify bobble is working**:
   ```bash
   bobble --version
   bobble --check --verbose
   ```

## Testing the Plugin

### 1. Load the plugin

Start Claude Code with the plugin loaded:

```bash
claude --plugin-dir /Users/ayush/dev/nodcode
```

### 2. Test the check command

Once Claude Code starts, run:

```bash
/nodcode:check
```

This should verify that:
- bobble is installed
- Your AirPods are available (if connected)
- The plugin is loaded correctly

### 3. Test the permission hook

Trigger a permission request by asking Claude to run a command:

```bash
# In the Claude Code chat
Please run: ls -la
```

Expected behavior:
1. If AirPods are connected and worn:
   - You'll hear the permission request spoken
   - Nod your head to approve
   - You should see "✓ Approved via head nod"

2. If AirPods are not connected:
   - Normal permission UI appears (graceful fallback)

### 4. Test different permission scenarios

Try different tools to verify hook works correctly:

- **Bash**: `Please run: echo "test"`
- **Write**: `Please create a file called test.txt`
- **Edit**: `Please edit README.md and add a line`
- **Task**: `Please analyze this codebase`

### 5. Test gesture detection

With AirPods connected:
- **Nod test**: Trigger permission, nod head → Should approve
- **Shake test**: Trigger permission, shake head → Should deny
- **Timeout test**: Trigger permission, don't move → Should fall back to UI after 15s

## Debugging

### Enable verbose output

Add debug logging to the hook by editing `hooks/permission-with-gesture.sh`:

```bash
# Uncomment debug lines (remove leading #)
# echo "[DEBUG] Hook started" >&2
# echo "[DEBUG] Tool name: $TOOL_NAME" >&2
```

Then check stderr output when running Claude Code.

### Test hook directly

You can test the permission hook script directly:

```bash
echo '{"tool_name": "Bash", "tool_input": {"command": "ls"}}' | /Users/ayush/dev/nodcode/hooks/permission-with-gesture.sh
```

Expected output (with AirPods connected):
- Voice speaks the permission request
- Wait for gesture
- Returns JSON with decision

### Common issues

1. **"bobble not found"**
   - Solution: Install bobble with Homebrew

2. **"Headphone motion not available"**
   - Solution: Connect and wear your AirPods Pro/Max or Beats Fit Pro

3. **No voice output**
   - Solution: Check macOS sound settings, ensure `say` command works:
     ```bash
     say "test"
     ```

4. **Hook not triggering**
   - Solution: Verify hook is registered:
     ```bash
     cat /Users/ayush/dev/nodcode/hooks/hooks.json
     ```

## Expected File Permissions

The hook script must be executable:

```bash
ls -l /Users/ayush/dev/nodcode/hooks/permission-with-gesture.sh
# Should show: -rwxr-xr-x (executable)
```

If not executable:
```bash
chmod +x /Users/ayush/dev/nodcode/hooks/permission-with-gesture.sh
```
