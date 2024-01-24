_G.__is_log = true

-- disable netrw at the very start of your init.lua
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- set termguicolors to enable highlight groups
vim.opt.termguicolors = true

-- lazy package manager bootstrap
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

plugins = { 
	{ 
	  "nvim-tree/nvim-tree.lua", version = "*", lazy = false,
	  dependencies = { "nvim-tree/nvim-web-devicons", },
	  config = function()
		require("nvim-tree").setup {
		  sort = {
			sorter = "case_sensitive",
		  },
		  view = {
			width = 30,
		  },
		  renderer = {
			group_empty = true,
		  },
		  filters = {
			dotfiles = true,
		  },
		}
	  end,
	},
	{ 'nvim-telescope/telescope.nvim', tag = '0.1.5', dependencies = { 'nvim-lua/plenary.nvim' } },
	{
		'nvim-lualine/lualine.nvim',
		dependencies = { 'nvim-tree/nvim-web-devicons', opt = true },
		config = function()
			require('lualine').setup {
				options = {
					icons_enabled = true,
					theme = 'auto',
					component_separators = { left = '', right = ''},
					section_separators = { left = '', right = ''},
					disabled_filetypes = {
						statusline = {},
						winbar = {},
					},
					ignore_focus = {},
					always_divide_middle = true,
					globalstatus = false,
					refresh = {
						statusline = 1000,
						tabline = 1000,
						winbar = 1000,
					}
				},
				sections = {
					lualine_a = {'mode'},
					lualine_b = {'branch', 'diff', 'diagnostics'},
					lualine_c = {'filename'},
					lualine_x = {'encoding', 'fileformat', 'filetype'},
					lualine_y = {'progress'},
					lualine_z = {'location'}
				},
				inactive_sections = {
					lualine_a = {},
					lualine_b = {},
					lualine_c = {'filename'},
					lualine_x = {'location'},
					lualine_y = {},
					lualine_z = {}
				},
				tabline = {},
				winbar = {},
				inactive_winbar = {},
				extensions = {}
			}
		end
	},
	{
		"kylechui/nvim-surround",
		version = "*", -- Use for stability; omit to use `main` branch for the latest features
		event = "VeryLazy",
		config = function()
			require("nvim-surround").setup({
				-- Configuration here, or leave empty to use defaults
			})
		end
	},
	{ 'smoka7/hop.nvim', version = "*", opts = {}, },

	{ 'wellle/targets.vim' },
	{ 'godlygeek/tabular' },
	{ 'tpope/vim-repeat' },
	{ 'kana/vim-operator-user' },
}

if not vim.g.vscode then
	table.insert(plugins, { "nvim-treesitter/nvim-treesitter-context" })
	table.insert(plugins, { 'RRethy/vim-illuminate', config = function()
		require'illuminate'.configure {
			providers = { 'lsp', 'treesitter', 'regex' },
			delay = 100,
			under_cursor = true,
		}
	end })
	table.insert(plugins, { 'nvim-telescope/telescope.nvim', tag = '0.1.5', dependencies = { 'nvim-lua/plenary.nvim' } })
	table.insert(plugins, { "neovim/nvim-lspconfig" })
	table.insert(plugins, { "nvim-lua/lsp-status.nvim" })
	table.insert(plugins, { "nvim-lua/lsp-status.nvim" })
	table.insert(plugins, { "nvim-treesitter/nvim-treesitter-context" })
end

-- lazy PM load
require("lazy").setup(plugins, {
	root = vim.g.pluginInstallPath,
	spec = {
		LasyPlugSpecs,
	}
})

-- Telestope configuration
local builtin = require('telescope.builtin')
vim.keymap.set('n', '<C-p>'     , builtin.find_files, {})
vim.keymap.set('n', '<leader>ff', builtin.find_files, {})
vim.keymap.set('n', '<leader>fg', builtin.live_grep, {})
vim.keymap.set('n', '<leader>fb', builtin.buffers, {})
vim.keymap.set('n', '<leader>fh', builtin.help_tags, {})

-- Lualine configuration
-- Hop configuration
require("hop").setup { }
vim.keymap.set('n', '<leader><leader>w', require'hop'.hint_words, {})
vim.keymap.set('n', '<leader><leader>b', function ()
	require'hop'.hint_words({ direction=require'hop.hint'.HintDirection.BEFORE_CURSOR })
end)
vim.keymap.set('n', '<leader><leader>f', require'hop'.hint_char1, {})
vim.keymap.set('n', '<leader><leader>p', require'hop'.hint_patterns, {})

