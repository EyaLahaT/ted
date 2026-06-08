# Have you met Ted?

> *"Dude, lots of chicks think architects are hot. Think about it, you create something out of nothing. You're like God."*

Ted is a Claude Code agent that automatically maintains `ARCHITECTURE.md` for any project. On every git commit, he reads your source files, maps the components, draws a Mermaid diagram, and flags any gaps — just like Ted Mosby would, if Ted Mosby were a git hook.

---

## What Ted does

- Generates and maintains `ARCHITECTURE.md` at your repo root
- Embeds a Mermaid component diagram with live edges (topics, services, APIs, imports)
- Marks broken connections and mismatches in red — Ted has seen enough things fall apart to know a gap when he sees one
- Runs automatically on every `git commit` via a pre-commit hook
- Works on any project: ROS2, Node, Python, Go, Rust, you name it

---

## Installation

From inside any git repository:

```bash
curl -s https://raw.githubusercontent.com/EyaLahaT/ted/main/install.sh | bash
```

Or clone and run locally:

```bash
git clone https://github.com/EyaLahaT/ted.git
cd ted
bash install.sh
```

Then generate your first `ARCHITECTURE.md`:

```
/update-architecture
```

---

## How it works

Ted installs two things:

1. **`~/.claude/commands/update-architecture.md`** — a global Claude Code slash command. This is Ted. He reads your code, reasons about the architecture, and writes the document.

2. **`.git/hooks/pre-commit`** — a hook that calls Ted before every commit. The updated `ARCHITECTURE.md` is staged automatically and included in your commit.

### Update logic

```
commit triggered
  └─ only ARCHITECTURE.md staged?       → skip (loop guard)
  └─ ARCHITECTURE.md missing?           → full generation
  └─ any files deleted in this commit?  → full regeneration
  └─ otherwise                          → incremental update
       └─ find changed packages
       └─ re-read entire package
       └─ update anchored sections
       └─ rewrite Mermaid diagram
       └─ rewrite Gaps section
```

### Gap detection

Ted marks components involved in a mismatch with `classDef warning fill:#ff6b6b` in the Mermaid diagram, and explains each gap in prose below it. Because Ted knows what it feels like when things don't connect the way they should. Classic Schmosby

---

## Requirements

- [Claude Code](https://claude.ai/code) CLI installed and authenticated
- Git

---

*"This is going to be legen... wait for it... dary."*
