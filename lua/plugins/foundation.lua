return {
	{
		"nvim-telescope/telescope.nvim",
		dependencies = { "nvim-lua/plenary.nvim" },
		cmd = "Telescope",
		config = function()
			local telescope = require("telescope")
			local builtin = require("telescope.builtin")

			telescope.setup({
				defaults = {
					prompt_prefix = "  ",
					selection_caret = "❯ ",
					path_display = { "smart" },
				},
			})

			local map = vim.keymap.set
			map("n", "<leader>ff", builtin.find_files, { desc = "Find files" })
			map("n", "<leader>fg", builtin.live_grep, { desc = "Live grep" })
			map("n", "<leader>fb", builtin.buffers, { desc = "Find buffers" })
			map("n", "<leader>fh", builtin.oldfiles, { desc = "Old files" })
			map("n", "<leader>fd", builtin.diagnostics, { desc = "Diagnostics" })
		end,
	},

	{
		"numToStr/Comment.nvim",
		event = "VeryLazy",
		config = function()
			require("Comment").setup()
		end,
	},

	{
		"windwp/nvim-autopairs",
		event = "InsertEnter",
		opts = {},
	},

	{
		"folke/which-key.nvim",
		event = "VeryLazy",
		config = function()
			require("which-key").setup({})
		end,
	},

	{
		"akinsho/toggleterm.nvim",
		version = "*",
		event = "VeryLazy",
		config = function()
			local term_utils = require("utils.terminal")

			require("toggleterm").setup({
				direction = "horizontal",
				size = 12,
				shade_terminals = true,
				start_in_insert = true,
				persist_size = true,
				close_on_exit = false,
				on_open = function(term)
					term_utils.set_terminal_keymaps(term.bufnr)
					vim.cmd("startinsert!")
				end,
			})
		end,
	},

	{
		"folke/trouble.nvim",
		cmd = "Trouble",
		keys = {
			{ "<leader>xx", "<cmd>Trouble diagnostics toggle<cr>", desc = "Diagnostics" },
			{ "<leader>xq", "<cmd>Trouble quickfix toggle<cr>", desc = "Quickfix" },
			{ "<leader>xs", "<cmd>Trouble symbols toggle<cr>", desc = "Symbols" },
		},
		opts = {},
	},
}
