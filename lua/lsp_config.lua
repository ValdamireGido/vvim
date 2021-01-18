--vim.cmd [[ packadd nlua.nvim ]]
local lsp        = require('lspconfig')
local completion = require('completion')
local configs    = require('lspconfig/configs')
local lsp_status = require('lsp-status')
lsp_status.register_progress()

local mapper = function(mode, key, result)
  vim.api.nvim_buf_set_keymap(0, mode, key, "<cmd>lua "..result.."<cr>", {noremap = true, silent = true})
end

configs.lualsp = {
	default_config = {
		cmd = { 'lua-language-server' };
		filetypes = { 'lua' };
		root_dir = function(fname)
			return lsp.util.find_git_ancestor(fname) or vim.loop.os_homedir()
		end;
		settings = {};
	}
}


--------------------------------------------------------------------------

lsp.ocamllsp.setup{
  on_attach = custom_attach
}

lsp.clangd.setup{
	capabilities = lsp_status.capabilities,
	on_attach = lsp_status.on_attach,
	init_options = {
		clangdFileStatus = true
	},
}

lsp.pyls.setup{
	capabilities = lsp_status.capabilities,
	on_attach = lsp_status.on_attach,
}

lsp.vimls.setup{
	capabilities = lsp_status.capabilities,
	on_attach = lsp_status.on_attach,
}

--------------------------------------------------------------------------

---[[ populate quickfix list with diagnostics 
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
