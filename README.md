# CherryPicker 🍒

[![License: GPL v3](https://img.shields.io/badge/License-GPLv3-blue.svg)](LICENSE)
[![Build & Release](https://github.com/Wyroczen/CherryPicker/actions/workflows/build-and-release.yml/badge.svg)](https://github.com/Wyroczen/CherryPicker/actions/workflows/build-and-release.yml)
[![Website](https://img.shields.io/badge/Website-wyroczen.github.io%2FCherryPicker-rose.svg)](https://wyroczen.github.io/CherryPicker/)
[![Platform: macOS 13+](https://img.shields.io/badge/Platform-macOS%2013%2B-black?logo=apple)](https://github.com/Wyroczen/CherryPicker)
[![Swift: 5.9+](https://img.shields.io/badge/Swift-5.9%2B-orange?logo=swift)](https://swift.org)
[![Donate with PayPal](https://img.shields.io/badge/Donate-PayPal-00457C?logo=paypal&logoColor=white)](https://paypal.me/wyroczen)

An ultralight, native application launcher and window manager for macOS, built with **pure Swift / SwiftUI / AppKit** without any external dependencies.

[**🌐 Official Website**](https://wyroczen.github.io/CherryPicker/) · [**📦 Download Latest .dmg**](https://github.com/Wyroczen/CherryPicker/releases/latest) · [**☕ Support Development**](https://paypal.me/wyroczen)

---

## Features

### 1. Liquid Glass Aesthetic & Floating Architecture
- **macOS Liquid Glass Materials**: Translucent `NSVisualEffectView` background with a subtle 1px specular highlight gradient.
- **Organic Curvature**: Smooth edges on the main HUD panel with a 26px continuous squircle corner radius.
- **Full-Bleed Floating Glass Layout**: The search results list spans the full window height beneath floating translucent headers and footers, eliminating artificial divider lines.
- **Soft Entry Ramp**:
  - In the input field zone, a high-opacity blur ensures 100% search text legibility while content scrolling underneath fades out smoothly.
  - A gentle opacity ramp between the text field and list ensures items glide smoothly under the header.
- **Minimalist Action Bar**: A discreet floating glass footer showing current selection details and an interactive `↵ Open` keycap.

### 2. Dynamic Window Preview Icons
- Every window management action features a vector preview monitor tile (`WindowPreviewIcon`):
  - macOS accent gradient background (`#38bdf8` -> `#2563eb`).
  - Dark display matrix displaying an accurately positioned white window box corresponding to the exact screen coordinate fraction (`0.0 ... 1.0`).
  - Available across all 47 window geometries.

### 3. Native Window Management
- Instant resizing and positioning of the active application window supporting over 40 geometries:
  - **Halves**: `Left Half`, `Right Half`, `Top Half`, `Bottom Half`, `Center Half`.
  - **Thirds (1/3)**: `First Third`, `Center Third`, `Last Third`, `Top Third`, `Middle Third`, `Bottom Third`.
  - **Two Thirds (2/3)**: `First Two Thirds`, `Center Two Thirds`, `Last Two Thirds`, `Top Two Thirds`, `Bottom Two Thirds`, `Top/Bottom Center Two Thirds`.
  - **Quarters & Fourths (1/4 & 3/4)**: Corner quarters, vertical columns, horizontal bands, and 75% width/height layouts.
  - **Sixths (1/6)**: 3-column x 2-row grid (`Top/Bottom Left, Center, Right Sixth`).
  - **Maximize & Sizing**: `Maximize` (100%), `Almost Maximize` (90%), `Maximize Height`, `Maximize Width`, `Reasonable Size` (60%, max 1024x900), and `Center`.
- **Electron / Chromium Workaround**: Automatically disables `AXEnhancedUserInterface` temporarily during window positioning, preventing window resizing freezes in apps like Slack, Discord, and VS Code.
- **Coordinate Space Translation**: Precision conversion between Cocoa screen coordinates (`NSScreen.visibleFrame`, bottom-left origin) and Accessibility coordinates (top-left origin), respecting menu bar and Dock margins.
- **Three-Step Sequence**: Applies `Position -> Size -> Position` order to bypass WindowServer edge-snapping geometry restrictions.

### 4. Unified Search (Spotlight & Commands)
- **Window Commands in Search Results**: Window management actions appear directly in the search results list (labeled `Command`).
- Rich search alias matching (e.g. *"left"*, *"half"*, *"third"*, *"max"*, *"quarter"*).
- **CoreServices `MDQuery` Subsystem**: Synchronous `MDQueryCreate` query using predicate `kMDItemContentTypeTree == 'com.apple.application-bundle'`.
- Instant indexing (~2-5 ms response time) without slow filesystem scanning.
- Filters out internal `/System/Library/` helper daemons.
- Sorted by Most Recently Used (`kMDItemLastUsedDate` / MRU).
- Asynchronous real-time file searching in the background.

### 5. Floating HUD Panel
- Runs as an accessory process (`.accessory` / `LSUIElement = true`), eliminating clutter from the Dock and `Cmd+Tab` switcher.
- Configured via `NSPanel` with `.nonactivatingPanel`, `level = .floating`, and `.canJoinAllSpaces, .fullScreenAuxiliary`.
- **Focus History Tracking (`FrontmostAppTracker`)**: Seamlessly preserves and restores active target application focus before applying window actions.
- Global Hotkey: **`Option + Space`** (`⌥ + Space`) registered via Carbon `RegisterEventHotKey`.
- **Reopen & Activation Support**: Direct clicking the CherryPicker icon in `/Applications` or Launchpad toggles the HUD.
- **Keyboard Navigation**: `↑` / `↓` keys navigate results smoothly, `Enter` executes the selection, and `ESC` dismisses the HUD.

---

## Requirements

- macOS 13.0 (Ventura) or later
- Apple Silicon or Intel Mac
- **Accessibility** permissions in macOS

---

## Installation & Getting Started

### Option A: Pre-built DMG Installer (Recommended)
1. Download the latest `CherryPicker-*.dmg` from [**Releases**](https://github.com/Wyroczen/CherryPicker/releases/latest).
2. Open the `.dmg` file and drag **CherryPicker** into your **Applications** folder.
3. Launch CherryPicker from Applications or Launchpad.
4. When prompted, grant **Accessibility** permissions:
   - Go to `System Settings -> Privacy & Security -> Accessibility`.
   - Toggle **CherryPicker** to enabled.
5. Press **`Option + Space`** (`⌥ + Space`) anywhere in macOS to trigger the launcher HUD!

### Option B: Build from Source
1. Clone the repository:
   ```bash
   git clone https://github.com/Wyroczen/CherryPicker.git
   cd CherryPicker
   ```
2. Build and run via Swift Package Manager:
   ```bash
   swift run
   ```
3. Or build the release `.app` package and `.dmg` locally:
   ```bash
   ./scripts/build_dmg.sh 1.0.0 arm64
   ```

---

## Support & Donations

CherryPicker is free, independent, and open-source software under GNU GPLv3. If it improves your workflow and saves you time every day, you can support its ongoing development:

[![Donate with PayPal](https://img.shields.io/badge/Donate-PayPal-00457C?style=for-the-badge&logo=paypal&logoColor=white)](https://paypal.me/wyroczen)

---

## License

CherryPicker is licensed under the [GNU General Public License v3.0 (GPLv3)](LICENSE).

```text
Copyright (C) 2026 Bartosz Wiśniewski (Wyroczen)

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.
```
