return {
	{
		"folke/tokyonight.nvim",
		lazy = false,
		priority = 1000,
		config = function()
			require("tokyonight").setup({
				style = "moon",
				light_style = "day",
				transparent = false,
				terminal_colors = true,
				styles = {
					comments = { italic = true },
					keywords = { italic = true },
					functions = {},
					variables = {},
					sidebars = "dark",
					floats = "dark",
				},
				sidebars = { "qf", "help", "NvimTree", "Trouble", "lazy", "mason" },
			})
			vim.cmd.colorscheme("tokyonight")
		end,
	},

	{
		"nvim-tree/nvim-web-devicons",
		lazy = true,
	},

	{
		"nvim-tree/nvim-tree.lua",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		lazy = false,
		priority = 900,
		init = function()
			vim.g.loaded_netrw = 1
			vim.g.loaded_netrwPlugin = 1
		end,
		config = function()
			require("nvim-tree").setup({
				disable_netrw = true,
				hijack_netrw = true,
				hijack_cursor = true,
				sync_root_with_cwd = false,
				respect_buf_cwd = false,
				view = {
					width = 34,
					side = "left",
					preserve_window_proportions = true,
				},
				renderer = {
					group_empty = true,
					highlight_git = true,
					highlight_opened_files = "name",
					indent_markers = { enable = true },
					icons = {
						show = {
							file = true,
							folder = true,
							folder_arrow = true,
							git = true,
						},
					},
				},
				git = {
					enable = true,
					ignore = false,
				},
				diagnostics = {
					enable = true,
					show_on_dirs = true,
					debounce_delay = 150,
				},
				update_focused_file = {
					enable = true,
					update_root = false,
				},
				actions = {
					open_file = {
						quit_on_open = false,
						resize_window = true,
					},
				},
				filters = {
					dotfiles = false,
					git_ignored = false,
				},
				filesystem_watchers = { enable = true },
			})
		end,
	},

	{
		"akinsho/bufferline.nvim",
		version = "*",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		event = "VeryLazy",
		config = function()
			local bufferline = require("bufferline")

			bufferline.setup({
				options = {
					diagnostics = "nvim_lsp",
					diagnostics_indicator = function(count, level)
						local icon = level:match("error") and " " or " "
						return " " .. icon .. count
					end,
					always_show_bufferline = true,
					show_buffer_close_icons = false,
					show_close_icon = false,
					separator_style = "slant",
					left_trunc_marker = "",
					right_trunc_marker = "",
					offsets = {
						{
							filetype = "NvimTree",
							text = "Explorer",
							highlight = "Directory",
							text_align = "left",
							separator = true,
						},
					},
				},
			})

			vim.keymap.set("n", "<Tab>", "<cmd>BufferLineCycleNext<CR>", {
				noremap = true,
				silent = true,
				desc = "Next buffer",
			})

			vim.keymap.set("n", "<S-Tab>", "<cmd>BufferLineCyclePrev<CR>", {
				noremap = true,
				silent = true,
				desc = "Previous buffer",
			})

			local function smart_buf_close()
				local current = vim.api.nvim_get_current_buf()
				local buffers = vim.fn.getbufinfo({ buflisted = 1 })

				if #buffers > 1 then
					local ok = pcall(function()
						bufferline.cycle(1)
					end)
					if not ok then
						pcall(function()
							bufferline.cycle(-1)
						end)
					end
					vim.cmd("bdelete " .. current)
				else
					vim.cmd("bdelete")
				end
			end

			vim.keymap.set("n", "<leader>w", smart_buf_close, {
				noremap = true,
				silent = true,
				desc = "Close buffer",
			})
		end,
	},

	{
		"nvim-lualine/lualine.nvim",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		event = "VeryLazy",
		config = function()
			require("lualine").setup({
				options = {
					theme = "auto",
					globalstatus = true,
					component_separators = "",
					section_separators = "",
					disabled_filetypes = {
						statusline = { "alpha" },
						winbar = {},
					},
				},
				sections = {
					lualine_a = { "mode" },
					lualine_b = { "branch", "diff" },
					lualine_c = {
						{
							"filename",
							path = 1,
							symbols = {
								modified = " ●",
								readonly = " ",
								unnamed = "[No Name]",
							},
						},
					},
					lualine_x = { "encoding", "fileformat", "filetype" },
					lualine_y = { "progress" },
					lualine_z = { "location" },
				},
			})
		end,
	},

	{
		"lukas-reineke/indent-blankline.nvim",
		main = "ibl",
		event = "VeryLazy",
		opts = {
			indent = { char = "│" },
			scope = { enabled = true },
		},
	},

	{
		"goolord/alpha-nvim",
		event = "VimEnter",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		config = function()
			local alpha = require("alpha")
			local dashboard = require("alpha.themes.dashboard")

			dashboard.section.header.val = {
				"",
				"  ███╗   ██╗██╗   ██╗██╗███╗   ███╗",
				"  ████╗  ██║██║   ██║██║████╗ ████║",
				"  ██╔██╗ ██║██║   ██║██║██╔████╔██║",
				"  ██║╚██╗██║╚██╗ ██╔╝██║██║╚██╔╝██║",
				"  ██║ ╚████║ ╚████╔╝ ██║██║ ╚═╝ ██║",
				"  ╚═╝  ╚═══╝  ╚═══╝  ╚═╝╚═╝     ╚═╝",
				"",
			}

			dashboard.section.buttons.val = {
				dashboard.button("e", "New file", ":ene <BAR> startinsert <CR>"),
				dashboard.button("f", "Find file", "<cmd>Telescope find_files<CR>"),
				dashboard.button("g", "Live grep", "<cmd>Telescope live_grep<CR>"),
				dashboard.button("r", "Recent files", "<cmd>Telescope oldfiles<CR>"),
				dashboard.button("w", "WhichKey", "<cmd>WhichKey<CR>"),
				dashboard.button("q", "Quit", "<cmd>qa<CR>"),
			}

			dashboard.section.footer.val = {
				"",
				"Have a productive session.",
			}

			alpha.setup(dashboard.config)
		end,
	},

	{
		"rcarriga/nvim-notify",
		config = function()
			require("notify").setup({
				stages = "fade_in_slide_out",
				timeout = 2500,
				render = "default",
				background_colour = "#000000",
				max_width = 70,
				max_height = 20,
				fps = 60,
			})
			vim.notify = require("notify")
		end,
	},
}
