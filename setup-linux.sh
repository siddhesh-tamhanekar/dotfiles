#!/bin/bash
# Linux Setup - Targeted for Ubuntu/Debian

DOTFILES_DIR="$HOME/dotfiles"

echo "🐧 Starting Linux Environment Setup..."

# 1. Update and Install Core
sudo apt update
sudo apt install -y neovim tmux git curl build-essential

# 2. Go Installation (Optional but recommended for your work)
if ! command -v go &> /dev/null; then
    echo "Installing Go..."
    sudo apt install -y golang-go
fi

# 3. Symlink Logic
echo "🔗 Linking configs..."
mkdir -p "$HOME/.config/nvim"
ln -sf "$DOTFILES_DIR/tmux.conf" "$HOME/.tmux.conf"
ln -sf "$DOTFILES_DIR/nvim/init.lua" "$HOME/.config/nvim/init.lua"

echo "✅ Linux Setup Complete."
