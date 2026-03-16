-- =============================================================================
-- NEOVIM v0.11+ MINIMALIST GO CONFIG (Native LSP)
-- =============================================================================

-- 1. CORE SETTINGS
vim.g.mapleader = " "
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.termguicolors = true
vim.opt.hlsearch = true
vim.opt.incsearch = true

-- 2. BOOTSTRAP LAZY.NVIM
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({ "git", "clone", "--filter=blob:none", "https://github.com/folke/lazy.nvim.git", "--branch=stable", lazypath })
end
vim.opt.rtp:prepend(lazypath)

-- 3. PLUGINS
require("lazy").setup({
    { "catppuccin/nvim", name = "catppuccin", priority = 1000 },
  "christoomey/vim-tmux-navigator",
  { "nvim-treesitter/nvim-treesitter", build = ":TSUpdate" },
  { "nvim-telescope/telescope.nvim", dependencies = { "nvim-lua/plenary.nvim" } },
  -- Note: We still use Mason to manage the binary, but use Native LSP to run it
  { "williamboman/mason.nvim" },
  { "hrsh7th/nvim-cmp", dependencies = { "hrsh7th/cmp-nvim-lsp" } },
})

-- 4. CONFIGURATION
require("catppuccin").setup({ flavour = "mocha" })
vim.cmd.colorscheme("catppuccin")

-- Treesitter (Syntax highlighting)
local ts_status, ts_configs = pcall(require, "nvim-treesitter.configs")
if ts_status then
  ts_configs.setup({
    ensure_installed = { "go", "lua" },
    highlight = { enable = true },
  })
end

-- 5. NATIVE LSP CONFIG (v0.11 Style)
require("mason").setup()

-- Native gopls setup
-- In 0.11, we enable the config directly via the global vim.lsp table
if vim.lsp.config then
    vim.lsp.config('gopls', {
        cmd = { 'gopls' },
        filetypes = { 'go', 'gomod', 'gowork', 'gotmpl' },
        root_markers = { 'go.work', 'go.mod', '.git' },
    })
    vim.lsp.enable('gopls')
end

-- Completion setup
local cmp = require('cmp')
cmp.setup({
  mapping = cmp.mapping.preset.insert({
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<CR>'] = cmp.mapping.confirm({ select = true }),
  }),
  sources = { { name = 'nvim_lsp' } }
})

-- 6. KEYMAPS (Essential & Native)
local key = vim.keymap.set
key('n', '<Esc>', '<cmd>nohlsearch<CR>')
key('n', 'gd', vim.lsp.buf.definition)
key('n', 'gr', vim.lsp.buf.references)
key('n', 'K',  vim.lsp.buf.hover)

-- Telescope
local builtin = require('telescope.builtin')
key('n', '<leader>ff', builtin.find_files)
key('n', '<leader>fg', builtin.live_grep)



local key = vim.keymap.set

-- Quickfix navigation
key('n', '<leader>qo', '<cmd>copen<CR>')  -- Open Quickfix
key('n', '<leader>qc', '<cmd>cclose<CR>') -- Close Quickfix
key('n', '<leader>j', '<cmd>cprev<CR>')          -- Previous item
key('n', '<leader>k', '<cmd>cnext<CR>')          -- Next item

-- 7. THE INVARIANTS (No Arrows)
for _, mode in ipairs({ 'n', 'i', 'v' }) do
  for _, arrow in ipairs({ '<Up>', '<Down>', '<Left>', '<Right>' }) do
    key(mode, arrow, '<nop>')
  end
end
