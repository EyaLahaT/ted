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

# ── 4. Configure permissions ─────────────────────────────────────────────────
echo "→ Configuring Claude Code permissions ..."

SETTINGS_DIR=".claude"
SETTINGS_FILE="$SETTINGS_DIR/settings.json"

TED_PERMS='["Read(*)", "Write(*ARCHITECTURE.md)", "Edit(*ARCHITECTURE.md)", "Bash(git diff*)", "Bash(git ls-files*)", "Bash(git add *ARCHITECTURE.md)"]'

mkdir -p "$SETTINGS_DIR"

SETTINGS_FILE="$SETTINGS_FILE" TED_PERMS="$TED_PERMS" python3 << 'PYEOF'
import json, os

settings_path = os.environ['SETTINGS_FILE']
ted_perms = json.loads(os.environ['TED_PERMS'])

if os.path.exists(settings_path):
    with open(settings_path) as f:
        settings = json.load(f)
else:
    settings = {}

perms = settings.setdefault('permissions', {})
allow = perms.setdefault('allow', [])

added = [p for p in ted_perms if p not in allow]
allow.extend(added)

with open(settings_path, 'w') as f:
    json.dump(settings, f, indent=2)
    f.write('\n')

if added:
    print(f"  Added: {', '.join(added)}")
else:
    print("  Already configured.")
PYEOF

echo "  ${GREEN}✓${RESET} .claude/settings.json updated."

# ── 5. Done ───────────────────────────────────────────────────────────────────
echo ""
echo "${BOLD}${GREEN}Teddy Westside is in the building.${RESET}"
echo ""
echo "  He will update ARCHITECTURE.md on every commit."
echo "  Run ${BOLD}/update-architecture${RESET} manually to generate it right now."
echo ""
echo "  This is going to be legen... wait for it..."
echo ""
