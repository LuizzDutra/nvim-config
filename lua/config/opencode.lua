-- opencode.nvim: https://github.com/nickjvandyke/opencode.nvim
local opencode_cmd = "opencode"
local terminal_opts = { win = { position = "right", enter = false } }

---@type opencode.Opts
vim.g.opencode_opts = {
  server = {
    -- Open the opencode TUI in a snacks terminal when a server isn't running
    start = function()
      require("snacks.terminal").open(opencode_cmd, terminal_opts)
    end,
  },
}

-- Show the terminal when OpenCode starts executing
vim.api.nvim_create_autocmd("User", {
  pattern = { "OpencodeEvent:session.execution.started" },
  callback = function()
    local win = require("snacks.terminal").get(opencode_cmd, { create = false })
    if win then
      win:show()
    end
  end,
})

-- Required for `opts.events.reload` (buffer auto-reload on OpenCode edits)
vim.o.autoread = true

local keymap = vim.keymap
keymap.set({ "n", "x" }, "<leader>oa", function()
  require("opencode").ask("@this: ")
end, { desc = "Ask OpenCode…" })
keymap.set({ "n", "x" }, "<leader>os", function()
  require("opencode").select()
end, { desc = "Select OpenCode…" })
-- Send range/motion to OpenCode (expr + dot-repeat)
keymap.set("n", "<leader>oo", function()
  return require("opencode").operator("@this")
end, { desc = "Send motion to OpenCode", expr = true })
keymap.set("n", "<leader>ol", function()
  return require("opencode").operator("@this") .. "_"
end, { desc = "Send line to OpenCode", expr = true })
-- Toggle the opencode terminal (F12 is reliably sent by terminals; <C-.> often isn't on Windows)
keymap.set({ "n", "t" }, "<F12>", function()
  require("snacks.terminal").toggle(opencode_cmd, terminal_opts)
end, { desc = "Toggle OpenCode" })
