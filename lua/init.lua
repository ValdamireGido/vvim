_G.__is_log = true
vim.opt.signcolumn = "yes"
vim.opt.winborder = "rounded"

local is_windows = vim.fn.has("win64") == 1 or vim.fn.has("win32") == 1 or vim.fn.has("win16") == 1
-- default shell
if is_windows then
	vim.opt.shell = "pwsh"
	vim.opt.shellcmdflag = "-command"
	vim.opt.shellquote = "\""
	vim.opt.shellxquote = ""
else
	vim.opt.shell = "bash"
end

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
		"kylechui/nvim-surround",
		version = "*", -- Use for stability; omit to use `main` branch for the latest features
		event = "VeryLazy",
		config = function()
			require("nvim-surround").setup({
				-- Configuration here, or leave empty to use defaults
			})
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

	---@type LazySpec
	{
		"mikavilpas/yazi.nvim",
		event = "VeryLazy",
		dependencies = {
			-- check the installation instructions at
			-- https://github.com/folke/snacks.nvim
			"folke/snacks.nvim"
		},
		keys = {
			-- 👇 in this section, choose your own keymappings!
			{
				"<leader>y",
				mode = { "n", "v" },
				"<cmd>Yazi<cr>",
				desc = "Open yazi at the current file",
			},
			{
				-- Open in the current working directory
				"<leader>cw",
				"<cmd>Yazi cwd<cr>",
				desc = "Open the file manager in nvim's working directory",
			},
			{
				"<c-up>",
				"<cmd>Yazi toggle<cr>",
				desc = "Resume the last yazi session",
			},
		},
		---@type YaziConfig | {}
		opts = {
			-- if you want to open yazi instead of netrw, see below for more info
			open_for_directories = false,
			keymaps = {
				show_help = "<f1>",
			},
		},
		-- 👇 if you use `open_for_directories=true`, this is recommended
		init = function()
			-- More details: https://github.com/mikavilpas/yazi.nvim/issues/802
			-- vim.g.loaded_netrw = 1
			vim.g.loaded_netrwPlugin = 1
		end,
	},


}


--
-- 			Non VSCode configuration
--
if not vim.g.vscode then


	table.insert(plugins, {
		"Koalhack/darcubox-nvim",
		config = function()
			require('darcubox').setup({
				options = {
					transparent = true,
					styles = {
						comments = {},
						functions = {},
						keywords = {},
						types = {},
					}
				}
			})
		end
	})


	table.insert(plugins, {
		"rcarriga/nvim-notify",
		config = function()
			vim.notify = require('notify')
			vim.notify.setup {
				fps = 60,
				stages = "slide",
				merge_duplicates = true,
				render = "wrapped-compact",
				max_width = 40,
				top_down = false,
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
		"nvzone/floaterm",
		dependencies = "nvzone/volt",
		opts = {},
		cmd = "FloatermToggle",
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
					lualine_c = { { 'filename', file_status = true, path = 1 } },
					lualine_x = { 'overseer', 'encoding', 'fileformat', 'filetype' },
					lualine_y = { 'progress' },
					lualine_z = { 'location' }
				},
				inactive_sections = {
					lualine_a = {},
					lualine_b = {},
					lualine_c = { { 'filename', file_status = true, path = 1 } },
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
					path_display = {"relative"},
				},
			})
			local builtin = require('telescope.builtin')
			vim.keymap.set('n', '<leader>ff', builtin.grep_string, {})
			vim.keymap.set('n', '<leader>fg', builtin.live_grep, {})
			vim.keymap.set('n', '<leader>fb', builtin.buffers, {})
			vim.keymap.set('n', '<leader>fh', builtin.help_tags, {})
			-- commands in Telescope
			vim.keymap.set('n', '<leader>:', builtin.commands, {})
			-- lsp symbols and references
			vim.keymap.set('n', '<leader>td', builtin.lsp_document_symbols, {})
			vim.keymap.set('n', '<leader>tw', builtin.lsp_workspace_symbols, {})
			vim.keymap.set('n', '<leader>tr', builtin.lsp_references, {})
			vim.keymap.set('n', '<C-A-p>', ':Telescope resume<cr>', {
				desc = "Telescope: resume last activated session"
			})
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
				},
				automatic_enable = true,
			}

			vim.keymap.set({ 'i' }, '<C-C>', function()
				vim.lsp.completion.get()
			end, {
				desc = "LSP Completion popup",
				remap = true,
			})

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
		opts = {
			toggle_key = "<C-k>",
			floating_window = false,
		},
		init = function()
			vim.keymap.set({ 'n' }, '<C-k>', function()
				require('lsp_signature').toggle_float_win()
			end, { silent = true, noremap = true, desc = 'Toggle Function Signature popup' })
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

	-- table.insert(plugins, {
	-- 	"guillemaru/perfnvim",
	-- 	config = function()
	-- 		require("perfnvim").setup{}
	-- 	end
	-- })

	table.insert(plugins, {
		"motiongorilla/p4nvim",
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
			vim.keymap.set('n', '<S-f5>', ':DapTerminate<CR>', {
				desc = "DAP Terminate Debug Session",
			})
			vim.keymap.set('n', '<C-F5>', function() dap.run_last() end, {
				desc = "DAP Run last selected configuration",
			})
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
			local python_ext = ""
			if is_windows then
				python_ext = "w.exe"
			end
			local path
			if vim.fn.executable(cwd .. "/venv/Scripts/python" .. python_ext) == 1 then
				path = cwd .. "/venv/Scripts/python" .. python_ext
            elseif vim.fn.executable(cwd .. "/.venv/Scripts/python" .. python_ext) == 1 then
            	path = cwd .. "/.venv/Scripts/pythonw" .. python_ext
			elseif vim.fn.executable(cwd .. "/.python_venv/Scripts/pythonw" .. python_ext) == 1 then
            	path = cwd .. "/.python_venv/Scripts/python" .. python_ext
            else
				path = "python" .. python_ext
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
			-- require('dap').set_log_level("TRACE")
		end,
	})


	table.insert(plugins, {
		'stevearc/overseer.nvim',
		opts = {
			strategy = "toggleterm",
		},
		config = function(_, opts)
			require('overseer').setup(opts)
			vim.keymap.set("n", "<C-S-R>", "<CMD>OverseerRun<CR>", {
				desc = "Run available tasks"
			})
			vim.keymap.set("n", "<C-S-L>", "<CMD>OverseerToggle<CR>", {
				desc = "Toggle Overseer"
			})
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
vim.opt.colorcolumn = "80"

if not vim.g.vscode then
	vim.cmd [[
		colorscheme darcubox
	]]
end

vim.cmd [[
	highlight Normal guibg=none ctermbg=none
	highlight NormalNC guifg=gray guibg=none ctermbg=none
	highlight NormalFloat guibg=black
	"highlight NonText guibg=none ctermbg=none
	highlight LineNr guifg=#606060

	highlight ColorColumn guibg=#16181c
	highlight SignColumn guibg=none ctermbg=none

	highlight GitSignsAdd guibg=none ctermbg=none
	highlight GitSignsChange guibg=none ctermbg=none
	highlight GitSignsDelete guibg=none ctermbg=none
	highlight GitSignsStagedAdd guibg=none ctermbg=none
	highlight GitSignsStagedChange guibg=none ctermbg=none
	highlight GitSignsStagedDelete guibg=none ctermbg=none

	highlight DapBreakpoint ctermbg=0 guibg=darkred
	highlight DapLogPoint ctermbg=0 guibg=#31353f
	highlight DapStopped ctermbg=0 guibg=#31358f
]]



