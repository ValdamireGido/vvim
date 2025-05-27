_G.__is_log = true

-- default shell
vim.opt.shell = "pwsh"
vim.opt.shellcmdflag = "-command"
vim.opt.shellquote = "\""
vim.opt.shellxquote = ""

-- lazy package manager bootstrap
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"--branch=stable", -- latest stable release
		"https://github.com/folke/lazy.nvim.git",
		lazypath,
	})
end
vim.opt.rtp:prepend(lazypath)

local plugins = {

	{
		'nvim-lualine/lualine.nvim',
		dependencies = { 'nvim-tree/nvim-web-devicons', opt = true },
		config = function()
			require('lualine').setup {
				options = {
					icons_enabled = true,
					theme = 'auto',
					component_separators = { left = '', right = '' },
					section_separators = { left = '', right = '' },
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
					lualine_a = { 'mode' },
					lualine_b = { 'branch', 'diff', 'diagnostics' },
					lualine_c = { 'filename' },
					lualine_x = { 'encoding', 'fileformat', 'filetype' },
					lualine_y = { 'progress' },
					lualine_z = { 'location' }
				},
				inactive_sections = {
					lualine_a = {},
					lualine_b = {},
					lualine_c = { 'filename' },
					lualine_x = { 'location' },
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

	{
		'smoka7/hop.nvim',
		version = "*",
		opts = {},
		config = function()
			-- Hop configuration
			require("hop").setup {}
			vim.keymap.set('n', '<leader><leader>w', require 'hop'.hint_words, {})
			vim.keymap.set('n', '<leader><leader>b', function()
				require 'hop'.hint_words({ direction = require 'hop.hint'.HintDirection.BEFORE_CURSOR })
			end)
			vim.keymap.set('n', '<leader><leader>f', require 'hop'.hint_char1, {})
			vim.keymap.set('n', '<leader><leader>p', require 'hop'.hint_patterns, {})
		end
	},

	{ 'wellle/targets.vim' },
	{ 'godlygeek/tabular' },
	{ 'tpope/vim-repeat' },
	{ 'kana/vim-operator-user' },

	{
		"mistweaverco/kulala.nvim",
		ft = { "http", "rest" },
		config = function()
			require("kulala").setup {
				global_keymaps = true,
				global_keymaps_prefix = "<leader>R",
				kulala_keymaps_prefix = "",
				ui = {
					formatter = true,
				},
			}
			vim.filetype.add({
				extension = {
					['http'] = 'http',
				},
			})
		end,
	},

}


--
-- 			Non VSCode configuration
--
if not vim.g.vscode then

	-- color schemes
	--
	table.insert(plugins, {
		"catppuccin/nvim",
		name = "catppuccin",
		priority = 1000,
	})
	table.insert(plugins, {
		"rebelot/kanagawa.nvim"
	})
	table.insert(plugins, {
		'AlexvZyl/nordic.nvim',
		lazy = false,
		priority = 1000,
		config = function(opts)
			require('nordic').load(opts)
		end
	})
	--
	--

	table.insert(plugins, {
		"nvim-tree/nvim-tree.lua",
		dependencies = { "nvim-tree/nvim-web-devicons", },
		init = function()

			-- disable netrw at the very start of your init.lua
			vim.g.loaded_netrw = 1
			vim.g.loaded_netrwPlugin = 1

			require("nvim-tree").setup({
				respect_buf_cwd = true,
				select_prompts = true,
				view = {
					number = true,
					relativenumber = true,
					float = {
						enable = true,
						quit_on_focus_loss = true,
						open_win_config = {
							relative = "editor",
							border = "rounded",
							width = 40,
							height = 40,
							row = 15,
							col = 15,
						},
					}
				},
			})
		end,
	})

	table.insert(plugins, {
		"rcarriga/nvim-notify",
		config = function()
			vim.notify = require('notify')
			vim.notify.setup {
				fps = 15,
				stages = "slide",
				merge_duplicates = true,
			}
		end
	})


	table.insert(plugins, {
		"dimfred/resize-mode.nvim",
		dependencies = {
			"rcarriga/nvim-notify"
		},
		config = function()
			require("resize-mode").setup {
				enable_mapping = true,
			}

			vim.keymap.set(
				'n',
				'<leader>r',
				function()
					require'resize-mode'.start()
					vim.notify("Entered Resize Mode")
				end,
				{}
			)
		end
	})

	table.insert(plugins, {
		"akinsho/toggleterm.nvim",
		config = function()
			require("toggleterm").setup {
				direction = "float",
				open_mapping = [[<m-\>]],
			}

			local Terminal = require("toggleterm.terminal").Terminal
			local lazygit = Terminal:new { cmd = "lazygit", hidden = true }
			local lazygit_toggle = function() lazygit:toggle() end
			vim.keymap.set("n", "<leader>gg", lazygit_toggle, { desc = "Toggle Lazygit" })

			local lazyp4 = Terminal:new { cmd = "lazyp4", hidden = true }
			local lazyp4_toggle = function() lazyp4:toggle() end
			vim.keymap.set("n", "<leader>lp", lazyp4_toggle, { desc = "Toggle LazyP4" })
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
					component_separators = { left = '', right = '' },
					section_separators = { left = '', right = '' },
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
					lualine_a = { 'mode' },
					lualine_b = { 'branch', 'diff', 'diagnostics' },
					lualine_c = { 'filename' },
					lualine_x = { 'encoding', 'fileformat', 'filetype' },
					lualine_y = { 'progress' },
					lualine_z = { 'location' }
				},
				inactive_sections = {
					lualine_a = {},
					lualine_b = {},
					lualine_c = { 'filename' },
					lualine_x = { 'location' },
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
		"nvim-treesitter/nvim-treesitter",
		config = function()
			require('nvim-treesitter').config = {
				ensure_installed = {
					"c",
					"cpp",
					"c_sharp",
					"diff",
					"lua",
					"vim",
					"vimdoc",
					"markdown",
					"json",
					"go",
					"python",
					"rust",
					"typescript",
					"yaml",
				}
			}
			require('nvim-treesitter').setup()
		end
	})

	table.insert(plugins, {
		"nvim-treesitter/nvim-treesitter-context",
		dependencies = { "nvim-treesitter/nvim-treesitter" }
	})

	table.insert(plugins, {
		'RRethy/vim-illuminate',
		config = function()
			require 'illuminate'.configure {
				providers = { 'lsp', 'regex' },
				delay = 100,
				under_cursor = true,
			}
		end
	})

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
							width = 0.8,
						},
						center = {
							mirror = true,
							width = 0.8,
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
			-- commands in Telescope
			vim.keymap.set('n', '<leader>:', builtin.commands, {})
			-- lsp symbols and references
			vim.keymap.set('n', '<leader>td', builtin.lsp_document_symbols, {})
			vim.keymap.set('n', '<leader>tw', builtin.lsp_workspace_symbols, {})
			vim.keymap.set('n', '<leader>tr', builtin.lsp_references, {})
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

	table.insert(plugins, { "neovim/nvim-lspconfig", })
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
			config.setup {
				ensure_installed = {
					"pyright",
				},
				automatic_enable = true,
			}

			vim.keymap.set({ 'n', 'v' }, '==', function()
				vim.lsp.buf.format({
					async = true,
					range = {
						["start"] = vim.api.nvim_buf_get_mark(0, "<"),
						["end"] = vim.api.nvim_buf_get_mark(0, ">"),
					}
				})
			end
			)
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
		"ray-x/lsp_signature.nvim",
		event = "InsertEnter",
		opts = {}
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
		dependencies = { { 'nvim-tree/nvim-web-devicons' } }
	})

	table.insert(plugins, {
		"kdheepak/lazygit.nvim",
		lazy = true,
		cmd = {
			"LazyGit",
			"LazyGitConfig",
			"LazyGitCurrentFile",
			"LazyGitFilter",
			"LazyGitFilterCurrentFile",
		},
		-- optional for floating window border decoration
		dependencies = {
			"nvim-lua/plenary.nvim",
		},
		-- setting the keybinding for LazyGit with 'keys' is recommended in
		-- order to load the plugin when the command is run for the first time
		keys = {
			{ "<leader>lg", "<cmd>LazyGit<cr>", desc = "LazyGit" }
		},
		config = function()
			require("telescope").load_extension("lazygit")
		end
	})

	table.insert(plugins, {
		"lewis6991/gitsigns.nvim",
		config = function()
			local gitsigns = require('gitsigns')
			gitsigns.setup{}
			vim.keymap.set('n', '<leader>gbl', function()
				gitsigns.blame_line({ full = true })
			end)
			vim.keymap.set('n', '<leader>gbf', gitsigns.blame, {
				desc = "GitSigns Blame"
			})
			vim.keymap.set('n', '<leader>gh', gitsigns.preview_hunk, {
				desc = "GitSigns Preview Hunk"
			})
		end
	})

	table.insert(plugins, {
		"folke/lazydev.nvim",
		ft = "lua",
		config = function()
			require("lazydev").setup {}
		end
	})

	table.insert(plugins, {
		"guillemaru/perfnvim",
		config = function()
			require("perfnvim").setup{}
		end
	})

	table.insert(plugins, {
		"sindrets/diffview.nvim"
	})

	table.insert(plugins, {'akinsho/git-conflict.nvim', version = "*", config = true})

	table.insert(plugins, {
		"Joakker/lua-json5",
		lazy = true,
		build = vim.fn.has("win32") == 1 and "powershell ./install.ps1" or "./install.sh",
	})

	table.insert(plugins, {
		"mfussenegger/nvim-dap",
		config = function()
			local dap = require('dap')
			vim.keymap.set('n', '<f5>', dap.continue, {
				desc = "DAP Continue"
			})
			vim.keymap.set('n', '<S-F5>', function()
					dap.disconnect({ terminateDebuggee = true })
					dap.close()
				end,
				{
					desc = "DAP Stop Debug Session",
				}
			)
			vim.keymap.set('n', '<C-F5>', function()
					dap.run_last()
				end,
				{
					desc = "DAP Run last selected configuration",
				}
			)
			vim.keymap.set('n', '<f8>', dap.step_over, {
				desc = "DAP Step Over"
			})
			vim.keymap.set('n', '<f9>', dap.step_into, {
				desc = "DAP Step Into"
			})
			vim.keymap.set('n', '<f7>', dap.step_out, {
				desc = "DAP Step Out"
			})
			vim.keymap.set('n', '<leader>b', dap.toggle_breakpoint, {
				desc = "DAP Toggle Breakpoint"
			})
			vim.keymap.set({'n', 'v'}, '<Leader>dh', function()
					require('dap.ui.widgets').hover()
				end,
				{
					desc = "DAP Hover"
				}
			)
			vim.keymap.set({'n', 'v'}, '<Leader>dp', function()
					require('dap.ui.widgets').preview()
				end,
				{
					desc = "DAP Preview",
				}
			)
			vim.keymap.set('n', '<Leader>df', function()
					local widgets = require('dap.ui.widgets')
					widgets.centered_float(widgets.frames)
				end,
				{
					desc = "DAP Frames"
				}
			)
			vim.keymap.set('n', '<Leader>ds', function()
					local widgets = require('dap.ui.widgets')
					widgets.centered_float(widgets.scopes)
				end,
				{
					desc = "DAP Scopes"
				}
			)

			vim.cmd('hi DapBreakpoint ctermbg=0 guifg=#993939 guibg=#31353f')
			vim.cmd('hi DapLogPoint ctermbg=0 guifg=#61afef guibg=#31353f')
			vim.cmd('hi DapStopped ctermbg=0 guifg=#98c379 guibg=#31353f')

			vim.fn.sign_define('DapBreakpoint', { text='', texthl='DapBreakpoint', linehl='DapBreakpoint', numhl='DapBreakpoint' })
			vim.fn.sign_define('DapBreakpointCondition', { text='', texthl='DapBreakpoint', linehl='DapBreakpoint', numhl='DapBreakpoint' })
			vim.fn.sign_define('DapBreakpointRejected', { text='', texthl='DapBreakpoint', linehl='DapBreakpoint', numhl= 'DapBreakpoint' })
			vim.fn.sign_define('DapLogPoint', { text='', texthl='DapLogPoint', linehl='DapLogPoint', numhl= 'DapLogPoint' })
			vim.fn.sign_define('DapStopped', { text='', texthl='DapStopped', linehl='DapStopped', numhl= 'DapStopped' })

			local dap_ui = require('dapui')
			dap_ui.setup()
			vim.keymap.set('n', '<leader>du', dap_ui.toggle, {
				desc = 'Toggle DAP UI'
			})

			local mason_dap = require('mason-nvim-dap')
			mason_dap.setup({
				ensure_installed = { "python" },
				automatic_installation = true,
				handlers = {
					function(config)
						require('mason-nvim-dap').default_setup(config)
					end
				}
			})
		end,
		dependencies = {
			"rcarriga/nvim-dap-ui",
			"nvim-neotest/nvim-nio",
			"jay-babu/mason-nvim-dap.nvim",
			"theHamsta/nvim-dap-virtual-text",
			"Joakker/lua-json5",
		}
	})

	table.insert(plugins, { "rcarriga/nvim-dap-ui" })

	table.insert(plugins, {
		"mfussenegger/nvim-dap-python",
		lazy = true,
		config = function()
            local cwd = vim.fn.getcwd()
			local path
			if vim.fn.executable(cwd .. "/venv/Scripts/pythonw.exe") == 1 then
				path = cwd .. "/venv/Scripts/pythonw.exe"
            elseif vim.fn.executable(cwd .. "/.venv/Scripts/pythonw.exe") == 1 then
            	path = cwd .. "/.venv/Scripts/pythonw.exe"
			elseif vim.fn.executable(cwd .. "/.python_venv/Scripts/pythonw.exe") == 1 then
            	path = cwd .. "/.python_venv/Scripts/pythonw.exe"
            else
				path = "pythonw.exe"
            end
			local python = vim.fn.expand(path)
			require('dap-python').setup(python)
		end
	})

	table.insert(plugins, {
		"linux-cultist/venv-selector.nvim",
		dependencies = {
			"neovim/nvim-lspconfig",
			"mfussenegger/nvim-dap",
			"mfussenegger/nvim-dap-python",
			{
				"nvim-telescope/telescope.nvim",
				branch = "0.1.x",
				dependencies = { "nvim-lua/plenary.nvim" }
			},
		},
		lazy = false,
		branch = "regexp", -- This is the regexp branch, use this for the new version
		keys = {
			{ ",v", "<cmd>VenvSelect<cr>" },
		},
		---@type venv-selector.Config
		opts = {
			-- Your settings go here
		},
	})

	table.insert(plugins, {
		"leoluz/nvim-dap-go",
		ft = "go",
		opts = {
			delve = {
				path = "dlv.cmd",
				detatched = false,
			}
		},
		config = function(_, opts)
			require('dap-go').setup(opts)
			require('dap').set_log_level("TRACE")
		end,
	})

end
--
-- -----------------------------------------
--


-- lazy PM load
require("lazy").setup(plugins, {
	root = vim.g.pluginInstallPath,
	spec = {}
})

if vim.g.neovide then
	-- transparency
	vim.g.neovide_transparency = 0.9
	-- corner radius
	vim.g.neovide_floating_corner_radius = 1.0
	-- cursor transition animation
	vim.g.neovide_cursor_animation_length = 0.05
	vim.g.neovide_cursor_trail_size = 0.0
end

-- set termguicolors to enable highlight groups
vim.opt.termguicolors = true
vim.opt.colorcolumn = "100"

if not vim.g.vscode then
	vim.cmd [[
		colorscheme nordic
	]]
end

vim.cmd [[
	highlight Normal guibg=none ctermbg=none
	highlight NormalNC guibg=none ctermbg=none
	highlight NonText guibg=none ctermbg=none
	highlight LineNr guifg=#606060

	highlight SignColumn guibg=none ctermbg=none
	highlight GitSignsAdd guibg=none ctermbg=none
	highlight GitSignsChange guibg=none ctermbg=none
	highlight GitSignsDelete guibg=none ctermbg=none
	highlight GitSignsStagedAdd guibg=none ctermbg=none
	highlight GitSignsStagedChange guibg=none ctermbg=none
	highlight GitSignsStagedDelete guibg=none ctermbg=none
]]



