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


vim.g.mapleader = " "


-- set up plugins.
-- alphebetized by repo name (not repo owner)
require("lazy").setup({
  spec = {
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
    { "hrsh7th/cmp-buffer", },
    { "hrsh7th/cmp-cmdline", },
    { "hrsh7th/cmp-nvim-lsp", },
    { "hrsh7th/cmp-path", },
    {
      "zbirenbaum/copilot-cmp",
      opts = {},
    },
    {
      "zbirenbaum/copilot.lua",
      opts = {},
    },
    { "idossha/htop.nvim", },
    {
      "rebelot/kanagawa.nvim",
      opts = {
        overrides = function(colors)
          return {
            LineNr = { fg = colors.palette.springViolet1 },
          }
        end,
      },
    },
    {
      "nvim-lualine/lualine.nvim",
      dependencies = { "nvim-tree/nvim-web-devicons", },
      opts = {
        sections = {
          lualine_z = { "location", "%B" },
        },
      },
    },
    {
      "iamcco/markdown-preview.nvim",
      cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
      ft = { "markdown" },
      build = "cd app && npm install",
      init = function()
        vim.g.mkdp_filetypes = { "markdown" }
      end,
    },
    {
      "NeogitOrg/neogit",
      dependencies = {
        "nvim-lua/plenary.nvim",
        "sindrets/diffview.nvim",
        "nvim-telescope/telescope.nvim",
      },
    },
    { "hrsh7th/nvim-cmp", },
    { "neovim/nvim-lspconfig", },
    {
      "nvim-tree/nvim-tree.lua",
      version = "*",
      lazy = false,
      dependencies = { "nvim-tree/nvim-web-devicons", },
      opts = {
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
      },
    },
    {
      "nvim-treesitter/nvim-treesitter",
      branch = "main",
      lazy = false,
      build = ":TSUpdate",
    },
    { "folke/sidekick.nvim", },
    {
      "nvim-telescope/telescope.nvim",
      branch = "master",
      dependencies = {
        "nvim-tree/nvim-web-devicons",
        "nvim-lua/plenary.nvim",
      },
    },
    {
      "nvim-treesitter/nvim-treesitter-textobjects",
      branch = "main",
    },
    {
      "folke/trouble.nvim",
      opts = {},
      cmd = "Trouble",
    },
  },
})

vim.cmd("colorscheme kanagawa-wave")


-- help with filetype detection
vim.filetype.add({
  extension = {
    launch = "xml",
  },
})

vim.treesitter.language.register("hcl", "terraform")
vim.treesitter.language.register("hcl", "terraform-vars")


-- install and enable treesitter parsers
local languages = {
  "bash",
  "c_sharp",
  "hcl",
  "lua",
  "markdown",
  "python",
  "rust",
  "vimdoc",
  "yaml",
}

require("nvim-treesitter").install(languages)

vim.api.nvim_create_autocmd("FileType", {
  pattern = vim.list_extend(vim.deepcopy(languages), { "terraform", "terraform-vars" }),
  callback = function() vim.treesitter.start() end,
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
    ["<C-j>"] = cmp.mapping.scroll_docs(4),
    ["<C-k>"] = cmp.mapping.scroll_docs(-4),

    ["<C-e>"] = cmp.mapping.abort(),

    -- if no completion is explicitly selected with TAB, insert a newline.
    -- otherwise, confirm the highlighted completion
    ["<CR>"] = cmp.mapping({
      i = function(fallback)
        if cmp.visible() and cmp.get_active_entry() then
          cmp.confirm({ behavior = cmp.ConfirmBehavior.Replace, select = false })
        else
          fallback()
        end
      end,
      s = cmp.mapping.confirm({ select = true }),
      c = cmp.mapping.confirm({ behavior = cmp.ConfirmBehavior.Replace, select = true }),
    }),

    -- if there's only one possible completion, complete right away
    ["<Tab>"] = function(fallback)
      if cmp.visible() then
        if #cmp.get_entries() == 1 then
          cmp.confirm({ select = true })
        else
          cmp.select_next_item()
        end
      else
        fallback()
      end
    end,
  }),
  sources = cmp.config.sources(
    {
      { name = "nvim_lsp" },
    },
    {
      { name = "copilot" },
    },
    {
      { name = "buffer" },
    }
  ),
})

