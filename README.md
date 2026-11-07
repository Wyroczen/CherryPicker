# CherryPicker 🍒

A lightweight macOS window management and Spotlight-like application & file launcher.

## Overview
CherryPicker focuses on fast, essential desktop productivity:
- **Window Management**: Instant tiling, resizing, and positioning of active application windows (halves, quarters, maximize, centering) using native macOS Accessibility APIs.
- **Application & File Search**: Sub-millisecond application discovery and file search powered directly by Apple's CoreServices `MDQuery` engine.
- **Floating HUD**: Floating, non-activating panel (`NSPanel`) that appears across all macOS Spaces without cluttering the Dock or `Cmd+Tab`.

## Architecture
- **Language**: Swift / SwiftUI / AppKit
- **System APIs**:
  - `ApplicationServices` (`AXUIElement`) for window control
  - `CoreServices` (`MDQuery`) for Spotlight metadata search
  - `Carbon` (`HIToolbox`) for system-wide global hotkeys
