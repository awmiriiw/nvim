return {
	{
		"williamboman/mason.nvim",
		build = ":MasonUpdate",
		config = function()
			require("mason").setup()
		end,
	},

	{
		"williamboman/mason-lspconfig.nvim",
		dependencies = { "williamboman/mason.nvim" },
		config = function()
			require("mason-lspconfig").setup({
				ensure_installed = {
					"lua_ls",
					"pyright",
					"gopls",
					"sqlls",
					"ts_ls",
					"html",
					"cssls",
					"clangd",
					"bashls",
					"marksman",
				},
				automatic_installation = true,
			})
		end,
	},

	{
		"neovim/nvim-lspconfig",
		event = { "BufReadPre", "BufNewFile" },
		dependencies = {
			"hrsh7th/cmp-nvim-lsp",
			"williamboman/mason-lspconfig.nvim",
			"williamboman/mason.nvim",
		},
		config = function()
			local capabilities = require("cmp_nvim_lsp").default_capabilities()

			local servers = {
				"lua_ls",
				"gopls",
				"sqlls",
				"pyright",
				"ts_ls",
				"html",
				"cssls",
				"clangd",
				"bashls",
				"marksman",
			}

			local function on_attach(_, bufnr)
				local map = vim.keymap.set
				local opts = { noremap = true, silent = true, buffer = bufnr }

				map("n", "gd", vim.lsp.buf.definition, opts)
				map("n", "gD", vim.lsp.buf.declaration, opts)
				map("n", "K", vim.lsp.buf.hover, opts)
				map("n", "gi", vim.lsp.buf.implementation, opts)
				map("n", "gr", vim.lsp.buf.references, opts)
				map("n", "<leader>rn", vim.lsp.buf.rename, opts)
				map("n", "<leader>ca", vim.lsp.buf.code_action, opts)

				map("n", "<leader>wa", vim.lsp.buf.add_workspace_folder, opts)
				map("n", "<leader>wr", vim.lsp.buf.remove_workspace_folder, opts)
				map("n", "<leader>wl", function()
					print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
				end, opts)

				vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
					buffer = bufnr,
					callback = function()
						local diags = vim.diagnostic.get(bufnr, {
							lnum = vim.api.nvim_win_get_cursor(0)[1] - 1,
						})
						if #diags > 0 then
							vim.diagnostic.open_float(nil, {
								focus = false,
								scope = "cursor",
								border = "rounded",
								source = "if_many",
							})
						end
					end,
				})
			end

			local configs = {
				lua_ls = {
					settings = {
						Lua = {
							runtime = { version = "LuaJIT" },
							diagnostics = { globals = { "vim" } },
							workspace = {
								checkThirdParty = false,
								library = vim.api.nvim_get_runtime_file("", true),
							},
							telemetry = { enable = false },
						},
					},
				},

				pyright = {
					settings = {
						python = {
							analysis = {
								autoSearchPaths = true,
								useLibraryCodeForTypes = true,
								diagnosticMode = "workspace",
							},
						},
					},
				},

				gopls = {
					settings = {
						gopls = {
							gofumpt = true,
							staticcheck = true,
							analyses = {
								unusedparams = true,
								shadow = true,
							},
						},
					},
				},

				sqlls = {},
				ts_ls = {},
				html = {},
				cssls = {},
				clangd = {},
				bashls = {},
				marksman = {},
			}

			for _, server in ipairs(servers) do
				vim.lsp.config(
					server,
					vim.tbl_deep_extend("force", {
						capabilities = capabilities,
						on_attach = on_attach,
					}, configs[server] or {})
				)
			end

			for _, server in ipairs(servers) do
				vim.lsp.enable(server)
			end
		end,
	},
}
