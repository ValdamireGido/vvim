
local lsp = require('lspconfig')
local completion = require('completion')
local status = require('ex.lsp_status')
--local configs = require('lspconfig/configs')
status.activate()

local custom_attach = function(client)
    completion.on_attach({
        chain_completion_list=require('ex.completion').chain_completion_list,
    })
    status.on_attach(client)
end

lsp.clangd.setup{
	on_attach = custom_attach,
	init_options = {
		clangdFileStatus = true
	},
}

lsp.jdtls.setup{
	on_attach = custom_attach
}

lsp.pyls.setup{
	on_attach = custom_attach,
	cmd = { 'pyls', '-v' }
}

lsp.vimls.setup{
	on_attach = custom_attach
}

local lua_language_server_path = 'D:\\reps\\lua-language-server\\'
lsp.sumneko_lua.setup{
	cmd = { lua_language_server_path..'bin\\Windows\\lua-language-server.exe', '-E', lua_language_server_path..'main.lua' },
	settings = {
		Lua = {
			diagnostics = {
				globals = {'vim'},
			},
			workspace = {
				library = {
					[vim.fn.expand('$VIMRUNTIME/lua')] = true,
					[vim.fn.expand('$VIMRUNTIME/lua/nim/lsp')] = true,
				}
			}
		}
	},
	on_attach = custom_attach
}

lsp.bashls.setup{
	on_attach = custom_attach
}

lsp.groovyls.setup{
	on_attach = custom_attach
}

lsp.omnisharp.setup{
	on_attach = custom_attach
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
