#!/bin/bash
# ================================================================
# SENIOR GO ENGINEER - MAC SETUP SCRIPT
# ================================================================

DOTFILES_DIR="$HOME/dotfiles"

echo "🍎 Starting macOS Setup..."

# 1. Ensure Homebrew is installed
if ! command -v brew &> /dev/null; then
    echo "Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    
    # Load brew into current shell session immediately
    if [[ $(uname -m) == "arm64" ]]; then
        eval "$(/opt/homebrew/bin/brew shellenv)"
    else
        eval "$(/usr/local/bin/brew shellenv)"
    fi
fi

# 2. Install Senior-grade CLI Tools
echo "🍺 Installing core tools..."
brew install nvim tmux git go ripgrep

# 3. Create Target Directories
# Neovim MUST have its folder before the link is created
echo "📁 Creating config directories..."
mkdir -p "$HOME/.config/nvim"

# 4. Create Symlinks (The "Ghost" Pointers)
echo "🔗 Linking configurations..."

# Tmux link
if [ -f "$DOTFILES_DIR/tmux.conf" ]; then
    ln -sf "$DOTFILES_DIR/tmux.conf" "$HOME/.tmux.conf"
    echo "✅ Linked .tmux.conf"
else
    echo "❌ Error: $DOTFILES_DIR/tmux.conf not found!"
fi

# Neovim link (Now pointing to the correct nvim/ folder)
if [ -f "$DOTFILES_DIR/nvim/init.lua" ]; then
    ln -sf "$DOTFILES_DIR/nvim/init.lua" "$HOME/.config/nvim/init.lua"
    echo "✅ Linked init.lua"
else
    echo "❌ Error: $DOTFILES_DIR/nvim/init.lua not found!"
fi

echo "--- 🚀 Mac Setup Complete! ---"
