# Lua Moon Phase Calculator

This script calculates the current moon phase based on the Gregorian date. It
uses Lua's built-in date and time functions.

### Getting Started

1. Clone the repository or download the script.
2. Run the script using a Lua interpreter (e.g., `lua main2.lua`).
3. The script supports CLI flags:

- `--date YYYY-MM-DD` : specify a date
- `--json` : output JSON
- `--verbose` : print extra info

Examples:

```sh
lua main2.lua --date 2026-07-27
lua main2.lua 2000 1 6 --json
lua main2.lua --verbose
```

Running tests:

```sh
lua tests/test_moon.lua
```