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

-- set up plugins.
-- alphebetized by repo name (not repo owner)
require("lazy").setup({
  {
    "emmanueltouzery/agitator.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-telescope/telescope.nvim",
    },
  },
  {
    "romgrk/barbar.nvim",
    dependencies = {
      "nvim-tree/nvim-web-devicons",
    },
  },
  {
    "hrsh7th/cmp-buffer",
  },
  {
    "hrsh7th/cmp-cmdline",
  },
  {
    "hrsh7th/cmp-nvim-lsp",
  },
  {
    "hrsh7th/cmp-path",
  },
  {
    "rebelot/kanagawa.nvim",
    config = function()
      require("kanagawa").setup({
        overrides = function(colors)
          return {
            LineNr = { fg = colors.palette.springViolet1 },
          }
        end,
      })
      vim.cmd("colorscheme kanagawa-wave")
    end,
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
    "NeogitOrg/neogit",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "sindrets/diffview.nvim",
      "nvim-telescope/telescope.nvim",
    },
    config = true,
  },
  {
    "hrsh7th/nvim-cmp",
  },
  {
    "neovim/nvim-lspconfig",
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
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function()
      require("nvim-treesitter.configs").setup({
        ensure_installed = {
          "bash",
          "c_sharp",
          "hcl",
          "lua",
          "markdown",
          "python",
          "rust",
          "vimdoc",
          "yaml",
        },
        highlight = {
          enable = true,
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
})


vim.g.mapleader = " "


-- help with filetype detection
vim.filetype.add({
  extension = {
    launch = "xml",
    tf = "hcl",
    tfvars = "hcl",
  },
})


-- nvim-cmp setup
local cmp = require("cmp")
cmp.setup({
  snippet = {
    expand = function(args)
      vim.snippet.expand(args.body)
    end,
  },
  mapping = cmp.mapping.preset.insert({
    ['<C-j>'] = cmp.mapping.scroll_docs(-4),
    ['<C-k>'] = cmp.mapping.scroll_docs(4),
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<C-e>'] = cmp.mapping.abort(),
    ['<CR>'] = cmp.mapping.confirm({ select = true }),
  }),
  sources = cmp.config.sources({
    { name = 'nvim_lsp' },
  }, {
    { name = 'buffer' },
  }),
})

-- use 'buffer' source for `/` and `?`
cmp.setup.cmdline({ '/', '?' }, {
  mapping = cmp.mapping.preset.cmdline(),
  sources = {
    { name = 'buffer' }
  }
})

-- use 'cmdline' and 'path' source for `:`
cmp.setup.cmdline(':', {
  mapping = cmp.mapping.preset.cmdline(),
  sources = cmp.config.sources({
    { name = 'path' }
  }, {
    { name = 'cmdline' }
  }),
  matching = { disallow_symbol_nonprefix_matching = false }
})

-- set up lspconfig
local lspconfig = require("lspconfig")
local cmp_nvim_lsp_capabilities = require("cmp_nvim_lsp").default_capabilities()
lspconfig.pyright.setup({
  capabilities = cmp_nvim_lsp_capabilities
})
--lspconfig.csharp_ls.setup({})
--lspconfig.terraformls.setup({
--  filetypes = {
--    "hcl",
--    "terraform",
--    "terraform-vars",
--  },
--})


-- keymaps
vim.keymap.set("n", "<Leader><Tab>", ":BufferPick<CR>", { noremap = true })
vim.keymap.set("n", "Y", "yy", { noremap = true })

vim.keymap.set("t", "<Esc>", "<C-\\><C-n>", { noremap = true })

local nvimtree = require("nvim-tree.api")
vim.keymap.set("n", "<Leader>t", function() nvimtree.tree.toggle(); end, { noremap = true })
vim.keymap.set("n", "<Leader>T", function() nvimtree.tree.find_file({ open = true, focus = true, }); end, { noremap = true })

local telescope = require("telescope.builtin")
vim.keymap.set("n", "<Leader>ff", telescope.find_files, { noremap = true })
vim.keymap.set("n", "<Leader>fg", telescope.live_grep, { noremap = true })
vim.keymap.set("n", "<Leader>fo", telescope.buffers, { noremap = true })
vim.keymap.set("n", "<Leader>fb", telescope.git_branches, { noremap = true })
vim.keymap.set("n", "<Leader>fh", telescope.help_tags, { noremap = true })

local neogit = require("neogit")
vim.keymap.set("n", "<Leader>gs", neogit.open, { noremap = true })

local agitator = require("agitator")
vim.keymap.set("n", "<Leader>gb", agitator.git_blame, { noremap = true })


-- chdir to the nearest-ancestor directory of the currently-opened buffer that contains a '.git' directory
local function get_git_root()
  local dot_git_path = vim.fn.finddir(".git", ".;")
  return vim.fn.fnamemodify(dot_git_path, ":h")
end
vim.api.nvim_create_user_command("Cdgit", function() vim.api.nvim_set_current_dir(get_git_root()); end, {})


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
