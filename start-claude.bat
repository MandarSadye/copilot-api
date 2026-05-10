@echo off
echo ================================================
echo GitHub Copilot API Server for Claude Code
echo ================================================
echo.

cd /d "G:\Applications\AgentsConfig\copilot-api"

if not exist node_modules (
    echo Installing dependencies...
    bun install
    echo.
)

echo Starting server...
echo.

bun run ./src/main.ts start -c --claude-code-model claude-opus-4.7 --claude-code-small-model claude-opus-4.6

pause
