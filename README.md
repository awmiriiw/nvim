# Neovim Config

A lightweight, modular Neovim configuration built with Lua, Lazy.nvim, the built-in LSP client, Tree-sitter, and Mason. It provides code completion, formatting, diagnostics, file navigation, and an integrated terminal.

## Overview

This configuration is designed for a modern editing workflow, including:

- Lazy.nvim plugin management and automatic bootstrap
- Language servers managed through Mason
- Tree-sitter syntax highlighting and indentation
- LSP-based code navigation, diagnostics, and code actions
- Completion with snippets, buffer words, and filesystem paths
- Format-on-save for supported filetypes
- Telescope search and an Nvim-tree file explorer
- Git signs, a statusline, buffer navigation, and an integrated terminal

## Tech Stack

- Neovim 0.11+
- Lua
- Lazy.nvim
- Mason.nvim
- Neovim built-in LSP
- nvim-cmp and LuaSnip
- Tree-sitter
- Conform.nvim

## Prerequisites

Before installing the configuration, make sure you have:

- Neovim 0.11 or newer
- Git
- A C compiler and GNU Make
- Curl and Unzip
- Node.js and npm
- Python 3
- ripgrep
- A Nerd Font-compatible terminal font

Some language servers and formatters may require additional language runtimes or tools. Clipboard integration may also require a system clipboard utility, such as `wl-clipboard` on Wayland or `xclip` on X11.

## Installation

1. Back up your existing Neovim configuration, if you have one:

```bash
mv ~/.config/nvim ~/.config/nvim.bak
```

2. Clone this repository into Neovim's configuration directory:

```bash
git clone https://github.com/awmiriiw/nvim.git ~/.config/nvim
```

3. Start Neovim:

```bash
nvim
```

Lazy.nvim bootstraps itself and installs the configured plugins. After startup, you can run these commands inside Neovim to synchronize plugins, update Mason's registry, and install Tree-sitter parsers:

```vim
:Lazy sync
:MasonUpdate
:TSUpdate
```

## Environment Variables

This project does not use a `.env` file or define project-specific environment variables. The configuration reads the standard `HOME` environment variable, when available, to add `~/.local/bin` to Neovim's `PATH`.

## Available Scripts

This repository is a Neovim configuration and does not include application build or package scripts. Start Neovim with:

```bash
nvim
```

Useful commands inside Neovim:

```text
:Lazy sync
:Mason
:MasonUpdate
:TSUpdate
:LspInfo
:ConformInfo
:checkhealth
```

## Notes

- The default leader key is `\`.
- Language servers are managed through Mason. External formatters must be installed separately and available in your system `PATH`.
- The configuration is designed for Neovim 0.11 or newer because it uses `vim.lsp.config()` and `vim.lsp.enable()`.
- The project is licensed under the GNU Affero General Public License v3.0. See [LICENSE](LICENSE) for details.

## License

This project is licensed under the GNU Affero General Public License v3.0 (AGPL-3.0). See the [LICENSE](LICENSE) file for the complete license text.
