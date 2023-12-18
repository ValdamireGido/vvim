
local lsp = require('lspconfig')
-- local completion = require('completion')
local status = require('ex.lsp_status')
--local configs = require('lspconfig/configs')
status.activate()

-- Global mappings.
-- See `:help vim.diagnostic.*` for documentation on any of the below functions
vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float)
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev)
vim.keymap.set('n', ']d', vim.diagnostic.goto_next)
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist)


lsp.clangd.setup { init_options = { clangdFileStatus = true } }
lsp.jdtls.setup { }
lsp.pyright.setup {}
lsp.vimls.setup { }

lsp.lua_ls.setup {}
lsp.bashls.setup { }
lsp.groovyls.setup { }
lsp.omnisharp.setup { }

--------------------------------------------------------------------------

--[[ populate quickfix list with diagnostics
local method = "textDocument/publishDiagnostics"
local default_callback = vim.lsp.callbacks[method]
vim.lsp.callbacks[method] = function(err, method, result, client_id)
default_callback(err, method, result, client_id)
if result and result.diagnostics then
	local item_list = {}
	for _, v in ipairs(result.diagnostics) do
		local fname = result.uri table.insert(item_list, {
			filename = fname, lnum = v.range.start.line + 1, col = v.range.start.character + 1;
			text = v.message;
			})
		end
		local old_items = vim.fn.getqflist()
		for _, old_item in ipairs(old_items) do
			local bufnr = vim.uri_to_bufnr(result.uri)
			if vim.uri_from_bufnr(old_item.bufnr) ~= result.uri then
				table.insert(item_list, old_item)
			end
		end
		vim.fn.setqflist({}, ' ', { title = 'LSP'; items = item_list; })
	end
end
]]

--------------------------------------------------------------------------

vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('UserLspConfig', {}),
  callback = function(ev)
    -- Enable completion triggered by <c-x><c-o>
    vim.bo[ev.buf].omnifunc = 'v:lua.vim.lsp.omnifunc'

    -- Buffer local mappings.
    -- See `:help vim.lsp.*` for documentation on any of the below functions
    local opts = { buffer = ev.buf }
    vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
    vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
    vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
    vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
    vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, opts)
    vim.keymap.set('n', '<leader>wa', vim.lsp.buf.add_workspace_folder, opts)
    vim.keymap.set('n', '<leader>wr', vim.lsp.buf.remove_workspace_folder, opts)
    vim.keymap.set('n', '<leader>wl', function()
      print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
    end, opts)
    vim.keymap.set('n', '<leader>D', vim.lsp.buf.type_definition, opts)
    vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, opts)
    vim.keymap.set({ 'n', 'v' }, '<leader>ca', vim.lsp.buf.code_action, opts)
    vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
    vim.keymap.set('n', '<leader>f', function()
      vim.lsp.buf.format { async = true }
    end, opts)
  end,
})

