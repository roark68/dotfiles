require("gitsigns").setup({
  on_attach = function(bufnr)
    local gs = require("gitsigns")
    local map = require("config.functions").bufmap(bufnr)

    -- Navigation (respects diffmode with ]c/[c)
    map("n", "]h", function()
      if vim.wo.diff then
        vim.cmd.normal({ "]c", bang = true })
      else
        gs.nav_hunk("next")
      end
    end, "Next hunk")
    map("n", "[h", function()
      if vim.wo.diff then
        vim.cmd.normal({ "[c", bang = true })
      else
        gs.nav_hunk("prev")
      end
    end, "Prev hunk")
    map("n", "]H", function() gs.nav_hunk("last") end, "Last hunk")
    map("n", "[H", function() gs.nav_hunk("first") end, "First hunk")

    -- Stage / reset
    map("n", "<leader>gs", gs.stage_hunk, "Stage hunk")
    map("n", "<leader>gr", gs.reset_hunk, "Reset hunk")
    map("x", "<leader>gs", function()
      gs.stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
    end, "Stage hunk")
    map("x", "<leader>gr", function()
      gs.reset_hunk({ vim.fn.line("."), vim.fn.line("v") })
    end, "Reset hunk")
    map("n", "<leader>gS", gs.stage_buffer, "Stage buffer")
    map("n", "<leader>gR", gs.reset_buffer, "Reset buffer")

    -- Inspect
    map("n", "<leader>gp", gs.preview_hunk, "Preview hunk (popup)")
    map("n", "<leader>gP", gs.preview_hunk_inline, "Preview hunk (inline)")
    map("n", "<leader>gw", gs.toggle_word_diff, "Toggle word diff")
    map("n", "<leader>gb", function() gs.blame_line({ full = true }) end, "Blame line")
    map("n", "<leader>gB", gs.toggle_current_line_blame, "Toggle line blame")
    map("n", "<leader>gd", gs.diffthis, "Diff this")
    map("n", "<leader>gD", function() gs.diffthis("~") end, "Diff against last commit")
    map("n", "<leader>gx", gs.toggle_deleted, "Toggle deleted")

    -- Text object: a hunk (e.g. dih, vih)
    map({ "o", "x" }, "ih", gs.select_hunk, "Select hunk")
  end,
})
