_G.__is_log = true

-- disable netrw at the very start of your init.lua
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- set termguicolors to enable highlight groups
vim.opt.termguicolors = true

vim.cmd [[
  highlight Normal guibg=none
  highlight NonText guibg=none
  highlight Normal ctermbg=none
  highlight NonText ctermbg=none
]]

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

local plugins = {

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

	table.insert(plugins, {
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
	  })

	  table.insert(plugins, {
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
	  })

	table.insert(plugins, {
		"nvim-treesitter/nvim-treesitter-context",
		dependencies = { "nvim-treesitter/nvim-treesitter" }
	})

	table.insert(plugins, { 'RRethy/vim-illuminate', config = function()
		require'illuminate'.configure {
			providers = { 'lsp', 'treesitter', 'regex' },
			delay = 100,
			under_cursor = true,
		}
	end })

	table.insert(plugins, {
		'nvim-telescope/telescope.nvim',
		tag = '0.1.8',
		dependencies = { 'nvim-lua/plenary.nvim' },
		config = function()
			require('telescope').setup({
				defaults = {
					layout_strategy = "center",
					layout_config = {
						vertical = {
							mirror = true,
						},
						center = {
							mirror = true,
						}
					},
					sorting_strategy = "ascending",
					path_display = {
						shorten = true,
						truncate = true,
					},
				},
			})
			local builtin = require('telescope.builtin')
			vim.keymap.set('n', '<leader>ff', builtin.find_files, {})
			vim.keymap.set('n', '<leader>fg', builtin.live_grep, {})
			vim.keymap.set('n', '<leader>fb', builtin.buffers, {})
			vim.keymap.set('n', '<leader>fh', builtin.help_tags, {})
		end
	})
	table.insert(plugins, {
		'nvim-telescope/telescope-frecency.nvim',
		version = "*",
		config = function()
			require("telescope").load_extension("frecency")
			vim.keymap.set('n', '<C-p>', ':Telescope frecency workspace=CWD<CR>')
		end,
	})

	table.insert(plugins, { "neovim/nvim-lspconfig" })
	table.insert(plugins, { "nvim-lua/lsp-status.nvim" })
	table.insert(plugins, { "nvim-lua/lsp-status.nvim" })

	table.insert(plugins, {
		"williamboman/mason.nvim",
		config = function()
			require("mason").setup()
		end
	})

	table.insert(plugins, {
		"williamboman/mason-lspconfig.nvim",
		config = function()
			local config = require("mason-lspconfig")
			config.setup()
			config.setup_handlers {
				function (server_name)
					require("lspconfig")[server_name].setup{}
				end
			}
		end
	})


	table.insert(plugins, {
		'echasnovski/mini.clue',
		version = '*',
		config = function()
			local miniclue = require('mini.clue')
			miniclue.setup({
			  triggers = {
				-- Leader triggers
				{ mode = 'n', keys = '<Leader>' },
				{ mode = 'x', keys = '<Leader>' },

				-- Built-in completion
				{ mode = 'i', keys = '<C-x>' },

				-- `g` key
				{ mode = 'n', keys = 'g' },
				{ mode = 'x', keys = 'g' },

				-- Marks
				{ mode = 'n', keys = "'" },
				{ mode = 'n', keys = '`' },
				{ mode = 'x', keys = "'" },
				{ mode = 'x', keys = '`' },

				-- Registers
				{ mode = 'n', keys = '"' },
				{ mode = 'x', keys = '"' },
				{ mode = 'i', keys = '<C-r>' },
				{ mode = 'c', keys = '<C-r>' },

				-- Window commands
				{ mode = 'n', keys = '<C-w>' },

				-- `z` key
				{ mode = 'n', keys = 'z' },
				{ mode = 'x', keys = 'z' },
			  },

			  clues = {
				-- Enhance this by adding descriptions for <Leader> mapping groups
				miniclue.gen_clues.builtin_completion(),
				miniclue.gen_clues.g(),
				miniclue.gen_clues.marks(),
				miniclue.gen_clues.registers(),
				miniclue.gen_clues.windows(),
				miniclue.gen_clues.z(),
			  },
			})
		end
	})

	table.insert(plugins, {
	  'nvimdev/dashboard-nvim',
	  event = 'VimEnter',
	  config = function()
		require('dashboard').setup {
			theme = 'hyper',
			config = {
			  week_header = {
			   enable = true,
			  },
			  shortcut = {
				{
					desc = '󰊳 Update',
					group = '@property',
					action = 'Lazy update',
					key = 'u'
				},
				{
				  icon = ' ',
				  icon_hl = '@variable',
				  desc = 'Files',
				  group = 'Label',
				  action = 'Telescope find_files',
				  key = 'f',
				},
				{
				  desc = ' Apps',
				  group = 'DiagnosticHint',
				  action = 'Telescope app',
				  key = 'a',
				},
				{
				  desc = ' dotfiles',
				  group = 'Number',
				  action = 'Telescope dotfiles',
				  key = 'd',
				},
			  },
			},
		}
	  end,
	  dependencies = { {'nvim-tree/nvim-web-devicons'}}
	})
end


-- lazy PM load
require("lazy").setup(plugins, {
	root = vim.g.pluginInstallPath,
	spec = {
		LasyPlugSpecs,
	}
})

-- Hop configuration
require("hop").setup { }
vim.keymap.set('n', '<leader><leader>w', require'hop'.hint_words, {})
vim.keymap.set('n', '<leader><leader>b', function ()
	require'hop'.hint_words({ direction=require'hop.hint'.HintDirection.BEFORE_CURSOR })
end)
vim.keymap.set('n', '<leader><leader>f', require'hop'.hint_char1, {})
vim.keymap.set('n', '<leader><leader>p', require'hop'.hint_patterns, {})

if vim.g.neovide then
	-- transparency
	vim.g.neovide_transparency = 0.9
	-- corner radius
	vim.g.neovide_floating_corner_radius = 1.0
	-- cursor transition animation 
	vim.g.neovide_cursor_animation_length = 0.05
	vim.g.neovide_cursor_trail_size = 0.0
end
