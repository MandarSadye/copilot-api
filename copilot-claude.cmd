@echo off
REM ============================================================
REM  copilot-claude.cmd
REM  Opens Windows Terminal with two tabs running in parallel:
REM    Tab 1: copilot-api proxy server (Claude Code mode)
REM    Tab 2: Claude Code CLI
REM ============================================================

REM --- Edit these if your paths/commands change ---
set "CLAUDE_EXE=C:\Users\Mandar\.local\bin\claude.exe"
set "API_CMD=copilot-api start --claude-code"

REM --- Launch Windows Terminal ---
REM   start ""           : detach wt.exe from this cmd window
REM   wt.exe             : Windows Terminal
REM   new-tab --title X  : open a tab with title X
REM   --                 : end of wt options; everything after is the command to run
REM   pwsh -NoExit -Command "..."  : PowerShell 7, keep tab open after the command finishes
REM   \;                 : wt's tab separator (escaped so cmd passes it through)

wt -w 0 new-tab --title "coplot-api" cmd /k "copilot-api start --claude-code" `; new-tab --title "claude" cmd /k "C:\Users\Mandar\.local\bin\claude.exe"