cmp.setup.cmdline({ "/", "?" }, {
  mapping = cmp.mapping.preset.cmdline({
    ["<C-e>"] = cmp.mapping.abort(),

    -- if no completion is explicitly selected with TAB, insert a newline.
    -- otherwise, confirm the highlighted completion
    ["<CR>"] = {
       c = function(fallback)
         if cmp.visible() and cmp.get_active_entry() then
           cmp.confirm({ behavior = cmp.ConfirmBehavior.Replace, select = false })
         else
           fallback()
         end
       end,
     },

    -- if there's only one possible completion, complete right away
    ["<Tab>"] = {
      c = function(_)
        if cmp.visible() then
          if #cmp.get_entries() == 1 then
            cmp.confirm({ select = true })
          else
            cmp.select_next_item()
          end
        else
          cmp.complete()
          if #cmp.get_entries() == 1 then
            cmp.confirm({ select = true })
          end
        end
      end,
    },
  }),
  sources = {
    { name = "buffer" }
  }
})

cmp.setup.cmdline(":", {
  mapping = cmp.mapping.preset.cmdline({
    ["<C-e>"] = cmp.mapping.abort(),

    -- if no completion is explicitly selected with TAB, insert a newline.
    -- otherwise, confirm the highlighted completion
    ["<CR>"] = {
       c = function(fallback)
         if cmp.visible() and cmp.get_active_entry() then
           cmp.confirm({ behavior = cmp.ConfirmBehavior.Replace, select = false })
         else
           fallback()
         end
       end,
     },

    -- if there's only one possible completion, complete right away
    ["<Tab>"] = {
      c = function(_)
        if cmp.visible() then
          if #cmp.get_entries() == 1 then
            cmp.confirm({ select = true })
          else
            cmp.select_next_item()
          end
        else
          cmp.complete()
          if #cmp.get_entries() == 1 then
            cmp.confirm({ select = true })
          end
        end
      end,
    },
  }),
  sources = cmp.config.sources({
    { name = "path", option = { treat_trailing_slash = true } }
  }, {
    { name = "cmdline" }
  }),
  matching = { disallow_symbol_nonprefix_matching = false }
})

-- set up lspconfig
local cmp_nvim_lsp_capabilities = require("cmp_nvim_lsp").default_capabilities()

-- copilot language server is bundled with copilot.lua plugin, no separate installation needed
vim.lsp.config("copilot", { capabilities = cmp_nvim_lsp_capabilities })
vim.lsp.enable("copilot")

vim.lsp.config("csharp_ls", { capabilities = cmp_nvim_lsp_capabilities })
vim.lsp.enable("csharp_ls")

vim.lsp.config("ty", { capabilities = cmp_nvim_lsp_capabilities })
vim.lsp.enable("ty")

vim.lsp.config("terraformls", {
  capabilities = cmp_nvim_lsp_capabilities,
  filetypes = {
    "hcl",
    "terraform",
    "terraform-vars",
  },
})
vim.lsp.enable("terraformls")


-- keymaps
vim.keymap.set("n", "<Leader><Tab>", ":BufferPick<CR>", { noremap = true })
vim.keymap.set("n", "Y", "yy", { noremap = true })

vim.keymap.set("t", "<Esc>", "<C-\\><C-n>", { noremap = true })

local nvimtree = require("nvim-tree.api")
vim.keymap.set("n", "<Leader>t", nvimtree.tree.toggle, { noremap = true })
vim.keymap.set("n", "<Leader>T", function() nvimtree.tree.find_file({ open = true, focus = true, }); end, { noremap = true })

local telescope = require("telescope.builtin")
vim.keymap.set("n", "<Leader>ff", function() telescope.find_files({hidden = true}); end, { noremap = true })
vim.keymap.set("n", "<Leader>fg", telescope.live_grep, { noremap = true })
vim.keymap.set("n", "<Leader>fo", telescope.buffers, { noremap = true })
vim.keymap.set("n", "<Leader>fb", telescope.git_branches, { noremap = true })
vim.keymap.set("n", "<Leader>fh", telescope.help_tags, { noremap = true })

local neogit = require("neogit")
vim.keymap.set("n", "<Leader>gs", neogit.open, { noremap = true })

local agitator = require("agitator")
vim.keymap.set("n", "<Leader>gb", agitator.git_blame, { noremap = true })

local sidekickcli = require("sidekick.cli")
vim.keymap.set({"n", "i", "t", "x"}, "<Leader>aa", sidekickcli.toggle, { noremap = true })
vim.keymap.set({"n", "x"}, "<Leader>at", function() sidekickcli.send({ msg = "{this}" }); end, { noremap = true })
vim.keymap.set({"n"}, "<Leader>af", function() sidekickcli.send({ msg = "{file}" }); end, { noremap = true })
vim.keymap.set({"x"}, "<Leader>av", function() sidekickcli.send({ msg = "{selection}" }); end, { noremap = true })


-- open alternative zip file extensions using the zip plugin
vim.api.nvim_create_autocmd("BufReadCmd", {
  pattern = {
    "*.nupkg",
    "*.whl",
  },
  callback = function()
    vim.fn["zip#Browse"](vim.fn.expand("<amatch>"))
  end,
})


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
