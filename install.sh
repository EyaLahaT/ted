#!/bin/bash
# ─────────────────────────────────────────────────────────────────────────────
#  Have you met Ted?
#  Ted Mosby is an architect. So is this.
#
#  Installs Ted into your current git repository and sets up the global
#  slash command so he can maintain ARCHITECTURE.md on every commit.
# ─────────────────────────────────────────────────────────────────────────────

set -e

BOLD=$(tput bold 2>/dev/null || echo "")
RESET=$(tput sgr0 2>/dev/null || echo "")
GREEN=$(tput setaf 2 2>/dev/null || echo "")
RED=$(tput setaf 1 2>/dev/null || echo "")
YELLOW=$(tput setaf 3 2>/dev/null || echo "")

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
COMMANDS_DIR="$HOME/.claude/commands"
HOOK_PATH=".git/hooks/pre-commit"

echo ""
echo "${BOLD}Have you met Ted?${RESET}"
echo "Ted Mosby is an architect. So is this."
echo ""

# ── 1. Verify git repo ────────────────────────────────────────────────────────
if ! git rev-parse --git-dir > /dev/null 2>&1; then
  echo "${RED}Error:${RESET} Not a git repository."
  echo "Run this script from inside a git repo. Ted needs somewhere to live."
  exit 1
fi

# ── 2. Install the slash command ──────────────────────────────────────────────
echo "→ Installing Ted's slash command to $COMMANDS_DIR ..."

mkdir -p "$COMMANDS_DIR"
cp "$SCRIPT_DIR/update-architecture.md" "$COMMANDS_DIR/update-architecture.md"

echo "  ${GREEN}✓${RESET} /update-architecture is ready."

# ── 3. Install the pre-commit hook ────────────────────────────────────────────
echo "→ Wiring up the pre-commit hook ..."

if [ -f "$HOOK_PATH" ]; then
  echo ""
  echo "${YELLOW}Warning:${RESET} A pre-commit hook already exists at $HOOK_PATH."
  read -p "  Overwrite it? [y/N] " confirm
  if [[ ! "$confirm" =~ ^[Yy]$ ]]; then
    echo "  Skipped. Add this line to your existing hook manually:"
    echo ""
    echo '    claude -p "/update-architecture"'
    echo ""
  else
    write_hook=true
  fi
else
  write_hook=true
fi

if [ "$write_hook" = true ]; then
  cat > "$HOOK_PATH" << 'EOF'
#!/bin/bash
# Ted — Architecture Agent pre-commit hook
# Maintains ARCHITECTURE.md automatically on every commit.
# "Ted Mosby is an architect. So is this."

claude -p "/update-architecture"
EOF
  chmod +x "$HOOK_PATH"
  echo "  ${GREEN}✓${RESET} Pre-commit hook installed."
fi

# ── 4. Done ───────────────────────────────────────────────────────────────────
echo ""
echo "${BOLD}${GREEN}Ted is in the building.${RESET}"
echo ""
echo "  He will update ARCHITECTURE.md on every commit."
echo "  Run ${BOLD}/update-architecture${RESET} manually to generate it right now."
echo ""
echo "  This is going to be legen... wait for it..."
echo ""
