# Changelog

All notable changes to nodcode will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.0.0] - 2025-12-30

### Added
- Initial release of nodcode plugin
- PermissionRequest hook integration with bobble
- Voice prompts using macOS `say` command
- Gesture detection (nod for yes, shake for no)
- Graceful fallback to normal UI when AirPods unavailable
- `/nodcode:check` slash command for installation verification
- Context-aware permission messages for different tools (Bash, Write, Edit, Task)
- 15-second timeout with automatic fallback
- Default sensitivity of 0.5 for reliable gesture detection

### Requirements
- macOS 14.0 or later
- Claude Code 1.0.33 or later
- bobble 1.0.0 or later (`brew install hyusap/tap/bobble`)
- AirPods Pro, AirPods Max, or Beats Fit Pro

[1.0.0]: https://github.com/hyusap/nodcode/releases/tag/v1.0.0
