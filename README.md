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
| `elenchus-cli` | `elenchus`      | Command-line checker for `.vrf` programs.                      |
| `elenchus-mcp` | `elenchus-mcp`  | MCP stdio server exposing the checker to AI agents.           |

## CLI or MCP?

Both give an LLM the same elenchus output. **Install `elenchus-cli` unless you
have a specific reason to use the MCP server.** The CLI works in every harness
that supports shell commands (Claude Code, CI, terminal) with no extra
configuration — just call `elenchus`. The MCP server requires wiring up a
JSON-RPC stdio transport in your harness, which adds setup for no gain in output.

The **skill** in the [main repository](https://github.com/m62624/elenchus) is
adapted for both — it works identically whether the agent calls elenchus via CLI
or via the MCP tool.

## Install

First add the tap (once), then install whichever formula you need:

```bash
brew tap m62624/elenchus

# CLI — provides the `elenchus` command (recommended)
brew install m62624/elenchus/elenchus-cli

# MCP server — provides the `elenchus-mcp` command (for AI agents via MCP)
brew install m62624/elenchus/elenchus-mcp
```

Once the tap is added you can use the short names too: `brew install elenchus-cli`.

Verify and upgrade:

```bash
elenchus --version
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
