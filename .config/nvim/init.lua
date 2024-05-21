-- generally recommended by many neovim plugins to remove race conditions on startup
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- enable 24-bit terminal colors
vim.opt.termguicolors = true

-- bootstrap lazy.nvim -- https://github.com/folke/lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- set up plugins
require("lazy").setup({
  {
    "romgrk/barbar.nvim",
    dependencies = {
      "nvim-tree/nvim-web-devicons",
    },
  },
  {
    "nvim-lualine/lualine.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons", },
    config = function()
      require("lualine").setup({
        --options = {
        --  sections = {
        --    lualine_z = { "location", "0x%B" },  -- not working
        --  },
        --},
      })
    end,
  },
  {
    "rebelot/kanagawa.nvim",
    config = function()
      require("kanagawa").setup({})
      vim.cmd("colorscheme kanagawa-wave")
    end,
  },
  {
    "nvim-tree/nvim-tree.lua",
    version = "*",
    lazy = false,
    dependencies = { "nvim-tree/nvim-web-devicons", },
    config = function()
      require("nvim-tree").setup({
        view = {
          centralize_selection = true,
          float = {
            enable = true,
            open_win_config = {
              width = 50,
              height = 50,
            },
          },
        },
      })
    end,
  },
  {
    "nvim-telescope/telescope.nvim",
    tag = "0.1.6",
    dependencies = {
      "nvim-tree/nvim-web-devicons",
      "nvim-lua/plenary.nvim",
    },
  },
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function()
      require("nvim-treesitter.configs").setup({
        ensure_installed = { "bash", "hcl", "lua", "markdown", "python", "vimdoc", },
        highlight = {
          enable = true,
        },
      })
    end,
  },
})


vim.g.mapleader = " "


-- help with filetype detection
vim.filetype.add({
  extension = {
    tf = "hcl",
    tfvars = "hcl",
  },
})


-- keymaps
vim.keymap.set("n", "<Leader><Tab>", ":BufferPick<CR>")
vim.keymap.set("n", "Y", "yy")

local nvimtree = require("nvim-tree.api")
vim.keymap.set("n", "<Leader>t", function() nvimtree.tree.toggle(); end)
vim.keymap.set("n", "<Leader>T", function() nvimtree.tree.find_file({ open = true, focus = true, }); end)

local telescope = require("telescope.builtin")
vim.keymap.set("n", "<Leader>ff", telescope.find_files, {})
vim.keymap.set("n", "<Leader>fg", telescope.live_grep, {})
vim.keymap.set("n", "<Leader>fb", telescope.buffers, {})
vim.keymap.set("n", "<Leader>fh", telescope.help_tags, {})


-- show certain types of whitespace
vim.cmd("set list")

-- use case insensitive search, except when using capital letters
vim.cmd("set ignorecase")
vim.cmd("set smartcase")

-- no terminal bell
vim.cmd('set belloff=""')

-- indent by 4 spaces by default, let filetype plugins override
vim.cmd("set shiftwidth=4")
vim.cmd("set softtabstop=4")

-- use spaces instead of tabs by default
vim.cmd("set expandtab")

-- display line numbers
vim.cmd("set number")

-- open new splits to the right (vsp) or bottom (sp)
vim.cmd("set splitright")
vim.cmd("set splitbelow")

-- insert only one space after period/exclamation mark/question mark
vim.cmd("set nojoinspaces")
