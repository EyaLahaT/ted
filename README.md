# Have you met Ted?

> *"Dude, lots of chicks think architects are hot. Think about it, you create something out of nothing. You're like God."*

Ted is a Claude Code agent that automatically maintains `ARCHITECTURE.md` for any project. On every git commit, he reads your source files, maps the components, draws a Mermaid diagram, and flags any gaps — just like Ted Mosby would, if Ted Mosby were a git hook.

---

## What Ted does

- Generates and maintains `ARCHITECTURE.md` at your repo root
- Embeds a Mermaid component diagram with labelled edges showing exactly what crosses each connection
- Marks broken connections with red stop signs — Ted has seen enough things fall apart to know a gap when he sees one
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

### Diagram modes

Ted picks the right diagram based on your project structure:

| Project type | Diagram granularity |
|---|---|
| Multiple packages / modules | One node per package |
| Single package | One node per source file |

Ted detects this automatically by counting package-defining files (`package.json`, `go.mod`, `Cargo.toml`, etc.). If none are found, he falls back to top-level directories.

### Diagram visual language

| Shape | Meaning |
|---|---|
| Rectangle `["Label"]` | Component (package or file) |
| Stadium `(["type: description"])` | Message, request, or data crossing an edge |
| Red hexagon `{{"✕"}}` | Gap — a dependency with no provider |

**Edge labels** follow a consistent format based on interaction type:

| Interaction | Format | Example |
|---|---|---|
| HTTP / REST | `HTTP METHOD /path` | `HTTP POST /login` |
| Event / pub-sub | `event: Name` | `event: UserCreated` |
| Function call | `call: name(args)` | `call: getUser(id)` |
| Database query | `query: description` | `query: find user` |
| Queue message | `msg: topic` | `msg: order.placed` |
| File I/O | `reads: file` / `writes: file` | `reads: config.json` |
| TCP/IP | `TCP: host:port` | `TCP: db:5432` |
| Generic | `sends:` / `requests:` / `receives:` | `sends: payload` |


### Update logic

```
commit triggered
  └─ only ARCHITECTURE.md staged?            → skip (loop guard)
  └─ ARCHITECTURE.md missing?                → full generation
  └─ package-defining file deleted?          → full generation
  └─ otherwise                               → incremental update
       └─ find changed packages/files
       └─ re-read via git ls-files
       └─ update anchored sections
       └─ rewrite Mermaid diagram
       └─ rewrite Gaps section
```

Ted only reads files tracked by git — anything in `.gitignore` is ignored automatically.

### Gap detection

When a component depends on something that doesn't exist, Ted draws a red dashed arrow to a red hexagon stop sign and explains the gap in prose below the diagram. Because Ted knows what it feels like when things don't connect the way they should. Classic Schmosby

---

## Requirements

- [Claude Code](https://claude.ai/code) CLI installed and authenticated
- Git

---

*"This is going to be legen... wait for it... dary."*
