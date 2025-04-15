local config = {
	python = {
		{
          -- The first three options are required by nvim-dap
          type = "python", -- the type here established the link to the adapter definition: `dap.adapters.python`
          request = "launch",
          name = "Launch file",

          -- Options below are for debugpy, see https://github.com/microsoft/debugpy/wiki/Debug-configuration-settings for supported options

		  console = "integratedTerminal",
          program = "${file}", -- This configuration will launch the current file if used.
		  command = os.getenv('LOCALAPPDATA') .. "/Microsoft/WindowsApps/wt.exe",
          pythonPath = function()
            -- debugpy supports launching an application with a different interpreter then the one used to launch debugpy itself.
            -- The code below looks for a `venv` or `.venv` folder in the current directly and uses the python within.
            -- You could adapt this - to for example use the `VIRTUAL_ENV` environment variable.
            local cwd = vim.fn.getcwd()
			local path
			if vim.fn.executable(cwd .. "/venv/Scripts/python.exe") == 1 then
				path = cwd .. "/venv/Scripts/pythonw.exe"
				vim.notify("DAP :: (venv) PYTHONPATH = " .. path)
            elseif vim.fn.executable(cwd .. "/.venv/Scripts/python.exe") == 1 then
            	path = cwd .. "/.venv/Scripts/python.exe"
				vim.notify("DAP :: (.venv) PYTHONPATH = " .. path)
            else
				path = "python.exe"
				vim.notify("DAP :: (abs) PYTHONPATH = " .. path)
            end
			return path
          end,
		  repl_lang = "python",
        },
	}
}
return config
