# homebrew-elenchus

A [Homebrew](https://brew.sh) **tap** (third-party package repository) for
[elenchus](https://github.com/m62624/elenchus). It ships prebuilt binaries for
macOS and Linux, updated automatically by elenchus's release pipeline — you do
not build from source.

> This repo only contains packaging. The source code, docs and issue tracker
> live in the [main elenchus repository](https://github.com/m62624/elenchus).

## What's in the tap

| Formula        | Installs binary | Purpose                                                        |
| -------------- | --------------- | ------------------------------------------------------------- |
| `elenchus-cli` | `elenchus-cli`  | Command-line checker for `.vrf` programs.                      |
| `elenchus-mcp` | `elenchus-mcp`  | MCP stdio server exposing the checker to AI agents.           |

## CLI or MCP — which one?

Both let an LLM run elenchus; the output is the same either way. The difference
is setup cost:

- **CLI (`elenchus-cli`)** — `elenchus-cli <file>` or `elenchus-cli --text "…"` from
  the shell. Works in every harness that can run shell commands (Claude Code, any
  CI pipeline, terminal). **Recommended: it needs no extra configuration, so if your
  harness can run shell commands, use the CLI.**
- **MCP server (`elenchus-mcp`)** — speaks stdio JSON-RPC. Worth the extra setup only
  when your harness natively supports MCP and you'd rather not (or can't) run a
  shell. Same output, more to configure.

The **skill** in the [main repository](https://github.com/m62624/elenchus) is
adapted for both — it works identically whether the agent calls `elenchus-cli`
via the CLI or via the MCP tool.

## Install

First add the tap (once), then install whichever formula you need:

```bash
brew tap m62624/elenchus

# CLI — provides the `elenchus-cli` command (recommended)
brew install m62624/elenchus/elenchus-cli

# MCP server — provides the `elenchus-mcp` command
brew install m62624/elenchus/elenchus-mcp
```

Once the tap is added you can use the short names too: `brew install elenchus-cli`.

Verify and upgrade:

```bash
elenchus-cli --version
brew upgrade m62624/elenchus/elenchus-cli
```

Uninstall / remove the tap:

```bash
brew uninstall elenchus-cli elenchus-mcp
brew untap m62624/elenchus
```

Supported platforms: macOS (Apple Silicon & Intel) and Linux (arm64 & x86_64).

## What is elenchus?

A small SAT engine with three-valued logic (TRUE / FALSE / UNKNOWN). It checks
LLM-generated premises for logical **consistency** — not truth, but
contradictions. Built for small local models. Beta.

See the [main repository](https://github.com/m62624/elenchus) for the language
spec, usage and the Claude Code skill.

## License

MIT — see the formula files and the [main repository](https://github.com/m62624/elenchus).
