-- MATIVE OPTIONS

vim.g.mapleader = " "
vim.g.maplocalleader = " "

local opt = vim.opt
opt.number = true
opt.relativenumber = true
opt.splitright = true
opt.splitbelow = true
opt.undofile = true -- Permanent undo history saved to disk
opt.signcolumn = "yes" --Avoid screen flicker when diagnostics appear

-- Tabs & Indentation (Full-stack standard)
opt.expandtab = true
opt.shiftwidth = 4
opt.tabstop = 4
opt.smartindent = true

-- Search & Performance
opt.ignorecase = true
opt.smartcase = true
opt.updatetime = 250 -- Faster completion and diagnostic trigger
opt.timeoutlen = 300

-- System Integration
opt.termguicolors = true
opt.clipboard = "unnamedplus" 
--Sync with Wayland clipdoard (requires wl-clipboard)

-- KEYMAPS & AUTOCOMMANDS

-- Narive Window Navigation (Don't confilct with Niri's Mod+Arrow keys)
vim.keymap.set("n", "<C-h>","<C-w>h", { desc = "Go to Left Window" })
vim.keymap.set("n", "<C-j>","<C-w>j", { desc = "Go to Lower Window" })
vim.keymap.set("n", "<C-k>","<C-w>k", { desc = "Go to Upper Window" })
vim.keymap.set("n", "<C-l>","<C-w>l", { desc = "Go to Right Window" })

-- Clean search highlights instantly
vim.keymap.set("n","<Esc>","<cmd>nohlsearch<CR>")

--Native LSP Keybindings (Applied globally when LSP attaches)
vim.api.nvim_create_autocmd("LspAttach",
{
	group = vim.api.nvim_create_augroup("UserLspConfig",{}),
	callback = function(ev)
		local opts = { buffer = ev.buf }
		vim.keymap.set("n","gD",vim.lsp.buf.declaration, opts)
		vim.keymap.set("n","gd",vim.lsp.buf.definition, opts)
		vim.keymap.set("n","K",vim.lsp.buf.hover, opts)
		vim.keymap.set("n","gi",vim.lsp.buf.implementation, opts)
		vim.keymap.set("n","<leader>rn",vim.lsp.buf.rename, opts)
		vim.keymap.set({"n","v"}, "<leader>ca",vim.lsp.buf.code_action, opts)
		vim.keymap.set("n","gr",vim.lsp.buf.references, opts)
		vim.keymap.set("n","<leader>f", function() vim.lsp.buf.format { async = true } end, opts)
	end,
})

-- BOOTSTRAP PLUGIN MANAGER

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then vim.fn.system({
	"git","clone","--filter=blob:none", "https://github.com/folke/lazy.nvim.git", "--branch=stable", lazypath,
})
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup("plugins", { change_datection = { notify = false }, })-- Pure silent background updates
