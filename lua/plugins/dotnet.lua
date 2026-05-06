return {
  -- C# and Razor/Blazor LSP via Roslyn (same engine as VS Code C# extension)
  -- Roslyn is installed via Mason: :MasonInstall roslyn
  {
    "seblyng/roslyn.nvim",
    ft = { "cs", "razor" },
    config = function(_, opts)
      require("roslyn").setup(opts)

      -- Settings are configured separately from plugin opts per roslyn.nvim API
      vim.lsp.config("roslyn", {
        settings = {
          ["csharp|background_analysis"] = {
            dotnet_analyzer_diagnostics_scope = "fullSolution",
            dotnet_compiler_diagnostics_scope = "fullSolution",
          },
          ["csharp|completion"] = {
            dotnet_show_completion_items_from_unimported_namespaces = true,
          },
          ["csharp|inlay_hints"] = {
            csharp_enable_inlay_hints_for_implicit_object_creation = true,
            csharp_enable_inlay_hints_for_implicit_variable_types = true,
            csharp_enable_inlay_hints_for_lambda_parameter_types = true,
            csharp_enable_inlay_hints_for_types = true,
            dotnet_enable_inlay_hints_for_indexer_parameters = true,
            dotnet_enable_inlay_hints_for_object_creation_parameters = true,
            dotnet_enable_inlay_hints_for_other_parameters = true,
            dotnet_enable_inlay_hints_for_parameters = true,
            dotnet_suppress_inlay_hints_for_parameters_that_differ_only_by_suffix = true,
            dotnet_suppress_inlay_hints_for_parameters_that_match_argument_name = true,
            dotnet_suppress_inlay_hints_for_parameters_that_match_method_intent = true,
          },
        },
      })

      -- Inlay hints don't display without explicitly enabling them
      vim.api.nvim_create_autocmd("LspAttach", {
        callback = function(args)
          local client = vim.lsp.get_client_by_id(args.data.client_id)
          if client and client.name == "roslyn" then
            vim.lsp.inlay_hint.enable(true, { bufnr = args.buf })
          end
        end,
      })
    end,
  },

  -- C# and HTML treesitter parsers (HTML covers markup portions of .razor files)
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      vim.list_extend(opts.ensure_installed, { "c_sharp", "html" })
    end,
  },

  -- csharpier formatter for .cs files
  {
    "stevearc/conform.nvim",
    opts = {
      formatters_by_ft = {
        cs = { "csharpier" },
      },
    },
  },

  -- Mason: custom registry required for roslyn (not in the main mason registry yet)
  -- The roslyn package includes the .razorExtension folder needed for Blazor support
  {
    "mason-org/mason.nvim",
    opts = {
      registries = {
        "github:mason-org/mason-registry",
        "github:Crashdummyy/mason-registry",
      },
      ensure_installed = { "roslyn", "csharpier" },
    },
  },
}
