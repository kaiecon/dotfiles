return {
  ---------------------------------------------------------------------------
  -- UI: Colorscheme (Lua version of One Dark)
  ---------------------------------------------------------------------------
  {
    "navarasu/onedark.nvim",
    priority = 1000,
    config = function()
      require("onedark").setup({ style = "darker" })
      require("onedark").load()
    end,
  },

  ---------------------------------------------------------------------------
  -- Syntax/Indent/Folding: Treesitter (replace legacy syntax plugins)
  ---------------------------------------------------------------------------
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    event = { "BufReadPost", "BufNewFile" },
    config = function()
      require("nvim-treesitter.configs").setup({
        ensure_installed      = {
          "lua", "vim", "vimdoc", "bash", "json", "toml", "yaml", "markdown",
          "markdown_inline", "html", "css", "javascript", "typescript", "tsx",
          "python", "cpp", "rust", "go",
        },
        highlight             = { enable = true },
        indent                = { enable = true },
        incremental_selection = { enable = true },
      })
      -- Optional: TS-based folding
      vim.opt.foldmethod = "expr"
      vim.wo.foldexpr = "v:lua.vim.treesitter.foldexpr()"
      vim.opt.foldenable = false
    end,
  },

  ---------------------------------------------------------------------------
  -- Finder: Telescope (Denite replacement)
  ---------------------------------------------------------------------------
  { "nvim-lua/plenary.nvim",                    lazy = true },
  {
    "nvim-telescope/telescope.nvim",
    cmd = "Telescope",
    keys = {
      { "<leader>ff", "<cmd>Telescope find_files<cr>", desc = "Find Files" },
      { "<leader>fg", "<cmd>Telescope live_grep<cr>",  desc = "Live Grep" },
      { "<leader>fb", "<cmd>Telescope buffers<cr>",    desc = "Buffers" },
      { "<leader>fh", "<cmd>Telescope help_tags<cr>",  desc = "Help" },
    },
    config = function()
      require("telescope").setup({})
      pcall(require("telescope").load_extension, "fzf")
    end,
  },
  { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },

  ---------------------------------------------------------------------------
  -- File Explorer: Neo-tree (Defx replacement)
  ---------------------------------------------------------------------------
  {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons",
      "MunifTanjim/nui.nvim",
    },
    cmd = "Neotree",
    keys = {
      { "<leader>e", "<cmd>Neotree toggle filesystem reveal left<cr>", desc = "Neo-tree" },
    },
    opts = {
      filesystem = { follow_current_file = { enabled = true }, use_libuv_file_watcher = true },
      window = { width = 34 },
    },
  },

  ---------------------------------------------------------------------------
  -- Statusline: Lualine (Lightline replacement)
  ---------------------------------------------------------------------------
  {
    "nvim-lualine/lualine.nvim",
    event = "VeryLazy",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      require("lualine").setup({
        options = { theme = "auto", globalstatus = true },
        sections = {
          lualine_c = { { "filename", path = 1 }, { "diagnostics", sources = { "nvim_diagnostic" } } },
          lualine_x = { "encoding", "fileformat", "filetype" },
        },
      })
    end,
  },

  ---------------------------------------------------------------------------
  -- Indent Guides: indent-blankline (indentLine replacement)
  ---------------------------------------------------------------------------
  {
    "lukas-reineke/indent-blankline.nvim",
    main = "ibl",
    event = { "BufReadPost", "BufNewFile" },
    opts = { scope = { enabled = true } },
  },

  ---------------------------------------------------------------------------
  -- Motions: Flash (EasyMotion replacement)
  ---------------------------------------------------------------------------
  {
    "folke/flash.nvim",
    event = "VeryLazy",
    keys = {
      { "<leader><leader>s", function() require("flash").jump() end,       mode = { "n", "x", "o" }, desc = "Jump (Flash)" },
      { "<leader><leader>w", function() require("flash").treesitter() end, mode = { "n", "x", "o" }, desc = "TS Jump (Flash)" },
    },
  },

  ---------------------------------------------------------------------------
  -- Surround / Comment
  ---------------------------------------------------------------------------
  { "kylechui/nvim-surround",  version = "*",                                       event = "VeryLazy", config = true },
  { "numToStr/Comment.nvim",   event = "VeryLazy",                                  config = true },

  ---------------------------------------------------------------------------
  -- Git
  ---------------------------------------------------------------------------
  { "tpope/vim-fugitive",      cmd = { "Git", "G", "Gpush", "Gpull", "Gdiffsplit" } },
  { "lewis6991/gitsigns.nvim", event = { "BufReadPost", "BufNewFile" },             config = true },

  ---------------------------------------------------------------------------
  -- Tasks/Runner
  ---------------------------------------------------------------------------
  {
    "stevearc/overseer.nvim",
    cmd = { "OverseerRun", "OverseerToggle" },
    config = true,
    keys = {
      { "<leader>tr", "<cmd>OverseerRun<cr>",    desc = "Run Task" },
      { "<leader>tt", "<cmd>OverseerToggle<cr>", desc = "Tasks" },
    },
  },

  ---------------------------------------------------------------------------
  -- Markdown Preview
  ---------------------------------------------------------------------------
  {
    "toppair/peek.nvim",
    ft = { "markdown", "md" },
    build = "deno task --quiet build:fast",
    opts = { app = "browser" }, -- or omit to use the default WebView
    keys = {
      { "<leader>mp", function() require("peek").open() end,  desc = "Peek Open" },
      { "<leader>mP", function() require("peek").close() end, desc = "Peek Close" },
    },
  },

  ---------------------------------------------------------------------------
  -- Formatter: Conform + Stylua (Lua)
  ---------------------------------------------------------------------------
  {
    "stevearc/conform.nvim",
    opts = {
      formatters_by_ft = { lua = { "stylua" } },
      format_on_save = function(bufnr)
        return { timeout_ms = 2000, lsp_fallback = true }
      end,
    },
    keys = {
      {
        "<leader>cf",
        function() require("conform").format({ async = true, lsp_fallback = true }) end,
        desc = "Format buffer (Conform)",
      },
    },
  },

  ---------------------------------------------------------------------------
  -- LSP stack: mason + lspconfig + nvim-cmp + LuaSnip + lazydev
  ---------------------------------------------------------------------------

  -- nvim-cmp core
  {
    "hrsh7th/nvim-cmp",
    dependencies = {
      "L3MON4D3/LuaSnip",
      "rafamadriz/friendly-snippets",
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "hrsh7th/cmp-cmdline",
      "onsails/lspkind.nvim",
    },
    config = function()
      -- completion setup
      local cmp = require("cmp")
      local lspkind = require("lspkind")
      require("luasnip.loaders.from_vscode").lazy_load()
      cmp.setup({
        snippet = { expand = function(args) require("luasnip").lsp_expand(args.body) end },
        mapping = cmp.mapping.preset.insert({
          ["<C-n>"] = cmp.mapping.select_next_item(),
          ["<C-p>"] = cmp.mapping.select_prev_item(),
          ["<C-d>"] = cmp.mapping.scroll_docs(-4),
          ["<C-f>"] = cmp.mapping.scroll_docs(4),
          ["<C-Space>"] = cmp.mapping.complete(),
          ["<CR>"] = cmp.mapping.confirm({ select = true }),
        }),
        -- ← lazydev を最優先の source として追加（Lua の補完が賢くなる）
        sources = cmp.config.sources(
          { { name = "lazydev", group_index = 0 }, { name = "nvim_lsp" }, { name = "luasnip" } },
          { { name = "buffer" }, { name = "path" } }
        ),
        formatting = {
          format = lspkind.cmp_format({ mode = "symbol_text", maxwidth = 50, ellipsis_char = "…" }),
        },
      })
      -- cmdline completion
      cmp.setup.cmdline("/", { mapping = cmp.mapping.preset.cmdline(), sources = { { name = "buffer" } } })
      cmp.setup.cmdline(":", {
        mapping = cmp.mapping.preset.cmdline(),
        sources = cmp.config.sources({ { name = "path" } }, { { name = "cmdline" } }),
      })
    end,
  },

  -- mason / mason-lspconfig
  { "williamboman/mason.nvim", build = ":MasonUpdate", config = true },
  {
    "williamboman/mason-lspconfig.nvim",
    dependencies = { "williamboman/mason.nvim" },
    config = function()
      require("mason-lspconfig").setup({
        ensure_installed = {
          "lua_ls", "ts_ls", "pyright", "gopls", "rust_analyzer",
          "clangd", "jsonls", "yamlls", "marksman",
        },
        automatic_installation = true,
      })
    end
  },

  -- lazydev.nvim（Neovim 用の LuaLS 知識を提供）
  {
    "folke/lazydev.nvim",
    ft = "lua",
    opts = {
      library = {
        -- `vim.uv` を使う時に luv の型を提供（任意）
        { path = "${3rd}/luv/library", words = { "vim%.uv" } },
      },
    },
  },
  -- luv の型定義（lazydev が必要時に使う）
  { "Bilal2453/luvit-meta",    lazy = true },

  -- lspconfig（lua_ls + その他サーバ）
  {
    "neovim/nvim-lspconfig",
    dependencies = { "williamboman/mason-lspconfig.nvim", "hrsh7th/nvim-cmp" },
    config = function()
      local capabilities = require("cmp_nvim_lsp").default_capabilities()
      local lspconfig = require("lspconfig")

      -- lua_ls（Neovim 前提の基本設定）
      lspconfig.lua_ls.setup({
        capabilities = capabilities,
        settings = {
          Lua = {
            runtime = { version = "LuaJIT" },
            workspace = { checkThirdParty = false },
            diagnostics = { globals = { "vim" } },
            completion = { callSnippet = "Replace" },
          },
        },
      })

      -- その他サーバは既定 + capabilities だけで起動
      for _, name in ipairs({
        "ts_ls", "pyright", "gopls", "rust_analyzer",
        "clangd", "jsonls", "yamlls", "marksman",
      }) do
        lspconfig[name].setup({ capabilities = capabilities })
      end
    end,
  },
}
