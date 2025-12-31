---
description: Check if bobble is installed and AirPods are available for gesture detection
---

# Nodcode Installation Check

Please run the following checks and report the results to the user:

1. **Check if bobble is installed**: Run `bobble --version` to verify bobble is installed via Homebrew
2. **Check AirPods availability**: Run `bobble --check --verbose` to check if AirPods with motion tracking are connected
3. **Test gesture detection**: Run `bobble --timeout 5 --sensitivity 0.5 --verbose` to do a quick 5-second test

For each step, show the command output and explain what it means.

If bobble is not installed, tell the user to install it with:
```
brew install hyusap/tap/bobble
```

If AirPods are not available, explain that they need AirPods Pro, AirPods Max, or Beats Fit Pro connected and worn.

If everything is working, congratulate them and explain that nodcode will now use head gestures for permission requests!
