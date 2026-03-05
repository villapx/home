-- generally recommended by many neovim plugins to remove race conditions on startup
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- enable 24-bit terminal colors
vim.opt.termguicolors = true

-- is this a work PC or a personal PC?
vim.g.is_work_pc = vim.fn.filereadable(vim.fn.expand("~/.config/nvim/.work")) == 1

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
      keys = {
        {
          "<Leader>gb",
          function() require("agitator").git_blame_toggle() end,
          desc = "agitator - toggle git blame",
          mode = {"n"},
          { noremap = true },
        },
      },
    },
    {
      "romgrk/barbar.nvim",
      dependencies = {
        "nvim-tree/nvim-web-devicons",
      },
      lazy = false,
      keys = {
        {
          "<Leader><Tab>",
          ":BufferPick<CR>",
          mode = {"n"},
          { noremap = true },
        },
        {
          "<C-q>",
          ":BufferClose<CR>",
          mode = {"n", "t", "x"},
          { noremap = true },
        },
        {
          "<A-l>",
          ":BufferNext<CR>",
          mode = {"n", "t", "x"},
          { noremap = true },
        },
        {
          "<A-h>",
          ":BufferPrevious<CR>",
          mode = {"n", "t", "x"},
          { noremap = true },
        },
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
      opts = {
        suggestion = {
          -- disable direct copilot suggestions since I use nvim-cmp to provide those
          enabled = false,
        },
        panel = {
          -- disable panel since, again, I use nvim-cmp's popup
          enabled = false,
        },
      },
    },
    {
      "idossha/htop.nvim",
      cmd = "Htop",
    },
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
      keys = {
        {
          "<Leader>gs",
          function() require("neogit").open() end,
          desc = "Open neogit",
          mode = {"n"},
          { noremap = true },
        },
      },
    },
    { "hrsh7th/nvim-cmp", },
    { "neovim/nvim-lspconfig", },
    {
      "nvim-tree/nvim-tree.lua",
      version = "*",
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
      keys = {
        {
          "<Leader>t",
          function() require("nvim-tree.api").tree.toggle() end,
          desc = "Toggle nvim-tree",
          mode = {"n"},
          { noremap = true },
        },
        {
          "<Leader>T",
          function() require("nvim-tree.api").tree.find_file({ open = true, focus = true, }); end,
          desc = "Open nvim-tree to currently-opened file",
          mode = {"n"},
          { noremap = true },
        },
      },
    },
    {
      "nvim-treesitter/nvim-treesitter",
      branch = "main",
      lazy = false,
      build = ":TSUpdate",
    },
    {
      "folke/sidekick.nvim",
      opts = {
        nes = {
          enabled = false,
        },
        cli = {
          mux = {
            enabled = true,
            backend = "tmux",
            create = "split",
            split = {
              vertical = true,
              size = 0.25,
            },
          },
        },
      },
      keys = {
        {
          "<Leader>aa",
          function() require("sidekick.cli").toggle() end,
          desc = "Sidekick toggle",
          mode = {"n", "x"},
          { noremap = true },
        },
        {
          "<Leader>at",
          function() require("sidekick.cli").send({ msg = "{this}" }); end,
          desc = "Send this",
          mode = {"n", "x"},
          { noremap = true },
        },
        {
          "<Leader>af",
          function() require("sidekick.cli").send({ msg = "{file}" }); end,
          desc = "Send current file",
          mode = {"n"},
          { noremap = true },
        },
        {
          "<Leader>av",
          function() require("sidekick.cli").send({ msg = "{selection}" }); end,
          desc = "Send current visual selection",
          mode = {"x"},
          { noremap = true },
        },
      },
    },
    {
      "nvim-telescope/telescope.nvim",
      branch = "master",
      dependencies = {
        "nvim-tree/nvim-web-devicons",
        "nvim-lua/plenary.nvim",
      },
      keys = {
        {
          "<Leader>ff",
          function() require("telescope.builtin").find_files({hidden = true}); end,
          desc = "Telescope find_files",
          mode = {"n"},
          { noremap = true },
        },
        {
          "<Leader>fg",
          function() require("telescope.builtin").live_grep() end,
          desc = "Telescope live_grep",
          mode = {"n"},
          { noremap = true },
        },
        {
          "<Leader>fo",
          function() require("telescope.builtin").buffers() end,
          desc = "Telescope buffers",
          mode = {"n"},
          { noremap = true },
        },
        {
          "<Leader>fb",
          function() require("telescope.builtin").git_branches() end,
          desc = "Telescope git_branches",
          mode = {"n"},
          { noremap = true },
        },
        {
          "<Leader>fh",
          function() require("telescope.builtin").help_tags() end,
          desc = "Telescope help_tags",
          mode = {"n"},
          { noremap = true },
        },
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

vim.filetype.add({
  extension = {
    gotmpl = "gotmpl",
  },
  pattern = {
    [".*/templates/.*%.tpl"] = "helm",
    [".*/templates/.*%.ya?ml"] = "helm",
    ["helmfile.*%.ya?ml"] = "helm",
  },
})

vim.treesitter.language.register("hcl", "terraform")
vim.treesitter.language.register("hcl", "terraform-vars")


-- install and enable treesitter parsers
local languages = {
  "bash",
  "c_sharp",
  "gotmpl",
  "hcl",
  "helm",
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

function cmp_insert_sources()
  local sources = {
    {
      { name = "nvim_lsp" },
    },
    {
      { name = "buffer" },
    },
  }

  if vim.g.is_work_pc then
    table.insert(sources, 2, { { name = "copilot" } })
  end

  return sources
end

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
  sources = cmp.config.sources(unpack(cmp_insert_sources())),
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

vim.lsp.config("csharp_ls", { capabilities = cmp_nvim_lsp_capabilities })
vim.lsp.enable("csharp_ls")

vim.lsp.config("pyright", { capabilities = cmp_nvim_lsp_capabilities })
vim.lsp.enable("pyright")

vim.lsp.config("rust_analyzer", { capabilities = cmp_nvim_lsp_capabilities })
vim.lsp.enable("rust_analyzer")

vim.lsp.config("terraformls", {
  capabilities = cmp_nvim_lsp_capabilities,
  filetypes = {
    "hcl",
    "terraform",
    "terraform-vars",
  },
})
vim.lsp.enable("terraformls")


-- non-plugin keymaps
vim.keymap.set("n", "Y", "yy", { noremap = true })

vim.keymap.set("t", "<Esc>", "<C-\\><C-n>", { noremap = true })

vim.keymap.set("n", "K", function() vim.lsp.buf.hover { border = "single" } end, { desc = "Hover documentation" })


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
