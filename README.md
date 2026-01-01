# Universal Utility
UniversalUtility is a modular Roblox utility hub designed to consolidate common quality-of-life features into a single, cohesive interface. The project emphasizes clean architecture, readability, and extensibility, allowing for straightforward maintenance and future expansion.

The system integrates multiple utility functions, including Anti-AFK mechanisms, automation tools, performance and network monitoring, automatic reconnection handling, and script execution capabilities.

## Features
User Interface UniversalUtility provides a modern, animated, and draggable interface built on a modular UI framework. Components are reusable and organized for scalability, with a configurable keybind to toggle the interface on demand.

Anti-AFK System Includes automated actions to prevent inactivity-based disconnections. Features include automatic jumping and mouse clicking, with support for clicking at the current cursor position, the center of the screen, or randomized positions. All actions support adjustable delay intervals.

Auto Key Spam Allows users to select custom keys for automated input. Spam intervals are configurable, and key validation is implemented to ensure safe and consistent behavior.

FPS and Network Monitoring Provides performance-related utilities such as FPS unlocking (executor-dependent) and real-time FPS tracking, including current, average, minimum, and maximum values. Network latency is estimated and displayed alongside a qualitative network stability rating.

Auto Rejoin Automatically attempts to rejoin the game following unexpected disconnections or kicks, minimizing downtime without user intervention.

Script Execution Includes a built-in script execution system using loadstring, with optional automatic saving of executed scripts for later reuse.

Persistent Configuration All user settings are saved locally and restored on subsequent loads, subject to executor support, ensuring a consistent experience across sessions.

### Project Structure
This repository contains the complete project structure for UniversalUtility, including the main entry point, core systems, user interface framework, and all feature modules. All required files and directories are organized to support full functionality and ease of development.

#### Permission and Usage Rights
You are permitted to copy, modify, and use the entire codebase freely. The project may be incorporated into other projects, used as a learning resource, or redistributed in modified form.

Attribution is not required. This project is provided as-is for personal and educational use, without warranty of any kind.
