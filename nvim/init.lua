-- =========================
-- Minimal init.lua (official-style split)
-- =========================

-- 0) Source legacy vimscript configs if present (first match wins)
do
	local cfgdir = vim.fn.stdpath("config")
	local candidates = {
		cfgdir .. "/legacy-init.vim",
		cfgdir .. "/legacy-init.nvim",
		cfgdir .. "/init.vim",
	}
	for _, f in ipairs(candidates) do
		if vim.fn.filereadable(f) == 1 then
			vim.cmd("source " .. f)
			break
		end
	end
end

-- Leader の設定（先に）
vim.g.mapleader      = ' '    -- <Leader> をスペースに
vim.g.maplocalleader = '\\'   -- 必要ならローカルリーダーも

-- Python3 ホストプログラム
vim.g.python3_host_prog = '/usr/bin/python'

-- 1) Basic options you want before loading lazy.nvim (safe to keep here)
vim.opt.autoindent      = true                    -- set autoindent
vim.opt.clipboard:append { 'unnamed', 'unnamedplus' }  -- set clipboard+=unnamed,unnamedplus
vim.opt.expandtab       = true                    -- set expandtab
vim.opt.foldenable      = false                   -- set nofoldenable
vim.opt.hlsearch        = false                   -- set hlsearch! （デフォルトで off に）
vim.opt.ignorecase      = true                    -- set ignorecase
vim.opt.infercase       = true                    -- set infercase
vim.opt.laststatus      = 2                       -- set laststatus=2
vim.opt.number          = true                    -- set number
vim.opt.shiftwidth      = 2                       -- set shiftwidth=2
vim.opt.smartcase       = true                    -- set smartcase
vim.opt.smartindent     = true                    -- set smartindent
vim.opt.softtabstop     = 2                       -- set softtabstop=2
vim.opt.tabstop         = 2                       -- set tabstop=2
vim.opt.wildmenu        = true                    -- set wildmenu
vim.opt.wildmode        = 'longest:full,full'     -- set wildmode=longest:full,full

-- Makefile requires hard tabs
vim.api.nvim_create_autocmd("FileType", {
	pattern = "make",
	callback = function()
		vim.opt_local.expandtab   = false
		vim.opt_local.tabstop     = 8
		vim.opt_local.shiftwidth  = 8
		vim.opt_local.softtabstop = 0
	end,
})

-- ノーハイライト（<Esc><Esc> で検索ハイライトをクリア）
vim.keymap.set('n', '<Esc><Esc>', '<Cmd>noh<CR>', {
  noremap = true, silent = true, desc = 'No highlight',
})

-- 括弧補完（インサートモード）
vim.keymap.set('i', '{<CR>', '{}<Left><CR><Esc>O', {
  noremap = true, desc = 'Auto-brace newline',
})
vim.keymap.set('i', '(<CR>', '()<Left>', {
  noremap = true, desc = 'Auto-paren newline',
})

-- 2) Load lazy.nvim bootstrap & setup (kept in lua/config/lazy.lua per docs)
require("config.lazy")
