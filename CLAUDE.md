# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

This is a personal dotfiles repository for managing shell configurations and development environment settings.

## Common Commands

```bash
# Clone and set up dotfiles (typical pattern)
git clone git@github.com:mskako/dotfiles.git ~/git/dotfiles

# Create symlinks to home directory (example)
ln -sf ~/git/dotfiles/.zshrc ~/.zshrc
ln -sf ~/git/dotfiles/.bashrc ~/.bashrc
```

## Repository Structure

Dotfiles repos typically contain:
- Shell configs (.zshrc, .bashrc, .profile)
- Editor configs (.vimrc, .config/nvim/)
- Git config (.gitconfig, .gitignore_global)
- Tool-specific configs (.tmux.conf, etc.)

## Notes

- Files are typically symlinked from this repo to the home directory
- Sensitive data (API keys, tokens) should never be committed
