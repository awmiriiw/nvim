return {
	"nvim-treesitter/nvim-treesitter",
	build = ":TSUpdate",
	lazy = false,
	priority = 1000,
	config = function()
		local ok, configs = pcall(require, "nvim-treesitter.configs")
		if not ok then
			return
		end

		configs.setup({
			ensure_installed = {
				"bash",
				"c",
				"cpp",
				"css",
				"html",
				"sql",
				"go",
				"javascript",
				"json",
				"lua",
				"python",
				"tsx",
				"typescript",
				"toml",
				"vim",
				"vimdoc",
				"yaml",
				"markdown",
				"markdown_inline",
			},
			auto_install = true,
			highlight = {
				enable = true,
				disable = function(lang, buf)
					if lang == "markdown" and vim.api.nvim_buf_line_count(buf) > 1500 then
						return true
					end
				end,
			},
			indent = { enable = true },
		})
	end,
}
