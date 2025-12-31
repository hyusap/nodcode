---
description: Set up nodcode by installing bobble and verifying AirPods are configured correctly
---

# Nodcode Setup

Guide the user through setting up nodcode. Follow these steps:

## Step 1: Check if bobble is installed

Run `bobble --version` to check if bobble is installed.

**If bobble is NOT installed:**
- Check if Homebrew is available by running `which brew`
- If Homebrew exists, ask the user: "bobble is not installed. Would you like me to install it via Homebrew? This will run: `brew install hyusap/tap/bobble`"
- If they agree, run the installation and show the output
- If Homebrew doesn't exist, explain they need to install Homebrew first from https://brew.sh

**If bobble IS installed:**
- Show the version and proceed to step 2

## Step 2: Check AirPods availability

Run `bobble --check --verbose` to verify AirPods with motion tracking are connected.

**If AirPods are available:**
- Great! Proceed to step 3

**If AirPods are NOT available:**
- Explain they need AirPods Pro, AirPods Max, or Beats Fit Pro
- Mention they should connect them and make sure they're wearing them
- This step can be skipped for now - they can set up AirPods later

## Step 3: Test gesture detection (optional)

If AirPods are available, offer to do a quick test:
- Run `bobble --timeout 5 --sensitivity 0.5 --verbose` for a 5-second gesture test
- Ask them to nod or shake their head
- Show the results

## Final message

If everything is set up correctly, congratulate them and explain:
- nodcode is ready to use!
- When Claude asks for permission, they'll hear a voice prompt
- Nod to approve, shake to deny, or wait 15 seconds for normal UI
- The permission hook will automatically use bobble for all requests
