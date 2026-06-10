#!/usr/bin/env bash
# gemini-bridge.sh — Wrapper for Gemini CLI to mimic Claude Code harness
# Supports hooks (Startup, Context Detection) and Memory sync

CWD="${PWD:-$HOME}"
PROJECT="general"

# 1. PRE-SESSION HOOKS (RAM Check)
if [ -f "$HOME/.claude/scripts/ram-check-startup.sh" ]; then
    bash "$HOME/.claude/scripts/ram-check-startup.sh" > /dev/null 2>&1
fi

# 2. CONTEXT DETECTION (Simulating SessionStart)
case "$CWD" in
    */Films/goldberg*|*goldberg-treatment*|*goldberg/*) PROJECT="goldberg" ;;
    */Films/virus*|*virus/*) PROJECT="virus" ;;
    */comptabilite*|*/compta*) PROJECT="compta" ;;
    */Projects/Dev/*) PROJECT="dev" ;;
esac

CONTEXT_PROMPT=""
case "$PROJECT" in
    goldberg) CONTEXT_PROMPT="PROJET: GOLDBERG. État: post-tournage. Règle: docs FR pure, JAMAIS tirets longs. Bible: ~/Projects/Films/goldberg/bible/." ;;
    virus)    CONTEXT_PROMPT="PROJET: VIRUS. Memory: 'virus-*'. Skills: /pitch." ;;
    compta)   CONTEXT_PROMPT="PROJET: COMPTABILITÉ. Cabinet: D'autant Plus. Règle: matching strict." ;;
    dev)      CONTEXT_PROMPT="PROJET: DEV. Workflow: /interview AVANT de coder. Règle: Verify results (signal frais)." ;;
esac

# 3. NOTIFY START
if [ -f "$HOME/.claude/scripts/notify.sh" ]; then
    bash "$HOME/.claude/scripts/notify.sh" "Gemini CLI session started ($PROJECT)" > /dev/null 2>&1
fi

# 4. RUN GEMINI CLI
# If arguments are passed, it's a direct command, else interactive
if [ $# -gt 0 ]; then
    # Inject context prompt for direct commands
    gemini "$CONTEXT_PROMPT $*"
else
    # Interactive mode (Gemini CLI will pick up context from GEMINI.md files)
    gemini
fi

# 5. POST-SESSION HOOKS
if [ -f "$HOME/.claude/scripts/notify-stop.sh" ]; then
    bash "$HOME/.claude/scripts/notify-stop.sh" "Gemini CLI session ended" > /dev/null 2>&1
fi
