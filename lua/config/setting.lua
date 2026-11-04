local opt = vim.opt

opt.encoding = "utf-8"
opt.fileencoding = "utf-8"
opt.ambiwidth = "single"
opt.clipboard = "unnamedplus"
opt.number = true
opt.relativenumber = false
opt.mouse = "a"
opt.ignorecase = true
opt.smartcase = true
opt.hlsearch = true
opt.wrap = false
opt.scrolloff = 8
opt.sidescrolloff = 8
opt.tabstop = 2
opt.shiftwidth = 2
opt.expandtab = true
opt.autoindent = true
opt.termguicolors = true
opt.signcolumn = "yes"
opt.updatetime = 250
opt.completeopt = { "menu", "menuone", "noselect" }

vim.diagnostic.config({
	virtual_text = false,
	signs = true,
	underline = true,
	update_in_insert = false,
	severity_sort = true,
	float = {
		border = "rounded",
		source = "if_many",
	},
})

local map = vim.keymap.set

map("n", "[d", vim.diagnostic.goto_prev, { noremap = true, silent = true, desc = "Prev diagnostic" })
map("n", "]d", vim.diagnostic.goto_next, { noremap = true, silent = true, desc = "Next diagnostic" })
map("n", "gl", vim.diagnostic.open_float, { noremap = true, silent = true, desc = "Float diagnostic" })
map("n", "<leader>q", vim.diagnostic.setloclist, { noremap = true, silent = true, desc = "Diagnostic list" })

map("n", "<leader>t", function()
	require("utils.terminal").smart_toggle_terminal()
end, { noremap = true, silent = true, desc = "Toggle terminal" })

local function is_nvimtree_win(winid)
	if not winid or not vim.api.nvim_win_is_valid(winid) then
		return false
	end
	local buf = vim.api.nvim_win_get_buf(winid)
	return vim.bo[buf].filetype == "NvimTree"
end

local function is_alpha_win(winid)
	if not winid or not vim.api.nvim_win_is_valid(winid) then
		return false
	end
	local buf = vim.api.nvim_win_get_buf(winid)
	return vim.bo[buf].filetype == "alpha"
end

local function find_nvimtree_win()
	for _, win in ipairs(vim.api.nvim_list_wins()) do
		if is_nvimtree_win(win) then
			return win
		end
	end
	return nil
end

local function return_to_previous_window()
	local prev = vim.t.prev_non_tree_win
	if prev and vim.api.nvim_win_is_valid(prev) and not is_nvimtree_win(prev) then
		vim.api.nvim_set_current_win(prev)
		local buf = vim.api.nvim_win_get_buf(prev)
		if vim.bo[buf].buftype == "terminal" then
			vim.cmd("startinsert!")
		end
		return true
	end
	for _, win in ipairs(vim.api.nvim_list_wins()) do
		if not is_nvimtree_win(win) then
			vim.api.nvim_set_current_win(win)
			local buf = vim.api.nvim_win_get_buf(win)
			if vim.bo[buf].buftype == "terminal" then
				vim.cmd("startinsert!")
			end
			return true
		end
	end
	return false
end

local function open_nvimtree_from_alpha()
	local current_win = vim.api.nvim_get_current_win()
	local alpha_buf = vim.api.nvim_win_get_buf(current_win)

	local new_buf = vim.api.nvim_create_buf(true, false)
	vim.api.nvim_win_set_buf(current_win, new_buf)
	pcall(vim.api.nvim_buf_delete, alpha_buf, { force = true })

	vim.t.prev_non_tree_win = current_win

	vim.schedule(function()
		vim.cmd("NvimTreeOpen")
		local tree_win = find_nvimtree_win()
		if tree_win and vim.api.nvim_win_is_valid(tree_win) then
			vim.api.nvim_set_current_win(tree_win)
		end
	end)
end

local function smart_tree_toggle()
	local current_win = vim.api.nvim_get_current_win()

	if is_alpha_win(current_win) then
		open_nvimtree_from_alpha()
		return
	end

	if is_nvimtree_win(current_win) then
		if not return_to_previous_window() then
			vim.cmd("NvimTreeClose")
		end
		return
	end

	vim.t.prev_non_tree_win = current_win
	local tree_win = find_nvimtree_win()
	if tree_win and vim.api.nvim_win_is_valid(tree_win) then
		vim.api.nvim_set_current_win(tree_win)
	else
		vim.cmd("NvimTreeOpen")
		tree_win = find_nvimtree_win()
		if tree_win then
			vim.api.nvim_set_current_win(tree_win)
		end
	end
end

map("n", "<leader>e", function()
	local current_win = vim.api.nvim_get_current_win()
	if is_alpha_win(current_win) then
		open_nvimtree_from_alpha()
		return
	end
	vim.cmd("NvimTreeToggle")
end, { noremap = true, silent = true, desc = "Toggle explorer" })

map("n", "<leader>b", smart_tree_toggle, { noremap = true, silent = true, desc = "Tree back/focus" })
