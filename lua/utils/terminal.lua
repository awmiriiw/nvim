local M = {}

function M.set_terminal_keymaps(bufnr)
  local opts = { noremap = true, silent = true, buffer = bufnr }
  vim.keymap.set("t", "<Esc>", [[<C-\><C-n>]], opts)
  vim.keymap.set("t", "jk", [[<C-\><C-n>]], opts)
end

function M.smart_toggle_terminal()
  local terminals = require("toggleterm.terminal").get_all()

  for _, term in ipairs(terminals) do
    if term and term.window and vim.api.nvim_win_is_valid(term.window) and term:is_open() then
      vim.api.nvim_set_current_win(term.window)
      vim.cmd("startinsert!")
      return
    end
  end

  vim.cmd("ToggleTerm direction=horizontal")
end

return M
